const router = require('express').Router();
const auth = require('../middleware/auth');
const Booking = require('../models/Booking');

router.post('/', auth, async (req, res) => {
  try {
    const { specialization, doctorId, serviceType, timestamp } = req.body;
    if (!specialization || !doctorId || !['Appointment', 'Consultation'].includes(serviceType))
      return res.status(400).json({ message: 'Missing booking details' });
    const booking = await Booking.create({
      user: req.userId, // taken from the verified token, so it cannot be spoofed
      doctor: doctorId, specialization, serviceType,
      timestamp: timestamp || new Date(),
    });
    res.status(201).json(booking);
  } catch (e) { res.status(500).json({ message: e.message }); }
});

router.get('/mine', auth, async (req, res) =>
  res.json(await Booking.find({ user: req.userId }).populate('doctor', 'name').sort('-createdAt')));

module.exports = router;
