from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime, date

class UserBase(BaseModel):
    full_name: str
    phone_number: str
    email: EmailStr
    password: str

class OwnerCreate(UserBase):
    pass

class SeekerCreate(UserBase):
    pass

class UserResponse(BaseModel):
    id: int
    full_name: str
    phone_number: str
    email: EmailStr
    user_type: str  # "owner" or "seeker"

    class Config:
        orm_mode = True

# Add these Token models
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[int] = None
    email: Optional[str] = None
    user_type: Optional[str] = None

class TokenUserResponse(BaseModel):
    user: UserResponse
    access_token: str
    token_type: str

class UserInDB(UserResponse):
    password: str
    created_at: Optional[datetime] = None

# Chat
class MessageBase(BaseModel):
    sender_id: int
    receiver_id: int
    message: str
    message_type: str = 'text'

class MessageCreate(MessageBase):
    pass

class MessageResponse(MessageBase):
    id: int
    timestamp: str

    class Config:
        orm_mode = True
        json_encoders = {
            datetime: lambda v: v.strftime("%Y-%m-%dT%H:%M:%S.%fZ")
        }

class PropertyResponse(BaseModel):
    id: int
    owner_id: int
    title: str
    # description: Optional[str]
    property_type: str
    size_sqft: Optional[float]
    location: str
    price_per_month: float
    min_stay_months: int
    is_available: bool
    created_at: str
    tv:bool
    fan:bool
    ac:bool
    chair:bool
    ventilation:bool
    ups:bool
    sofa:bool
    lamp:bool
    bath:int   


    class Config:
        orm_mode = True

class Booking(BaseModel):
    dormitory_name: str
    seeker_email: str
    owner_email: str
    check_in_date: date
    total_amount: float

class BookingResponse(BaseModel):
    id: int
    property_id: int
    seeker_id: int
    start_date: date
    end_date: date
    total_price: float
    status: str
    created_at: datetime

    class Config:
        from_attributes = True