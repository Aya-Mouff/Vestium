# app/models.py
from app import db
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    __tablename__ = 'user'
    
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    full_name = db.Column(db.String(100), nullable=False)
    bio = db.Column(db.Text)
    pfp = db.Column(db.Text)  # Profile picture URL
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)
    last_login = db.Column(db.DateTime)
    last_sync = db.Column(db.DateTime)  # Added for sync
    email_verified = db.Column(db.Boolean, default=False)
    camera_permission = db.Column(db.Boolean, default=False)
    gallery_permission = db.Column(db.Boolean, default=False)
    is_admin = db.Column(db.Boolean, default=False)  # Added for admin features
    refresh_token = db.Column(db.Text)
    firebase_uid = db.Column(db.String(255), unique=True)
    device_token = db.Column(db.Text)  # Added for push notifications
    
    # Relationships
    items = db.relationship('Item', backref='owner', lazy=True, cascade='all, delete-orphan')
    outfits = db.relationship('Outfit', backref='creator', lazy=True, cascade='all, delete-orphan')
    posts = db.relationship('Post', backref='author', lazy=True, foreign_keys='Post.user_id')
    comments = db.relationship('Comment', backref='commenter', lazy=True)
    likes = db.relationship('Like', backref='liker', lazy=True)
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        return {
            'user_id': self.user_id,
            'username': self.username,
            'full_name': self.full_name,
            'bio': self.bio,
            'pfp': self.pfp,
            'email': self.email,
            'date_created': self.date_created.isoformat() if self.date_created else None,
            'last_login': self.last_login.isoformat() if self.last_login else None,
            'last_sync': self.last_sync.isoformat() if self.last_sync else None,
            'email_verified': self.email_verified,
            'camera_permission': self.camera_permission,
            'gallery_permission': self.gallery_permission,
            'is_admin': self.is_admin,
            'device_token': self.device_token
        }

# Item Category Model
class ItemCategory(db.Model):
    __tablename__ = 'items_categories'
    
    category_id = db.Column(db.Integer, primary_key=True)
    category_name = db.Column(db.String(50), nullable=False, unique=True)
    
    def to_dict(self):
        return {
            'category_id': self.category_id,
            'category_name': self.category_name
        }

# Item Model
class Item(db.Model):
    __tablename__ = 'items'
    
    item_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    image_path = db.Column(db.Text)
    item_name = db.Column(db.String(100))
    description = db.Column(db.Text)
    season = db.Column(db.String(20))
    date = db.Column(db.DateTime, default=datetime.utcnow)
    last_updated = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # Added for sync
    
    def to_dict(self):
        return {
            'item_id': self.item_id,
            'user_id': self.user_id,
            'image_path': self.image_path,
            'item_name': self.item_name,
            'description': self.description,
            'season': self.season,
            'date': self.date.isoformat() if self.date else None,
            'last_updated': self.last_updated.isoformat() if self.last_updated else None
        }

# Item Category Join Table
class ItemCategoryJoin(db.Model):
    __tablename__ = 'item_categories_join'
    
    item_id = db.Column(db.Integer, db.ForeignKey('items.item_id', ondelete='CASCADE'), primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey('items_categories.category_id', ondelete='CASCADE'), primary_key=True)
    
    def to_dict(self):
        return {
            'item_id': self.item_id,
            'category_id': self.category_id
        }

# Outfit Category Model
class OutfitCategory(db.Model):
    __tablename__ = 'outfit_categories'
    
    category_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'))
    category_name = db.Column(db.String(50), nullable=False)
    
    def to_dict(self):
        return {
            'category_id': self.category_id,
            'user_id': self.user_id,
            'category_name': self.category_name
        }

# Outfit Model
class Outfit(db.Model):
    __tablename__ = 'outfits'
    
    outfit_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    outfit_name = db.Column(db.String(100))
    description = db.Column(db.Text)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    season = db.Column(db.String(20))
    image_path = db.Column(db.Text)
    last_updated = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # Added for sync
    
    def to_dict(self):
        return {
            'outfit_id': self.outfit_id,
            'user_id': self.user_id,
            'outfit_name': self.outfit_name,
            'description': self.description,
            'date': self.date.isoformat() if self.date else None,
            'season': self.season,
            'image_path': self.image_path,
            'last_updated': self.last_updated.isoformat() if self.last_updated else None
        }

