# app/__init__.py
from app.middleware.offline_middleware import offline_middleware
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv

# Initialize extensions
db = SQLAlchemy()
migrate = Migrate()
cors = CORS()
jwt = JWTManager()

# Load environment variables from .env file
load_dotenv()

def create_app():
    app = Flask(__name__)
    
    # Load from .env, with fallbacks
    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'your-secret-key-change-in-production')
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'postgresql://postgres:12345678@localhost:5432/vestium_db')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    
    # JWT from .env
    app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'your-jwt-secret-key-change-in-production')
    app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=1)
    app.config['JWT_REFRESH_TOKEN_EXPIRES'] = timedelta(days=30)
    app.config['JWT_TOKEN_LOCATION'] = ['headers']
    app.config['JWT_HEADER_NAME'] = 'Authorization'
    app.config['JWT_HEADER_TYPE'] = 'Bearer'
    
    # CORS from .env
    cors_origins = os.environ.get('CORS_ORIGINS', 'http://localhost:3000,http://localhost:5000')
    app.config['CORS_ORIGINS'] = [origin.strip() for origin in cors_origins.split(',')]
    
    # Supabase Configuration
    app.config['SUPABASE_URL'] = os.environ.get('SUPABASE_URL', '')
    app.config['SUPABASE_KEY'] = os.environ.get('SUPABASE_KEY', '')
    app.config['SUPABASE_SERVICE_ROLE_KEY'] = os.environ.get('SUPABASE_SERVICE_ROLE_KEY', '')
    
    # Firebase Configuration
    app.config['FIREBASE_CREDENTIALS_PATH'] = os.environ.get('FIREBASE_CREDENTIALS_PATH', 'config/firebase-service-account.json')
    app.config['FIREBASE_PROJECT_ID'] = os.environ.get('FIREBASE_PROJECT_ID', 'vestium-backend')
    
    # Initialize extensions with app
    db.init_app(app)
    migrate.init_app(app, db)
    cors.init_app(app, resources={r"/api/*": {"origins": app.config['CORS_ORIGINS']}})
    jwt.init_app(app)
    
    # Initialize offline middleware
    offline_middleware.init_app(app)
    
    # Initialize services immediately
    def initialize_services_on_startup():
        """Initialize external services when app starts"""
        with app.app_context():
            print("🚀 Initializing Vestium services...")
            
            # Initialize Supabase service
            try:
                from app.services.supabase_service import supabase_service
                if hasattr(supabase_service, 'initialize'):
                    if supabase_service.initialize():
                        print("✅ Supabase service initialized successfully")
                    else:
                        print("⚠️ Supabase service failed to initialize - check your .env configuration")
                else:
                    # Supabase service auto-initializes
                    if hasattr(supabase_service, 'supabase') and supabase_service.supabase:
                        print("✅ Supabase service initialized successfully")
                    else:
                        print("⚠️ Supabase service not initialized - check your .env configuration")
            except Exception as e:
                print(f"❌ Error initializing Supabase: {e}")
            
            # Initialize Firebase service
            try:
                from app.services.firebase_service import firebase_service
                # Initialize Firebase with app config
                firebase_service.initialize(app)
                
                # Check if initialized
                if firebase_service.initialized:
                    print("✅ Firebase service initialized - push notifications enabled")
                else:
                    print("⚠️ Firebase service not initialized - push notifications disabled")
                    
            except Exception as e:
                print(f"⚠️ Firebase service error: {e}")
    
    # Initialize services when app starts
    initialize_services_on_startup()
    
    # Register new blueprints
    from app.routes.sync import sync_bp
    app.register_blueprint(sync_bp, url_prefix='/api/sync')
    
    # Import models
    from app import models
    
    # Register blueprints
    from app.routes.auth import auth_bp
    from app.routes.users import users_bp
    from app.routes.items import items_bp
    from app.routes.outfits import outfits_bp
    from app.routes.posts import posts_bp
    from app.routes.feed import feed_bp
    
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(users_bp, url_prefix='/api/users')
    app.register_blueprint(items_bp, url_prefix='/api/items')
    app.register_blueprint(outfits_bp, url_prefix='/api/outfits')
    app.register_blueprint(posts_bp, url_prefix='/api/posts')
    app.register_blueprint(feed_bp, url_prefix='/api/feed')
    
    # Health check endpoint
    @app.route('/api/health')
    def health_check():
        from app.models import User
        try:
            user_count = User.query.count()
            
            # Check Supabase status
            supabase_status = False
            try:
                from app.services.supabase_service import supabase_service
                supabase_status = hasattr(supabase_service, 'supabase') and supabase_service.supabase is not None
            except:
                pass
            
            # Check Firebase status
            firebase_status = False
            try:
                from app.services.firebase_service import firebase_service
                firebase_status = firebase_service.initialized
            except:
                pass
            
            return {
                'status': 'healthy',
                'service': 'Vestium API',
                'version': '1.0.0',
                'database': 'connected',
                'database_records': user_count,
                'supabase': 'connected' if supabase_status else 'disconnected',
                'firebase': 'initialized' if firebase_status else 'disabled',
                'timestamp': datetime.utcnow().isoformat()
            }
        except Exception as e:
            return {'status': 'unhealthy', 'error': str(e)}, 500
    
    @app.route('/')
    def index():
        # Check current status
        supabase_status = False
        firebase_status = False
        
        try:
            from app.services.supabase_service import supabase_service
            supabase_status = hasattr(supabase_service, 'supabase') and supabase_service.supabase is not None
        except:
            pass
        
        try:
            from app.services.firebase_service import firebase_service
            firebase_status = firebase_service.initialized
        except:
            pass
        
        return {
            'message': 'Vestium API',
            'version': '1.0.0',
            'services': {
                'supabase': 'connected' if supabase_status else 'disconnected',
                'firebase': 'initialized' if firebase_status else 'disabled'
            },
            'endpoints': {
                'auth': '/api/auth',
                'users': '/api/users',
                'items': '/api/items',
                'outfits': '/api/outfits',
                'posts': '/api/posts',
                'feed': '/api/feed',
                'sync': '/api/sync',
                'health': '/api/health'
            }
        }
    
    return app