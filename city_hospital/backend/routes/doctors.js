const router = require('express').Router();
const auth = require('../middleware/auth');
const Doctor = require('../models/Doctor');

// GET /api/doctors?specialization=Cardiologist
router.get('/', auth, async (req, res) => {
  const filter = req.query.specialization ? { specialization: req.query.specialization } : {};
  res.json(await Doctor.find(filter));
});

module.exports = router;
