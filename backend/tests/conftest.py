# tests/conftest.py
import pytest
import os
import sys
from dotenv import load_dotenv

# Add the parent directory to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

load_dotenv()

@pytest.fixture(scope='session')
def app():
    """Create app for testing"""
    from app import create_app
    
    app = create_app()
    app.config.update({
        'TESTING': True,
        'SQLALCHEMY_DATABASE_URI': os.getenv('TEST_DATABASE_URL', 
                                           'postgresql://postgres:12345678@localhost:5432/vestium_test'),
        'WTF_CSRF_ENABLED': False,
    })
    
    yield app

@pytest.fixture(scope='session')
def client(app):
    """Create test client"""
    return app.test_client()

@pytest.fixture(scope='session')
def db_session(app):
    """Create database session"""
    from app import db
    
    with app.app_context():
        db.create_all()
        yield db
        db.session.remove()
        db.drop_all()