from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from psycopg2.extras import RealDictCursor
from passlib.context import CryptContext
from . import models
from .database import get_db_connection

app = FastAPI(title="RentEase API")

# Configure CORS
# Configure CORS more explicitly
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, you'd limit this to your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str):
    return pwd_context.hash(password)

# Initialize database tables
@app.on_event("startup")
async def startup_db_client():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Create users table if it doesn't exist
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
    
    conn.commit()
    cursor.close()
    conn.close()

# API endpoints
@app.post("/register/owner", response_model=models.UserResponse, status_code=status.HTTP_201_CREATED)
async def register_owner(user: models.OwnerCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Check if email already exists
    cursor.execute("SELECT * FROM users WHERE email = %s", (user.email,))
    if cursor.fetchone():
        cursor.close()
        conn.close()
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hash the password
    hashed_password = hash_password(user.password)
    
    # Insert new owner
    cursor.execute("""
    INSERT INTO users (full_name, phone_number, email, password, user_type)
    VALUES (%s, %s, %s, %s, %s) RETURNING id, full_name, phone_number, email, user_type
    """, (user.full_name, user.phone_number, user.email, hashed_password, "owner"))
    
    new_user = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    
    return new_user

@app.post("/register/seeker", response_model=models.UserResponse, status_code=status.HTTP_201_CREATED)
async def register_seeker(user: models.SeekerCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Check if email already exists
    cursor.execute("SELECT * FROM users WHERE email = %s", (user.email,))
    if cursor.fetchone():
        cursor.close()
        conn.close()
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hash the password
    hashed_password = hash_password(user.password)
    
    # Insert new seeker
    cursor.execute("""
    INSERT INTO users (full_name, phone_number, email, password, user_type)
    VALUES (%s, %s, %s, %s, %s) RETURNING id, full_name, phone_number, email, user_type
    """, (user.full_name, user.phone_number, user.email, hashed_password, "seeker"))
    
    new_user = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    
    return new_user
@app.get("/users", response_model=list[models.UserResponse])
async def get_users():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT id, full_name, phone_number, email, user_type FROM users")
    users = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return users