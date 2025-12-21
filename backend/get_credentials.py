# get_credentials.py
import os
import json
import getpass

def collect_credentials():
    print("=" * 60)
    print("VESTIUM BACKEND SETUP - Credential Collection")
    print("=" * 60)
    
    credentials = {}
    
    # PostgreSQL
    print("\n1. POSTGRESQL DATABASE")
    print("-" * 40)
    credentials['POSTGRES_PASSWORD'] = getpass.getpass("Enter your PostgreSQL password: ")
    
    # Supabase
    print("\n2. SUPABASE (for image storage)")
    print("-" * 40)
    print("Go to: https://supabase.com → Your Project → Settings → API")
    credentials['SUPABASE_URL'] = input("Enter Supabase URL (https://xxx.supabase.co): ").strip()
    credentials['SUPABASE_KEY'] = input("Enter Supabase anon public key: ").strip()
    credentials['SUPABASE_SERVICE_ROLE_KEY'] = input("Enter Supabase service role key: ").strip()
    
    # Firebase
    print("\n3. FIREBASE (for notifications)")
    print("-" * 40)
    print("Go to: Firebase Console → Project Settings → Service accounts")
    print("Generate new private key and save as JSON")
    firebase_json_path = input("Path to firebase-credentials.json: ").strip()
    
    if os.path.exists(firebase_json_path):
        with open(firebase_json_path, 'r') as f:
            firebase_data = json.load(f)
            credentials['FIREBASE_PROJECT_ID'] = firebase_data.get('project_id', '')
    else:
        print("⚠️  File not found. You'll need to set this manually.")
        credentials['FIREBASE_PROJECT_ID'] = input("Enter Firebase Project ID: ").strip()
    
    # Generate .env file
    env_content = f"""# Flask
FLASK_APP=run.py
FLASK_DEBUG=1
SECRET_KEY={os.urandom(24).hex()}

# Database
DATABASE_URL=postgresql://postgres:{credentials['POSTGRES_PASSWORD']}@localhost:5432/vestium_db

# JWT
JWT_SECRET_KEY={os.urandom(24).hex()}

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:5000

# Supabase
SUPABASE_URL={credentials['SUPABASE_URL']}
SUPABASE_KEY={credentials['SUPABASE_KEY']}
SUPABASE_SERVICE_ROLE_KEY={credentials['SUPABASE_SERVICE_ROLE_KEY']}

# Firebase
FIREBASE_CREDENTIALS_PATH=firebase-credentials.json
FIREBASE_PROJECT_ID={credentials.get('FIREBASE_PROJECT_ID', 'your-project-id')}
"""
    
    # Write .env file
    with open('.env', 'w') as f:
        f.write(env_content)
    
    print("\n" + "=" * 60)
    print("✅ .env file created successfully!")
    print("=" * 60)
    
    # Copy firebase credentials if provided
    if os.path.exists(firebase_json_path):
        import shutil
        shutil.copy(firebase_json_path, 'firebase-credentials.json')
        print("✅ Copied firebase-credentials.json to project folder")
    
    print("\nNext steps:")
    print("1. Run: conda activate vestium")
    print("2. Run: pip install -r requirements.txt")
    print("3. Run: python run.py")
    print("\nYour API will be available at: http://localhost:5000")

if __name__ == "__main__":
    collect_credentials()