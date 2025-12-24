# app/services/image_service.py
import os
import uuid
from datetime import datetime
from werkzeug.utils import secure_filename
from PIL import Image
import logging

logger = logging.getLogger(__name__)

class ImageService:
    @staticmethod
    def allowed_file(filename: str, allowed_extensions: set = None) -> bool:
        """Check if file extension is allowed"""
        if allowed_extensions is None:
            allowed_extensions = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
        
        return '.' in filename and \
               filename.rsplit('.', 1)[1].lower() in allowed_extensions
    
    @staticmethod
    def generate_filename(user_id: int, original_filename: str, prefix: str = '') -> str:
        """Generate a secure unique filename"""
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        unique_id = uuid.uuid4().hex[:8]
        ext = os.path.splitext(original_filename)[1]
        
        safe_name = secure_filename(original_filename)
        base_name = os.path.splitext(safe_name)[0]
        
        if prefix:
            filename = f"{prefix}_{user_id}_{timestamp}_{unique_id}_{base_name}{ext}"
        else:
            filename = f"{user_id}_{timestamp}_{unique_id}_{base_name}{ext}"
        
        return filename
    
    @staticmethod
    def save_temp_file(file, user_id: int, folder: str = 'temp') -> str:
        """Save uploaded file temporarily before uploading to Supabase"""
        # Create temp directory
        temp_dir = os.path.join('temp_uploads', folder, str(user_id))
        os.makedirs(temp_dir, exist_ok=True)
        
        # Generate filename
        filename = ImageService.generate_filename(user_id, file.filename, folder)
        filepath = os.path.join(temp_dir, filename)
        
        # Save file
        file.save(filepath)
        
        # Optimize image if needed
        ImageService.optimize_image(filepath)
        
        logger.info(f"✅ File saved temporarily: {filepath}")
        return filepath
    
    @staticmethod
    def optimize_image(filepath: str, max_size: tuple = (1200, 1200), quality: int = 85):
        """Optimize image size and quality"""
        try:
            with Image.open(filepath) as img:
                # Convert to RGB if necessary
                if img.mode in ('RGBA', 'LA', 'P'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    if img.mode == 'P':
                        img = img.convert('RGBA')
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
                
                # Resize if too large
                img.thumbnail(max_size, Image.Resampling.LANCZOS)
                
                # Save optimized
                img.save(filepath, 'JPEG' if filepath.lower().endswith('.jpg') else 'PNG', 
                        quality=quality, optimize=True)
                
                logger.info(f"✅ Image optimized: {filepath}")
                
        except Exception as e:
            logger.error(f"❌ Failed to optimize image {filepath}: {e}")
    
    @staticmethod
    def cleanup_temp_file(filepath: str):
        """Delete temporary file"""
        try:
            if os.path.exists(filepath):
                os.remove(filepath)
                logger.info(f"✅ Temp file cleaned up: {filepath}")
        except Exception as e:
            logger.error(f"❌ Failed to cleanup temp file {filepath}: {e}")