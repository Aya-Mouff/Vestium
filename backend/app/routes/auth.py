from flask import Blueprint, request, jsonify
from app import db
from app.models import User
from flask_jwt_extended import (
    create_access_token, create_refresh_token, jwt_required,
    get_jwt_identity, get_jwt
)
import re

auth_bp = Blueprint('auth', __name__)

def validate_email(email):
    """Validate email format"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None

def validate_password(password):
    """Validate password strength"""
    if len(password) < 6:
        return False, 'Password must be at least 6 characters'
    return True, ''

@auth_bp.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        
        # Validation
        required_fields = ['email', 'password', 'full_name']
        for field in required_fields:
            if not data.get(field):
                return jsonify({'error': f'{field} is required'}), 400
        
        # Email validation
        if not validate_email(data['email']):
            return jsonify({'error': 'Invalid email format'}), 400
        
        # Password validation
        is_valid, message = validate_password(data['password'])
        if not is_valid:
            return jsonify({'error': message}), 400
        
        # Check if email already exists
        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'Email already registered'}), 400
        
        # Check if username exists (if provided)
        username = data.get('username')
        if username and User.query.filter_by(username=username).first():
            return jsonify({'error': 'Username already taken'}), 400
        
        # Generate username from email if not provided
        if not username:
            username = data['email'].split('@')[0]
            # Make username unique
            base_username = username
            counter = 1
            while User.query.filter_by(username=username).first():
                username = f"{base_username}{counter}"
                counter += 1
        
        # Create new user
        user = User(
            username=username,
            email=data['email'],
            full_name=data['full_name'],
            bio=data.get('bio', ''),
            pfp=data.get('pfp')  # Profile picture URL
        )
        user.set_password(data['password'])
        
        db.session.add(user)
        db.session.commit()
        
        # Create tokens
        access_token = create_access_token(identity=str(user.user_id))
        refresh_token = create_refresh_token(identity=str(user.user_id))
        
        # Save refresh token to user
        user.refresh_token = refresh_token
        db.session.commit()
        
        return jsonify({
            'message': 'User registered successfully',
            'user': user.to_dict(),
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        
        if not data.get('email') or not data.get('password'):
            return jsonify({'error': 'Email and password are required'}), 400
        
        # Find user by email
        user = User.query.filter_by(email=data['email']).first()
        
        if not user or not user.check_password(data['password']):
            return jsonify({'error': 'Invalid email or password'}), 401
        
        # Update last login
        user.last_login = db.func.now()
        
        # Create tokens
        access_token = create_access_token(identity=str(user.user_id))
        refresh_token = create_refresh_token(identity=str(user.user_id))
        
        # Save refresh token
        user.refresh_token = refresh_token
        db.session.commit()
        
        return jsonify({
            'message': 'Login successful',
            'user': user.to_dict(),
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    try:
        current_user_id = get_jwt_identity()
        user = User.query.get(current_user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Verify refresh token matches stored token
        # jwt_token = get_jwt()
        # if user.refresh_token != jwt_token['jti']:
        #     return jsonify({'error': 'Invalid refresh token'}), 401
        
        # Get current token string from header
        current_token = request.headers.get('Authorization', '').replace('Bearer ', '').strip()

        if not current_token or user.refresh_token != current_token:
            return jsonify({'error': 'Invalid refresh token'}), 401

        # Create new access token
        new_access_token = create_access_token(identity=str(user.user_id))
        
        return jsonify({
            'access_token': new_access_token
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    try:
        current_user_id = get_jwt_identity()
        user = User.query.get(current_user_id)
        
        if user:
            user.refresh_token = None
            db.session.commit()
        
        return jsonify({'message': 'Logged out successfully'}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_current_user():
    try:
        current_user_id = get_jwt_identity()
        user = User.query.get(current_user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify({
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500 
    
@auth_bp.route('/change-password', methods=['PUT'])
@jwt_required()
def change_password():
    try:
        current_user_id = int(get_jwt_identity())
        user = User.query.get(current_user_id)

        if not user:
            return jsonify({'error': 'User not found'}), 404

        data = request.get_json() or {}

        current_password = data.get('current_password', '')
        new_password = data.get('new_password', '')

        # Validate presence
        if not current_password or not new_password:
            return jsonify({'error': 'current_password and new_password are required'}), 400

        # Verify current password
        if not user.check_password(current_password):
            return jsonify({'error': 'Current password is incorrect'}), 401

        # Validate new password strength (reuse your existing validator)
        is_valid, message = validate_password(new_password)
        if not is_valid:
            return jsonify({'error': message}), 400

        # Prevent using the same password
        if user.check_password(new_password):
            return jsonify({'error': 'New password must be different from current password'}), 400

        # Update password
        user.set_password(new_password)
        db.session.commit()

        return jsonify({'message': 'Password updated successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/update-profile', methods=['PUT'])
@jwt_required()
def update_profile():
    try:
        current_user_id = int(get_jwt_identity())
        user = User.query.get(current_user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json() or {}
        
        # List of allowed fields to update
        allowed_fields = ['username', 'full_name', 'bio', 'pfp']
        
        # Validate and update each field
        updated_fields = []
        for field in allowed_fields:
            if field in data and data[field] is not None:
                # Special validation for username
                if field == 'username':
                    new_username = data['username'].strip()
                    if new_username and new_username != user.username:
                        # Check if username is taken by another user
                        existing = User.query.filter(
                            User.username == new_username,
                            User.user_id != current_user_id
                        ).first()
                        if existing:
                            return jsonify({
                                'error': f'Username "{new_username}" is already taken'
                            }), 400
                        setattr(user, 'username', new_username)
                        updated_fields.append('username')
                else:
                    setattr(user, field, data[field])
                    updated_fields.append(field)
        
        # If no fields were updated
        if not updated_fields:
            return jsonify({'error': 'No valid fields to update'}), 400
        
        # Update last_updated timestamp if you have that field
        if hasattr(user, 'last_updated'):
            user.last_updated = db.func.now()
        
        db.session.commit()
        
        return jsonify({
            'message': 'Profile updated successfully',
            'updated_fields': updated_fields,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500