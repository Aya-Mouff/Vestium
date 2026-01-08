# import os
# import json
# import logging
# from datetime import datetime, timedelta
# from flask import current_app
# from sqlalchemy import and_
# from app import db
# from app.models import User, Item, Outfit, Post, Like, Comment, Follow

# logger = logging.getLogger(__name__)

# class SyncService:
#     """Service to handle offline-online synchronization"""
    
#     # Queue tables for offline operations
#     @staticmethod
#     def create_sync_tables_if_not_exists():
#         """Create sync queue tables for offline operations"""
#         # This would be called during app initialization
#         # In a real implementation, you'd have migration scripts
#         pass
    
#     @staticmethod
#     def get_pending_operations(user_id):
#         """Get all pending sync operations for a user"""
#         # In a real implementation, you'd query a sync_queue table
#         return []
    
#     @staticmethod
#     def queue_operation(user_id, operation_type, table_name, data, local_id=None):
#         """Queue an operation for later sync"""
#         try:
#             # In a real implementation, you'd insert into a sync_queue table
#             operation = {
#                 'user_id': user_id,
#                 'operation_type': operation_type,  # CREATE, UPDATE, DELETE
#                 'table_name': table_name,
#                 'data': data,
#                 'local_id': local_id,
#                 'timestamp': datetime.utcnow().isoformat(),
#                 'status': 'pending',
#                 'retry_count': 0
#             }
            
#             # For now, just log it
#             logger.info(f"Queued operation: {operation}")
            
#             # In production: save to a database table or file
#             sync_file = f"sync_queue_{user_id}.json"
#             operations = []
            
#             if os.path.exists(sync_file):
#                 with open(sync_file, 'r') as f:
#                     operations = json.load(f)
            
#             operations.append(operation)
            
#             with open(sync_file, 'w') as f:
#                 json.dump(operations, f, indent=2)
            
#             return True
#         except Exception as e:
#             logger.error(f"Failed to queue operation: {e}")
#             return False
    
#     @staticmethod
#     def sync_user_data(user_id, access_token, force=False):
#         """Sync all pending operations for a user"""
#         try:
#             sync_file = f"sync_queue_{user_id}.json"
            
#             if not os.path.exists(sync_file):
#                 return {'success': True, 'synced': 0, 'failed': 0}
            
#             with open(sync_file, 'r') as f:
#                 operations = json.load(f)
            
#             # Filter pending operations
#             pending_ops = [op for op in operations if op['status'] == 'pending']
            
#             if not pending_ops and not force:
#                 return {'success': True, 'synced': 0, 'failed': 0}
            
#             synced = 0
#             failed = 0
            
#             for operation in pending_ops:
#                 try:
#                     # Here you would make actual API calls to sync
#                     # For now, we'll simulate success
#                     operation['status'] = 'synced'
#                     operation['synced_at'] = datetime.utcnow().isoformat()
#                     synced += 1
                    
#                 except Exception as e:
#                     operation['status'] = 'failed'
#                     operation['error'] = str(e)
#                     operation['retry_count'] = operation.get('retry_count', 0) + 1
#                     failed += 1
            
#             # Save updated operations
#             with open(sync_file, 'w') as f:
#                 json.dump(operations, f, indent=2)
            
#             # Clean up old synced operations (older than 7 days)
#             SyncService._cleanup_old_operations(user_id)
            
#             return {
#                 'success': True,
#                 'synced': synced,
#                 'failed': failed,
#                 'total': len(pending_ops)
#             }
            
#         except Exception as e:
#             logger.error(f"Sync failed: {e}")
#             return {'success': False, 'error': str(e)}
    
#     @staticmethod
#     def _cleanup_old_operations(user_id):
#         """Remove old synced operations"""
#         try:
#             sync_file = f"sync_queue_{user_id}.json"
            
#             if not os.path.exists(sync_file):
#                 return
            
#             with open(sync_file, 'r') as f:
#                 operations = json.load(f)
            
#             cutoff_date = datetime.utcnow() - timedelta(days=7)
            
#             # Keep only pending or recent operations
#             filtered_ops = []
#             for op in operations:
#                 if op['status'] == 'pending':
#                     filtered_ops.append(op)
#                 elif op['status'] == 'synced':
#                     synced_at = datetime.fromisoformat(op.get('synced_at', '2000-01-01'))
#                     if synced_at > cutoff_date:
#                         filtered_ops.append(op)
#                 else:  # failed - keep for retry
#                     filtered_ops.append(op)
            
