from fastapi import FastAPI, HTTPException, Depends, status, Security, Body
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from pydantic import BaseModel
from .models import (
    UserBase, OwnerCreate, SeekerCreate, UserResponse, Token, 
    TokenData, TokenUserResponse, UserInDB, MessageBase, 
    MessageCreate, MessageResponse, PropertyResponse, Booking, 
    BookingResponse
)
from .database import (
    db_save_user, db_get_user_by_email, db_update_user,
    db_save_otp, db_verify_otp, generate_id, get_timestamp,
    get_properties_table, get_users_table, get_messages_table
)
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
import boto3
from decimal import Decimal


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

def verify_password(plain_password: str, hashed_password: str):
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
        email: str = payload.get("email")
        if email is None:
            raise credentials_exception
        token_data = TokenData(
            user_id=payload.get("user_id"),
            email=email,
            user_type=payload.get("user_type")
        )
    except PyJWTError:
        raise credentials_exception
    
    user = db_get_user_by_email(token_data.email)
    if user is None:
        raise credentials_exception
        
    # Convert DynamoDB user to UserBase
    user_obj = UserBase(
        id=user.get('id'),
        full_name=user.get('full_name'),
        phone_number=user.get('phone_number'),
        email=user.get('email'),
        password=user.get('password')
    )
    
    return user_obj

# Authentication endpoint
@app.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = db_get_user_by_email(form_data.username)
    
    if not user or not verify_password(form_data.password, user.get("password")):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Include user_type in the token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={
            "user_id": user.get("id"),
            "email": user.get("email"),
            "user_type": user.get("user_type"),  # Include user type in token
        },
        expires_delta=access_token_expires
    )
    print("User logged in, token generated:", access_token)
    return {"access_token": access_token, "token_type": "bearer"}


