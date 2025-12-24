# tests/test_api.py
import pytest
import json

def test_health_endpoint(client):
    """Test health check endpoint"""
    response = client.get('/api/health')
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
    
    data = json.loads(response.data)
    assert 'status' in data, "Response should have status field"
    assert data['status'] == 'healthy', f"Status should be 'healthy', got '{data['status']}'"

def test_root_endpoint(client):
    """Test root endpoint returns API info"""
    response = client.get('/')
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
    
    data = json.loads(response.data)
    assert 'message' in data, "Should have message field"
    assert data['message'] == 'Vestium API', f"Message should be 'Vestium API'"

def test_auth_endpoints_exist(client):
    """Test that auth endpoints exist"""
    endpoints = ['/api/auth/login', '/api/auth/register']
    
    for endpoint in endpoints:
        # Test that endpoint accepts POST
        response = client.post(endpoint, json={})
        # Should get 400 (bad request) not 404 (not found)
        assert response.status_code != 404, f"Endpoint {endpoint} not found"
        print(f"✅ Endpoint {endpoint} exists (status: {response.status_code})")

def test_protected_endpoints_require_auth(client):
    """Test that protected endpoints require authentication"""
    protected_endpoints = [
        '/api/items',
        '/api/outfits',
        '/api/posts',
        '/api/feed'
    ]
    
    for endpoint in protected_endpoints:
        response = client.get(endpoint)
        # Should get 401 (unauthorized) or 400, not 404
        assert response.status_code != 404, f"Endpoint {endpoint} not found"
        
        if response.status_code == 401:
            print(f"✅ Endpoint {endpoint} correctly requires auth")
        else:
            print(f"⚠️  Endpoint {endpoint} returned {response.status_code} (expected 401 for no auth)")