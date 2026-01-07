# app/routes/feed.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Post, User, Follow, Like, Comment, Outfit
from sqlalchemy import or_, desc, func
import logging
from typing import Dict, Set, List, Tuple

logger = logging.getLogger(__name__)

feed_bp = Blueprint('feed', __name__)


def get_post_stats(post_ids: List[int], current_user_id: int | None = None):
    """Return likes_count, comments_count and liked_ids for given posts."""
    if not post_ids:
        return {}, {}, set()

    # Likes count per post
    likes_rows: List[Tuple[int, int]] = (
        db.session.query(Like.post_id, func.count(Like.like_id))
        .filter(Like.post_id.in_(post_ids))
        .group_by(Like.post_id)
        .all()
    )
    likes_map: Dict[int, int] = {post_id: count for post_id, count in likes_rows}

    # Comments count per post
    comments_rows: List[Tuple[int, int]] = (
        db.session.query(Comment.post_id, func.count(Comment.comment_id))
        .filter(Comment.post_id.in_(post_ids))
        .group_by(Comment.post_id)
        .all()
    )
    comments_map: Dict[int, int] = {post_id: count for post_id, count in comments_rows}

    # Posts liked by current user (optional)
    liked_ids: Set[int] = set()
    if current_user_id:
        liked_rows: List[Tuple[int]] = (
            db.session.query(Like.post_id)
            .filter(Like.post_id.in_(post_ids), Like.user_id == current_user_id)
            .all()
        )
        liked_ids = {post_id for (post_id,) in liked_rows}

    return likes_map, comments_map, liked_ids


@feed_bp.route('', methods=['GET'])
@jwt_required()
def get_feed():
    """Get personalized feed for current user"""
    try:
        current_user_id = int(get_jwt_identity())

        # Pagination params
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)

        # Following ids
        following_ids = [
            f.following_id
            for f in Follow.query.filter_by(follower_id=current_user_id)
        ]

        # Base query: Post + user info
        query = (
            db.session.query(Post, User.username, User.full_name, User.pfp)
            .outerjoin(User, Post.user_id == User.user_id)
        )

        if following_ids:
            # Your outfits subquery
            your_outfits_sq = (
                Outfit.query.with_entities(Outfit.outfit_id)
                .filter_by(user_id=current_user_id)
                .subquery()
            )

            from_following = Post.user_id.in_(following_ids)
            your_posts = or_(
                Post.user_id == current_user_id,
                Post.outfit_id.in_(your_outfits_sq),
            )
            query = query.filter(or_(from_following, your_posts))
        else:
            # If not following anyone, show all posts except user's own
            query = query.filter(Post.user_id != current_user_id)

        query = query.order_by(desc(Post.date))

        # Paginate
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        rows = pagination.items  # list of (Post, username, full_name, pfp)

        # Collect post_ids for batch queries
        post_ids = [post.post_id for (post, _, _, _) in rows]
        if not post_ids:
            return jsonify(
                {
                    "success": True,
                    "feed": [],
                    "total": pagination.total,
                    "page": pagination.page,
                    "per_page": pagination.per_page,
                    "total_pages": pagination.pages,
                }
            ), 200

        # Batch counts and liked ids using helper
        likes_map, comments_map, liked_ids = get_post_stats(post_ids, current_user_id)

        # Prefetch outfits for posts that have outfit_id
        outfit_ids = {post.outfit_id for (post, _, _, _) in rows if post.outfit_id}
        outfits_map: Dict[int, Outfit] = {}
        if outfit_ids:
            outfits = Outfit.query.filter(Outfit.outfit_id.in_(outfit_ids)).all()
            outfits_map = {o.outfit_id: o for o in outfits}

        # Build response list
        feed_posts = []
        for post, username, full_name, pfp in rows:
            data = post.to_dict()

            # User info
            data["user"] = {
                "user_id": post.user_id,
                "username": username,
                "full_name": full_name,
                "pfp": pfp,
            }

            # Outfit info if applicable
            if post.outfit_id and post.outfit_id in outfits_map:
                outfit = outfits_map[post.outfit_id]
                data["outfit"] = {
                    "outfit_id": outfit.outfit_id,
                    "outfit_name": outfit.outfit_name,
                    "description": outfit.description,
                }

            # Stats from maps
            data["likes_count"] = likes_map.get(post.post_id, 0)
            data["comments_count"] = comments_map.get(post.post_id, 0)
            data["is_liked"] = post.post_id in liked_ids

            feed_posts.append(data)

        return jsonify(
            {
                "success": True,
                "feed": feed_posts,
                "total": pagination.total,
                "page": pagination.page,
                "per_page": pagination.per_page,
                "total_pages": pagination.pages,
            }
        ), 200

    except Exception as e:
        logger.error(f"Error getting feed: {e}")
        return jsonify({"success": False, "error": str(e)}), 500


