const router = require('express').Router();
const Booking = require('../models/Booking');

router.use((req, res, next) =>
  req.headers['x-admin-key'] === process.env.ADMIN_KEY ? next() : res.status(403).json({ message: 'Forbidden' }));

router.get('/bookings', async (_, res) =>
  res.json(await Booking.find().populate('user', 'email').populate('doctor', 'name').sort('-createdAt')));

router.patch('/bookings/:id', async (req, res) =>
  res.json(await Booking.findByIdAndUpdate(req.params.id, { status: req.body.status }, { new: true })));

module.exports = router;
