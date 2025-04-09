from fastapi import FastAPI, HTTPException, Depends, status, Security, Body
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from pydantic import BaseModel
from requests import Session
from .models import (
    UserBase, OwnerCreate, SeekerCreate, UserResponse, Token, 
    TokenData, TokenUserResponse, UserInDB, MessageBase, 
    MessageCreate, MessageResponse, PropertyResponse, Booking, 
    BookingResponse
)
from .database import (
    db_save_user, db_get_user_by_email, db_update_user,
    db_save_otp, db_verify_otp, generate_id, get_timestamp,
    get_properties_table, get_users_table, get_messages_table,
    get_bookings_table, get_favorites_table
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
from boto3.dynamodb.conditions import Attr


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
        "verified": False,
        "favorites": []  # Initialize with empty favorites list
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
        "verified": False,
        "favorites": []  # Initialize with empty favorites list
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

# Get user profile by ID
@app.get("/users/profile", response_model=UserResponse)
async def get_user_profile(current_user: UserBase = Depends(get_current_user)):
    try:
        # Get the user from database to ensure we have the latest data
        users_table = get_users_table()
        response = users_table.get_item(
            Key={"email": current_user.email}
        )
        user_data = response.get("Item", {})
        
        # Return the current user's profile
        return UserResponse(
            id=user_data.get("id", current_user.id),
            full_name=user_data.get("full_name", current_user.full_name),
            phone_number=user_data.get("phone_number", current_user.phone_number),
            email=user_data.get("email", current_user.email),
            user_type=user_data.get("user_type", "unknown")
        )
    except Exception as e:
        print(f"Error fetching user profile: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch user profile: {str(e)}"
        )

# Update user profile
class UserProfileUpdate(BaseModel):
    full_name: Optional[str] = None
    phone_number: Optional[str] = None

@app.put("/users/profile", response_model=UserResponse)
async def update_user_profile(
    profile_update: UserProfileUpdate,
    current_user: UserBase = Depends(get_current_user)
):
    try:
        users_table = get_users_table()
        
        # Prepare update expression
        update_expression = "SET "
        expression_attribute_values = {}
        expression_attribute_names = {}
        
        if profile_update.full_name is not None:
            update_expression += "#full_name = :full_name, "
            expression_attribute_values[":full_name"] = profile_update.full_name
            expression_attribute_names["#full_name"] = "full_name"
        
        if profile_update.phone_number is not None:
            update_expression += "#phone_number = :phone_number, "
            expression_attribute_values[":phone_number"] = profile_update.phone_number
            expression_attribute_names["#phone_number"] = "phone_number"
        
        # Remove trailing comma and space
        update_expression = update_expression.rstrip(", ")
        
        # Update user in DynamoDB
        if expression_attribute_values:
            response = users_table.update_item(
                Key={"email": current_user.email},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_attribute_values,
                ExpressionAttributeNames=expression_attribute_names,
                ReturnValues="ALL_NEW"
            )
            
            updated_user = response.get("Attributes", {})
            
            # Update current_user object with new values
            if profile_update.full_name is not None:
                current_user.full_name = profile_update.full_name
            if profile_update.phone_number is not None:
                current_user.phone_number = profile_update.phone_number
                
            return UserResponse(
                id=updated_user.get("id", current_user.id),
                full_name=updated_user.get("full_name", current_user.full_name),
                phone_number=updated_user.get("phone_number", current_user.phone_number),
                email=updated_user.get("email", current_user.email),
                user_type=updated_user.get("user_type", "unknown")
            )
        else:
            # No fields to update, just return current user
            users_table = get_users_table()
            response = users_table.get_item(
                Key={"email": current_user.email}
            )
            user_data = response.get("Item", {})
            
            return UserResponse(
                id=user_data.get("id", current_user.id),
                full_name=user_data.get("full_name", current_user.full_name),
                phone_number=user_data.get("phone_number", current_user.phone_number),
                email=user_data.get("email", current_user.email),
                user_type=user_data.get("user_type", "unknown")
            )
            
    except Exception as e:
        print(f"Error updating user profile: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update user profile: {str(e)}"
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
    from .database import get_messages_table, db_get_user_by_email

    try:
        print("🔍 Fetching messages for user:", current_user.id)

        messages_table = get_messages_table()

        print("📤 Querying messages where user is sender...")
        sent_messages = messages_table.query(
            IndexName='SenderIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('sender_id').eq(current_user.id)
        ).get('Items', [])
        print(f"✅ Sent messages found: {len(sent_messages)}")

        print("📥 Querying messages where user is receiver...")
        received_messages = messages_table.query(
            IndexName='ReceiverIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('receiver_id').eq(current_user.id)
        ).get('Items', [])
        print(f"✅ Received messages found: {len(received_messages)}")

        # Combine messages
        all_messages = sent_messages + received_messages
        print(f"📦 Total messages combined: {len(all_messages)}")

        chat_partners = {}

        for msg in all_messages:
            print("🔁 Processing message:", msg)

            partner_id = msg['receiver_id'] if msg['sender_id'] == current_user.id else msg['sender_id']
            timestamp = msg.get('timestamp', '')

            # Only update if it's the latest message with this partner
            if partner_id not in chat_partners or timestamp > chat_partners[partner_id]['timestamp']:
                print(f"🔍 Fetching user details for partner ID: {partner_id}")
                partner = db_get_user_by_id(partner_id)
                partner_name = partner.get('full_name') if partner else "Unknown User"

                chat_partners[partner_id] = {
                    'chat_partner_id': partner_id,
                    'chat_partner_name': partner_name,
                    'message': msg.get('message', ''),
                    'timestamp': timestamp
                }

        chat_list = list(chat_partners.values())
        chat_list.sort(key=lambda x: x['timestamp'], reverse=True)

        print("✅ Final chat list prepared:", chat_list)
        return chat_list

    except Exception as e:
        print(f"❌ Error fetching chats: {str(e)}")
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
            'total_price': booking.total_amount,  # Use string directly for DynamoDB compatibility
            'status': 'completed',
            'created_at': get_timestamp()
        }
        
        # Get bookings table
        bookings_table = get_bookings_table()
        
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

def send_booking_confirmation_email(seeker_email: str, dormitory_name: str, check_in_date: date, total_amount: str):
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
#Search for properties based on location
@app.get("/properties/search", response_model=List[PropertyResponse])
async def search_properties_by_location(location: str):
    """
    Searches properties based on a location string.
    Performs a case-insensitive 'contains' search on the 'location' attribute.
    """
    if not location:
        # Return empty list or maybe nearby properties if query is empty?
        # Let's return empty for now.
        return [] 

    try:
        properties_table = get_properties_table()
        
        # Use scan with a FilterExpression. 
        # Note: Scan can be less efficient on large tables. 
        # Consider a GSI on 'location' if performance becomes an issue.
        # We'll do a case-insensitive search by fetching all and filtering in Python,
        # as DynamoDB's contains is case-sensitive.
        # A more performant approach would involve storing a lowercase version of the location.
        
        response = properties_table.scan() # Fetch all items
        all_properties = response.get('Items', [])
        
        # Handle pagination if necessary (scan might not return all items at once)
        while 'LastEvaluatedKey' in response:
            response = properties_table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            all_properties.extend(response.get('Items', []))

        # Filter in Python for case-insensitive 'contains'
        search_term_lower = location.lower()
        filtered_properties = [
            prop for prop in all_properties
            if 'location' in prop and search_term_lower in prop['location'].lower()
        ]

        # Optional: Sort results if needed, e.g., by creation date
        sorted_properties = sorted(
            filtered_properties,
            key=lambda x: x.get('created_at', ''),
            reverse=True
        )

        print(f"Search for location '{location}' found {len(sorted_properties)} properties.")
        return sorted_properties

    except Exception as e:
        print(f"Error searching properties for location '{location}': {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to search properties: {str(e)}"
        )

@app.get("/get_property/{property_id}", response_model=PropertyResponse)
async def get_property_by_id(property_id: str):
    try:
        properties_table = get_properties_table()
        users_table = get_users_table()

        # Step 1: Fetch property
        response = properties_table.get_item(Key={'id': property_id})
        property_item = response.get('Item')
        print(f"Fetched property: {property_item}")

        if not property_item:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Property with ID {property_id} not found."
            )

        # Step 2: Fetch user using owner_email
        owner_email = property_item.get('owner_email')
        print(f"Owner email: {owner_email}")

        if owner_email:
            user_response = users_table.get_item(Key={'email': owner_email})
            print(f"User response: {user_response}")
            user_item = user_response.get('Item')
            print(f"User item: {user_item}")

            if user_item and 'full_name' in user_item:
                property_item['owner_name'] = user_item['full_name']
            else:
                property_item['owner_name'] = 'Unknown'
        else:
            property_item['owner_name'] = 'Unknown'

        return property_item

    except Exception as e:
        print(f"Error fetching property by ID '{property_id}': {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get property: {str(e)}"
        )


    except Exception as e:
        print(f"Error fetching property by ID '{property_id}': {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get property: {str(e)}"
        )