# Registration endpoints with token generation
@app.post("/register/owner", response_model=TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_owner(user: OwnerCreate):
    # Check if email already exists
    existing_user = db_get_user_by_email(user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hash the password
    hashed_password = hash_password(user.password)
    
    # Generate user ID
    user_id = generate_id()
    
    # Create user data dictionary
    user_data = {
        "id": user_id,
        "full_name": user.full_name,
        "phone_number": user.phone_number,
        "email": user.email,
        "password": hashed_password,
        "user_type": "owner",
        "created_at": get_timestamp(),
        "verified": False
    }
    
    # Save user to database
    new_user = db_save_user(user_data)
    if not new_user:
        raise HTTPException(status_code=500, detail="Failed to create user")
    
    # Generate token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"user_id": user_id, "email": user.email, "user_type": "owner"},
        expires_delta=access_token_expires
    )
    
    # Create response excluding password
    user_response = UserResponse(
        id=user_id,
        full_name=user.full_name,
        phone_number=user.phone_number,
        email=user.email,
        user_type="owner"
    )
    
    return {
        "user": user_response,
        "access_token": access_token,
        "token_type": "bearer"
    }

@app.post("/register/seeker", response_model=TokenUserResponse, status_code=status.HTTP_201_CREATED)
async def register_seeker(user: SeekerCreate):
    # Check if email already exists
    existing_user = db_get_user_by_email(user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hash the password
    hashed_password = hash_password(user.password)
    
    # Generate user ID
    user_id = generate_id()
    
    # Create user data dictionary
    user_data = {
        "id": user_id,
        "full_name": user.full_name,
        "phone_number": user.phone_number,
        "email": user.email,
        "password": hashed_password,
        "user_type": "seeker",
        "created_at": get_timestamp(),
        "verified": False
    }
    
    # Save user to database
    new_user = db_save_user(user_data)
    if not new_user:
        raise HTTPException(status_code=500, detail="Failed to create user")
    
    # Generate token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"user_id": user_id, "email": user.email, "user_type": "seeker"},
        expires_delta=access_token_expires
    )
    
    # Create response excluding password
    user_response = UserResponse(
        id=user_id,
        full_name=user.full_name,
        phone_number=user.phone_number,
        email=user.email,
        user_type="seeker"
    )
    
    return {
        "user": user_response,
        "access_token": access_token,
        "token_type": "bearer"
    }

# Password Reset endpoints
@app.post("/request-password-reset")
async def request_password_reset(email: str = Body(...)):
    # Check if user exists
    user = db_get_user_by_email(email)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Generate OTP
    otp = ''.join(random.choices('0123456789', k=6))
    
    # Save OTP
    if not db_save_otp(email, otp):
        raise HTTPException(status_code=500, detail="Failed to generate reset token")
        
    # Send email with OTP
    try:
        # Load SMTP settings from environment variables
        smtp_server = os.getenv("SMTP_SERVER", "smtp.gmail.com")
        smtp_port = int(os.getenv("SMTP_PORT", "587"))
        smtp_username = os.getenv("SMTP_USERNAME", "rentease2024@gmail.com")
        smtp_password = os.getenv("SMTP_PASSWORD", "cqbxdnriwvmmztjg")
        
        # Create email message
        msg = MIMEMultipart()
        msg["From"] = smtp_username
        msg["To"] = email
        msg["Subject"] = "Password Reset - RentEase"
        
        # Email body
        body = f"""
        <html>
        <body>
            <h2>Password Reset</h2>
            <p>Hello {user.get('full_name')},</p>
            <p>Your password reset code is: <strong>{otp}</strong></p>
            <p>This code will expire in 30 minutes.</p>
            <p>If you did not request this reset, please ignore this email.</p>
            <p>Thank you,<br>RentEase Team</p>
        </body>
        </html>
        """
        
        msg.attach(MIMEText(body, "html"))
        
        # Send email
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(smtp_username, smtp_password)
            server.send_message(msg)
            
        return {"message": "Password reset email sent"}
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to send reset email")

@app.post("/reset-password")
async def reset_password(
    email: str = Body(...),
    otp: str = Body(...),
    new_password: str = Body(...)
):
    # Verify OTP
    if not db_verify_otp(email, otp):
        raise HTTPException(status_code=400, detail="Invalid or expired code")
        
    # Hash the new password
    hashed_password = hash_password(new_password)
    
    # Update user password
    if not db_update_user(email, {"password": hashed_password}):
        raise HTTPException(status_code=500, detail="Failed to update password")
        
    return {"message": "Password reset successful"}

# Add this verification endpoint after the reset-password endpoint
@app.post("/verify/{user_type}")
async def verify_user(
    user_type: str,
    email: str = Body(...),
    verified: bool = Body(...),
):
    # Check if user exists
    user = db_get_user_by_email(email)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Update user verification status
    if not db_update_user(email, {"verified": verified}):
        raise HTTPException(status_code=500, detail="Failed to update verification status")
    
    # Generate new token with updated verification status
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={
            "user_id": user.get("id"),
            "email": user.get("email"),
            "user_type": user.get("user_type"),
            "verified": True
        },
        expires_delta=access_token_expires
    )
    
    return {
        "message": "User verification status updated",
        "access_token": access_token,
        "token_type": "bearer"
    }

# Protected endpoints
@app.get("/users", response_model=list[UserResponse])
async def get_users(current_user: UserBase = Depends(get_current_user)):
    try:
        users_table = get_users_table()
        response = users_table.scan()
        users = response.get('Items', [])
        
        # Convert to UserResponse objects
        user_responses = [
            UserResponse(
                id=user.get('id'),
                full_name=user.get('full_name'),
                phone_number=user.get('phone_number'),
                email=user.get('email'),
                user_type=user.get('user_type')
            ) for user in users
        ]
        
        return user_responses
    except Exception as e:
        print(f"Error fetching users: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch users: {str(e)}"
        )


@app.get("/properties/nearby", response_model=List[PropertyResponse])
async def get_nearby_properties():
    # This endpoint remains public (no authentication required)
    try:
        properties_table = get_properties_table()
        # Scan the table for properties
        response = properties_table.scan()
        properties = response.get('Items', [])
        
        # Filter properties in Jaipur (if location field exists)
        jaipur_properties = [
            prop for prop in properties 
            if 'location' in prop and 'Jaipur' in prop.get('location', '')
        ]
        
        # Sort by created_at in descending order if the field exists
        sorted_properties = sorted(
            jaipur_properties,
            key=lambda x: x.get('created_at', ''),
            reverse=True
        )
        
        return sorted_properties
    except Exception as e:
        print(f"Error fetching nearby properties: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch nearby properties: {str(e)}"
        )

