CREATE TABLE IF NOT EXISTS password_reset_otps (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    otp VARCHAR(6) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE
);

-- Add index for faster lookups
CREATE INDEX IF NOT EXISTS idx_password_reset_otps_user_id ON password_reset_otps(user_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_otps_expires_at ON password_reset_otps(expires_at); 