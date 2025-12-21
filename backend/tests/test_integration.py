# tests/test_integration.py
import pytest
import json

class TestUserRegistrationFlow:
    """Test complete user registration and login flow"""
    
    def test_register_new_user(self, client, db_session):
        """Test registering a new user"""
        user_data = {
            'email': 'integration_test@vestium.com',
            'password': 'integration123',
            'full_name': 'Integration Test User',
            'username': 'integrationtest'
        }
        
        response = client.post('/api/auth/register', 
                             json=user_data,
                             content_type='application/json')
        
        assert response.status_code == 201, f"Expected 201, got {response.status_code}"
        
        data = json.loads(response.data)
        assert 'access_token' in data, "Response should include access token"
        assert 'refresh_token' in data, "Response should include refresh token"
        assert 'user' in data, "Response should include user data"
        
        user = data['user']
        assert user['email'] == user_data['email']
        assert user['username'] == user_data['username']
        
        # Store token for other tests
        self.access_token = data['access_token']
        
        # Cleanup - delete test user
        from app.models import User
        test_user = User.query.filter_by(email=user_data['email']).first()
        if test_user:
            db_session.session.delete(test_user)
            db_session.session.commit()
    
    def test_login_with_registered_user(self, client, db_session):
        """Test logging in with registered user"""
        # First create a user
        from app.models import User
        user = User(
            username='login_test',
            email='login_test@vestium.com',
            full_name='Login Test User'
        )
        user.set_password('testpassword123')
        
        db_session.session.add(user)
        db_session.session.commit()
        
        # Try to login
        login_data = {
            'email': 'login_test@vestium.com',
            'password': 'testpassword123'
        }
        
        response = client.post('/api/auth/login',
                             json=login_data,
                             content_type='application/json')
        
        assert response.status_code == 200, f"Login failed: {response.status_code}"
        
        data = json.loads(response.data)
        assert 'access_token' in data, "Login should return access token"
        
        # Cleanup
        db_session.session.delete(user)
        db_session.session.commit()
    
    def test_protected_endpoint_with_token(self, client, db_session):
        """Test accessing protected endpoint with valid token"""
        # Create user and get token
        from app.models import User
        user = User(
            username='protected_test',
            email='protected_test@vestium.com',
            full_name='Protected Test User'
        )
        user.set_password('testpassword123')
        
        db_session.session.add(user)
        db_session.session.commit()
        
        # Login to get token
        login_data = {
            'email': 'protected_test@vestium.com',
            'password': 'testpassword123'
        }
        
        response = client.post('/api/auth/login',
                             json=login_data,
                             content_type='application/json')
        
        data = json.loads(response.data)
        token = data['access_token']
        
        # Try to access protected endpoint with token
        headers = {
            'Authorization': f'Bearer {token}'
        }
        
        response = client.get('/api/items', headers=headers)
        # Should get 200 (empty list) or at least not 401
        assert response.status_code != 401, "Should not get unauthorized with valid token"
        
        # Cleanup
        db_session.session.delete(user)
        db_session.session.commit()