# app/routes/feed.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Post, User, Follow, Like, Comment, Outfit
from sqlalchemy import or_, desc, func
import logging

logger = logging.getLogger(__name__)

feed_bp = Blueprint('feed', __name__)

@feed_bp.route('', methods=['GET'])
@jwt_required()
def get_feed():
    """Get personalized feed for current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get pagination parameters
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Get users that current user is following
        following_ids = [f.following_id for f in Follow.query.filter_by(follower_id=current_user_id).all()]
        
        # Build query: posts from following + own posts + some random posts
        query = db.session.query(Post)
        
        # Add user info subquery
        query = query.add_columns(
            User.username,
            User.full_name,
            User.pfp
        ).outerjoin(User, Post.user_id == User.user_id)
        
        # Filter: posts from following OR user's own posts
        if following_ids:
            # Posts from people you follow
            from_following = Post.user_id.in_(following_ids)
            
            # Your own posts (including outfit posts)
            your_outfits = Outfit.query.filter_by(user_id=current_user_id).subquery()
            your_posts = or_(
                Post.user_id == current_user_id,
                Post.outfit_id.in_(db.session.query(your_outfits.c.outfit_id))
            )
            
            query = query.filter(or_(from_following, your_posts))
        else:
            # If not following anyone, show all posts except user's own
            query = query.filter(Post.user_id != current_user_id)
        
        # Order by date (newest first)
        query = query.order_by(desc(Post.date))
        
        # Paginate
        posts = query.paginate(page=page, per_page=per_page, error_out=False)
        
        # Prepare response
        feed_posts = []
        for post, username, full_name, pfp in posts.items:
            post_data = post.to_dict()
            
            # Add user info
            post_data['user'] = {
                'user_id': post.user_id,
                'username': username,
                'full_name': full_name,
                'pfp': pfp
            }
            
            # Get outfit info if applicable
            if post.outfit_id:
                outfit = Outfit.query.get(post.outfit_id)
                if outfit:
                    post_data['outfit'] = {
                        'outfit_id': outfit.outfit_id,
                        'outfit_name': outfit.outfit_name,
                        'description': outfit.description
                    }
            
            # Get counts
            post_data['comments_count'] = Comment.query.filter_by(post_id=post.post_id).count()
            post_data['likes_count'] = Like.query.filter_by(post_id=post.post_id).count()
            
            # Check if current user liked this post
            is_liked = Like.query.filter_by(post_id=post.post_id, user_id=current_user_id).first() is not None
            post_data['is_liked'] = is_liked
            
            feed_posts.append(post_data)
        
        return jsonify({
            'success': True,
            'feed': feed_posts,
            'total': posts.total,
            'page': posts.page,
            'per_page': posts.per_page,
            'total_pages': posts.pages
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting feed: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@feed_bp.route('/explore', methods=['GET'])
@jwt_required()
def explore_posts():
    """Get explore feed (posts from users you don't follow)"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get pagination
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Get users that current user is following
        following_ids = [f.following_id for f in Follow.query.filter_by(follower_id=current_user_id).all()]
        following_ids.append(current_user_id)  # Exclude own posts
        
        # Query: posts from users you don't follow
        query = db.session.query(Post)
        
        # Add user info
        query = query.add_columns(
            User.username,
            User.full_name,
            User.pfp
        ).join(User, Post.user_id == User.user_id)
        
        # Filter out following and self
        if following_ids:
            query = query.filter(~Post.user_id.in_(following_ids))
        
        # Order by popularity (likes + comments)
        subquery = db.session.query(
            Post.post_id,
            (func.count(Like.like_id) + func.count(Comment.comment_id) * 2).label('popularity')
        ).outerjoin(Like, Post.post_id == Like.post_id)\
         .outerjoin(Comment, Post.post_id == Comment.post_id)\
         .group_by(Post.post_id).subquery()
        
        query = query.join(subquery, Post.post_id == subquery.c.post_id)
        query = query.order_by(desc(subquery.c.popularity), desc(Post.date))
        
        # Paginate
        posts = query.paginate(page=page, per_page=per_page, error_out=False)
        
        # Prepare response
        explore_posts = []
        for post, username, full_name, pfp in posts.items:
            post_data = post.to_dict()
            
            # Add user info
            post_data['user'] = {
                'user_id': post.user_id,
                'username': username,
                'full_name': full_name,
                'pfp': pfp
            }
            
            # Get counts
            post_data['comments_count'] = Comment.query.filter_by(post_id=post.post_id).count()
            post_data['likes_count'] = Like.query.filter_by(post_id=post.post_id).count()
            
            # Check if liked
            is_liked = Like.query.filter_by(post_id=post.post_id, user_id=current_user_id).first() is not None
            post_data['is_liked'] = is_liked
            
            explore_posts.append(post_data)
        
        return jsonify({
            'success': True,
            'posts': explore_posts,
            'total': posts.total,
            'page': posts.page,
            'per_page': posts.per_page,
            'total_pages': posts.pages
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting explore posts: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@feed_bp.route('/trending', methods=['GET'])
def trending_posts():
    """Get trending posts (most liked/commented in last 7 days)"""
    try:
        from datetime import datetime, timedelta
        
        # Get pagination
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Calculate date 7 days ago
        week_ago = datetime.utcnow() - timedelta(days=7)
        
        # Query: posts from last 7 days ordered by engagement
        query = db.session.query(Post)
        
        # Add user info
        query = query.add_columns(
            User.username,
            User.full_name,
            User.pfp
        ).join(User, Post.user_id == User.user_id)
        
        # Filter by date
        query = query.filter(Post.date >= week_ago)
        
        # Calculate engagement score
        subquery = db.session.query(
            Post.post_id,
            (func.count(Like.like_id) * 1 + func.count(Comment.comment_id) * 2).label('engagement')
        ).outerjoin(Like, Post.post_id == Like.post_id)\
         .outerjoin(Comment, Post.post_id == Comment.post_id)\
         .filter(Post.date >= week_ago)\
         .group_by(Post.post_id).subquery()
        
        query = query.join(subquery, Post.post_id == subquery.c.post_id)
        query = query.order_by(desc(subquery.c.engagement), desc(Post.date))
        
        # Paginate
        posts = query.paginate(page=page, per_page=per_page, error_out=False)
        
        # Prepare response
        trending_posts = []
        for post, username, full_name, pfp in posts.items:
            post_data = post.to_dict()
            
            # Add user info
            post_data['user'] = {
                'user_id': post.user_id,
                'username': username,
                'full_name': full_name,
                'pfp': pfp
            }
            
            # Get counts
            post_data['comments_count'] = Comment.query.filter_by(post_id=post.post_id).count()
            post_data['likes_count'] = Like.query.filter_by(post_id=post.post_id).count()
            
            trending_posts.append(post_data)
        
        return jsonify({
            'success': True,
            'posts': trending_posts,
            'total': posts.total,
            'page': posts.page,
            'per_page': posts.per_page,
            'total_pages': posts.pages
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting trending posts: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500