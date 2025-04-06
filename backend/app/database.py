from .aws_config import get_table, USERS_TABLE, MESSAGES_TABLE, PROPERTIES_TABLE, BOOKINGS_TABLE, OTP_TABLE, create_tables_if_not_exist
import uuid
import time
from datetime import datetime
from botocore.exceptions import ClientError

# Create tables on import if they don't exist
create_tables_if_not_exist()

def get_users_table():
    """
    Returns the users table from DynamoDB
    """
    return get_table(USERS_TABLE)

def get_messages_table():
    """
    Returns the messages table from DynamoDB
    """
    return get_table(MESSAGES_TABLE)

def get_properties_table():
    """
    Returns the properties table from DynamoDB
    """
    return get_table(PROPERTIES_TABLE)

def get_bookings_table():
    """
    Returns the bookings table from DynamoDB
    """
    return get_table(BOOKINGS_TABLE)

def get_otp_table():
    """
    Returns the OTP table from DynamoDB
    """
    return get_table(OTP_TABLE)

def generate_id():
    """
    Generate a unique ID for DynamoDB items
    """
    return str(uuid.uuid4())

def get_timestamp():
    """
    Get the current timestamp in ISO format
    """
    return datetime.utcnow().isoformat()

def db_save_user(user_data):
    """
    Save a user to the DynamoDB users table
    
    Args:
        user_data (dict): User data to save
        
    Returns:
        dict: The saved user data
    """
    users_table = get_users_table()
    
    # Add timestamp if not present
    if 'created_at' not in user_data:
        user_data['created_at'] = get_timestamp()
    
    try:
        users_table.put_item(Item=user_data)
        return user_data
    except ClientError as e:
        print(f"Error saving user: {e}")
        return None

def db_get_user_by_email(email):
    """
    Get a user from the DynamoDB users table by email
    
    Args:
        email (str): The user's email
        
    Returns:
        dict or None: The user data or None if not found
    """
    users_table = get_users_table()
    
    try:
        response = users_table.get_item(Key={'email': email})
        return response.get('Item')
    except ClientError as e:
        print(f"Error getting user: {e}")
        return None

def db_update_user(email, update_data):
    """
    Update a user in the DynamoDB users table
    
    Args:
        email (str): The user's email
        update_data (dict): The data to update
        
    Returns:
        bool: True if successful, False otherwise
    """
    users_table = get_users_table()
    
    # Create update expression and attribute values
    update_expression = "SET "
    expression_attribute_values = {}
    
    for key, value in update_data.items():
        if key != 'email':  # Skip the primary key
            update_expression += f"{key} = :{key}, "
            expression_attribute_values[f":{key}"] = value
    
    # Remove trailing comma and space
    update_expression = update_expression[:-2]
    
    try:
        users_table.update_item(
            Key={'email': email},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values
        )
        return True
    except ClientError as e:
        print(f"Error updating user: {e}")
        return False

def db_save_otp(email, otp):
    """
    Save an OTP to the DynamoDB OTP table
    
    Args:
        email (str): The user's email
        otp (str): The OTP code
        
    Returns:
        bool: True if successful, False otherwise
    """
    otp_table = get_otp_table()
    
    try:
        # Store OTP with expiration timestamp (30 minutes)
        expiration_time = int(time.time()) + 30 * 60  # 30 minutes in seconds
        
        otp_table.put_item(Item={
            'email': email,
            'otp': otp,
            'expiration_time': expiration_time,
            'created_at': get_timestamp()
        })
        return True
    except ClientError as e:
        print(f"Error saving OTP: {e}")
        return False

def db_verify_otp(email, otp):
    """
    Verify an OTP from the DynamoDB OTP table
    
    Args:
        email (str): The user's email
        otp (str): The OTP code to verify
        
    Returns:
        bool: True if valid, False otherwise
    """
    otp_table = get_otp_table()
    
    try:
        response = otp_table.get_item(Key={'email': email})
        stored_otp_data = response.get('Item')
        
        if not stored_otp_data:
            return False
            
        # Check if OTP matches and is not expired
        current_time = int(time.time())
        is_valid = (
            stored_otp_data.get('otp') == otp and
            stored_otp_data.get('expiration_time', 0) > current_time
        )
        
        # Delete the OTP after verification (whether valid or not)
        otp_table.delete_item(Key={'email': email})
        
        return is_valid
    except ClientError as e:
        print(f"Error verifying OTP: {e}")
        return False