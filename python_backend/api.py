# import mysql.connector

# # Connect to MySQL database
# conn = mysql.connector.connect(
#     host="localhost",
#     user="yourusername",
#     password="yourpassword",
#     database="yourdatabase"
# )

# # Create a cursor object
# cursor = conn.cursor()

# # Execute a SQL command
# cursor.execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), age INT)")

# # Commit the transaction
# conn.commit()

# # Close the connection
# conn.close()

# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Allow all origins (for development purposes only)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Successfully connected from Dart!"}

# Run the server: uvicorn backend:app --reload
