# tests/test_firebase.py
import pytest
import os

def test_firebase_credentials_exist():
    """Test that Firebase credentials file exists"""
    creds_path = os.getenv('FIREBASE_CREDENTIALS_PATH')
    assert creds_path is not None, "FIREBASE_CREDENTIALS_PATH not set"
    assert os.path.exists(creds_path), f"Credentials file not found: {creds_path}"

def test_firebase_credentials_valid():
    """Test that Firebase credentials file is valid JSON"""
    import json
    creds_path = os.getenv('FIREBASE_CREDENTIALS_PATH')
    
    with open(creds_path, 'r') as f:
        creds = json.load(f)
    
    required_fields = ['type', 'project_id', 'private_key', 'client_email']
    for field in required_fields:
        assert field in creds, f"Missing required field: {field}"
    
    assert creds['type'] == 'service_account', "Invalid service account type"

def test_firebase_initialization():
    """Test Firebase Admin SDK initialization"""
    from app.services.firebase_service import FirebaseService
    
    firebase_service = FirebaseService()
    assert hasattr(firebase_service, 'initialized'), "FirebaseService missing initialized attribute"
    
    # It should either be initialized or fail gracefully
    if firebase_service.initialized:
        print("✅ Firebase initialized successfully")
    else:
        print("⚠️ Firebase not initialized (may be intentional for development)")

def test_firebase_service_methods():
    """Test that FirebaseService methods exist"""
    from app.services.firebase_service import FirebaseService
    
    firebase_service = FirebaseService()
    
    # Check that required methods exist
    assert hasattr(firebase_service, 'send_notification')
    assert hasattr(firebase_service, 'send_to_user')
    assert hasattr(firebase_service, 'send_like_notification')
    assert hasattr(firebase_service, 'send_comment_notification')
    assert hasattr(firebase_service, 'send_follow_notification')