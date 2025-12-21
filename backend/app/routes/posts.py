from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Post, Outfit, Like, Comment, User
from app.services.supabase_service import supabase_service
from app.services.image_service import ImageService
import os

posts_bp = Blueprint('posts', __name__)

@posts_bp.route('', methods=['GET'])
@jwt_required()
def get_user_posts():
    """Get all posts for current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get posts where user is the author OR posts from user's outfits
        posts = Post.query.filter(
            db.or_(
                Post.user_id == current_user_id,
                Post.outfit_id.in_(
                    db.session.query(Outfit.outfit_id)
                    .filter(Outfit.user_id == current_user_id)
                )
            )
        ).order_by(Post.date.desc()).all()
        
        posts_data = []
        for post in posts:
            post_data = post.to_dict()
            
            # Get likes count
            likes_count = Like.query.filter_by(post_id=post.post_id).count()
            post_data['likes_count'] = likes_count
            
            # Get comments count
            comments_count = Comment.query.filter_by(post_id=post.post_id).count()
            post_data['comments_count'] = comments_count
            
            # Check if current user liked this post
            user_liked = Like.query.filter_by(
                post_id=post.post_id, 
                user_id=current_user_id
            ).first() is not None
            post_data['user_liked'] = user_liked
            
            # Get author info if it's a gallery post
            if post.user_id:
                author = User.query.get(post.user_id)
                if author:
                    post_data['author'] = {
                        'username': author.username,
                        'full_name': author.full_name,
                        'pfp': author.pfp
                    }
            
            posts_data.append(post_data)
        
        return jsonify({
            'success': True,
            'posts': posts_data,
            'count': len(posts_data)
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('', methods=['POST'])
@jwt_required()
def create_post():
    """Create a new post"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Check if we have form data or JSON
        if request.is_json:
            data = request.get_json()
            image_file = None
        else:
            data = request.form.to_dict()
            image_file = request.files.get('image')
        
        # Validate
        caption = data.get('caption', '').strip()
        outfit_id = data.get('outfit_id')
        
        # Either outfit_id or image is required
        if not outfit_id and (not image_file or not image_file.filename):
            return jsonify({'success': False, 'error': 'Either outfit_id or image is required'}), 400
        
        # If outfit_id provided, verify it belongs to user
        if outfit_id:
            outfit = Outfit.query.get(outfit_id)
            if not outfit or outfit.user_id != current_user_id:
                return jsonify({'success': False, 'error': 'Outfit not found or not owned by you'}), 400
        
        image_url = None
        
        # Handle image upload if provided (gallery post)
        if image_file and image_file.filename:
            if not ImageService.allowed_file(image_file.filename):
                return jsonify({'success': False, 'error': 'Invalid image format'}), 400
            
            # Save temp file
            temp_path = ImageService.save_temp_file(image_file, current_user_id, 'posts')
            
            # Upload to Supabase
            image_url = supabase_service.upload_post_image(temp_path, current_user_id)
            
            # Cleanup temp file
            ImageService.cleanup_temp_file(temp_path)
        
        # Create post
        post = Post(
            user_id=current_user_id if image_url else None,  # Gallery post has user_id
            outfit_id=outfit_id,
            image_path=image_url or outfit.image_path if outfit else None,
            caption=caption,
            date=db.func.now()
        )
        
        db.session.add(post)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Post created successfully',
            'post': post.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/<int:post_id>', methods=['GET'])
@jwt_required()
def get_post(post_id):
    """Get a specific post"""
    try:
        current_user_id = int(get_jwt_identity())
        post = Post.query.get(post_id)
        
        if not post:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        # Check permissions
        if post.user_id and post.user_id != current_user_id:
            # Gallery post - only owner can see
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        elif post.outfit_id:
            # Outfit post - check if user owns the outfit
            outfit = Outfit.query.get(post.outfit_id)
            if not outfit or outfit.user_id != current_user_id:
                return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Get likes and comments
        likes = Like.query.filter_by(post_id=post_id).all()
        comments = Comment.query.filter_by(post_id=post_id).all()
        
        post_data = post.to_dict()
        post_data['likes'] = [like.user_id for like in likes]
        post_data['comments'] = [{
            'comment_id': comment.comment_id,
            'user_id': comment.user_id,
            'content': comment.content,
            'date': comment.date.isoformat() if comment.date else None
        } for comment in comments]
        post_data['user_liked'] = any(like.user_id == current_user_id for like in likes)
        
        return jsonify({'success': True, 'post': post_data}), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/<int:post_id>', methods=['DELETE'])
