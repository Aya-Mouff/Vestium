# app/routes/notifications.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Notification, UserDevice, User
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

notifications_bp = Blueprint('notifications', __name__)


def get_current_user():
    """Helper function to get current user from JWT token"""
    user_id = int(get_jwt_identity())
    return User.query.get(user_id)


@notifications_bp.route('', methods=['GET'])
@jwt_required()
def get_notifications():
    """
    Get all notifications for the current user
    Returns notifications sorted by newest first with pagination support
    
    Query Parameters:
    - limit: Number of notifications to return (default: 50)
    - offset: Number of notifications to skip (default: 0)
    - unread_only: Filter to only unread notifications (default: false)
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        # Get query parameters with validation
        limit = request.args.get('limit', 50, type=int)
        offset = request.args.get('offset', 0, type=int)
        unread_only = request.args.get('unread_only', 'false').lower() == 'true'
        
        # Validate pagination parameters
        if limit < 1 or limit > 100:
            limit = 50
        if offset < 0:
            offset = 0
        
        # Build query
        query = Notification.query.filter_by(user_id=current_user.user_id)
        
        if unread_only:
            query = query.filter_by(is_read=False)
        
        # Get total count before pagination
        total_count = query.count()
        
        # Get unread count (always needed for UI badge)
        unread_count = Notification.query.filter_by(
            user_id=current_user.user_id,
            is_read=False
        ).count()
        
        # Get notifications with pagination
        notifications = query.order_by(
            Notification.created_at.desc()
        ).limit(limit).offset(offset).all()
        
        # Convert to dict with actor and post details
        notifications_data = [
            notif.to_dict(include_actor=True, include_post=True) 
            for notif in notifications
        ]
        
        return jsonify({
            'success': True,
            'notifications': notifications_data,
            'total_count': total_count,
            'unread_count': unread_count,
            'limit': limit,
            'offset': offset,
            'has_more': (offset + limit) < total_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error fetching notifications: {e}", exc_info=True)
        return jsonify({
            'success': False,
            'error': 'Failed to fetch notifications'
        }), 500


@notifications_bp.route('/unread-count', methods=['GET'])
@jwt_required()
def get_unread_count():
    """
    Get just the unread notification count (lightweight endpoint for polling)
    This endpoint is optimized for frequent requests from the UI
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        unread_count = Notification.query.filter_by(
            user_id=current_user.user_id,
            is_read=False
        ).count()
        
        return jsonify({
            'success': True,
            'unread_count': unread_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting unread count: {e}")
        return jsonify({
            'success': False,
            'error': 'Failed to get unread count'
        }), 500


@notifications_bp.route('/<int:notification_id>/read', methods=['PUT'])
@jwt_required()
def mark_notification_read(notification_id):
    """
    Mark a specific notification as read
    Returns the updated notification and current unread count
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        notification = Notification.query.filter_by(
            notification_id=notification_id,
            user_id=current_user.user_id
        ).first()
        
        if not notification:
            return jsonify({
                'success': False,
                'error': 'Notification not found'
            }), 404
        
        # Only update if not already read (prevents unnecessary DB writes)
        if not notification.is_read:
            notification.is_read = True
            # notification.read_at = datetime.utcnow()  # Optional: track when it was read
            db.session.commit()
            logger.info(f"Notification {notification_id} marked as read by user {current_user.user_id}")
        
        # Get updated unread count
        unread_count = Notification.query.filter_by(
            user_id=current_user.user_id,
            is_read=False
        ).count()
        
        return jsonify({
            'success': True,
            'message': 'Notification marked as read',
            'notification': notification.to_dict(include_actor=True, include_post=True),
            'unread_count': unread_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error marking notification {notification_id} as read: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to mark notification as read'
        }), 500


@notifications_bp.route('/read-all', methods=['PUT'])
@jwt_required()
def mark_all_read():
    """
    Mark all unread notifications as read for the current user
    Bulk operation for better performance
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        # Use bulk update for better performance
        updated_count = Notification.query.filter_by(
            user_id=current_user.user_id,
            is_read=False
        ).update({
            'is_read': True
        }, synchronize_session=False)
        
        db.session.commit()
        
        logger.info(f"Marked {updated_count} notifications as read for user {current_user.user_id}")
        
        return jsonify({
            'success': True,
            'message': f'Marked {updated_count} notification(s) as read',
            'updated_count': updated_count,
            'unread_count': 0  # All are now read
        }), 200
        
    except Exception as e:
        logger.error(f"Error marking all notifications as read: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to mark all notifications as read'
        }), 500


@notifications_bp.route('/<int:notification_id>', methods=['DELETE'])
@jwt_required()
def delete_notification(notification_id):
    """
    Delete a specific notification
    Only the owner can delete their notifications
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        notification = Notification.query.filter_by(
            notification_id=notification_id,
            user_id=current_user.user_id
        ).first()
        
        if not notification:
            return jsonify({
                'success': False,
                'error': 'Notification not found'
            }), 404
        
        db.session.delete(notification)
        db.session.commit()
        
        logger.info(f"Notification {notification_id} deleted by user {current_user.user_id}")
        
        # Get updated unread count
        unread_count = Notification.query.filter_by(
            user_id=current_user.user_id,
            is_read=False
        ).count()
        
        return jsonify({
            'success': True,
            'message': 'Notification deleted successfully',
            'unread_count': unread_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error deleting notification {notification_id}: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to delete notification'
        }), 500


@notifications_bp.route('/clear-all', methods=['DELETE'])
@jwt_required()
def clear_all_notifications():
    """
    Delete all notifications for the current user
    Use with caution - this is permanent
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        deleted_count = Notification.query.filter_by(
            user_id=current_user.user_id
        ).delete(synchronize_session=False)
        
        db.session.commit()
        
        logger.info(f"Cleared {deleted_count} notifications for user {current_user.user_id}")
        
        return jsonify({
            'success': True,
            'message': f'Deleted {deleted_count} notification(s)',
            'deleted_count': deleted_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error clearing all notifications: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to clear notifications'
        }), 500


# ========== PUSH NOTIFICATION DEVICE MANAGEMENT ==========

@notifications_bp.route('/device-token', methods=['POST'])
@jwt_required()
def register_device_token():
    """
    Register or update a device token for push notifications
    Supports multiple devices per user (mobile, tablet, web)
    
    Request Body:
    {
        "device_token": "string (required)",
        "device_name": "string (optional, e.g., 'John's iPhone')",
        "device_type": "string (optional, ios|android|web)"
    }
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': 'Request body is required'
            }), 400
        
        device_token = data.get('device_token')
        device_name = data.get('device_name', 'Unknown Device')
        device_type = data.get('device_type', 'unknown')  # ios, android, web
        
        if not device_token:
            return jsonify({
                'success': False,
                'error': 'device_token is required'
            }), 400
        
        # Validate device_type
        valid_device_types = ['ios', 'android', 'web', 'unknown']
        if device_type not in valid_device_types:
            device_type = 'unknown'
        
        # Check if this device token already exists
        existing_device = UserDevice.query.filter_by(
            device_token=device_token
        ).first()
        
        if existing_device:
            # Update existing device
            existing_device.device_name = device_name
            existing_device.device_type = device_type
            existing_device.last_active = datetime.utcnow()
            
            # If the device belonged to a different user, reassign it
            if existing_device.user_id != current_user.user_id:
                logger.warning(
                    f"Device token reassignment: device {existing_device.id} "
                    f"from user {existing_device.user_id} to user {current_user.user_id}"
                )
                existing_device.user_id = current_user.user_id
            
            db.session.commit()
            
            logger.info(f"Device token updated for user {current_user.user_id}: {device_name}")
            
            return jsonify({
                'success': True,
                'message': 'Device token updated successfully',
                'device': existing_device.to_dict()
            }), 200
        else:
            # Create new device registration
            new_device = UserDevice(
                user_id=current_user.user_id,
                device_token=device_token,
                device_name=device_name,
                device_type=device_type
            )
            db.session.add(new_device)
            db.session.commit()
            
            # Get total device count for this user
            device_count = UserDevice.query.filter_by(
                user_id=current_user.user_id
            ).count()
            
            logger.info(f"New device registered for user {current_user.user_id}: {device_name}")
            
            return jsonify({
                'success': True,
                'message': 'Device token registered successfully',
                'device': new_device.to_dict(),
                'total_devices': device_count
            }), 201
        
    except Exception as e:
        logger.error(f"Error registering device token: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to register device token'
        }), 500


@notifications_bp.route('/devices', methods=['GET'])
@jwt_required()
def get_user_devices():
    """
    Get all registered devices for the current user
    Ordered by most recently active
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        devices = UserDevice.query.filter_by(
            user_id=current_user.user_id
        ).order_by(UserDevice.last_active.desc()).all()
        
        return jsonify({
            'success': True,
            'devices': [device.to_dict() for device in devices],
            'count': len(devices)
        }), 200
        
    except Exception as e:
        logger.error(f"Error fetching devices: {e}")
        return jsonify({
            'success': False,
            'error': 'Failed to fetch devices'
        }), 500


@notifications_bp.route('/devices/<int:device_id>', methods=['DELETE'])
@jwt_required()
def remove_device(device_id):
    """
    Remove a specific device from the user's registered devices
    Used when user logs out or uninstalls the app
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        device = UserDevice.query.filter_by(
            id=device_id,
            user_id=current_user.user_id
        ).first()
        
        if not device:
            return jsonify({
                'success': False,
                'error': 'Device not found'
            }), 404
        
        device_name = device.device_name
        db.session.delete(device)
        db.session.commit()
        
        logger.info(f"Device removed for user {current_user.user_id}: {device_name}")
        
        # Get remaining device count
        remaining_devices = UserDevice.query.filter_by(
            user_id=current_user.user_id
        ).count()
        
        return jsonify({
            'success': True,
            'message': 'Device removed successfully',
            'remaining_devices': remaining_devices
        }), 200
        
    except Exception as e:
        logger.error(f"Error removing device {device_id}: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to remove device'
        }), 500


@notifications_bp.route('/devices/clear-inactive', methods=['DELETE'])
@jwt_required()
def clear_inactive_devices():
    """
    Remove devices that haven't been active in the last 90 days
    Helps keep the device list clean
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        from datetime import timedelta
        
        cutoff_date = datetime.utcnow() - timedelta(days=90)
        
        deleted_count = UserDevice.query.filter(
            UserDevice.user_id == current_user.user_id,
            UserDevice.last_active < cutoff_date
        ).delete(synchronize_session=False)
        
        db.session.commit()
        
        logger.info(f"Cleared {deleted_count} inactive devices for user {current_user.user_id}")
        
        return jsonify({
            'success': True,
            'message': f'Removed {deleted_count} inactive device(s)',
            'deleted_count': deleted_count
        }), 200
        
    except Exception as e:
        logger.error(f"Error clearing inactive devices: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to clear inactive devices'
        }), 500


