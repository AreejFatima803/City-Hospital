require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/auth', require('./routes/auth'));
app.use('/api/doctors', require('./routes/doctors'));
app.use('/api/bookings', require('./routes/bookings'));
app.use('/api/admin', require('./routes/admin'));
app.get('/admin', (_, res) => res.sendFile(path.join(__dirname, 'admin.html')));

// MongoDB Atlas connection
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    console.log('MongoDB Atlas connected');
    await require('./seed')();
    app.listen(process.env.PORT || 5000, () =>
      console.log(`Server running on port ${process.env.PORT || 5000}`));
  })
  .catch((err) => { console.error('MongoDB connection error:', err.message); process.exit(1); });
