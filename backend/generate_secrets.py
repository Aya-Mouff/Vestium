# generate_secrets.py
import secrets
import string

def generate_secret_key(length=64):
    """Generate a secure random secret key"""
    alphabet = string.ascii_letters + string.digits + string.punctuation
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def generate_jwt_secret(length=32):
    """Generate a secure JWT secret"""
    return secrets.token_hex(length)

def update_env_file():
    """Generate new secrets and update .env file"""
    print("🔐 Generating secure secrets...")
    
    # Generate new secrets
    flask_secret = generate_secret_key(64)
    jwt_secret = generate_jwt_secret(32)
    
    print(f"✅ Flask SECRET_KEY: {flask_secret[:20]}...")
    print(f"✅ JWT_SECRET_KEY: {jwt_secret[:20]}...")
    
    # Read existing .env or create new
    try:
        with open('.env', 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        lines = []
    
    # Update or add secrets
    new_lines = []
    flask_updated = False
    jwt_updated = False
    
    for line in lines:
        if line.startswith('SECRET_KEY='):
            new_lines.append(f'SECRET_KEY={flask_secret}\n')
            flask_updated = True
        elif line.startswith('JWT_SECRET_KEY='):
            new_lines.append(f'JWT_SECRET_KEY={jwt_secret}\n')
            jwt_updated = True
        else:
            new_lines.append(line)
    
    # Add if not found
    if not flask_updated:
        new_lines.append(f'SECRET_KEY={flask_secret}\n')
    if not jwt_updated:
        new_lines.append(f'JWT_SECRET_KEY={jwt_secret}\n')
    
    # Write back
    with open('.env', 'w') as f:
        f.writelines(new_lines)
    
    print("\n✅ Updated .env file with new secure keys!")
    print("\n⚠️  IMPORTANT:")
    print("   - Keep these keys SECRET!")
    print("   - NEVER commit .env to git!")
    print("   - Use different keys in production!")

if __name__ == "__main__":
    update_env_file()