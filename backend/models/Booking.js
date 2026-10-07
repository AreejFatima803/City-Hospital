const mongoose = require('mongoose');
module.exports = mongoose.model('Booking', new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
  specialization: { type: String, required: true },
  serviceType: { type: String, enum: ['Appointment', 'Consultation'], required: true },
  status: { type: String, enum: ['Pending', 'Confirmed', 'Cancelled'], default: 'Pending' },
  timestamp: { type: Date, default: Date.now },
}, { timestamps: true }));
