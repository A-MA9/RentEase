import psycopg2

def init_database():
    """
    Initialize the PostgreSQL database for RentEase.
    Creates the database if it doesn't exist and sets up initial tables.
    """
    # Connect to default postgres database to create our app database
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password="9311"  # Change this to your actual password
    )
    conn.autocommit = True
    cursor = conn.cursor()
    
    # Create database if it doesn't exist
    cursor.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = 'rentease'")
    if not cursor.fetchone():
        print("Creating database 'rentease'...")
        cursor.execute("CREATE DATABASE rentease")
    else:
        print("Database 'rentease' already exists.")
    
    cursor.close()
    conn.close()
    
    # Connect to our app database to create tables
    conn = psycopg2.connect(
        host="localhost",
        database="rentease",
        user="postgres",
        password="9311"  # Change this to your actual password
    )
    cursor = conn.cursor()
    
    # Create users table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        full_name VARCHAR(100) NOT NULL,
        phone_number VARCHAR(20) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(100) NOT NULL,
        user_type VARCHAR(10) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    
    # Create properties table for room listings
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS properties (
        id SERIAL PRIMARY KEY,
        owner_id INTEGER REFERENCES users(id),
        title VARCHAR(100) NOT NULL,
        description TEXT,
        property_type VARCHAR(50) NOT NULL,
        size_sqft NUMERIC,
        location VARCHAR(200) NOT NULL,
        price_per_month NUMERIC NOT NULL,
        min_stay_months INTEGER NOT NULL,
        is_available BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    
    # Create property_images table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS property_images (
        id SERIAL PRIMARY KEY,
        property_id INTEGER REFERENCES properties(id),
        image_url VARCHAR(255) NOT NULL,
        is_primary BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    
    # Create bookings table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS bookings (
        id SERIAL PRIMARY KEY,
        property_id INTEGER REFERENCES properties(id),
        seeker_id INTEGER REFERENCES users(id),
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_price NUMERIC NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    
    conn.commit()
    cursor.close()
    conn.close()
    
    print("Database initialization completed successfully!")

if __name__ == "__main__":
    init_database()