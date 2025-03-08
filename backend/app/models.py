from pydantic import BaseModel, EmailStr, Field
from typing import Optional,List

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

#Chat

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