# ========== PUSH NOTIFICATION TESTING ==========

@notifications_bp.route('/test', methods=['POST'])
@jwt_required()
def send_test_notification():
    """
    Send a test notification to the current user (for debugging/testing)
    Only works if Firebase is properly initialized
    
    Optional Request Body:
    {
        "title": "Custom title",
        "body": "Custom message"
    }
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        from app.services.firebase_service import firebase_service
        
        # Check if Firebase is initialized
        if not firebase_service.initialized:
            return jsonify({
                'success': False,
                'error': 'Firebase not initialized. Push notifications are currently disabled.',
                'help': 'Check that FIREBASE_CREDENTIALS environment variable is set correctly'
            }), 503
        
        # Get custom message if provided
        data = request.get_json() or {}
        title = data.get('title', 'Test Notification')
        body = data.get('body', 'This is a test notification from Vestium!')
        
        # Send test notification to all user's devices
        success = firebase_service.send_to_user(
            user_id=current_user.user_id,
            title=title,
            body=body,
            data={
                'type': 'test',
                'timestamp': datetime.utcnow().isoformat(),
                'user_id': str(current_user.user_id)
            }
        )
        
        if success:
            # Count how many devices received it
            device_count = UserDevice.query.filter_by(
                user_id=current_user.user_id
            ).count()
            
            logger.info(f"Test notification sent to user {current_user.user_id} ({device_count} devices)")
            
            return jsonify({
                'success': True,
                'message': f'Test notification sent to {device_count} device(s)',
                'device_count': device_count
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': 'Failed to send notification. Check if devices are registered.',
                'help': 'Register a device token first using POST /api/notifications/device-token'
            }), 500
        
    except ImportError:
        logger.error("Firebase service not available")
        return jsonify({
            'success': False,
            'error': 'Firebase service not configured',
            'help': 'Ensure firebase_service.py exists and is properly configured'
        }), 503
    except Exception as e:
        logger.error(f"Error sending test notification: {e}", exc_info=True)
        return jsonify({
            'success': False,
            'error': f'Failed to send test notification: {str(e)}'
        }), 500


# ========== NOTIFICATION PREFERENCES (Optional Enhancement) ==========

@notifications_bp.route('/preferences', methods=['GET'])
@jwt_required()
def get_notification_preferences():
    """
    Get notification preferences for the current user
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        # Check if user has notification preferences
        if hasattr(current_user, 'notification_preferences'):
            preferences = current_user.notification_preferences or {}
        else:
            # Default preferences if not stored in DB
            preferences = {
                'email_notifications': True,
                'push_notifications': True,
                'notification_types': {
                    'likes': True,
                    'comments': True,
                    'follows': True,
                    'mentions': True
                }
            }
        
        return jsonify({
            'success': True,
            'preferences': preferences
        }), 200
        
    except Exception as e:
        logger.error(f"Error fetching notification preferences: {e}")
        return jsonify({
            'success': False,
            'error': 'Failed to fetch notification preferences'
        }), 500


@notifications_bp.route('/preferences', methods=['PUT'])
@jwt_required()
def update_notification_preferences():
    """
    Update notification preferences for the current user
    
    Request Body:
    {
        "email_notifications": true/false,
        "push_notifications": true/false,
        "notification_types": {
            "likes": true/false,
            "comments": true/false,
            "follows": true/false,
            "mentions": true/false
        }
    }
    """
    try:
        current_user = get_current_user()
        if not current_user:
            return jsonify({
                'success': False,
                'error': 'User not found'
            }), 404
        
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': 'Request body is required'
            }), 400
        
        # Update preferences (this assumes you have a JSON field on User model)
        if hasattr(current_user, 'notification_preferences'):
            current_user.notification_preferences = data
            db.session.commit()
            
            logger.info(f"Notification preferences updated for user {current_user.user_id}")
            
            return jsonify({
                'success': True,
                'message': 'Notification preferences updated',
                'preferences': data
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': 'Notification preferences not supported in current database schema'
            }), 501
        
    except Exception as e:
        logger.error(f"Error updating notification preferences: {e}", exc_info=True)
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'Failed to update notification preferences'
        }), 500