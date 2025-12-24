# tests/test_database.py
import pytest
from app.models import User, Item, Outfit

def test_database_connection(db_session):
    """Test database connection is working"""
    # Try a simple query
    user_count = User.query.count()
    assert isinstance(user_count, int), "Should return integer count"

def test_create_test_user(db_session):
    """Test creating a user in database"""
    user = User(
        username="testuser_db",
        email="test_db@vestium.com",
        full_name="Database Test User",
        bio="Test user for database testing"
    )
    user.set_password("test123")
    
    db_session.session.add(user)
    db_session.session.commit()
    
    assert user.user_id is not None, "User should have an ID after commit"
    assert user.user_id > 0, "User ID should be positive"
    
    # Verify we can retrieve the user
    retrieved = User.query.get(user.user_id)
    assert retrieved is not None, "Should be able to retrieve user"
    assert retrieved.email == "test_db@vestium.com", "Email should match"
    
    # Cleanup
    db_session.session.delete(user)
    db_session.session.commit()

def test_user_password_hashing(db_session):
    """Test password hashing and verification"""
    user = User(
        username="password_test",
        email="password@test.com",
        full_name="Password Test"
    )
    user.set_password("secure_password123")
    
    assert user.password_hash is not None, "Password should be hashed"
    assert user.password_hash != "secure_password123", "Password should not be stored in plain text"
    assert user.check_password("secure_password123"), "Should verify correct password"
    assert not user.check_password("wrong_password"), "Should reject wrong password"

def test_database_models_exist():
    """Test that all required models exist"""
    models = [User, Item, Outfit]
    for model in models:
        assert model is not None, f"Model {model.__name__} should exist"
        assert hasattr(model, '__tablename__'), f"Model {model.__name__} should have table name"