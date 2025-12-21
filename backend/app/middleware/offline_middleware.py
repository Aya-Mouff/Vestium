# app/middleware/offline_middleware.py
import logging

logger = logging.getLogger(__name__)

class OfflineMiddleware:
    """Middleware to detect offline mode and queue operations"""
    
    def __init__(self, app=None):
        self.app = app
        if app:
            self.init_app(app)
    
    def init_app(self, app):
        """Initialize the middleware with the Flask app"""
        app.before_request(self.detect_offline_mode)
        app.after_request(self.add_offline_header)
        
        # Store in app extensions
        app.extensions['offline_middleware'] = self
    
    def detect_offline_mode(self):
        """Detect if request is in offline mode"""
        from flask import request
        
        offline_header = request.headers.get('X-Offline-Mode', 'false')
        request.offline_mode = offline_header.lower() == 'true'
        
        if request.offline_mode:
            logger.info(f"Offline mode detected for {request.path}")
    
    def add_offline_header(self, response):
        """Add offline capability header to responses"""
        response.headers['X-Offline-Capable'] = 'true'
        return response

# Create instance
offline_middleware = OfflineMiddleware()