#             with open(sync_file, 'w') as f:
#                 json.dump(filtered_ops, f, indent=2)
                
#         except Exception as e:
#             logger.error(f"Cleanup failed: {e}")
    
#     @staticmethod
#     def get_sync_status(user_id):
#         """Get sync status for a user"""
#         try:
#             sync_file = f"sync_queue_{user_id}.json"
            
#             if not os.path.exists(sync_file):
#                 return {
#                     'has_pending': False,
#                     'pending_count': 0,
#                     'last_sync': None
#                 }
            
#             with open(sync_file, 'r') as f:
#                 operations = json.load(f)
            
#             pending = [op for op in operations if op['status'] == 'pending']
#             synced = [op for op in operations if op['status'] == 'synced']
            
#             # Get last sync time
#             last_sync = None
#             if synced:
#                 synced_times = [datetime.fromisoformat(op.get('synced_at', '')) 
#                               for op in synced if op.get('synced_at')]
#                 if synced_times:
#                     last_sync = max(synced_times).isoformat()
            
#             return {
#                 'has_pending': len(pending) > 0,
#                 'pending_count': len(pending),
#                 'last_sync': last_sync,
#                 'total_operations': len(operations)
#             }
            
#         except Exception as e:
#             logger.error(f"Failed to get sync status: {e}")
#             return {
#                 'has_pending': False,
#                 'pending_count': 0,
#                 'last_sync': None,
#                 'error': str(e)
#             }

# -----------------------------------------------------------------------

# app/services/sync_service.py
import json
import logging
from datetime import datetime, timedelta
from app import db
from app.models import SyncQueue, User, Item, Outfit, Post, Comment, Like, Follow
from app.models import ItemCategory, ItemCategoryJoin, OutfitItem, OutfitCategory, OutfitCategoryJoin
from sqlalchemy import distinct
import traceback

logger = logging.getLogger(__name__)

