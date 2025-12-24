# test_sync.py
import requests
import json
import time

print("🔄 Testing Vestium Sync Functionality")
print("=" * 60)

base_url = "http://localhost:5000"

# First, create a test user and get token
print("\n1. Creating test user for sync...")
test_email = f"sync_test_{int(time.time())}@vestium.com"
test_user = {
    "email": test_email,
    "password": "SyncTest123!",
    "full_name": "Sync Test User",
    "username": f"synctest_{int(time.time())}"
}

try:
    # Register
    response = requests.post(f"{base_url}/api/auth/register", json=test_user, timeout=10)
    
    if response.status_code == 201:
        data = response.json()
        token = data.get('access_token')
        user_id = data.get('user', {}).get('user_id')
        print(f"✅ Test user created: {test_user['username']}")
        print(f"   User ID: {user_id}")
        print(f"   Token: {token[:30]}...")
        
        headers = {'Authorization': f'Bearer {token}'}
        
        # Test sync status
        print("\n2. Testing sync status...")
        response = requests.get(f"{base_url}/api/sync/status", headers=headers, timeout=10)
        if response.status_code == 200:
            status_data = response.json()
            print(f"✅ Sync status: {status_data.get('message')}")
            print(f"   Counts: {json.dumps(status_data.get('counts', {}), indent=4)}")
        else:
            print(f"❌ Sync status failed: {response.status_code}")
        
        # Test pull data
        print("\n3. Testing pull data...")
        response = requests.post(f"{base_url}/api/sync/pull", headers=headers, timeout=10)
        if response.status_code == 200:
            pull_data = response.json()
            print(f"✅ Pull successful")
            print(f"   Data keys: {list(pull_data.get('data', {}).keys())}")
            
            # Count items
            data = pull_data.get('data', {})
            for key, value in data.items():
                if isinstance(value, list):
                    print(f"   {key}: {len(value)} items")
        else:
            print(f"❌ Pull failed: {response.status_code}")
            print(f"   Response: {response.text}")
        
        # Test push data (simulate offline changes)
        print("\n4. Testing push data...")
        test_item = {
            "items": [{
                "item_name": "Sync Test Item",
                "description": "Created during sync test",
                "season": "All",
                "image_path": "test/sync_item.jpg"
            }]
        }
        
        response = requests.post(f"{base_url}/api/sync/push", 
                               json=test_item, 
                               headers=headers, 
                               timeout=10)
        
        if response.status_code == 200:
            push_data = response.json()
            print(f"✅ Push successful")
            print(f"   Stats: {json.dumps(push_data.get('stats', {}), indent=4)}")
        else:
            print(f"❌ Push failed: {response.status_code}")
        
        # Clean up: delete test user (optional)
        print("\n5. Cleaning up...")
        # You might want to keep the test user for debugging
        
    else:
        print(f"❌ User creation failed: {response.status_code}")
        print(f"   Response: {response.text}")
        
except Exception as e:
    print(f"❌ Sync test error: {e}")

print("\n" + "=" * 60)
print("🎉 Sync Test Complete!")
print(f"\n💡 Next steps:")
print("1. Integrate sync in your Flutter app")
print("2. Test offline mode")
print("3. Set up periodic background sync")