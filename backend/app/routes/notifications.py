# app/routes/notifications.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Notification, User
from sqlalchemy import desc
import logging

logger = logging.getLogger(__name__)

notifications_bp = Blueprint('notifications', __name__)


@notifications_bp.route('', methods=['GET'])
@jwt_required()
def get_notifications():
    """
    Get all notifications for the current user.
    
    Query Parameters:
    - page: Page number (default: 1)
    - per_page: Items per page (default: 20)
    - unread_only: If 'true', return only unread notifications (default: false)
    - type: Filter by notification type ('follow', 'like', 'comment')
    """
    try:
        current_user_id = int(get_jwt_identity())
        
        # Get query parameters
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        unread_only = request.args.get('unread_only', 'false').lower() == 'true'
        notification_type = request.args.get('type', None)
        
        # Build query
        query = Notification.query.filter_by(user_id=current_user_id)
        
        # Filter by read status
        if unread_only:
            query = query.filter_by(is_read=False)
        
        # Filter by type
        if notification_type:
            query = query.filter_by(type=notification_type)
        
        # Order by newest first
        query = query.order_by(desc(Notification.created_at))
        
        # Paginate
        total = query.count()
        notifications = query.offset((page - 1) * per_page).limit(per_page).all()
        
        # Get unread count
        unread_count = Notification.query.filter_by(
            user_id=current_user_id,
            is_read=False
        ).count()
        
        # Convert to dict with actor and post details
        notifications_data = [
            notif.to_dict(include_actor=True, include_post=True) 
            for notif in notifications
        ]
        
        return jsonify({
            'success': True,
            'notifications': notifications_data,
            'total': total,
            'unread_count': unread_count,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page if total > 0 else 0
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting notifications: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/unread-count', methods=['GET'])
@jwt_required()
def get_unread_count():
    """Get count of unread notifications"""
    try:
        current_user_id = int(get_jwt_identity())
        
        unread_count = Notification.query.filter_by(
            user_id=current_user_id,
            is_read=False
        ).count()
        
        return jsonify({
            'success': True,
            'unread_count': unread_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting unread count: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/<int:notification_id>', methods=['GET'])
@jwt_required()
def get_notification(notification_id):
    """Get a specific notification"""
    try:
        current_user_id = int(get_jwt_identity())
        
        notification = Notification.query.get(notification_id)
        
        if not notification:
            return jsonify({
                'success': False,
                'error': 'Notification not found'
            }), 404
        
        # Check ownership
        if notification.user_id != current_user_id:
            return jsonify({
                'success': False,
                'error': 'Unauthorized'
            }), 403
        
        return jsonify({
            'success': True,
            'notification': notification.to_dict(include_actor=True, include_post=True)
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting notification: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/<int:notification_id>/read', methods=['PUT'])
@jwt_required()
def mark_notification_read(notification_id):
    """Mark a specific notification as read"""
    try:
        current_user_id = int(get_jwt_identity())
        
        notification = Notification.query.get(notification_id)
        
        if not notification:
            return jsonify({
                'success': False,
                'error': 'Notification not found'
            }), 404
        
        # Check ownership
        if notification.user_id != current_user_id:
            return jsonify({
                'success': False,
                'error': 'Unauthorized'
            }), 403
        
        # Mark as read
        notification.is_read = True
        db.session.commit()
        
        logger.info(f"Notification {notification_id} marked as read by user {current_user_id}")
        
        return jsonify({
            'success': True,
            'message': 'Notification marked as read',
            'notification': notification.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error marking notification as read: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/read-all', methods=['PUT'])
@jwt_required()
def mark_all_read():
    """Mark all notifications as read for the current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Update all unread notifications
        updated_count = Notification.query.filter_by(
            user_id=current_user_id,
            is_read=False
        ).update({'is_read': True})
        
        db.session.commit()
        
        logger.info(f"User {current_user_id} marked {updated_count} notifications as read")
        
        return jsonify({
            'success': True,
            'message': f'{updated_count} notifications marked as read',
            'updated_count': updated_count
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error marking all notifications as read: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/<int:notification_id>', methods=['DELETE'])
@jwt_required()
def delete_notification(notification_id):
    """Delete a specific notification"""
    try:
        current_user_id = int(get_jwt_identity())
        
        notification = Notification.query.get(notification_id)
        
        if not notification:
            return jsonify({
                'success': False,
                'error': 'Notification not found'
            }), 404
        
        # Check ownership
        if notification.user_id != current_user_id:
            return jsonify({
                'success': False,
                'error': 'Unauthorized'
            }), 403
        
        db.session.delete(notification)
        db.session.commit()
        
        logger.info(f"Notification {notification_id} deleted by user {current_user_id}")
        
        return jsonify({
            'success': True,
            'message': 'Notification deleted successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error deleting notification: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/clear-all', methods=['DELETE'])
@jwt_required()
def clear_all_notifications():
    """Delete all notifications for the current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Delete all notifications for this user
        deleted_count = Notification.query.filter_by(
            user_id=current_user_id
        ).delete()
        
        db.session.commit()
        
        logger.info(f"User {current_user_id} cleared {deleted_count} notifications")
        
        return jsonify({
            'success': True,
            'message': f'{deleted_count} notifications cleared',
            'deleted_count': deleted_count
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error clearing all notifications: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@notifications_bp.route('/test', methods=['POST'])
@jwt_required()
def create_test_notification():
    """
    Create a test notification (for development/testing purposes).
    
    Body:
    {
        "type": "follow|like|comment",
        "message": "Test notification message"
    }
    """
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        notification_type = data.get('type', 'follow')
        message = data.get('message', 'This is a test notification')
        
        # Create test notification
        notification = Notification(
            user_id=current_user_id,
            type=notification_type,
            actor_id=current_user_id,  # Self for testing
            message=message
        )
        
        db.session.add(notification)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Test notification created',
            'notification': notification.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error creating test notification: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