#Messages retrieve
@app.get("/messages/{user_id}", response_model=List[MessageResponse])
async def get_chat_history(
    user_id: str, current_user: UserBase = Depends(get_current_user)
):
    print(f"Fetching chat history for user {current_user.id} with {user_id}")
    
    try:
        messages_table = get_messages_table()
        
        # Query messages where current user is sender and user_id is receiver
        sender_query = messages_table.query(
            IndexName='SenderIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('sender_id').eq(current_user.id),
            FilterExpression=boto3.dynamodb.conditions.Attr('receiver_id').eq(user_id)
        )
        
        # Query messages where current user is receiver and user_id is sender
        receiver_query = messages_table.query(
            IndexName='ReceiverIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('receiver_id').eq(current_user.id),
            FilterExpression=boto3.dynamodb.conditions.Attr('sender_id').eq(user_id)
        )
        
        # Combine both query results
        sender_messages = sender_query.get('Items', [])
        receiver_messages = receiver_query.get('Items', [])
        all_messages = sender_messages + receiver_messages
        
        # Sort by timestamp
        sorted_messages = sorted(all_messages, key=lambda x: x.get('timestamp', ''))
        
        print(f"Found {len(sorted_messages)} messages")
        return sorted_messages
        
    except Exception as e:
        print(f"Error fetching messages: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

# ✅ Request Body Model
class MessageCreate(BaseModel):
    receiver_id: str
    message: str

# ✅ Send Message Endpoint
@app.post("/messages/send", status_code=201)
async def send_message(
    message_data: MessageCreate,  
    current_user: UserBase = Depends(get_current_user)
):
    from .database import get_messages_table, generate_id, get_timestamp
    
    print(f"Sending message from user {current_user.id} to {message_data.receiver_id}")
    
    try:
        messages_table = get_messages_table()
        
        # Create a new message
        message_id = generate_id()
        timestamp = get_timestamp()
        
        new_message = {
            'id': message_id,
            'sender_id': current_user.id,
            'receiver_id': message_data.receiver_id,
            'message': message_data.message,
            'message_type': 'text',
            'timestamp': timestamp
        }
        
        # Save the message to DynamoDB
        messages_table.put_item(Item=new_message)
        
        print(f"Message sent successfully: {new_message}")
        return new_message
    except Exception as e:
        print(f"Error sending message: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

#Retrieve chats
@app.get("/chats", response_model=List[dict])
async def get_user_chats(current_user: UserBase = Depends(get_current_user)):
    from .database import get_messages_table, get_users_table, db_get_user_by_email
    
    try:
        messages_table = get_messages_table()
        
        # Get all messages where current user is sender or receiver
        sent_messages = messages_table.query(
            IndexName='SenderIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('sender_id').eq(current_user.id)
        ).get('Items', [])
        
        received_messages = messages_table.query(
            IndexName='ReceiverIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('receiver_id').eq(current_user.id)
        ).get('Items', [])
        
        # Combine messages and extract unique chat partner IDs
        all_messages = sent_messages + received_messages
        
        # Get unique chat partners and their latest message
        chat_partners = {}
        for msg in all_messages:
            partner_id = msg['receiver_id'] if msg['sender_id'] == current_user.id else msg['sender_id']
            timestamp = msg.get('timestamp', '')
            
            if partner_id not in chat_partners or timestamp > chat_partners[partner_id]['timestamp']:
                # Get chat partner details
                partner = db_get_user_by_email(partner_id)
                partner_name = partner.get('full_name') if partner else "Unknown User"
                
                chat_partners[partner_id] = {
                    'chat_partner_id': partner_id,
                    'chat_partner_name': partner_name,
                    'message': msg.get('message', ''),
                    'timestamp': timestamp
                }
        
        # Convert to list and sort by timestamp (newest first)
        chat_list = list(chat_partners.values())
        chat_list.sort(key=lambda x: x['timestamp'], reverse=True)
        
        return chat_list
    except Exception as e:
        print(f"Error fetching chats: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch chats: {str(e)}"
        )


# Add this class near the top with other Pydantic models
class ForgotPasswordRequest(BaseModel):
    email: str

# Password reset request endpoint
@app.post("/forgot-password")
async def forgot_password(request: ForgotPasswordRequest):
    # Check if user exists
    user = db_get_user_by_email(request.email)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Generate OTP
    otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
    
    # Save OTP
    if not db_save_otp(request.email, otp):
        raise HTTPException(status_code=500, detail="Failed to generate reset token")
    
    # Print OTP in a visible way (for testing)
    print("\n" + "="*50)
    print(f"Password Reset OTP for {request.email}")
    print(f"OTP: {otp}")
    print("="*50 + "\n")
    
    # Send email with OTP if needed
    try:
        # Load SMTP settings from environment variables
        smtp_server = os.getenv("SMTP_SERVER", "smtp.gmail.com")
        smtp_port = int(os.getenv("SMTP_PORT", "587"))
        smtp_username = os.getenv("SMTP_USERNAME", "rentease2024@gmail.com")
        smtp_password = os.getenv("SMTP_PASSWORD", "cqbxdnriwvmmztjg")
        
        # Create email message
        msg = MIMEMultipart()
        msg["From"] = smtp_username
        msg["To"] = request.email
        msg["Subject"] = "Password Reset - RentEase"
        
        # Email body
        body = f"""
        <html>
        <body>
            <h2>Password Reset</h2>
            <p>Hello {user.get('full_name')},</p>
            <p>Your password reset code is: <strong>{otp}</strong></p>
            <p>This code will expire in 30 minutes.</p>
            <p>If you did not request this reset, please ignore this email.</p>
            <p>Thank you,<br>RentEase Team</p>
        </body>
        </html>
        """
        
        msg.attach(MIMEText(body, "html"))
        
        # Send email
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(smtp_username, smtp_password)
            server.send_message(msg)
            
        return {"message": "Password reset email sent"}
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to send reset email")

# Add this class near other Pydantic models
class VerifyOtpRequest(BaseModel):
    email: str
    otp: str

# Verify OTP endpoint
@app.post("/verify-reset-otp")
async def verify_reset_otp(request: VerifyOtpRequest):
    # Verify OTP
    if not db_verify_otp(request.email, request.otp):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired OTP"
        )
    
    # Get user details
    user = db_get_user_by_email(request.email)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Generate reset token
    reset_token = create_access_token(
        data={"user_id": user.get("id"), "email": request.email},
        expires_delta=timedelta(minutes=15)
    )
    
    return {"reset_token": reset_token}

# Add this class near other Pydantic models
class ResetPasswordRequest(BaseModel):
    new_password: str

# Reset password endpoint with token
@app.post("/reset-password-token")
async def reset_password_with_token(
    request: ResetPasswordRequest,
    current_user: UserBase = Depends(get_current_user)
):
    # Hash new password
    hashed_password = hash_password(request.new_password)
    
    # Update user password
    if not db_update_user(current_user.email, {"password": hashed_password}):
        raise HTTPException(status_code=500, detail="Failed to update password")
    
    return {"message": "Password reset successfully"}

@app.post("/bookings/", response_model=BookingResponse)
async def create_booking(booking: Booking):
    try:
        from .database import get_properties_table, generate_id, get_timestamp
        
        # Get property details by scanning the properties table
        properties_table = get_properties_table()
        property_response = properties_table.scan(
            FilterExpression=boto3.dynamodb.conditions.Attr('title').eq(booking.dormitory_name)
        )
        properties = property_response.get('Items', [])
        
        if not properties:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Property not found"
            )
        property_id = properties[0].get('id')
        
        # Get seeker details
        user = db_get_user_by_email(booking.seeker_email)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Seeker not found"
            )
        seeker_id = user.get('id')
        
        # Calculate end_date (30 days from check_in_date)
        end_date = booking.check_in_date + timedelta(days=30)
        
        # Generate booking ID
        booking_id = generate_id()
        
        # Create booking data
        booking_data = {
            'id': booking_id,
            'property_id': property_id,
            'seeker_id': seeker_id,
            'start_date': booking.check_in_date.isoformat(),
            'end_date': end_date.isoformat(),
            'total_price': float(booking.total_amount),
            'status': 'completed',
            'created_at': get_timestamp()
        }
        
        # Get bookings table
        dynamodb = boto3.resource('dynamodb')
        bookings_table = dynamodb.Table('bookings')
        
        # Save booking to DynamoDB
        bookings_table.put_item(Item=booking_data)
        
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
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create booking: {str(e)}"
        )

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
@app.get("/properties")
async def get_properties(owner_id: Optional[str] = None):
    try:
        from .database import get_properties_table, get_users_table
        
        properties_table = get_properties_table()
        
        if owner_id:
            # Get properties for a specific owner
            response = properties_table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr('owner_id').eq(owner_id)
            )
        else:
            # Get all properties
            response = properties_table.scan()
            
        properties = response.get('Items', [])
        
        # If no owner_id was specified, enrich the property data with owner information
        if not owner_id and properties:
            users_table = get_users_table()
            
            # Extract unique owner IDs
            owner_ids = list(set(prop.get('owner_id') for prop in properties if 'owner_id' in prop))
            
            # Get owner information for each owner ID
            owners = {}
            for id in owner_ids:
                # Query user by ID
                user_response = users_table.scan(
                    FilterExpression=boto3.dynamodb.conditions.Attr('id').eq(id)
                )
                user_items = user_response.get('Items', [])
                if user_items:
                    owners[id] = {
                        'full_name': user_items[0].get('full_name', 'Unknown'),
                        'email': user_items[0].get('email', 'Unknown')
                    }
            
            # Add owner information to properties
            for prop in properties:
                owner_id = prop.get('owner_id')
                if owner_id in owners:
                    prop['owner_name'] = owners[owner_id]['full_name']
                    prop['owner_email'] = owners[owner_id]['email']
        
        return properties
        
    except Exception as e:
        print(f"Error fetching properties: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch properties: {str(e)}"
        )

