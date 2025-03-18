const express = require('express');
const { Pool } = require('pg');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
    cors: { origin: "*" }
});

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "rentease",
    password: "aman",
    port: 5432,
});

app.use(cors());
app.use(express.json());

// Store messages in DB
app.post('/send-message', async (req, res) => {
    const { sender_id, receiver_id, message } = req.body;
    const result = await pool.query(
        "INSERT INTO messages (sender_id, receiver_id, message) VALUES ($1, $2, $3) RETURNING *",
        [sender_id, receiver_id, message]
    );
    io.emit('newMessage', result.rows[0]); // Notify all clients
    res.json(result.rows[0]);
});

// Get messages between two users
app.get('/messages', async (req, res) => {
    const { sender_id, receiver_id } = req.query;
    const result = await pool.query(
        "SELECT * FROM messages WHERE (sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1) ORDER BY timestamp",
        [sender_id, receiver_id]
    );
    res.json(result.rows);
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.id);
    socket.on('disconnect', () => console.log('User disconnected:', socket.id));
});

server.listen(3000, () => console.log('Server running on port 3000'));