# Outfit Item Join Table
class OutfitItem(db.Model):
    __tablename__ = 'outfit_item'
    
    outfit_id = db.Column(db.Integer, db.ForeignKey('outfits.outfit_id', ondelete='CASCADE'), primary_key=True)
    item_id = db.Column(db.Integer, db.ForeignKey('items.item_id', ondelete='CASCADE'), primary_key=True)
    
    def to_dict(self):
        return {
            'outfit_id': self.outfit_id,
            'item_id': self.item_id
        }

# Outfit Category Join Table
class OutfitCategoryJoin(db.Model):
    __tablename__ = 'outfit_category_join'
    
    outfit_id = db.Column(db.Integer, db.ForeignKey('outfits.outfit_id', ondelete='CASCADE'), primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey('outfit_categories.category_id', ondelete='CASCADE'), primary_key=True)
    
    def to_dict(self):
        return {
            'outfit_id': self.outfit_id,
            'category_id': self.category_id
        }

# Post Model
class Post(db.Model):
    __tablename__ = 'posts'
    
    post_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=True)
    outfit_id = db.Column(db.Integer, db.ForeignKey('outfits.outfit_id', ondelete='SET NULL'), nullable=True)
    image_path = db.Column(db.Text)
    caption = db.Column(db.Text)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    last_updated = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # Added for sync
    
    def to_dict(self):
        return {
            'post_id': self.post_id,
            'user_id': self.user_id,
            'outfit_id': self.outfit_id,
            'image_path': self.image_path,
            'caption': self.caption,
            'date': self.date.isoformat() if self.date else None,
            'last_updated': self.last_updated.isoformat() if self.last_updated else None
        }

# Comment Model
class Comment(db.Model):
    __tablename__ = 'comments'
    
    comment_id = db.Column(db.Integer, primary_key=True)
    post_id = db.Column(db.Integer, db.ForeignKey('posts.post_id', ondelete='CASCADE'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    content = db.Column(db.Text, nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    last_updated = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # Added for sync
    
    def to_dict(self):
        return {
            'comment_id': self.comment_id,
            'post_id': self.post_id,
            'user_id': self.user_id,
            'content': self.content,
            'date': self.date.isoformat() if self.date else None,
            'last_updated': self.last_updated.isoformat() if self.last_updated else None
        }

# Like Model
class Like(db.Model):
    __tablename__ = 'likes'
    
    like_id = db.Column(db.Integer, primary_key=True)
    post_id = db.Column(db.Integer, db.ForeignKey('posts.post_id', ondelete='CASCADE'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'like_id': self.like_id,
            'post_id': self.post_id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None
        }

# Follow Model
class Follow(db.Model):
    __tablename__ = 'followings_followers'
    
    following_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), primary_key=True)
    follower_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), primary_key=True)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'following_id': self.following_id,
            'follower_id': self.follower_id,
            'date': self.date.isoformat() if self.date else None
        }

# Sync Queue Model (for offline sync)
class SyncQueue(db.Model):
    __tablename__ = 'sync_queue'
    
    queue_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    action = db.Column(db.String(50), nullable=False)  # 'create', 'update', 'delete'
    entity_type = db.Column(db.String(50), nullable=False)  # 'item', 'outfit', 'post', etc.
    entity_id = db.Column(db.Integer, nullable=True)  # ID of the entity (null for creates)
    entity_data = db.Column(db.Text, nullable=False)  # JSON data of the entity
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    processed = db.Column(db.Boolean, default=False)
    processed_at = db.Column(db.DateTime)
    
    def to_dict(self):
        import json
        return {
            'queue_id': self.queue_id,
            'user_id': self.user_id,
            'action': self.action,
            'entity_type': self.entity_type,
            'entity_id': self.entity_id,
            'entity_data': json.loads(self.entity_data) if self.entity_data else {},
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'processed': self.processed,
            'processed_at': self.processed_at.isoformat() if self.processed_at else None
        }


# User Device Model (for multi-device push notification support)
class UserDevice(db.Model):
    __tablename__ = 'user_devices'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id', ondelete='CASCADE'), nullable=False)
    device_token = db.Column(db.String(255), nullable=False, unique=True)
    device_name = db.Column(db.String(100))  # e.g., "iPhone 12", "Samsung Galaxy S21"
    device_type = db.Column(db.String(20))  # e.g., "ios", "android"
    date_registered = db.Column(db.DateTime, default=datetime.utcnow)
    last_active = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationship back to User
    user = db.relationship('User', backref=db.backref('devices', lazy=True, cascade='all, delete-orphan'))
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'device_token': self.device_token,
            'device_name': self.device_name,
            'device_type': self.device_type,
            'date_registered': self.date_registered.isoformat() if self.date_registered else None,
            'last_active': self.last_active.isoformat() if self.last_active else None
        }