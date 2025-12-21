from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Item, ItemCategory, ItemCategoryJoin
from app.services.supabase_service import supabase_service
from app.services.image_service import ImageService
# In app/routes/items.py - FIXED debug route
from flask import Blueprint, request, jsonify, current_app 
import os

items_bp = Blueprint('items', __name__)

@items_bp.route('', methods=['GET'])
@jwt_required()
def get_user_items():
    """Get all items for current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        items = Item.query.filter_by(user_id=current_user_id)\
                         .order_by(Item.date.desc())\
                         .all()
        
        items_data = []
        for item in items:
            item_dict = item.to_dict()
            
            # Get categories
            categories = ItemCategory.query.join(
                ItemCategoryJoin, ItemCategory.category_id == ItemCategoryJoin.category_id
            ).filter(ItemCategoryJoin.item_id == item.item_id).all()
            
            item_dict['categories'] = [cat.category_name for cat in categories]
            items_data.append(item_dict)
        
        return jsonify({
            'success': True,
            'items': items_data,
            'count': len(items_data)
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('', methods=['POST'])
@jwt_required()
def create_item():
    """Create a new item with image upload to Supabase"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Check if POST request has the file part
        if 'image' not in request.files:
            return jsonify({'success': False, 'error': 'No image file provided'}), 400
        
        file = request.files['image']
        
        # If user does not select file, browser submits empty file
        if file.filename == '':
            return jsonify({'success': False, 'error': 'No image selected'}), 400
        
        # Check file extension
        if not ImageService.allowed_file(file.filename):
            return jsonify({'success': False, 'error': 'File type not allowed. Use PNG, JPG, JPEG, GIF, or WEBP'}), 400
        
        # Get form data
        name = request.form.get('name', '').strip()
        description = request.form.get('description', '').strip()
        season = request.form.get('season', '').strip()
        categories = request.form.getlist('categories[]')
        
        # Validate required fields
        if not name:
            return jsonify({'success': False, 'error': 'Item name is required'}), 400
        
        # Save file temporarily
        temp_path = ImageService.save_temp_file(file, current_user_id, 'items')
        
        try:
            # Upload to Supabase
            image_url = supabase_service.upload_item_image(temp_path, current_user_id)
            
            # Create item in database
            item = Item(
                user_id=current_user_id,
                item_name=name,
                description=description,
                season=season,
                image_path=image_url,  # Store Supabase URL
                date=db.func.now()
            )
            
            db.session.add(item)
            db.session.commit()  # Commit to get item_id
            
            # Add categories
            for category_name in categories:
                category = ItemCategory.query.filter_by(category_name=category_name).first()
                if category:
                    join = ItemCategoryJoin(item_id=item.item_id, category_id=category.category_id)
                    db.session.add(join)
            
            db.session.commit()
            
            # Cleanup temp file
            ImageService.cleanup_temp_file(temp_path)
            
            return jsonify({
                'success': True,
                'message': 'Item created successfully',
                'item': item.to_dict()
            }), 201
            
        except Exception as e:
            # Cleanup temp file on error
            if os.path.exists(temp_path):
                ImageService.cleanup_temp_file(temp_path)
            raise
            
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('/<int:item_id>', methods=['GET'])
@jwt_required()
def get_item(item_id):
    """Get a specific item"""
    try:
        current_user_id = int(get_jwt_identity())
        item = Item.query.get(item_id)
        
        if not item:
            return jsonify({'success': False, 'error': 'Item not found'}), 404
        
        if item.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Get categories
        categories = ItemCategory.query.join(
            ItemCategoryJoin, ItemCategory.category_id == ItemCategoryJoin.category_id
        ).filter(ItemCategoryJoin.item_id == item_id).all()
        
        item_data = item.to_dict()
        item_data['categories'] = [cat.category_name for cat in categories]
        
        return jsonify({'success': True, 'item': item_data}), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('/<int:item_id>', methods=['PUT'])
