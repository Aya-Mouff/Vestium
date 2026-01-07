from flask import Blueprint, request, jsonify
from app import db
from app.models import User, Follow, Post, Item, Outfit
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.services.firebase_service import firebase_service
import os
from werkzeug.utils import secure_filename

users_bp = Blueprint('users', __name__)

def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@users_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Get counts
        followers_count = Follow.query.filter_by(following_id=user_id).count()
        following_count = Follow.query.filter_by(follower_id=user_id).count()
        posts_count = Post.query.filter_by(user_id=user_id).count()
        items_count = Item.query.filter_by(user_id=user_id).count()
        outfits_count = Outfit.query.filter_by(user_id=user_id).count()
        
        user_data = user.to_dict()
        user_data.update({
            'followers_count': followers_count,
            'following_count': following_count,
            'posts_count': posts_count,
            'items_count': items_count,
            'outfits_count': outfits_count
        })
        
        return jsonify({'user': user_data}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@users_bp.route('/<int:user_id>/profile', methods=['PUT'])
@jwt_required()
def update_profile(user_id):
    try:
        current_user_id = int(get_jwt_identity())
        
        # Users can only update their own profile
        if current_user_id != user_id:
            return jsonify({'error': 'Unauthorized'}), 403
        
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json()
        
        # Update fields if provided
        if 'username' in data:
            # Check if username is unique
            existing = User.query.filter_by(username=data['username']).first()
            if existing and existing.user_id != user_id:
                return jsonify({'error': 'Username already taken'}), 400
            user.username = data['username']
        
        if 'full_name' in data:
            user.full_name = data['full_name']
        
        if 'bio' in data:
            user.bio = data['bio']
        
        if 'email' in data:
            # Check if email is unique
            existing = User.query.filter_by(email=data['email']).first()
            if existing and existing.user_id != user_id:
                return jsonify({'error': 'Email already registered'}), 400
            user.email = data['email']
        
        db.session.commit()
        
        return jsonify({
            'message': 'Profile updated successfully',
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@users_bp.route('/<int:user_id>/follow', methods=['POST'])
@jwt_required()
def follow_user(user_id):
    try:
        current_user_id = int(get_jwt_identity())
        
        # Can't follow yourself
        if current_user_id == user_id:
            return jsonify({'error': 'Cannot follow yourself'}), 400
        
        user_to_follow = User.query.get(user_id)
        if not user_to_follow:
            return jsonify({'error': 'User not found'}), 404
        
        # Check if already following
        existing_follow = Follow.query.filter_by(
            following_id=user_id,
            follower_id=current_user_id
        ).first()
        
        if existing_follow:
            return jsonify({'error': 'Already following this user'}), 400
        
        # Create follow relationship
        follow = Follow(
            following_id=user_id,
            follower_id=current_user_id
        )
        
        db.session.add(follow)
        db.session.commit()
        
        # Send follow notification to the user being followed
        try:
            firebase_service.send_follow_notification(
                follower_id=current_user_id,  # Who is following
                following_id=user_id  # Who is being followed
            )
        except Exception as notif_error:
            # Log notification error but don't fail the follow action
            print(f"Failed to send follow notification: {notif_error}")
        
        return jsonify({
            'message': f'Now following {user_to_follow.username}'
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@users_bp.route('/<int:user_id>/unfollow', methods=['POST'])
@jwt_required()
def unfollow_user(user_id):
    try:
        current_user_id = int(get_jwt_identity())
        
        follow = Follow.query.filter_by(
            following_id=user_id,
            follower_id=current_user_id
        ).first()
        
        if not follow:
            return jsonify({'error': 'Not following this user'}), 400
        
        db.session.delete(follow)
        db.session.commit()
        
        return jsonify({
            'message': 'Unfollowed successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@users_bp.route('/<int:user_id>/followers', methods=['GET'])
def get_followers(user_id):
    try:
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Get followers with pagination
        followers_query = Follow.query.filter_by(following_id=user_id)
        total = followers_query.count()
        
        followers = followers_query\
            .order_by(Follow.date.desc())\
            .offset((page - 1) * per_page)\
            .limit(per_page)\
            .all()
        
        # Get user details for each follower
        follower_users = []
        for follow in followers:
            follower_user = User.query.get(follow.follower_id)
            if follower_user:
                follower_users.append(follower_user.to_dict())
        
        return jsonify({
            'followers': follower_users,
            'total': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@users_bp.route('/<int:user_id>/following', methods=['GET'])
def get_following(user_id):
    try:
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Get following with pagination
        following_query = Follow.query.filter_by(follower_id=user_id)
        total = following_query.count()
        
        following = following_query\
            .order_by(Follow.date.desc())\
            .offset((page - 1) * per_page)\
            .limit(per_page)\
            .all()
        
        # Get user details for each followed user
        following_users = []
        for follow in following:
            followed_user = User.query.get(follow.following_id)
            if followed_user:
                following_users.append(followed_user.to_dict())
        
        return jsonify({
            'following': following_users,
            'total': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@users_bp.route('/search', methods=['GET'])
def search_users():
    try:
        query = request.args.get('q', '')
        
        if not query or len(query) < 2:
            return jsonify({'error': 'Search query must be at least 2 characters'}), 400
        
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Search in username and full_name
        users_query = User.query.filter(
            db.or_(
                User.username.ilike(f'%{query}%'),
                User.full_name.ilike(f'%{query}%')
            )
        )
        
        total = users_query.count()
        
        users = users_query\
            .order_by(User.username)\
            .offset((page - 1) * per_page)\
            .limit(per_page)\
            .all()
        
        return jsonify({
            'users': [user.to_dict() for user in users],
            'total': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500