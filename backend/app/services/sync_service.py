import os
import json
import logging
from datetime import datetime, timedelta
from flask import current_app
from sqlalchemy import and_
from app import db
from app.models import User, Item, Outfit, Post, Like, Comment, Follow

logger = logging.getLogger(__name__)

class SyncService:
    """Service to handle offline-online synchronization"""
    
    # Queue tables for offline operations
    @staticmethod
    def create_sync_tables_if_not_exists():
        """Create sync queue tables for offline operations"""
        # This would be called during app initialization
        # In a real implementation, you'd have migration scripts
        pass
    
    @staticmethod
    def get_pending_operations(user_id):
        """Get all pending sync operations for a user"""
        # In a real implementation, you'd query a sync_queue table
        return []
    
    @staticmethod
    def queue_operation(user_id, operation_type, table_name, data, local_id=None):
        """Queue an operation for later sync"""
        try:
            # In a real implementation, you'd insert into a sync_queue table
            operation = {
                'user_id': user_id,
                'operation_type': operation_type,  # CREATE, UPDATE, DELETE
                'table_name': table_name,
                'data': data,
                'local_id': local_id,
                'timestamp': datetime.utcnow().isoformat(),
                'status': 'pending',
                'retry_count': 0
            }
            
            # For now, just log it
            logger.info(f"Queued operation: {operation}")
            
            # In production: save to a database table or file
            sync_file = f"sync_queue_{user_id}.json"
            operations = []
            
            if os.path.exists(sync_file):
                with open(sync_file, 'r') as f:
                    operations = json.load(f)
            
            operations.append(operation)
            
            with open(sync_file, 'w') as f:
                json.dump(operations, f, indent=2)
            
            return True
        except Exception as e:
            logger.error(f"Failed to queue operation: {e}")
            return False
    
    @staticmethod
    def sync_user_data(user_id, access_token, force=False):
        """Sync all pending operations for a user"""
        try:
            sync_file = f"sync_queue_{user_id}.json"
            
            if not os.path.exists(sync_file):
                return {'success': True, 'synced': 0, 'failed': 0}
            
            with open(sync_file, 'r') as f:
                operations = json.load(f)
            
            # Filter pending operations
            pending_ops = [op for op in operations if op['status'] == 'pending']
            
            if not pending_ops and not force:
                return {'success': True, 'synced': 0, 'failed': 0}
            
            synced = 0
            failed = 0
            
            for operation in pending_ops:
                try:
                    # Here you would make actual API calls to sync
                    # For now, we'll simulate success
                    operation['status'] = 'synced'
                    operation['synced_at'] = datetime.utcnow().isoformat()
                    synced += 1
                    
                except Exception as e:
                    operation['status'] = 'failed'
                    operation['error'] = str(e)
                    operation['retry_count'] = operation.get('retry_count', 0) + 1
                    failed += 1
            
            # Save updated operations
            with open(sync_file, 'w') as f:
                json.dump(operations, f, indent=2)
            
            # Clean up old synced operations (older than 7 days)
            SyncService._cleanup_old_operations(user_id)
            
            return {
                'success': True,
                'synced': synced,
                'failed': failed,
                'total': len(pending_ops)
            }
            
        except Exception as e:
            logger.error(f"Sync failed: {e}")
            return {'success': False, 'error': str(e)}
    
    @staticmethod
    def _cleanup_old_operations(user_id):
        """Remove old synced operations"""
        try:
            sync_file = f"sync_queue_{user_id}.json"
            
            if not os.path.exists(sync_file):
                return
            
            with open(sync_file, 'r') as f:
                operations = json.load(f)
            
            cutoff_date = datetime.utcnow() - timedelta(days=7)
            
            # Keep only pending or recent operations
            filtered_ops = []
            for op in operations:
                if op['status'] == 'pending':
                    filtered_ops.append(op)
                elif op['status'] == 'synced':
                    synced_at = datetime.fromisoformat(op.get('synced_at', '2000-01-01'))
                    if synced_at > cutoff_date:
                        filtered_ops.append(op)
                else:  # failed - keep for retry
                    filtered_ops.append(op)
            
            with open(sync_file, 'w') as f:
                json.dump(filtered_ops, f, indent=2)
                
        except Exception as e:
            logger.error(f"Cleanup failed: {e}")
    
    @staticmethod
    def get_sync_status(user_id):
        """Get sync status for a user"""
        try:
            sync_file = f"sync_queue_{user_id}.json"
            
            if not os.path.exists(sync_file):
                return {
                    'has_pending': False,
                    'pending_count': 0,
                    'last_sync': None
                }
            
            with open(sync_file, 'r') as f:
                operations = json.load(f)
            
            pending = [op for op in operations if op['status'] == 'pending']
            synced = [op for op in operations if op['status'] == 'synced']
            
            # Get last sync time
            last_sync = None
            if synced:
                synced_times = [datetime.fromisoformat(op.get('synced_at', '')) 
                              for op in synced if op.get('synced_at')]
                if synced_times:
                    last_sync = max(synced_times).isoformat()
            
            return {
                'has_pending': len(pending) > 0,
                'pending_count': len(pending),
                'last_sync': last_sync,
                'total_operations': len(operations)
            }
            
        except Exception as e:
            logger.error(f"Failed to get sync status: {e}")
            return {
                'has_pending': False,
                'pending_count': 0,
                'last_sync': None,
                'error': str(e)
            }