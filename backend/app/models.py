# from pydantic import BaseModel, EmailStr, Field
# from typing import Optional,List

# class UserBase(BaseModel):
#     full_name: str
#     phone_number: str
#     email: EmailStr
#     password: str

# class OwnerCreate(UserBase):
#     pass

# class SeekerCreate(UserBase):
#     pass

# class UserResponse(BaseModel):
#     id: int
#     full_name: str
#     phone_number: str
#     email: EmailStr
#     user_type: str  # "owner" or "seeker"

#     class Config:
#         orm_mode = True

# #Chat

# class MessageBase(BaseModel):
#     sender_id: int
#     receiver_id: int
#     message: str

# class MessageCreate(MessageBase):
#     pass

# class MessageResponse(MessageBase):
#     id: int
#     timestamp: str

#     class Config:
#         orm_mode = True

# class PropertyResponse(BaseModel):
#     id: int
#     owner_id: int
#     title: str
#     description: Optional[str]
#     property_type: str
#     size_sqft: Optional[float]
#     location: str
#     price_per_month: float
#     min_stay_months: int
#     is_available: bool
#     created_at: str

#     class Config:
#         orm_mode = True

from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime

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

class MessageCreate(MessageBase):
    pass

class MessageResponse(MessageBase):
    id: int
    timestamp: str

    class Config:
        orm_mode = True

class PropertyResponse(BaseModel):
    id: int
    owner_id: int
    title: str
    description: Optional[str]
    property_type: str
    size_sqft: Optional[float]
    location: str
    price_per_month: float
    min_stay_months: int
    is_available: bool
    created_at: str

    class Config:
        orm_mode = True