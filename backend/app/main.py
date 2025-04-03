from fastapi import FastAPI, HTTPException, Depends, status, Security, Body
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import psycopg2
from psycopg2.extras import RealDictCursor
from passlib.context import CryptContext
from pydantic import BaseModel
from .models import (
    UserBase, OwnerCreate, SeekerCreate, UserResponse, Token, 
    TokenData, TokenUserResponse, UserInDB, MessageBase, 
    MessageCreate, MessageResponse, PropertyResponse, Booking, 
    BookingResponse
)
from .database import get_db_connection
from typing import List, Optional
from fastapi.responses import JSONResponse
from datetime import datetime, timedelta, date
import jwt
from jwt.exceptions import PyJWTError
from typing import Dict
import random
import os
from dotenv import load_dotenv
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


# JWT Configuration
SECRET_KEY = "your-secret-key-change-this-in-production"  # Use a strong secret key in production
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # Token valid for 1 week

app = FastAPI(title="RentEase API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
    expose_headers=["*"],  # Expose all headers
    max_age=3600,  # Cache preflight requests for 1 hour
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
    return UserBase(**user)

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
        message_type VARCHAR(20) NOT NULL DEFAULT 'text',
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)

    # Create bookings table if it doesn't exist
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS bookings (
        id SERIAL PRIMARY KEY,
        dormitory_name VARCHAR(255) NOT NULL,
        seeker_email VARCHAR(255) NOT NULL,
        owner_email VARCHAR(255) NOT NULL,
        booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        check_in_date DATE NOT NULL,
        payment_status VARCHAR(50) DEFAULT 'completed',
        total_amount DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (seeker_email) REFERENCES users(email),
        FOREIGN KEY (owner_email) REFERENCES users(email)
    )
    """)
    
    conn.commit()
    cursor.close()
    conn.close()

# Authentication endpoint
@app.post("/login", response_model=Token)
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
@app.post("/register/owner", response_model=TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_owner(user: OwnerCreate):
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

@app.post("/register/seeker", response_model=TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_seeker(user: SeekerCreate):
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
@app.get("/users", response_model=list[UserResponse])
async def get_users(current_user: UserBase = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute("SELECT id, full_name, phone_number, email, user_type FROM users")
    users = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return users


@app.get("/properties/nearby", response_model=List[PropertyResponse])
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
@app.get("/messages/{user_id}", response_model=List[MessageResponse])
async def get_chat_history(
    user_id: int, current_user: UserBase = Depends(get_current_user)
):
    print(f"Fetching chat history for user {current_user.id} with {user_id}")
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute(
            """
            SELECT id, sender_id, receiver_id, message, message_type,
                   to_char(timestamp, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') as timestamp
            FROM messages 
            WHERE (sender_id = %s AND receiver_id = %s) 
               OR (sender_id = %s AND receiver_id = %s)
            ORDER BY timestamp ASC
            """,
            (current_user.id, user_id, user_id, current_user.id),
        )
        
        messages = cursor.fetchall()
        print(f"Found {len(messages)} messages")
        
        # Convert messages to list of dicts with properly formatted timestamps
        formatted_messages = []
        for msg in messages:
            msg_dict = dict(msg)
            formatted_messages.append(msg_dict)
            
        return formatted_messages
    except Exception as e:
        print(f"Error fetching messages: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

# ✅ Request Body Model
class MessageCreate(BaseModel):
    receiver_id: int
    message: str

# ✅ Send Message Endpoint
@app.post("/messages/send", status_code=201)
async def send_message(
    message_data: MessageCreate,  
    current_user: UserBase = Depends(get_current_user)
):
    print(f"Sending message from user {current_user.id} to {message_data.receiver_id}")
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute(
            """
            INSERT INTO messages (sender_id, receiver_id, message, message_type)
            VALUES (%s, %s, %s, %s)
            RETURNING id, sender_id, receiver_id, message, message_type,
                    to_char(timestamp, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') as timestamp
            """,
            (current_user.id, message_data.receiver_id, message_data.message, 'text'),
        )
        new_message = cursor.fetchone()
        conn.commit()
        print(f"Message sent successfully: {new_message}")
        return new_message
    except Exception as e:
        conn.rollback()
        print(f"Error sending message: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

#Retrieve chats
@app.get("/chats", response_model=List[dict])
async def get_user_chats(current_user: UserBase = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    query = """
    SELECT DISTINCT ON (CASE 
        WHEN sender_id = %(user_id)s THEN receiver_id 
        ELSE sender_id 
    END) 
    CASE 
        WHEN sender_id = %(user_id)s THEN receiver_id 
        ELSE sender_id 
    END AS chat_partner_id,
    users.full_name AS chat_partner_name,
    messages.message, 
    messages.timestamp
    FROM messages 
    JOIN users ON users.id = CASE 
        WHEN sender_id = %(user_id)s THEN receiver_id 
        ELSE sender_id 
    END
    WHERE sender_id = %(user_id)s OR receiver_id = %(user_id)s 
    ORDER BY chat_partner_id, messages.timestamp DESC;
    """
    
    cursor.execute(query, {"user_id": current_user.id})
    chat_list = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return chat_list


# Add this class near the top with other Pydantic models
class ForgotPasswordRequest(BaseModel):
    email: str

# Password reset request endpoint
@app.post("/forgot-password")
async def forgot_password(request: ForgotPasswordRequest):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Check if user exists
        cursor.execute("SELECT id, full_name FROM users WHERE email = %s", (request.email,))
        user = cursor.fetchone()
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Generate OTP
        otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
        
        # Store OTP in database with expiration
        cursor.execute(
            """
            INSERT INTO password_reset_otps (user_id, otp, expires_at)
            VALUES (%s, %s, NOW() + INTERVAL '10 minutes')
            """,
            (user['id'], otp)
        )
        conn.commit()
        
        # Print OTP in a visible way
        print("\n" + "="*50)
        print(f"Password Reset OTP for {request.email}")
        print(f"OTP: {otp}")
        print("="*50 + "\n")
        
        return {"message": "OTP sent successfully"}
        
    except Exception as e:
        conn.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
    finally:
        cursor.close()
        conn.close()

# Add this class near other Pydantic models
class VerifyOtpRequest(BaseModel):
    email: str
    otp: str

# Verify OTP endpoint
@app.post("/verify-reset-otp")
async def verify_reset_otp(request: VerifyOtpRequest):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Get user and latest OTP
        cursor.execute(
            """
            SELECT u.id, u.full_name, pro.otp, pro.expires_at
            FROM users u
            JOIN password_reset_otps pro ON u.id = pro.user_id
            WHERE u.email = %s
            AND pro.expires_at > NOW()
            ORDER BY pro.created_at DESC
            LIMIT 1
            """,
            (request.email,)
        )
        result = cursor.fetchone()
        
        if not result:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid or expired OTP"
            )
        
        if result['otp'] != request.otp:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid OTP"
            )
        
        # Generate reset token
        reset_token = create_access_token(
            data={"user_id": result['id'], "email": request.email},
            expires_delta=timedelta(minutes=15)
        )
        
        return {"reset_token": reset_token}
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
    finally:
        cursor.close()
        conn.close()

# Add this class near other Pydantic models
class ResetPasswordRequest(BaseModel):
    new_password: str

# Reset password endpoint
@app.post("/reset-password")
async def reset_password(
    request: ResetPasswordRequest,
    current_user: UserBase = Depends(get_current_user)
):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Hash new password
        hashed_password = hash_password(request.new_password)
        
        # Update password
        cursor.execute(
            "UPDATE users SET password = %s WHERE id = %s",
            (hashed_password, current_user.id)
        )
        
        # Delete used OTPs
        cursor.execute(
            "DELETE FROM password_reset_otps WHERE user_id = %s",
            (current_user.id,)
        )
        
        conn.commit()
        return {"message": "Password reset successfully"}
        
    except Exception as e:
        conn.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
    finally:
        cursor.close()
        conn.close()

@app.post("/bookings/", response_model=BookingResponse)
async def create_booking(booking: Booking):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Get property_id from dormitory_name
        cursor.execute("SELECT id FROM properties WHERE title = %s", (booking.dormitory_name,))
        property_result = cursor.fetchone()
        if not property_result:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Property not found"
            )
        property_id = property_result['id']

        # Get seeker_id from email
        cursor.execute("SELECT id FROM users WHERE email = %s", (booking.seeker_email,))
        seeker_result = cursor.fetchone()
        if not seeker_result:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Seeker not found"
            )
        seeker_id = seeker_result['id']

        # Calculate end_date (30 days from check_in_date)
        end_date = booking.check_in_date + timedelta(days=30)

        # Insert the booking
        cursor.execute(
            """
            INSERT INTO bookings (property_id, seeker_id, start_date, end_date, total_price, status)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id, property_id, seeker_id, start_date, end_date, total_price, status, created_at
            """,
            (
                property_id,
                seeker_id,
                booking.check_in_date,
                end_date,
                booking.total_amount,
                'completed'
            ),
        )
        
        booking_data = cursor.fetchone()
        conn.commit()

        # Send confirmation email to seeker
        send_booking_confirmation_email(
            booking.seeker_email,
            booking.dormitory_name,
            booking.check_in_date,
            booking.total_amount
        )

        # Send notification email to owner
        send_owner_notification_email(
            booking.owner_email,
            booking.dormitory_name,
            booking.seeker_email,
            booking.check_in_date
        )

        return booking_data

    except Exception as e:
        print(f"Error creating booking: {str(e)}")
        conn.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create booking"
        )
    finally:
        cursor.close()
        conn.close()

def send_booking_confirmation_email(seeker_email: str, dormitory_name: str, check_in_date: date, total_amount: float):
    try:
        msg = MIMEMultipart()
        msg['From'] = os.getenv("SMTP_USERNAME")
        msg['To'] = seeker_email
        msg['Subject'] = "Booking Confirmation - RentEase"

        body = f"""
        Dear User,

        Your booking has been confirmed!

        Booking Details:
        Dormitory: {dormitory_name}
        Check-in Date: {check_in_date}
        Total Amount: ₹{total_amount}

        Thank you for choosing RentEase!

        Best regards,
        RentEase Team
        """

        msg.attach(MIMEText(body, 'plain'))

        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(os.getenv("SMTP_USERNAME"), os.getenv("SMTP_PASSWORD"))
        server.send_message(msg)
        server.quit()

    except Exception as e:
        print(f"Error sending confirmation email: {str(e)}")

def send_owner_notification_email(owner_email: str, dormitory_name: str, seeker_email: str, check_in_date: date):
    try:
        msg = MIMEMultipart()
        msg['From'] = os.getenv("SMTP_USERNAME")
        msg['To'] = owner_email
        msg['Subject'] = "New Booking Notification - RentEase"

        body = f"""
        Dear Owner,

        You have received a new booking for your dormitory!

        Booking Details:
        Dormitory: {dormitory_name}
        Seeker Email: {seeker_email}
        Check-in Date: {check_in_date}

        Please log in to your dashboard to view more details.

        Best regards,
        RentEase Team
        """

        msg.attach(MIMEText(body, 'plain'))

        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(os.getenv("SMTP_USERNAME"), os.getenv("SMTP_PASSWORD"))
        server.send_message(msg)
        server.quit()

    except Exception as e:
        print(f"Error sending owner notification email: {str(e)}")


#Fetch property details
@app.post("/properties") 
async def get_properties():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    query = """
    SELECT properties.id, properties.title, properties.location, properties.price_per_month, 
           users.full_name AS owner_name, users.email AS owner_email
    FROM properties
    JOIN users ON properties.owner_id = users.id
    """
    
    cursor.execute(query)
    properties = cursor.fetchall()
    
    cursor.close()
    conn.close()
    print("Sent data")
    
    return properties


if __name__ == '__main__':
    app.run(debug=True)