# Add a new endpoint to get user email by ID
@app.get("/get_user_email/{user_id}")
async def get_user_email_by_id(user_id: str):
    """
    Fetches a user's email by their ID.
    This endpoint is specifically for retrieving owner email for property detail pages.
    """
    try:
        # Use the existing helper function to get the user
        user = db_get_user_by_id(user_id)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with ID {user_id} not found."
            )
        
        # Only return the email for privacy reasons
        return {"email": user.get("email")}
        
    except HTTPException:
        # Re-raise HTTP exceptions
        raise
    except Exception as e:
        print(f"Error fetching user email by ID '{user_id}': {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get user email: {str(e)}"
        )

# Favorites functionality
@app.post("/favorites/toggle")
async def toggle_favorite(
    body: dict = Body(...),
    current_user: UserBase = Depends(get_current_user)
):
    """Toggle a property as favorite for the current user"""
    try:
        print(f"==== TOGGLE FAVORITE REQUEST ====")
        print(f"Body received: {body}")
        print(f"Current user: {current_user.email}")
        
        # Extract property_id from request body
        # Check if body is a dict with property_id or a direct string value
        if isinstance(body, dict) and 'property_id' in body:
            property_id = str(body['property_id'])
            print(f"Using property_id from JSON: {property_id}")
        else:
            # If we somehow got a string directly
            property_id = str(body)
            print(f"Using body directly as property_id: {property_id}")
            
        if not property_id:
            print(f"ERROR: Empty property_id")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Property ID is required"
            )
            
        # Get the favorites table
        favorites_table = get_favorites_table()
        print(f"Got favorites table")
        
        # Check if the favorite already exists
        try:
            # Try to get the item from favorites table
            response = favorites_table.get_item(
                Key={
                    "user_email": current_user.email,
                    "property_id": property_id
                }
            )
            item_exists = "Item" in response
            print(f"Favorite exists check: {item_exists}")
            
            if item_exists:
                # Delete the favorite
                print(f"Removing favorite: {property_id}")
                favorites_table.delete_item(
                    Key={
                        "user_email": current_user.email,
                        "property_id": property_id
                    }
                )
                action = "removed from"
                is_favorite = False
            else:
                # Add the favorite
                print(f"Adding favorite: {property_id}")
                # Get property details to store with favorite
                properties_table = get_properties_table()
                property_response = properties_table.get_item(
                    Key={"id": property_id}
                )
                property_item = property_response.get("Item", {})
                
                # Create favorite item
                favorite_item = {
                    "user_email": current_user.email,
                    "property_id": property_id,
                    "user_id": current_user.id,
                    "created_at": get_timestamp(),
                    # Include basic property details for quick display
                    "property_title": property_item.get("title", "Unknown Property"),
                    "property_location": property_item.get("location", ""),
                    "property_price": property_item.get("price_per_month", ""),
                    "property_image": property_item.get("image_urls", [])[0] if property_item.get("image_urls") else ""
                }
                
                # Save to favorites table
                favorites_table.put_item(Item=favorite_item)
                action = "added to"
                is_favorite = True
            
            print(f"Successfully {action} favorites")
            return {
                "success": True,
                "message": f"Property {action} favorites",
                "is_favorite": is_favorite
            }
        
        except Exception as e:
            print(f"Error checking or toggling favorite: {str(e)}")
            raise
        
    except Exception as e:
        print(f"ERROR in toggle_favorite: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to toggle favorite: {str(e)}"
        )

