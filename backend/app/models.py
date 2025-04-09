from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime, date

class UserBase(BaseModel):
    id: Optional[str] = None
    full_name: str
    phone_number: str
    email: EmailStr
    password: str

class OwnerCreate(BaseModel):
    full_name: str
    phone_number: str
    email: EmailStr
    password: str

class SeekerCreate(BaseModel):
    full_name: str
    phone_number: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: str
    full_name: str
    phone_number: str
    email: EmailStr
    user_type: str  # "owner" or "seeker"

    class Config:
        from_attributes = True

# Add these Token models
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[str] = None
    email: Optional[str] = None
    user_type: Optional[str] = None

class TokenUserResponse(BaseModel):
    user: UserResponse
    access_token: str
    token_type: str

class UserInDB(UserResponse):
    password: str
    created_at: Optional[str] = None

# Chat
class MessageBase(BaseModel):
    sender_id: str
    receiver_id: str
    message: str
    message_type: str = 'text'

class MessageCreate(MessageBase):
    pass

class MessageResponse(MessageBase):
    id: str
    timestamp: str

    class Config:
        from_attributes = True
        json_encoders = {
            datetime: lambda v: v.strftime("%Y-%m-%dT%H:%M:%S.%fZ")
        }

class PropertyResponse(BaseModel):
    id: str
    owner_id: str
    title: str
    description: Optional[str]
    property_type: str
    size_sqft: Optional[float] = None
    location: str
    price_per_month: float
    min_stay_months: int
    is_available: bool
    created_at: str
    image_urls: List[str] = []
    panoramic_urls: Optional[List[str]] = []
    gender: Optional[str] = "Both"
    rooms_available: Optional[int] = 1
    tv: bool = False
    fan: bool = False
    ac: bool = False
    chair: bool = False
    ventilation: bool = False
    ups: bool = False
    sofa: bool = False
    lamp: bool = False
    bath: int = 1
    owner_name: Optional[str] = None

    class Config:
        from_attributes = True

class Booking(BaseModel):
    dormitory_name: str
    seeker_email: str
    owner_email: str
    check_in_date: date
    total_amount: str

class BookingResponse(BaseModel):
    id: str
    property_id: str
    seeker_id: str
    start_date: date
    end_date: date
    total_price: str
    status: str
    created_at: datetime

    class Config:
        from_attributes = True