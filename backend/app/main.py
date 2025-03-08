from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from psycopg2.extras import RealDictCursor
from passlib.context import CryptContext
from . import models
from .database import get_db_connection
from typing import List
from fastapi.responses import JSONResponse

app = FastAPI(title="RentEase API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=False,  # Must be False for allow_origins=["*"]
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

@app.options("/properties/nearby")
async def options_properties():
    return JSONResponse(
        content={"message": "OK"},
        headers={
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, Accept",
        },
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


@app.post("/messages", response_model=models.MessageResponse, status_code=status.HTTP_201_CREATED)
async def send_message(message: models.MessageCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
    INSERT INTO messages (sender_id, receiver_id, message)
    VALUES (%s, %s, %s) RETURNING id, sender_id, receiver_id, message, timestamp
    """, (message.sender_id, message.receiver_id, message.message))
    
    new_message = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()

    return new_message


@app.get("/messages/{user_id}", response_model=List[models.MessageResponse])
async def get_messages(user_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
    SELECT * FROM messages WHERE sender_id = %s OR receiver_id = %s ORDER BY timestamp ASC
    """, (user_id, user_id))

    messages = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return messages

@app.get("/properties/nearby", response_model=List[models.PropertyResponse])
async def get_nearby_properties():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # For now, we'll fetch all properties in Jaipur
    cursor.execute("""
    SELECT id, owner_id, title, description, property_type, size_sqft, location, 
           price_per_month, min_stay_months, is_available, 
           to_char(created_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') as created_at
    FROM properties 
    WHERE location LIKE 'Jaipur%'
    ORDER BY created_at DESC
    """)
    
    properties = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return properties