@feed_bp.route("/explore", methods=["GET"])
@jwt_required()
def explore_posts():
    """Get explore feed (posts from users you don't follow)"""
    try:
        current_user_id = int(get_jwt_identity())

        # Pagination
        page = request.args.get("page", 1, type=int)
        per_page = request.args.get("per_page", 20, type=int)

        # Users that current user is following
        following_ids = [
            f.following_id
            for f in Follow.query.filter_by(follower_id=current_user_id).all()
        ]
        following_ids.append(current_user_id)  # Exclude own posts

        # Query: posts from users you don't follow
        query = db.session.query(Post)

        # Add user info
        query = query.add_columns(User.username, User.full_name, User.pfp).join(
            User, Post.user_id == User.user_id
        )

        # Filter out following and self
        if following_ids:
            query = query.filter(~Post.user_id.in_(following_ids))

        # Popularity subquery (likes + 2 * comments)
        subquery = (
            db.session.query(
                Post.post_id,
                (
                    func.count(Like.like_id)
                    + func.count(Comment.comment_id) * 2
                ).label("popularity"),
            )
            .outerjoin(Like, Post.post_id == Like.post_id)
            .outerjoin(Comment, Post.post_id == Comment.post_id)
            .group_by(Post.post_id)
            .subquery()
        )

        query = query.join(subquery, Post.post_id == subquery.c.post_id)
        query = query.order_by(desc(subquery.c.popularity), desc(Post.date))

        # Paginate
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        rows = pagination.items  # (post, username, full_name, pfp)

        post_ids = [post.post_id for (post, _, _, _) in rows]
        likes_map, comments_map, liked_ids = get_post_stats(post_ids, current_user_id)

        # Build response
        explore_posts_list = []
        for post, username, full_name, pfp in rows:
            post_data = post.to_dict()

            post_data["user"] = {
                "user_id": post.user_id,
                "username": username,
                "full_name": full_name,
                "pfp": pfp,
            }

            post_data["comments_count"] = comments_map.get(post.post_id, 0)
            post_data["likes_count"] = likes_map.get(post.post_id, 0)
            post_data["is_liked"] = post.post_id in liked_ids

            explore_posts_list.append(post_data)

        return jsonify(
            {
                "success": True,
                "posts": explore_posts_list,
                "total": pagination.total,
                "page": pagination.page,
                "per_page": pagination.per_page,
                "total_pages": pagination.pages,
            }
        ), 200

    except Exception as e:
        logger.error(f"Error getting explore posts: {e}")
        return jsonify({"success": False, "error": str(e)}), 500


@feed_bp.route("/trending", methods=["GET"])
def trending_posts():
    """Get trending posts (most liked/commented in last 7 days)"""
    try:
        from datetime import datetime, timedelta

        # Pagination
        page = request.args.get("page", 1, type=int)
        per_page = request.args.get("per_page", 20, type=int)

        # Date 7 days ago
        week_ago = datetime.utcnow() - timedelta(days=7)

        # Query: posts from last 7 days ordered by engagement
        query = db.session.query(Post)

        # Add user info
        query = query.add_columns(User.username, User.full_name, User.pfp).join(
            User, Post.user_id == User.user_id
        )

        # Filter by date
        query = query.filter(Post.date >= week_ago)

        # Engagement subquery
        subquery = (
            db.session.query(
                Post.post_id,
                (
                    func.count(Like.like_id) * 1
                    + func.count(Comment.comment_id) * 2
                ).label("engagement"),
            )
            .outerjoin(Like, Post.post_id == Like.post_id)
            .outerjoin(Comment, Post.post_id == Comment.post_id)
            .filter(Post.date >= week_ago)
            .group_by(Post.post_id)
            .subquery()
        )

        query = query.join(subquery, Post.post_id == subquery.c.post_id)
        query = query.order_by(desc(subquery.c.engagement), desc(Post.date))

        # Paginate
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        rows = pagination.items  # (post, username, full_name, pfp)

        post_ids = [post.post_id for (post, _, _, _) in rows]
        likes_map, comments_map, _ = get_post_stats(post_ids, current_user_id=None)

        # Build response
        trending_posts_list = []
        for post, username, full_name, pfp in rows:
            post_data = post.to_dict()

            post_data["user"] = {
                "user_id": post.user_id,
                "username": username,
                "full_name": full_name,
                "pfp": pfp,
            }

            post_data["comments_count"] = comments_map.get(post.post_id, 0)
            post_data["likes_count"] = likes_map.get(post.post_id, 0)

            trending_posts_list.append(post_data)

        return jsonify(
            {
                "success": True,
                "posts": trending_posts_list,
                "total": pagination.total,
                "page": pagination.page,
                "per_page": pagination.per_page,
                "total_pages": pagination.pages,
            }
        ), 200

    except Exception as e:
        logger.error(f"Error getting trending posts: {e}")
        return jsonify({"success": False, "error": str(e)}), 500
