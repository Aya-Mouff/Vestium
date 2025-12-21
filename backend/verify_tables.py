import psycopg2
from app.config import Config

try:
    conn = psycopg2.connect(Config.SQLALCHEMY_DATABASE_URI)
    cursor = conn.cursor()
    
    # Get all tables
    cursor.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name;
    """)
    
    tables = cursor.fetchall()
    
    print("✓ Tables created in vestium_db:")
    for i, table in enumerate(tables, 1):
        print(f"  {i}. {table[0]}")
    
    # Count records in each table
    print("\n✓ Record counts:")
    for table in tables:
        table_name = table[0]
        if table_name != 'alembic_version':  # Skip migration table
            cursor.execute(f'SELECT COUNT(*) FROM "{table_name}"')
            count = cursor.fetchone()[0]
            print(f"  {table_name}: {count} records")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"✗ Error: {e}")