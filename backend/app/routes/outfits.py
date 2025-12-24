from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models import Outfit, OutfitItem, OutfitCategory, OutfitCategoryJoin, Item
from app.services.supabase_service import supabase_service
from app.services.image_service import ImageService
from app.services.firebase_service import firebase_service
import os

outfits_bp = Blueprint('outfits', __name__)

@outfits_bp.route('', methods=['GET'])
@jwt_required()
def get_user_outfits():
    """Get all outfits for current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        outfits = Outfit.query.filter_by(user_id=current_user_id)\
                             .order_by(Outfit.date.desc())\
                             .all()
        
        outfits_data = []
        for outfit in outfits:
            outfit_data = outfit.to_dict()
            
            # Get items
            items = Item.query.join(
                OutfitItem, Item.item_id == OutfitItem.item_id
            ).filter(OutfitItem.outfit_id == outfit.outfit_id).all()
            
            outfit_data['items'] = [item.to_dict() for item in items]
            
            # Get categories
            categories = OutfitCategory.query.join(
                OutfitCategoryJoin, OutfitCategory.category_id == OutfitCategoryJoin.category_id
            ).filter(OutfitCategoryJoin.outfit_id == outfit.outfit_id).all()
            
            outfit_data['categories'] = [cat.category_name for cat in categories]
            outfits_data.append(outfit_data)
        
        return jsonify({
            'success': True,
            'outfits': outfits_data,
            'count': len(outfits_data)
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@outfits_bp.route('', methods=['POST'])
@jwt_required()
def create_outfit():
    """Create a new outfit"""
    try:
        current_user_id = int(get_jwt_identity())
        
        # Check if we have form data or JSON
        if request.is_json:
            data = request.get_json()
            image_file = None
        else:
            data = request.form.to_dict()
            # Handle JSON fields
            if 'item_ids' in data:
                import json
                data['item_ids'] = json.loads(data['item_ids'])
            if 'categories' in data:
                import json
                data['categories'] = json.loads(data['categories'])
            image_file = request.files.get('image')
        
        # Validate required fields
        if not data.get('name'):
            return jsonify({'success': False, 'error': 'Outfit name is required'}), 400
        
        if not data.get('item_ids') or len(data['item_ids']) == 0:
            return jsonify({'success': False, 'error': 'At least one item is required'}), 400
        
        # Verify all items belong to user
        for item_id in data['item_ids']:
            item = Item.query.get(item_id)
            if not item or item.user_id != current_user_id:
                return jsonify({'success': False, 'error': f'Item {item_id} not found or not owned by you'}), 400
        
        image_url = None
        
        # Handle image upload if provided
        if image_file and image_file.filename:
            if not ImageService.allowed_file(image_file.filename):
                return jsonify({'success': False, 'error': 'Invalid image format'}), 400
            
            # Save temp file
            temp_path = ImageService.save_temp_file(image_file, current_user_id, 'outfits')
            
            # Upload to Supabase
            image_url = supabase_service.upload_outfit_image(temp_path, current_user_id)
            
            # Cleanup temp file
            ImageService.cleanup_temp_file(temp_path)
        
        # Create outfit
        outfit = Outfit(
            user_id=current_user_id,
            outfit_name=data['name'].strip(),
            description=data.get('description', '').strip(),
            season=data.get('season', '').strip(),
            image_path=image_url,
            date=db.func.now()
        )
        
        db.session.add(outfit)
        db.session.commit()
        
        # Add items
        for item_id in data['item_ids']:
            outfit_item = OutfitItem(outfit_id=outfit.outfit_id, item_id=item_id)
            db.session.add(outfit_item)
        
        # Add categories
        for category_name in data.get('categories', []):
            if category_name.strip():
                # Find or create category for this user
                category = OutfitCategory.query.filter_by(
                    category_name=category_name.strip(),
                    user_id=current_user_id
                ).first()
                
                if not category:
                    category = OutfitCategory(
                        user_id=current_user_id,
                        category_name=category_name.strip()
                    )
                    db.session.add(category)
                    db.session.commit()
                
                join = OutfitCategoryJoin(outfit_id=outfit.outfit_id, category_id=category.category_id)
                db.session.add(join)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Outfit created successfully',
            'outfit': outfit.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@outfits_bp.route('/<int:outfit_id>', methods=['GET'])
@jwt_required()
def get_outfit(outfit_id):
    """Get a specific outfit"""
    try:
        current_user_id = int(get_jwt_identity())
        outfit = Outfit.query.get(outfit_id)
        
        if not outfit:
            return jsonify({'success': False, 'error': 'Outfit not found'}), 404
        
        if outfit.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Get items
        items = Item.query.join(
            OutfitItem, Item.item_id == OutfitItem.item_id
        ).filter(OutfitItem.outfit_id == outfit_id).all()
        
        # Get categories
        categories = OutfitCategory.query.join(
            OutfitCategoryJoin, OutfitCategory.category_id == OutfitCategoryJoin.category_id
        ).filter(OutfitCategoryJoin.outfit_id == outfit_id).all()
        
        outfit_data = outfit.to_dict()
        outfit_data['items'] = [item.to_dict() for item in items]
        outfit_data['categories'] = [cat.category_name for cat in categories]
        
        return jsonify({'success': True, 'outfit': outfit_data}), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@outfits_bp.route('/<int:outfit_id>', methods=['PUT'])
@jwt_required()
def update_outfit(outfit_id):
    """Update an outfit"""
    try:
        current_user_id = int(get_jwt_identity())
        outfit = Outfit.query.get(outfit_id)
        
        if not outfit:
            return jsonify({'success': False, 'error': 'Outfit not found'}), 404
        
        if outfit.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        data = request.get_json()
        
        # Update fields
        if 'name' in data:
            outfit.outfit_name = data['name'].strip()
        
        if 'description' in data:
            outfit.description = data['description'].strip()
        
        if 'season' in data:
            outfit.season = data['season'].strip()
        
        # Update items if provided
        if 'item_ids' in data:
            # Remove existing items
            OutfitItem.query.filter_by(outfit_id=outfit_id).delete()
            
            # Add new items
            for item_id in data['item_ids']:
                outfit_item = OutfitItem(outfit_id=outfit_id, item_id=item_id)
                db.session.add(outfit_item)
        
        # Update categories if provided
        if 'categories' in data:
            # Remove existing categories
            OutfitCategoryJoin.query.filter_by(outfit_id=outfit_id).delete()
            
            # Add new categories
            for category_name in data['categories']:
                if category_name.strip():
                    category = OutfitCategory.query.filter_by(
                        category_name=category_name.strip(),
                        user_id=current_user_id
                    ).first()
                    
                    if not category:
                        category = OutfitCategory(
                            user_id=current_user_id,
                            category_name=category_name.strip()
                        )
                        db.session.add(category)
                        db.session.commit()
                    
                    join = OutfitCategoryJoin(outfit_id=outfit_id, category_id=category.category_id)
                    db.session.add(join)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Outfit updated successfully',
            'outfit': outfit.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@outfits_bp.route('/<int:outfit_id>', methods=['DELETE'])
@jwt_required()
def delete_outfit(outfit_id):
    """Delete an outfit"""
    try:
        current_user_id = int(get_jwt_identity())
        outfit = Outfit.query.get(outfit_id)
        
        if not outfit:
            return jsonify({'success': False, 'error': 'Outfit not found'}), 404
        
        if outfit.user_id != current_user_id:
            return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
        # Delete image from Supabase if exists
        if outfit.image_path:
            supabase_service.delete_image(outfit.image_path)
        
        # Delete from database
        db.session.delete(outfit)
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'Outfit deleted successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@outfits_bp.route('/categories', methods=['GET'])
@jwt_required()
def get_outfit_categories():
    """Get all outfit categories for current user"""
    try:
        current_user_id = int(get_jwt_identity())
        
        categories = OutfitCategory.query.filter_by(user_id=current_user_id)\
                                       .order_by(OutfitCategory.category_name)\
                                       .all()
        
        return jsonify({
            'success': True,
            'categories': [{
                'id': cat.category_id,
                'name': cat.category_name
            } for cat in categories]
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500