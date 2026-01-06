from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import UserDevice, User
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

devices_bp = Blueprint('devices', __name__)

@devices_bp.route('/register', methods=['POST'])
@jwt_required()
def register_device():
    """
    Register a device token for push notifications.
    
    Expected JSON body:
    {
        "device_token": "string (required)",
        "device_name": "string (optional)",
        "device_type": "ios|android (optional)"
    }
    """
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        # Validation
        device_token = data.get('device_token')
        if not device_token:
            return jsonify({
                'success': False,
                'error': 'device_token is required'
            }), 400
        
        device_name = data.get('device_name', 'Unknown Device')
        device_type = data.get('device_type', 'unknown')
        
        # Check if this exact token already exists for this user
        existing_device = UserDevice.query.filter_by(
            user_id=current_user_id,
            device_token=device_token
        ).first()
        
        if existing_device:
            # Update last_active timestamp
            existing_device.last_active = datetime.utcnow()
            existing_device.device_name = device_name
            existing_device.device_type = device_type
            db.session.commit()
            
            logger.info(f"✅ Device token updated for user {current_user_id}")
            return jsonify({
                'success': True,
                'message': 'Device token updated',
                'device': existing_device.to_dict()
            }), 200
        
        # Create new device entry
        new_device = UserDevice(
            user_id=current_user_id,
            device_token=device_token,
            device_name=device_name,
            device_type=device_type
        )
        
        db.session.add(new_device)
        db.session.commit()
        
        logger.info(f"✅ New device registered for user {current_user_id}: {device_name}")
        return jsonify({
            'success': True,
            'message': 'Device registered successfully',
            'device': new_device.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"❌ Error registering device: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@devices_bp.route('/unregister', methods=['DELETE'])
@jwt_required()
def unregister_device():
    """
    Unregister a device token (e.g., on logout).
    
    Expected JSON body:
    {
        "device_token": "string (required)"
    }
    """
    try:
        current_user_id = int(get_jwt_identity())
        data = request.get_json()
        
        device_token = data.get('device_token')
        if not device_token:
            return jsonify({
                'success': False,
                'error': 'device_token is required'
            }), 400
        
        # Find and delete the device
        device = UserDevice.query.filter_by(
            user_id=current_user_id,
            device_token=device_token
        ).first()
        
        if not device:
            return jsonify({
                'success': False,
                'error': 'Device not found'
            }), 404
        
        db.session.delete(device)
        db.session.commit()
        
        logger.info(f"✅ Device unregistered for user {current_user_id}")
        return jsonify({
            'success': True,
            'message': 'Device unregistered successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"❌ Error unregistering device: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@devices_bp.route('/list', methods=['GET'])
@jwt_required()
def list_devices():
    """Get all registered devices for the current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        devices = UserDevice.query.filter_by(user_id=current_user_id)\
                                  .order_by(UserDevice.last_active.desc())\
                                  .all()
        
        return jsonify({
            'success': True,
            'devices': [device.to_dict() for device in devices],
            'count': len(devices)
        }), 200
        
    except Exception as e:
        logger.error(f"❌ Error listing devices: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@devices_bp.route('/<int:device_id>', methods=['DELETE'])
@jwt_required()
def delete_device(device_id):
    """Delete a specific device by ID"""
    try:
        current_user_id = int(get_jwt_identity())
        
        device = UserDevice.query.filter_by(
            id=device_id,
            user_id=current_user_id
        ).first()
        
        if not device:
            return jsonify({
                'success': False,
                'error': 'Device not found'
            }), 404
        
        db.session.delete(device)
        db.session.commit()
        
        logger.info(f"✅ Device {device_id} deleted for user {current_user_id}")
        return jsonify({
            'success': True,
            'message': 'Device deleted successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"❌ Error deleting device: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
