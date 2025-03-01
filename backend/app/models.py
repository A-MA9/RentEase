from pydantic import BaseModel, EmailStr, Field
from typing import Optional

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