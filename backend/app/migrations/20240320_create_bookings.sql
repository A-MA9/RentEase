CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    dormitory_name VARCHAR(255) NOT NULL,
    seeker_email VARCHAR(255) NOT NULL,
    owner_email VARCHAR(255) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    check_in_date DATE NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'completed',
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (seeker_email) REFERENCES users(email),
    FOREIGN KEY (owner_email) REFERENCES users(email)
); 