@app.get("/favorites")
async def get_favorites(current_user: UserBase = Depends(get_current_user)):
    """Get all favorite properties for the current user"""
    try:
        print(f"==== GET FAVORITES REQUEST ====")
        print(f"User: {current_user.email}")
        
        # Get the favorites table
        favorites_table = get_favorites_table()
        
        # Query favorites table for user's favorites
        response = favorites_table.query(
            KeyConditionExpression=boto3.dynamodb.conditions.Key('user_email').eq(current_user.email)
        )
        
        favorites_items = response.get('Items', [])
        print(f"Found {len(favorites_items)} favorites")
        
        if not favorites_items:
            print("No favorites found for user")
            return []
        
        # Get properties table to fetch complete property details
        properties_table = get_properties_table()
        favorite_properties = []
        
        # Fetch each favorite property's complete details
        for favorite in favorites_items:
            property_id = favorite.get('property_id')
            try:
                print(f"Getting property {property_id}")
                property_response = properties_table.get_item(Key={"id": property_id})
                property_item = property_response.get("Item")
                
                if property_item:
                    print(f"Property found: {property_item.get('title', 'Unknown')}")
                    # Add is_favorite flag
                    property_item['is_favorite'] = True
                    favorite_properties.append(property_item)
                else:
                    print(f"No property found with ID {property_id}")
                    # Still include basic favorite details from favorites table
                    basic_property = {
                        'id': property_id,
                        'title': favorite.get('property_title', 'Unknown Property'),
                        'location': favorite.get('property_location', ''),
                        'price_per_month': favorite.get('property_price', ''),
                        'image_urls': [favorite.get('property_image', '')] if favorite.get('property_image') else [],
                        'is_favorite': True
                    }
                    favorite_properties.append(basic_property)
            except Exception as e:
                print(f"Error fetching property {property_id}: {str(e)}")
                # Continue with other properties if one fails
                continue
        
        print(f"Returning {len(favorite_properties)} favorite properties")
        return favorite_properties
        
    except Exception as e:
        print(f"ERROR in get_favorites: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get favorites: {str(e)}"
        )

@app.get("/check_favorite/{property_id}")
async def check_favorite(
    property_id: str,
    current_user: UserBase = Depends(get_current_user)
):
    """Check if a property is in user's favorites"""
    try:
        print(f"==== CHECK FAVORITE REQUEST ====")
        print(f"Property ID: {property_id}")
        print(f"User: {current_user.email}")
        
        # Get the favorites table
        favorites_table = get_favorites_table()
        
        # Check if the favorite exists
        response = favorites_table.get_item(
            Key={
                "user_email": current_user.email,
                "property_id": property_id
            }
        )
        
        is_favorite = "Item" in response
        print(f"Is favorite: {is_favorite}")
        
        return {"is_favorite": is_favorite}
        
    except Exception as e:
        print(f"ERROR in check_favorite: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to check favorite: {str(e)}"
        )

if __name__ == '__main__':
    app.run(debug=True)
