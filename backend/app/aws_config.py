import boto3
from botocore.exceptions import ClientError
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# AWS Credentials - Make sure to set these in your environment variables
AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY', '')
AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY', '')
AWS_REGION = os.getenv('AWS_REGION', '')

# Create a session with the AWS credentials
session = boto3.Session(
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY,
    region_name=AWS_REGION
)

# Create DynamoDB resource
dynamodb = session.resource('dynamodb')

# Table names
USERS_TABLE = 'RentEase_Users'
MESSAGES_TABLE = 'RentEase_Messages'
PROPERTIES_TABLE = 'RentEase_Properties'
BOOKINGS_TABLE = 'RentEase_Bookings'
OTP_TABLE = 'RentEase_OTP'
FAVORITES_TABLE = 'RentEase_Favorites'

def create_tables_if_not_exist():
    """
    Create the necessary DynamoDB tables if they don't exist.
    """
    tables = list(dynamodb.tables.all())
    existing_table_names = [table.name for table in tables]
    
    # Create Users table if it doesn't exist
    if USERS_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=USERS_TABLE,
                KeySchema=[
                    {'AttributeName': 'email', 'KeyType': 'HASH'},  # Partition key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'email', 'AttributeType': 'S'},
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {USERS_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {USERS_TABLE}: {e}")
    
    # Create Messages table if it doesn't exist
    if MESSAGES_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=MESSAGES_TABLE,
                KeySchema=[
                    {'AttributeName': 'id', 'KeyType': 'HASH'},  # Partition key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'id', 'AttributeType': 'S'},
                    {'AttributeName': 'sender_id', 'AttributeType': 'S'},
                    {'AttributeName': 'receiver_id', 'AttributeType': 'S'},
                ],
                GlobalSecondaryIndexes=[
                    {
                        'IndexName': 'SenderIndex',
                        'KeySchema': [
                            {'AttributeName': 'sender_id', 'KeyType': 'HASH'},
                        ],
                        'Projection': {'ProjectionType': 'ALL'},
                        'ProvisionedThroughput': {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
                    },
                    {
                        'IndexName': 'ReceiverIndex',
                        'KeySchema': [
                            {'AttributeName': 'receiver_id', 'KeyType': 'HASH'},
                        ],
                        'Projection': {'ProjectionType': 'ALL'},
                        'ProvisionedThroughput': {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
                    }
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {MESSAGES_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {MESSAGES_TABLE}: {e}")
    
    # Create Properties table if it doesn't exist
    if PROPERTIES_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=PROPERTIES_TABLE,
                KeySchema=[
                    {'AttributeName': 'id', 'KeyType': 'HASH'},  # Partition key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'id', 'AttributeType': 'S'},
                    {'AttributeName': 'owner_email', 'AttributeType': 'S'},
                ],
                GlobalSecondaryIndexes=[
                    {
                        'IndexName': 'OwnerIndex',
                        'KeySchema': [
                            {'AttributeName': 'owner_email', 'KeyType': 'HASH'},
                        ],
                        'Projection': {'ProjectionType': 'ALL'},
                        'ProvisionedThroughput': {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
                    }
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {PROPERTIES_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {PROPERTIES_TABLE}: {e}")
    
    # Create Bookings table if it doesn't exist
    if BOOKINGS_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=BOOKINGS_TABLE,
                KeySchema=[
                    {'AttributeName': 'id', 'KeyType': 'HASH'},  # Partition key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'id', 'AttributeType': 'S'},
                    {'AttributeName': 'seeker_email', 'AttributeType': 'S'},
                    {'AttributeName': 'property_id', 'AttributeType': 'S'},
                ],
                GlobalSecondaryIndexes=[
                    {
                        'IndexName': 'SeekerIndex',
                        'KeySchema': [
                            {'AttributeName': 'seeker_email', 'KeyType': 'HASH'},
                        ],
                        'Projection': {'ProjectionType': 'ALL'},
                        'ProvisionedThroughput': {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
                    },
                    {
                        'IndexName': 'PropertyIndex',
                        'KeySchema': [
                            {'AttributeName': 'property_id', 'KeyType': 'HASH'},
                        ],
                        'Projection': {'ProjectionType': 'ALL'},
                        'ProvisionedThroughput': {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
                    }
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {BOOKINGS_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {BOOKINGS_TABLE}: {e}")
    
    # Create OTP table if it doesn't exist
    if OTP_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=OTP_TABLE,
                KeySchema=[
                    {'AttributeName': 'email', 'KeyType': 'HASH'},  # Partition key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'email', 'AttributeType': 'S'},
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {OTP_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {OTP_TABLE}: {e}")
    
    # Create Favorites table if it doesn't exist
    if FAVORITES_TABLE not in existing_table_names:
        try:
            dynamodb.create_table(
                TableName=FAVORITES_TABLE,
                KeySchema=[
                    {'AttributeName': 'user_email', 'KeyType': 'HASH'},  # Partition key
                    {'AttributeName': 'property_id', 'KeyType': 'RANGE'},  # Sort key
                ],
                AttributeDefinitions=[
                    {'AttributeName': 'user_email', 'AttributeType': 'S'},
                    {'AttributeName': 'property_id', 'AttributeType': 'S'},
                ],
                ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
            )
            print(f"Table {FAVORITES_TABLE} created successfully")
        except ClientError as e:
            print(f"Error creating table {FAVORITES_TABLE}: {e}")
            
# Function to get a table
def get_table(table_name):
    return dynamodb.Table(table_name) 