@jwt_required()
def delete_post(post_id):
    """Delete a post"""
    try:
        current_user_id = int(get_jwt_identity())
        post = Post.query.get(post_id)
        
        if not post:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        # Check permissions
        if post.user_id and post.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        elif post.outfit_id:
            outfit = Outfit.query.get(post.outfit_id)
            if not outfit or outfit.user_id != current_user_id:
                return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Delete image from Supabase if it's a gallery post image
        if post.image_path and post.user_id:  # Gallery post with custom image
            supabase_service.delete_image(post.image_path)
        
        db.session.delete(post)
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'Post deleted successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/<int:post_id>/like', methods=['POST'])
@jwt_required()
def like_post(post_id):
    """Like or unlike a post"""
    try:
        current_user_id = int(get_jwt_identity())
        post = Post.query.get(post_id)
        
        if not post:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        # Check if already liked
        existing_like = Like.query.filter_by(
            post_id=post_id, 
            user_id=current_user_id
        ).first()
        
        if existing_like:
            # Unlike
            db.session.delete(existing_like)
            action = 'unliked'
        else:
            # Like
            like = Like(post_id=post_id, user_id=current_user_id)
            db.session.add(like)
            action = 'liked'
        
        db.session.commit()
        
        # Send notification if liked (and not own post)
        if action == 'liked':
            from app.services.firebase_service import firebase_service
            post_owner_id = post.user_id if post.user_id else (
                Outfit.query.get(post.outfit_id).user_id if post.outfit_id else None
            )
            if post_owner_id and post_owner_id != current_user_id:
                firebase_service.send_like_notification(post_id, current_user_id, post_owner_id)
        
        return jsonify({
            'success': True,
            'action': action,
            'likes_count': Like.query.filter_by(post_id=post_id).count()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/<int:post_id>/comments', methods=['GET'])
@jwt_required()
def get_comments(post_id):
    """Get comments for a post"""
    try:
        comments = Comment.query.filter_by(post_id=post_id)\
                               .order_by(Comment.date.desc())\
                               .all()
        
        comments_data = []
        for comment in comments:
            user = User.query.get(comment.user_id)
            comment_data = {
                'comment_id': comment.comment_id,
                'user': {
                    'user_id': user.user_id,
                    'username': user.username,
                    'full_name': user.full_name,
                    'pfp': user.pfp
                },
                'content': comment.content,
                'date': comment.date.isoformat() if comment.date else None
            }
            comments_data.append(comment_data)
        
        return jsonify({
            'success': True,
            'comments': comments_data,
            'count': len(comments_data)
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/<int:post_id>/comments', methods=['POST'])
@jwt_required()
def add_comment(post_id):
    """Add a comment to a post"""
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        if not data.get('content'):
            return jsonify({'success': False, 'error': 'Comment content is required'}), 400
        
        # Verify post exists
        post = Post.query.get(post_id)
        if not post:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        # Create comment
        comment = Comment(
            post_id=post_id,
            user_id=current_user_id,
            content=data['content'].strip(),
            date=db.func.now()
        )
        
        db.session.add(comment)
        db.session.commit()
        
        # Send notification (if not own post)
        from app.services.firebase_service import firebase_service
        post_owner_id = post.user_id if post.user_id else (
            Outfit.query.get(post.outfit_id).user_id if post.outfit_id else None
        )
        if post_owner_id and post_owner_id != current_user_id:
            firebase_service.send_comment_notification(post_id, current_user_id, post_owner_id)
        
        # Get user info for response
        user = User.query.get(current_user_id)
        
        return jsonify({
            'success': True,
            'message': 'Comment added successfully',
            'comment': {
                'comment_id': comment.comment_id,
                'user': {
                    'user_id': user.user_id,
                    'username': user.username,
                    'full_name': user.full_name,
                    'pfp': user.pfp
                },
                'content': comment.content,
                'date': comment.date.isoformat() if comment.date else None
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500