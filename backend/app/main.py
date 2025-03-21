from fastapi import FastAPI, HTTPException, Depends, status, Security
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import psycopg2
from psycopg2.extras import RealDictCursor
from passlib.context import CryptContext
from pydantic import BaseModel
from . import models
from .database import get_db_connection
from typing import List, Optional
from fastapi.responses import JSONResponse
from datetime import datetime, timedelta
import jwt
from jwt.exceptions import PyJWTError
from typing import Dict

# JWT Configuration
SECRET_KEY = "your-secret-key-change-this-in-production"  # Use a strong secret key in production
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # Token valid for 1 week

app = FastAPI(title="RentEase API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,  # Changed to True to support auth headers
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# OAuth2 scheme for token handling
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str):
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

# JWT Token functions
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    
    # Encode the JWT token with user type
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: int = payload.get("user_id")
        if user_id is None:
            raise credentials_exception
    except PyJWTError:
        raise credentials_exception
        
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if user is None:
        raise credentials_exception
    return models.UserInDB(**user)

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
    
    # Create messages table if it doesn't exist
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS messages (
        id SERIAL PRIMARY KEY,
        sender_id INTEGER REFERENCES users(id),
        receiver_id INTEGER REFERENCES users(id),
        message TEXT NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    
    conn.commit()
    cursor.close()
    conn.close()

# Authentication endpoint
@app.post("/login", response_model=models.Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute("SELECT * FROM users WHERE email = %s", (form_data.username,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if not user or not verify_password(form_data.password, user["password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Include user_type in the token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={
            "user_id": user["id"],
            "email": user["email"],
            "user_type": user["user_type"],  # Include user type in token
        },
        expires_delta=access_token_expires
    )
    print("User logged in, token generated:", access_token)
    return {"access_token": access_token, "token_type": "bearer"}


# Registration endpoints with token generation
@app.post("/register/owner", response_model=models.TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_owner(user: models.OwnerCreate):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
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
    
    # Generate token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"user_id": new_user["id"], "email": new_user["email"], "user_type": new_user["user_type"]},
        expires_delta=access_token_expires
    )
    
    return {
        "user": new_user,
        "access_token": access_token,
        "token_type": "bearer"
    }

@app.post("/register/seeker", response_model=models.TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_seeker(user: models.SeekerCreate):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
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
    
    # Generate token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"user_id": new_user["id"], "email": new_user["email"], "user_type": new_user["user_type"]},
        expires_delta=access_token_expires
    )
    
    return {
        "user": new_user,
        "access_token": access_token,
        "token_type": "bearer"
    }

# Protected endpoints
@app.get("/users", response_model=list[models.UserResponse])
async def get_users(current_user: models.UserInDB = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute("SELECT id, full_name, phone_number, email, user_type FROM users")
    users = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return users


@app.get("/properties/nearby", response_model=List[models.PropertyResponse])
async def get_nearby_properties():
    # This endpoint remains public (no authentication required)
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
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

#Messages retrieve
@app.get("/messages/{user_id}", response_model=List[models.MessageResponse])
async def get_chat_history(
    user_id: int, current_user: models.UserInDB = Depends(get_current_user)
):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute(
        """
        SELECT * FROM messages 
        WHERE (sender_id = %s AND receiver_id = %s) 
           OR (sender_id = %s AND receiver_id = %s)
        ORDER BY timestamp ASC
        """,
        (current_user.id, user_id, user_id, current_user.id),
    )
    
    messages = cursor.fetchall()
    cursor.close()
    conn.close()

    return messages

# ✅ Request Body Model
class MessageCreate(BaseModel):
    receiver_id: int
    message: str

# ✅ Send Message Endpoint
@app.post("/messages/send")
async def send_message(
    message_data: MessageCreate,  
    current_user: Dict = Depends(get_current_user)  # 🔹 Extract sender_id from token
):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            INSERT INTO messages (sender_id, receiver_id, message, timestamp)
            VALUES (%s, %s, %s, %s)
            """,
            (current_user.id, message_data.receiver_id, message_data.message, datetime.utcnow()),
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

    return {"status": "Message sent successfully"}
