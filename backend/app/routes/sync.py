# app/routes/sync.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import User, Item, Outfit, Post, Comment, Like, Follow
from app.models import ItemCategoryJoin, OutfitItem, OutfitCategoryJoin
from datetime import datetime
import logging
import json

logger = logging.getLogger(__name__)

sync_bp = Blueprint('sync', __name__)

@sync_bp.route('/status', methods=['GET'])
@jwt_required()
def sync_status():
    """Get sync status and counts for user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get counts for each table
        counts = {
            'items': Item.query.filter_by(user_id=current_user_id).count(),
            'outfits': Outfit.query.filter_by(user_id=current_user_id).count(),
            'posts': Post.query.filter_by(user_id=current_user_id).count(),
            'comments': Comment.query.filter_by(user_id=current_user_id).count(),
            'likes': Like.query.filter_by(user_id=current_user_id).count(),
            'following': Follow.query.filter_by(follower_id=current_user_id).count(),
            'followers': Follow.query.filter_by(following_id=current_user_id).count(),
        }
        
        # Get last sync timestamp from user (you might want to store this)
        user = User.query.get(current_user_id)
        last_sync = user.last_sync if hasattr(user, 'last_sync') else None
        
        return jsonify({
            'success': True,
            'user_id': current_user_id,
            'counts': counts,
            'last_sync': last_sync.isoformat() if last_sync else None,
            'server_time': datetime.utcnow().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting sync status: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@sync_bp.route('/pull', methods=['POST'])
@jwt_required()
def pull_data():
    """Pull all data for user (for initial sync or offline refresh)"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get all data for this user
        data = {
            'user': User.query.get(current_user_id).to_dict(),
            'items': [item.to_dict() for item in Item.query.filter_by(user_id=current_user_id).all()],
            'outfits': [outfit.to_dict() for outfit in Outfit.query.filter_by(user_id=current_user_id).all()],
            'posts': [post.to_dict() for post in Post.query.filter_by(user_id=current_user_id).all()],
            'comments': [comment.to_dict() for comment in Comment.query.filter_by(user_id=current_user_id).all()],
            'likes': [like.to_dict() for like in Like.query.filter_by(user_id=current_user_id).all()],
            'following': [follow.to_dict() for follow in Follow.query.filter_by(follower_id=current_user_id).all()],
            'followers': [follow.to_dict() for follow in Follow.query.filter_by(following_id=current_user_id).all()],
        }
        
        # Get join tables data
        item_ids = [item['item_id'] for item in data['items']]
        outfit_ids = [outfit['outfit_id'] for outfit in data['outfits']]
        
        if item_ids:
            # Item categories
            item_categories = ItemCategoryJoin.query.filter(ItemCategoryJoin.item_id.in_(item_ids)).all()
            data['item_categories'] = [join.to_dict() for join in item_categories]
            
            # Outfit items
            outfit_items = OutfitItem.query.filter(OutfitItem.item_id.in_(item_ids)).all()
            data['outfit_items'] = [join.to_dict() for join in outfit_items]
        
        if outfit_ids:
            # Outfit categories
            outfit_categories = OutfitCategoryJoin.query.filter(OutfitCategoryJoin.outfit_id.in_(outfit_ids)).all()
            data['outfit_categories'] = [join.to_dict() for join in outfit_categories]
        
        # Update last sync time
        user = User.query.get(current_user_id)
        if hasattr(user, 'last_sync'):
            user.last_sync = datetime.utcnow()
            db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Data pulled successfully',
            'data': data,
            'timestamp': datetime.utcnow().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error pulling data: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@sync_bp.route('/push', methods=['POST'])
@jwt_required()
def push_data():
    """Push offline changes to server"""
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        if not data:
            return jsonify({'success': False, 'error': 'No data provided'}), 400
        
        stats = {
            'items_created': 0,
            'items_updated': 0,
            'outfits_created': 0,
            'outfits_updated': 0,
            'posts_created': 0,
            'posts_updated': 0,
            'conflicts': 0
        }
        
        # Process items
        if 'items' in data:
            for item_data in data['items']:
                try:
                    # Check if item exists
                    existing = Item.query.get(item_data.get('item_id'))
                    
                    if existing:
                        # Update existing
                        if existing.user_id == current_user_id:
                            # Only update if user owns it
                            for key, value in item_data.items():
                                if hasattr(existing, key) and key != 'item_id':
                                    setattr(existing, key, value)
                            stats['items_updated'] += 1
                        else:
                            stats['conflicts'] += 1
                    else:
                        # Create new
                        item_data['user_id'] = current_user_id
                        item = Item(**item_data)
                        db.session.add(item)
                        stats['items_created'] += 1
                        
                except Exception as e:
                    logger.warning(f"Error processing item: {e}")
                    continue
        
        # Process outfits
        if 'outfits' in data:
            for outfit_data in data['outfits']:
                try:
                    existing = Outfit.query.get(outfit_data.get('outfit_id'))
                    
                    if existing:
                        if existing.user_id == current_user_id:
                            for key, value in outfit_data.items():
                                if hasattr(existing, key) and key != 'outfit_id':
                                    setattr(existing, key, value)
                            stats['outfits_updated'] += 1
                        else:
                            stats['conflicts'] += 1
                    else:
                        outfit_data['user_id'] = current_user_id
                        outfit = Outfit(**outfit_data)
                        db.session.add(outfit)
                        stats['outfits_created'] += 1
                        
                except Exception as e:
                    logger.warning(f"Error processing outfit: {e}")
                    continue
        
        # Process posts
        if 'posts' in data:
            for post_data in data['posts']:
                try:
                    existing = Post.query.get(post_data.get('post_id'))
                    
                    if existing:
                        if existing.user_id == current_user_id:
                            for key, value in post_data.items():
                                if hasattr(existing, key) and key not in ['post_id', 'user_id']:
                                    setattr(existing, key, value)
                            stats['posts_updated'] += 1
                        else:
                            stats['conflicts'] += 1
                    else:
                        post_data['user_id'] = current_user_id
                        post = Post(**post_data)
                        db.session.add(post)
                        stats['posts_created'] += 1
                        
                except Exception as e:
                    logger.warning(f"Error processing post: {e}")
                    continue
        
        # Commit all changes
        db.session.commit()
        
        # Update last sync
        user = User.query.get(current_user_id)
        if hasattr(user, 'last_sync'):
            user.last_sync = datetime.utcnow()
            db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Data pushed successfully',
            'stats': stats,
            'timestamp': datetime.utcnow().isoformat()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error pushing data: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@sync_bp.route('/conflicts', methods=['POST'])
