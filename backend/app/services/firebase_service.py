# app/services/firebase_service.py
import os
import json
import logging
from flask import current_app

logger = logging.getLogger(__name__)

class FirebaseService:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(FirebaseService, cls).__new__(cls)
            cls._instance.initialized = False
        return cls._instance
    def initialize(self, app=None):
        """Initialize Firebase Admin SDK - call this explicitly from create_app()"""
        logger.info(f"🔥 FirebaseService.initialize() called")
        
        # Check if already initialized
        if self.initialized:
            logger.info("🔥 Firebase already initialized")
            return True
        
        try:
            import firebase_admin
            from firebase_admin import credentials
            
            logger.info(f"🔥 firebase_admin imported successfully")
            
            # Check if Firebase is already initialized globally
            if firebase_admin._apps:
                logger.info("🔥 Firebase already initialized globally")
                self.initialized = True
                return True
            
            if app:
                # Get config from app
                cred_path = app.config.get('FIREBASE_CREDENTIALS_PATH')
                logger.info(f"🔥 Got cred_path from app config: {cred_path}")
            else:
                # Try to get from current_app if available
                try:
                    cred_path = current_app.config.get('FIREBASE_CREDENTIALS_PATH')
                    logger.info(f"🔥 Got cred_path from current_app: {cred_path}")
                except RuntimeError:
                    # No app context
                    logger.warning("No app context for Firebase initialization")
                    self.initialized = False
                    return False
            
            logger.info(f"🔥 Checking if cred_path exists: {cred_path}")
            if cred_path and os.path.exists(cred_path):
                logger.info(f"🔥 Credentials file exists, loading...")
                # Load from file
                cred = credentials.Certificate(cred_path)
            else:
                logger.warning(f"🔥 Credentials file not found at {cred_path}")
                # Try environment variable
                cred_json = os.environ.get('FIREBASE_CREDENTIALS_JSON')
                if cred_json:
                    logger.info(f"🔥 Trying environment variable...")
                    cred_dict = json.loads(cred_json)
                    cred = credentials.Certificate(cred_dict)
                else:
                    logger.warning("No Firebase credentials found. Notifications disabled.")
                    self.initialized = False
                    return False
            
            logger.info(f"🔥 Initializing firebase_admin...")
            firebase_admin.initialize_app(cred)
            self.initialized = True
            logger.info("✅ Firebase Admin SDK initialized")
            return True
            
        except ImportError as e:
            logger.warning(f"Firebase Admin SDK not installed: {e}")
            self.initialized = False
            return False
        except Exception as e:
            logger.error(f"❌ Failed to initialize Firebase: {e}")
            import traceback
            logger.error(traceback.format_exc())
            self.initialized = False
            return False
    # def initialize(self, app=None):
    #     """Initialize Firebase Admin SDK - call this explicitly from create_app()"""
    #     try:
    #         # Try to import firebase_admin here to avoid import errors during migrations
    #         import firebase_admin
    #         from firebase_admin import credentials
            
    #         if app:
    #             # Get config from app
    #             cred_path = app.config.get('FIREBASE_CREDENTIALS_PATH')
    #         else:
    #             # Try to get from current_app if available
    #             try:
    #                 cred_path = current_app.config.get('FIREBASE_CREDENTIALS_PATH')
    #             except RuntimeError:
    #                 # No app context
    #                 logger.warning("No app context for Firebase initialization")
    #                 return
            
    #         if cred_path and os.path.exists(cred_path):
    #             # Load from file
    #             cred = credentials.Certificate(cred_path)
    #         else:
    #             # Try environment variable
    #             cred_json = os.environ.get('FIREBASE_CREDENTIALS_JSON')
    #             if cred_json:
    #                 cred_dict = json.loads(cred_json)
    #                 cred = credentials.Certificate(cred_dict)
    #             else:
    #                 logger.warning("No Firebase credentials found. Notifications disabled.")
    #                 self.initialized = False
    #                 return
            
    #         firebase_admin.initialize_app(cred)
    #         self.initialized = True
    #         logger.info("✅ Firebase Admin SDK initialized")
            
    #     except ImportError as e:
    #         logger.warning(f"Firebase Admin SDK not installed: {e}")
    #         self.initialized = False
    #     except Exception as e:
    #         logger.error(f"❌ Failed to initialize Firebase: {e}")
    #         self.initialized = False
    
    def send_notification(self, device_token: str, title: str, body: str, data: dict = None) -> bool:
        """Send push notification to a device"""
        if not self.initialized:
            logger.warning("Firebase not initialized. Skipping notification.")
            return False
        
        try:
            import firebase_admin
            from firebase_admin import messaging
            
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body,
                ),
                data=data or {},
                token=device_token,
            )
            
            response = messaging.send(message)
            logger.info(f"✅ Notification sent: {response}")
            return True
            
        except Exception as e:
            logger.error(f"❌ Failed to send notification: {e}")
            return False
    
    def send_to_user(self, user_id: int, title: str, body: str, data: dict = None) -> bool:
        """Send notification to a user (you need to store device tokens in your DB)"""
        # In a real app, you would fetch the device token from your database
        # For now, this is a placeholder
        from app.models import User
        
        user = User.query.get(user_id)
        if user and hasattr(user, 'device_token') and user.device_token:
            return self.send_notification(user.device_token, title, body, data)
        return False
    
    def send_like_notification(self, post_id: int, liker_id: int, post_owner_id: int):
        """Send notification when someone likes a post"""
        from app.models import User
        liker = User.query.get(liker_id)
        liker_name = liker.username if liker else "Someone"
        
        return self.send_to_user(
            user_id=post_owner_id,
            title="New Like",
            body=f"{liker_name} liked your post",
            data={
                'type': 'like',
                'post_id': str(post_id),
                'liker_id': str(liker_id)
            }
        )
    
    def send_comment_notification(self, post_id: int, commenter_id: int, post_owner_id: int):
        """Send notification when someone comments on a post"""
        from app.models import User
        commenter = User.query.get(commenter_id)
        commenter_name = commenter.username if commenter else "Someone"
        
        return self.send_to_user(
            user_id=post_owner_id,
            title="New Comment",
            body=f"{commenter_name} commented on your post",
            data={
                'type': 'comment',
                'post_id': str(post_id),
                'commenter_id': str(commenter_id)
            }
        )
    
    def send_follow_notification(self, follower_id: int, following_id: int):
        """Send notification when someone follows a user"""
        from app.models import User
        follower = User.query.get(follower_id)
        follower_name = follower.username if follower else "Someone"
        
        return self.send_to_user(
            user_id=following_id,
            title="New Follower",
            body=f"{follower_name} started following you",
            data={
                'type': 'follow',
                'follower_id': str(follower_id)
            }
        )

# Singleton instance - THIS MUST BE AT THE END OF THE FILE
firebase_service = FirebaseService()