import psycopg2
from psycopg2.extras import RealDictCursor
import time

def get_db_connection():
    """
    Creates and returns a connection to the database.
    """
    while True:
        try:
            conn = psycopg2.connect(
                host="localhost",
                database="rentease",
                user="postgres",
                password="9311",  # Update this to match your actual PostgreSQL password
                cursor_factory=RealDictCursor
            )
            return conn
        except Exception as error:
            print(f"Error connecting to database: {error}")
            time.sleep(2)  # Wait for 2 seconds before retrying