@jwt_required()
def resolve_conflicts():
    """Resolve sync conflicts (client decides which version to keep)"""
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        if not data or 'resolutions' not in data:
            return jsonify({'success': False, 'error': 'No resolutions provided'}), 400
        
        resolutions = data['resolutions']
        resolved = 0
        
        for resolution in resolutions:
            try:
                entity_type = resolution.get('type')
                entity_id = resolution.get('id')
                keep_server = resolution.get('keep_server', False)
                
                if entity_type == 'item':
                    item = Item.query.get(entity_id)
                    if item and item.user_id == current_user_id:
                        if keep_server:
                            # Keep server version (do nothing)
                            pass
                        else:
                            # Keep client version
                            client_data = resolution.get('client_data')
                            if client_data:
                                for key, value in client_data.items():
                                    if hasattr(item, key) and key != 'item_id':
                                        setattr(item, key, value)
                        resolved += 1
                        
                elif entity_type == 'outfit':
                    outfit = Outfit.query.get(entity_id)
                    if outfit and outfit.user_id == current_user_id:
                        if not keep_server:
                            client_data = resolution.get('client_data')
                            if client_data:
                                for key, value in client_data.items():
                                    if hasattr(outfit, key) and key != 'outfit_id':
                                        setattr(outfit, key, value)
                        resolved += 1
                        
                elif entity_type == 'post':
                    post = Post.query.get(entity_id)
                    if post and post.user_id == current_user_id:
                        if not keep_server:
                            client_data = resolution.get('client_data')
                            if client_data:
                                for key, value in client_data.items():
                                    if hasattr(post, key) and key not in ['post_id', 'user_id']:
                                        setattr(post, key, value)
                        resolved += 1
                        
            except Exception as e:
                logger.warning(f"Error resolving conflict: {e}")
                continue
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': f'Resolved {resolved} conflicts',
            'resolved': resolved
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error resolving conflicts: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@sync_bp.route('/cleanup', methods=['POST'])
@jwt_required()
def cleanup_orphans():
    """Clean up orphaned records (for admin/sync maintenance)"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Only allow admin or the user themselves
        user = User.query.get(current_user_id)
        if not hasattr(user, 'is_admin') or not user.is_admin:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Find orphaned records
        orphan_stats = {}
        
        # Orphaned outfit items (outfit or item deleted)
        outfit_items = OutfitItem.query.all()
        for oi in outfit_items:
            outfit = Outfit.query.get(oi.outfit_id)
            item = Item.query.get(oi.item_id)
            if not outfit or not item:
                db.session.delete(oi)
                orphan_stats['outfit_items'] = orphan_stats.get('outfit_items', 0) + 1
        
        # Orphaned item categories
        item_cats = ItemCategoryJoin.query.all()
        for ic in item_cats:
            item = Item.query.get(ic.item_id)
            if not item:
                db.session.delete(ic)
                orphan_stats['item_categories'] = orphan_stats.get('item_categories', 0) + 1
        
        # Orphaned outfit categories
        outfit_cats = OutfitCategoryJoin.query.all()
        for oc in outfit_cats:
            outfit = Outfit.query.get(oc.outfit_id)
            if not outfit:
                db.session.delete(oc)
                orphan_stats['outfit_categories'] = orphan_stats.get('outfit_categories', 0) + 1
        
        # Orphaned likes (post or user deleted)
        likes = Like.query.all()
        for like in likes:
            post = Post.query.get(like.post_id)
            user = User.query.get(like.user_id)
            if not post or not user:
                db.session.delete(like)
                orphan_stats['likes'] = orphan_stats.get('likes', 0) + 1
        
        # Orphaned comments
        comments = Comment.query.all()
        for comment in comments:
            post = Post.query.get(comment.post_id)
            user = User.query.get(comment.user_id)
            if not post or not user:
                db.session.delete(comment)
                orphan_stats['comments'] = orphan_stats.get('comments', 0) + 1
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Cleanup completed',
            'orphans_removed': orphan_stats,
            'timestamp': datetime.utcnow().isoformat()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error during cleanup: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500