# app/services/supabase_service.py
import os
from supabase import create_client, Client
from flask import current_app
import uuid
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

class SupabaseService:
    _instance = None
    _initialized = False
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(SupabaseService, cls).__new__(cls)
        return cls._instance
    
    def initialize(self):
        """Initialize Supabase client"""
        if self._initialized:
            return True
            
        try:
            # Get configuration
            supabase_url = current_app.config.get('SUPABASE_URL', '')
            supabase_key = current_app.config.get('SUPABASE_KEY', '')
            
            if not supabase_url:
                logger.error("❌ SUPABASE_URL not configured")
                return False
            if not supabase_key:
                logger.error("❌ SUPABASE_KEY not configured")
                return False
            
            logger.info(f"🔗 Connecting to Supabase...")
            
            # Create client
            self.supabase: Client = create_client(supabase_url, supabase_key)
            
            # Test connection by trying to access storage
            try:
                # Try to list files in the bucket (empty list is fine)
                files = self.supabase.storage.from_('vestium-images').list()
                logger.info(f"✅ Supabase connected. Found {len(files)} files in 'vestium-images' bucket")
                
                self._initialized = True
                return True
                
            except Exception as e:
                logger.error(f"❌ Failed to access Supabase storage: {e}")
                logger.info("💡 Check if your Supabase key has storage permissions")
                return False
                
        except Exception as e:
            logger.error(f"❌ Failed to initialize Supabase client: {e}")
            return False
    
    def upload_image(self, file_path: str, user_id: int, folder: str = 'items') -> str:
        """
        Upload image to Supabase Storage
        Returns public URL of uploaded image
        """
        if not self._initialized:
            if not self.initialize():
                raise Exception("Failed to initialize Supabase client")
        
        try:
            # Read file
            with open(file_path, 'rb') as f:
                file_data = f.read()
            
            # Generate unique filename
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            file_ext = os.path.splitext(file_path)[1].lower()
            
            # Clean folder name
            folder = folder.strip('/')
            
            # Create folder structure
            filename = f"{folder}/{user_id}/{timestamp}_{uuid.uuid4().hex[:8]}{file_ext}"
            
            # Determine content type
            content_types = {
                '.jpg': 'image/jpeg',
                '.jpeg': 'image/jpeg',
                '.png': 'image/png',
                '.gif': 'image/gif',
                '.webp': 'image/webp'
            }
            content_type = content_types.get(file_ext, 'image/jpeg')
            
            logger.info(f"📤 Uploading {file_path} to {filename}")
            
            # Upload to Supabase Storage - SIMPLIFIED VERSION
            response = self.supabase.storage.from_('vestium-images').upload(
                path=filename,
                file=file_data,
                file_options={"content-type": content_type}
            )
            
            logger.info(f"✅ Upload response: {response}")
            
            # Get public URL
            public_url = self.supabase.storage.from_('vestium-images').get_public_url(filename)
            
            logger.info(f"✅ Image uploaded successfully: {public_url}")
            return public_url
            
        except Exception as e:
            logger.error(f"❌ Failed to upload image to Supabase: {e}")
            # Provide more helpful error message
            error_msg = str(e)
            if '413' in error_msg:
                raise Exception("File too large. Maximum size is 10MB.")
            elif '401' in error_msg or '403' in error_msg:
                raise Exception("Authentication failed. Check your Supabase API key permissions.")
            elif '404' in error_msg:
                raise Exception("Bucket 'vestium-images' not found or not accessible.")
            else:
                raise Exception(f"Upload failed: {error_msg}")
    
    def delete_image(self, image_url: str) -> bool:
        """Delete image from Supabase Storage"""
        if not self._initialized:
            logger.error("Supabase client not initialized")
            return False
        
        try:
            # Extract filename from URL
            # URL format: https://xyz.supabase.co/storage/v1/object/public/vestium-images/folder/filename
            parts = image_url.split('/vestium-images/')
            if len(parts) != 2:
                logger.error(f"Invalid image URL format: {image_url}")
                return False
            
            filename = parts[1]
            logger.info(f"🗑️ Deleting image: {filename}")
            
            # Delete from Supabase
            result = self.supabase.storage.from_('vestium-images').remove([filename])
            logger.info(f"✅ Delete result: {result}")
            return True
            
        except Exception as e:
            logger.error(f"❌ Failed to delete image: {e}")
            return False
    
    # Convenience methods
    def upload_user_profile(self, file_path: str, user_id: int) -> str:
        return self.upload_image(file_path, user_id, folder='profiles')
    
    def upload_item_image(self, file_path: str, user_id: int) -> str:
        return self.upload_image(file_path, user_id, folder='items')
    
    def upload_outfit_image(self, file_path: str, user_id: int) -> str:
        return self.upload_image(file_path, user_id, folder='outfits')
    
    def upload_post_image(self, file_path: str, user_id: int) -> str:
        return self.upload_image(file_path, user_id, folder='posts')
    
    def is_initialized(self) -> bool:
        return self._initialized

# Singleton instance
supabase_service = SupabaseService()