@jwt_required()
def update_item(item_id):
    """Update an item"""
    try:
        current_user_id = int(get_jwt_identity())
        item = Item.query.get(item_id)
        
        if not item:
            return jsonify({'success': False, 'error': 'Item not found'}), 404
        
        if item.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        data = request.get_json()
        
        # Update fields
        if 'name' in data:
            item.item_name = data['name'].strip()
        
        if 'description' in data:
            item.description = data['description'].strip()
        
        if 'season' in data:
            item.season = data['season'].strip()
        
        # Update categories if provided
        if 'categories' in data:
            # Remove existing categories
            ItemCategoryJoin.query.filter_by(item_id=item_id).delete()
            
            # Add new categories
            for category_name in data['categories']:
                category = ItemCategory.query.filter_by(category_name=category_name).first()
                if category:
                    join = ItemCategoryJoin(item_id=item_id, category_id=category.category_id)
                    db.session.add(join)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Item updated successfully',
            'item': item.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('/<int:item_id>', methods=['DELETE'])
@jwt_required()
def delete_item(item_id):
    """Delete an item and its image from Supabase"""
    try:
        current_user_id = int(get_jwt_identity())
        item = Item.query.get(item_id)
        
        if not item:
            return jsonify({'success': False, 'error': 'Item not found'}), 404
        
        if item.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Check if item is used in any outfits
        from app.models import OutfitItem
        outfit_items = OutfitItem.query.filter_by(item_id=item_id).all()
        
        if outfit_items:
            # Get outfit details for error message
            from app.models import Outfit
            outfit_ids = [oi.outfit_id for oi in outfit_items]
            outfits = Outfit.query.filter(Outfit.outfit_id.in_(outfit_ids)).all()
            
            return jsonify({
                'success': False,
                'error': 'Cannot delete item. It is used in outfits.',
                'outfits': [{'id': o.outfit_id, 'name': o.outfit_name} for o in outfits]
            }), 400
        
        # Delete image from Supabase
        if item.image_path:
            supabase_service.delete_image(item.image_path)
        
        # Delete from database
        db.session.delete(item)
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'Item deleted successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('/categories', methods=['GET'])
@jwt_required()
def get_categories():
    """Get all item categories"""
    try:
        categories = ItemCategory.query.order_by(ItemCategory.category_name).all()
        
        return jsonify({
            'success': True,
            'categories': [{
                'id': cat.category_id,
                'name': cat.category_name
            } for cat in categories]
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@items_bp.route('/debug', methods=['GET'])
def debug_supabase():
    """Debug endpoint to check Supabase configuration"""
    from app.services.supabase_service import supabase_service
    
    debug_info = {
        'flask_app_config': {
            'SUPABASE_URL': current_app.config.get('SUPABASE_URL', 'NOT SET'),
            'SUPABASE_KEY_PREFIX': current_app.config.get('SUPABASE_KEY', 'NOT SET')[:20] + '...' if current_app.config.get('SUPABASE_KEY') else 'NOT SET',
            'SUPABASE_SERVICE_ROLE_KEY_PREFIX': current_app.config.get('SUPABASE_SERVICE_ROLE_KEY', 'NOT SET')[:20] + '...' if current_app.config.get('SUPABASE_SERVICE_ROLE_KEY') else 'NOT SET',
        },
        'supabase_service': {
            'initialized': supabase_service.is_initialized(),
            'instance_id': id(supabase_service),
        }
    }
    
    # Try a simple test upload
    try:
        test_content = b'Debug test from Flask'
        supabase = supabase_service.supabase
        response = supabase.storage.from_('vestium-images').upload(
            path='debug/test_flask.txt',
            file=test_content,
            file_options={"content-type": "text/plain"}
        )
        debug_info['test_upload'] = {
            'success': True,
            'response': str(response)
        }
    except Exception as e:
        debug_info['test_upload'] = {
            'success': False,
            'error': str(e)
        }
    
    return jsonify(debug_info)