class SyncService:
    """Complete sync service using your existing models"""
    
    @staticmethod
    def queue_operation(user_id: int, data: dict) -> dict:
        """Queue an operation for sync"""
        try:
            # Validate required fields
            required = ['action', 'entity_type', 'entity_data']
            for field in required:
                if field not in data:
                    return {'success': False, 'error': f'Missing {field}'}
            
            # Create sync entry
            sync_entry = SyncQueue(
                user_id=user_id,
                action=data['action'],
                entity_type=data['entity_type'],
                entity_id=data.get('entity_id'),
                entity_data=json.dumps(data['entity_data'], default=str),
                created_at=datetime.utcnow(),
                processed=False
            )
            
            db.session.add(sync_entry)
            db.session.commit()
            
            logger.info(f"Queued {data['action']} for {data['entity_type']} (user: {user_id})")
            
            return {
                'success': True,
                'queue_id': sync_entry.queue_id,
                'message': 'Operation queued'
            }
            
        except Exception as e:
            db.session.rollback()
            logger.error(f"Queue failed: {e}")
            return {'success': False, 'error': str(e)}
    
    @staticmethod
    def process_user_queue(user_id: int) -> dict:
        """Process all pending operations for a user"""
        try:
            pending = SyncQueue.query.filter_by(
                user_id=user_id,
                processed=False
            ).order_by(SyncQueue.created_at).all()
            
            if not pending:
                return {'success': True, 'message': 'No pending operations'}
            
            processed = 0
            failed = 0
            results = []
            
            for operation in pending:
                try:
                    # Skip if too many retries
                    if hasattr(operation, 'retry_count') and operation.retry_count >= 3:
                        operation.processed = True
                        operation.processed_at = datetime.utcnow()
                        failed += 1
                        continue
                    
                    # Process operation
                    result = SyncService._process_operation(operation)
                    
                    if result['success']:
                        operation.processed = True
                        operation.processed_at = datetime.utcnow()
                        processed += 1
                    else:
                        # Add retry_count if column exists
                        if hasattr(operation, 'retry_count'):
                            operation.retry_count = getattr(operation, 'retry_count', 0) + 1
                        failed += 1
                    
                    results.append({
                        'queue_id': operation.queue_id,
                        'success': result['success'],
                        'message': result.get('message'),
                        'error': result.get('error'),
                        'server_id': result.get('server_id')
                    })
                    
                except Exception as e:
                    logger.error(f"Operation {operation.queue_id} failed: {e}")
                    if hasattr(operation, 'retry_count'):
                        operation.retry_count = getattr(operation, 'retry_count', 0) + 1
                    failed += 1
            
            db.session.commit()
            
            # Update user's last sync
            user = User.query.get(user_id)
            if user and hasattr(user, 'last_sync'):
                user.last_sync = datetime.utcnow()
                db.session.commit()
            
            return {
                'success': True,
                'processed': processed,
                'failed': failed,
                'total': len(pending),
                'results': results
            }
            
        except Exception as e:
            db.session.rollback()
            logger.error(f"Process queue failed: {e}")
            return {'success': False, 'error': str(e)}
    
    @staticmethod
    def _process_operation(operation: SyncQueue) -> dict:
        """Process a single sync operation"""
        try:
            data = json.loads(operation.entity_data)
            
            # Route to appropriate handler
            if operation.entity_type == 'item':
                return SyncService._handle_item(operation, data)
            elif operation.entity_type == 'outfit':
                return SyncService._handle_outfit(operation, data)
            elif operation.entity_type == 'post':
                return SyncService._handle_post(operation, data)
            elif operation.entity_type == 'comment':
                return SyncService._handle_comment(operation, data)
            elif operation.entity_type == 'like':
                return SyncService._handle_like(operation, data)
            elif operation.entity_type == 'follow':
                return SyncService._handle_follow(operation, data)
            elif operation.entity_type == 'item_category':  # ADD THIS
                return SyncService._handle_item_category(operation, data)
            elif operation.entity_type == 'outfit_category':  # ADD THIS
                return SyncService._handle_outfit_category(operation, data)
            elif operation.entity_type == 'outfit_item':
                return SyncService._handle_outfit_item(operation, data)
            else:
                return {'success': False, 'error': f'Unknown entity: {operation.entity_type}'}
                
        except Exception as e:
            logger.error(f"Process operation failed: {e}")
            return {'success': False, 'error': str(e)}
    
    @staticmethod
    def _handle_item(operation: SyncQueue, data: dict) -> dict:
        """Handle item operations"""
        if operation.action == 'create':
            item = Item(
                user_id=operation.user_id,
                item_name=data.get('item_name', ''),
                description=data.get('description', ''),
                season=data.get('season', ''),
                image_path=data.get('image_path'),
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(item)
            db.session.flush()
            
            # Handle categories
            categories = data.get('categories', [])
            for category_name in categories:
                category = ItemCategory.query.filter_by(
                    category_name=category_name.strip()
                ).first()
                if category:
                    join = ItemCategoryJoin(
                        item_id=item.item_id,
                        category_id=category.category_id
                    )
                    db.session.add(join)
            
            return {'success': True, 'server_id': item.item_id}
            
        elif operation.action == 'update':
            item = Item.query.get(operation.entity_id)
            if not item or item.user_id != operation.user_id:
                return {'success': False, 'error': 'Item not found or unauthorized'}
            
            # Update fields
            if 'item_name' in data:
                item.item_name = data['item_name']
            if 'description' in data:
                item.description = data['description']
            if 'season' in data:
                item.season = data['season']
            if 'image_path' in data:
                item.image_path = data['image_path']
            
            return {'success': True}
            
        elif operation.action == 'delete':
            item = Item.query.get(operation.entity_id)
            if not item or item.user_id != operation.user_id:
                return {'success': False, 'error': 'Item not found or unauthorized'}
            
            db.session.delete(item)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_outfit_item(operation: SyncQueue, data: dict) -> dict:
        """Handle outfit-item relationship operations"""
        outfit_id = data.get('outfit_id')
        item_id = data.get('item_id')
        
        if not outfit_id or not item_id:
            return {'success': False, 'error': 'Missing outfit_id or item_id'}
        
        if operation.action == 'create':
            # Check if relationship already exists
            existing = OutfitItem.query.filter_by(
                outfit_id=outfit_id,
                item_id=item_id
            ).first()
            
            if existing:
                return {'success': True}
            
            # Verify both entities exist and belong to user
            outfit = Outfit.query.get(outfit_id)
            item = Item.query.get(item_id)
            
            if not outfit or not item:
                return {'success': False, 'error': 'Outfit or item not found'}
            
            if outfit.user_id != operation.user_id or item.user_id != operation.user_id:
                return {'success': False, 'error': 'Unauthorized'}
            
            outfit_item = OutfitItem(
                outfit_id=outfit_id,
                item_id=item_id
            )
            db.session.add(outfit_item)
            return {'success': True}
            
        elif operation.action == 'delete':
            outfit_item = OutfitItem.query.filter_by(
                outfit_id=outfit_id,
                item_id=item_id
            ).first()
            
            if outfit_item:
                # Verify ownership through outfit
                outfit = Outfit.query.get(outfit_id)
                if outfit and outfit.user_id == operation.user_id:
                    db.session.delete(outfit_item)
            
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_outfit(operation: SyncQueue, data: dict) -> dict:
        """Handle outfit operations"""
        if operation.action == 'create':
            outfit = Outfit(
                user_id=operation.user_id,
                outfit_name=data.get('outfit_name', ''),
                description=data.get('description', ''),
                season=data.get('season', ''),
                image_path=data.get('image_path'),
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(outfit)
            db.session.flush()
            
            # Add items
            item_ids = data.get('item_ids', [])
            for item_id in item_ids:
                item = Item.query.get(item_id)
                if item and item.user_id == operation.user_id:
                    join = OutfitItem(
                        outfit_id=outfit.outfit_id,
                        item_id=item_id
                    )
                    db.session.add(join)
            
            # Add categories
            categories = data.get('categories', [])
            for category_name in categories:
                category = OutfitCategory.query.filter_by(
                    user_id=operation.user_id,
                    category_name=category_name.strip()
                ).first()
                
                if not category:
                    category = OutfitCategory(
                        user_id=operation.user_id,
                        category_name=category_name.strip()
                    )
                    db.session.add(category)
                    db.session.flush()
                
                join = OutfitCategoryJoin(
                    outfit_id=outfit.outfit_id,
                    category_id=category.category_id
                )
                db.session.add(join)
            
            return {'success': True, 'server_id': outfit.outfit_id}
            
        elif operation.action == 'update':
            outfit = Outfit.query.get(operation.entity_id)
            if not outfit or outfit.user_id != operation.user_id:
                return {'success': False, 'error': 'Outfit not found or unauthorized'}
            
            # Update fields
            if 'outfit_name' in data:
                outfit.outfit_name = data['outfit_name']
            if 'description' in data:
                outfit.description = data['description']
            if 'season' in data:
                outfit.season = data['season']
            if 'image_path' in data:
                outfit.image_path = data['image_path']
            
            return {'success': True}
            
        elif operation.action == 'delete':
            outfit = Outfit.query.get(operation.entity_id)
            if not outfit or outfit.user_id != operation.user_id:
                return {'success': False, 'error': 'Outfit not found or unauthorized'}
            
            db.session.delete(outfit)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_post(operation: SyncQueue, data: dict) -> dict:
        """Handle post operations"""
        if operation.action == 'create':
            post = Post(
                user_id=operation.user_id,
                outfit_id=data.get('outfit_id'),
                image_path=data.get('image_path'),
                caption=data.get('caption', ''),
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(post)
            db.session.flush()
            
            return {'success': True, 'server_id': post.post_id}
            
        elif operation.action == 'update':
            post = Post.query.get(operation.entity_id)
            if not post or post.user_id != operation.user_id:
                return {'success': False, 'error': 'Post not found or unauthorized'}
            
            if 'caption' in data:
                post.caption = data['caption']
            
            return {'success': True}
            
        elif operation.action == 'delete':
            post = Post.query.get(operation.entity_id)
            if not post or post.user_id != operation.user_id:
                return {'success': False, 'error': 'Post not found or unauthorized'}
            
            db.session.delete(post)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_comment(operation: SyncQueue, data: dict) -> dict:
        """Handle comment operations"""
        if operation.action == 'create':
            comment = Comment(
                post_id=data['post_id'],
                user_id=operation.user_id,
                content=data.get('content', ''),
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(comment)
            
            return {'success': True}
            
        elif operation.action == 'update':
            comment = Comment.query.get(operation.entity_id)
            if not comment or comment.user_id != operation.user_id:
                return {'success': False, 'error': 'Comment not found or unauthorized'}
            
            comment.content = data.get('content', '')
            return {'success': True}
            
        elif operation.action == 'delete':
            comment = Comment.query.get(operation.entity_id)
            if not comment or comment.user_id != operation.user_id:
                return {'success': False, 'error': 'Comment not found or unauthorized'}
            
            db.session.delete(comment)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_item_category(operation: SyncQueue, data: dict) -> dict:
        """Handle item category operations"""
        if operation.action == 'create':
            # Check if category already exists
            existing = ItemCategory.query.filter_by(
                category_name=data.get('category_name', '').strip()
            ).first()
            
            if existing:
                return {'success': True, 'server_id': existing.category_id}
            
            category = ItemCategory(
                category_name=data.get('category_name', '').strip()
            )
            db.session.add(category)
            db.session.flush()
            
            return {'success': True, 'server_id': category.category_id}
            
        elif operation.action == 'update':
            category = ItemCategory.query.get(operation.entity_id)
            if not category:
                return {'success': False, 'error': 'Category not found'}
            
            if 'category_name' in data:
                category.category_name = data['category_name']
            
            return {'success': True}
            
        elif operation.action == 'delete':
            category = ItemCategory.query.get(operation.entity_id)
            if not category:
                return {'success': False, 'error': 'Category not found'}
            
            # Check if category is in use
            in_use = ItemCategoryJoin.query.filter_by(category_id=operation.entity_id).first()
            if in_use:
                return {'success': False, 'error': 'Category is in use by items'}
            
            db.session.delete(category)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}

    @staticmethod
    def _handle_outfit_category(operation: SyncQueue, data: dict) -> dict:
        """Handle outfit category operations"""
        if operation.action == 'create':
            # Check if category already exists for this user
            existing = OutfitCategory.query.filter_by(
                user_id=operation.user_id,
                category_name=data.get('category_name', '').strip()
            ).first()
            
            if existing:
                return {'success': True, 'server_id': existing.category_id}
            
            category = OutfitCategory(
                user_id=operation.user_id,
                category_name=data.get('category_name', '').strip()
            )
            db.session.add(category)
            db.session.flush()
            
            return {'success': True, 'server_id': category.category_id}
            
        elif operation.action == 'update':
            category = OutfitCategory.query.get(operation.entity_id)
            if not category or category.user_id != operation.user_id:
                return {'success': False, 'error': 'Category not found or unauthorized'}
            
            if 'category_name' in data:
                category.category_name = data['category_name']
            
            return {'success': True}
            
        elif operation.action == 'delete':
            category = OutfitCategory.query.get(operation.entity_id)
            if not category or category.user_id != operation.user_id:
                return {'success': False, 'error': 'Category not found or unauthorized'}
            
            # Check if category is in use
            in_use = OutfitCategoryJoin.query.filter_by(category_id=operation.entity_id).first()
            if in_use:
                return {'success': False, 'error': 'Category is in use by outfits'}
            
            db.session.delete(category)
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_like(operation: SyncQueue, data: dict) -> dict:
        """Handle like operations"""
        post_id = data.get('post_id')
        if not post_id:
            return {'success': False, 'error': 'Post ID required'}
        
        if operation.action == 'create':  # Like
            existing = Like.query.filter_by(
                post_id=post_id,
                user_id=operation.user_id
            ).first()
            
            if existing:
                return {'success': True}
            
            like = Like(
                post_id=post_id,
                user_id=operation.user_id,
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(like)
            return {'success': True}
            
        elif operation.action == 'delete':  # Unlike
            like = Like.query.filter_by(
                post_id=post_id,
                user_id=operation.user_id
            ).first()
            
            if like:
                db.session.delete(like)
            
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def _handle_follow(operation: SyncQueue, data: dict) -> dict:
        """Handle follow operations"""
        following_id = data.get('following_id')
        if not following_id:
            return {'success': False, 'error': 'Following ID required'}
        
        if following_id == operation.user_id:
            return {'success': False, 'error': 'Cannot follow yourself'}
        
        if operation.action == 'create':  # Follow
            existing = Follow.query.filter_by(
                following_id=following_id,
                follower_id=operation.user_id
            ).first()
            
            if existing:
                return {'success': True}
            
            follow = Follow(
                following_id=following_id,
                follower_id=operation.user_id,
                date=datetime.fromisoformat(data.get('date')) if data.get('date') else datetime.utcnow()
            )
            db.session.add(follow)
            return {'success': True}
            
        elif operation.action == 'delete':  # Unfollow
            follow = Follow.query.filter_by(
                following_id=following_id,
                follower_id=operation.user_id
            ).first()
            
            if follow:
                db.session.delete(follow)
            
            return {'success': True}
            
        return {'success': False, 'error': 'Unknown action'}
    
    @staticmethod
    def get_user_data(user_id: int) -> dict:
        """Get all user data for sync"""
        try:
            # Get all user data
            items = Item.query.filter_by(user_id=user_id).all()
            outfits = Outfit.query.filter_by(user_id=user_id).all()
            posts = Post.query.filter_by(user_id=user_id).all()
            comments = Comment.query.filter_by(user_id=user_id).all()
            likes = Like.query.filter_by(user_id=user_id).all()
            following = Follow.query.filter_by(follower_id=user_id).all()
            followers = Follow.query.filter_by(following_id=user_id).all()

            # Get item categories
            item_categories_list = ItemCategory.query.all()
            
            # Get outfit categories for this user
            outfit_categories_list = OutfitCategory.query.filter_by(user_id=user_id).all()
            
            data = {
                'items': [item.to_dict() for item in items],
                'outfits': [outfit.to_dict() for outfit in outfits],
                'posts': [post.to_dict() for post in posts],
                'comments': [comment.to_dict() for comment in comments],
                'likes': [like.to_dict() for like in likes],
                'following': [follow.to_dict() for follow in following],
                'followers': [follow.to_dict() for follow in followers],
            }
            data['item_categories'] = [cat.to_dict() for cat in item_categories_list]
            data['outfit_categories'] = [cat.to_dict() for cat in outfit_categories_list]
            
            
            # Get item categories
            item_categories = []
            for item in items:
                joins = ItemCategoryJoin.query.filter_by(item_id=item.item_id).all()
                for join in joins:
                    category = ItemCategory.query.get(join.category_id)
                    if category:
                        item_categories.append({
                            'item_id': item.item_id,
                            'category_name': category.category_name
                        })
            data['item_categories'] = item_categories
            
            # Get outfit items and categories
            outfit_items = []
            outfit_categories = []
            
            for outfit in outfits:
                # Outfit items
                joins = OutfitItem.query.filter_by(outfit_id=outfit.outfit_id).all()
                for join in joins:
                    outfit_items.append({
                        'outfit_id': outfit.outfit_id,
                        'item_id': join.item_id
                    })
                
                # Outfit categories
                category_joins = OutfitCategoryJoin.query.filter_by(outfit_id=outfit.outfit_id).all()
                for join in category_joins:
                    category = OutfitCategory.query.get(join.category_id)
                    if category:
                        outfit_categories.append({
                            'outfit_id': outfit.outfit_id,
                            'category_name': category.category_name
                        })
            
            data['outfit_items'] = outfit_items
            data['outfit_categories'] = outfit_categories
            
            return {
                'success': True,
                'data': data,
                'timestamp': datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Get user data failed: {e}")
            return {'success': False, 'error': str(e)}
    
    @staticmethod
    def get_sync_status(user_id: int) -> dict:
        """Get sync status for user"""
        try:
            total = SyncQueue.query.filter_by(user_id=user_id).count()
            pending = SyncQueue.query.filter_by(user_id=user_id, processed=False).count()
            
            user = User.query.get(user_id)
            last_sync = user.last_sync.isoformat() if user and user.last_sync else None
            
            return {
                'total_operations': total,
                'pending_operations': pending,
                'last_sync': last_sync
            }
            
        except Exception as e:
            logger.error(f"Get status failed: {e}")
            return {'error': str(e)}
    
    @staticmethod
    def run_auto_sync():
        """Auto-sync job for cron"""
        logger.info("🔄 Running auto-sync...")
        
        try:
            # Get users with pending operations
            pending_users = db.session.query(
                distinct(SyncQueue.user_id)
            ).filter(
                SyncQueue.processed == False
            ).all()
            
            user_ids = [user_id for (user_id,) in pending_users]
            
            if not user_ids:
                logger.info("No pending operations")
                return
            
            synced = 0
            total_processed = 0
            
            for user_id in user_ids:
                try:
                    user = User.query.get(user_id)
                    # Only sync active users
                    if user and user.last_login and (datetime.utcnow() - user.last_login).days < 1:
                        result = SyncService.process_user_queue(user_id)
                        if result['success']:
                            synced += 1
                            total_processed += result.get('processed', 0)
                except Exception as e:
                    logger.error(f"Failed user {user_id}: {e}")
                    continue
            
            # Cleanup old processed operations
            week_ago = datetime.utcnow() - timedelta(days=7)
            deleted = SyncQueue.query.filter(
                SyncQueue.processed == True,
                SyncQueue.processed_at < week_ago
            ).delete()
            
            db.session.commit()
            
            logger.info(f"✅ Auto-sync: {synced} users, {total_processed} ops, cleaned {deleted}")
            
        except Exception as e:
            logger.error(f"❌ Auto-sync failed: {e}")

# Global instance
sync_service = SyncService()