# Add this to the import section at the top
class PropertyCreate(BaseModel):
    owner_id: str
    title: str
    property_type: str
    description: str
    location: str
    price_per_month: float
    min_stay_months: int
    image_urls: List[str]
    panoramic_urls: Optional[List[str]] = []
    gender: str
    rooms_available: int
    size_sqft: Optional[float] = None
    tv: bool = False
    fan: bool = False
    ac: bool = False
    chair: bool = False
    ventilation: bool = False
    ups: bool = False
    sofa: bool = False
    lamp: bool = False
    bath: int = 1
    is_available: bool = True

# Add this endpoint after the existing property endpoints
@app.post("/properties/", response_model=PropertyResponse)
async def create_property(property_data: PropertyCreate):
    try:
        from .database import get_properties_table, generate_id, get_timestamp
        
        # Generate a unique property ID
        property_id = generate_id()
        
        # Get current timestamp
        created_at = get_timestamp()
        
        # Create property item
        property_item = {
            'id': property_id,
            'owner_id': property_data.owner_id,
            'title': property_data.title,
            'property_type': property_data.property_type,
            'description': property_data.description,
            'location': property_data.location,
            'price_per_month': Decimal(str(property_data.price_per_month)),
            'min_stay_months': property_data.min_stay_months,
            'image_urls': property_data.image_urls,
            'panoramic_urls': property_data.panoramic_urls,
            'gender': property_data.gender,
            'rooms_available': property_data.rooms_available,
            'size_sqft': Decimal(str(property_data.size_sqft)) if property_data.size_sqft is not None else None,
            'tv': property_data.tv,
            'fan': property_data.fan,
            'ac': property_data.ac,
            'chair': property_data.chair,
            'ventilation': property_data.ventilation,
            'ups': property_data.ups,
            'sofa': property_data.sofa,
            'lamp': property_data.lamp,
            'bath': property_data.bath,
            'is_available': property_data.is_available,
            'created_at': created_at
        }
        
        # Get property table
        properties_table = get_properties_table()
        
        # Add owner_email for easier querying
        user = db_get_user_by_id(property_data.owner_id)
        if user and 'email' in user:
            property_item['owner_email'] = user['email']
        
        # Save property to DynamoDB
        properties_table.put_item(Item=property_item)
        
        return property_item
        
    except Exception as e:
        print(f"Error creating property: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create property: {str(e)}"
        )

# Add this helper function
def db_get_user_by_id(user_id: str):
    """Get user by ID"""
    users_table = get_users_table()
    response = users_table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr('id').eq(user_id)
    )
    users = response.get('Items', [])
    
    if users:
        return users[0]
    return None

if __name__ == '__main__':
    app.run(debug=True)
