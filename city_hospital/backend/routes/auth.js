const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const sign = (u) => ({
  token: jwt.sign({ id: u._id }, process.env.JWT_SECRET, { expiresIn: '7d' }),
  userId: u._id, email: u.email,
});

router.post('/signup', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password || password.length < 6)
      return res.status(400).json({ message: 'Enter an email and a password of 6+ characters' });
    if (await User.findOne({ email: email.toLowerCase() }))
      return res.status(409).json({ message: 'This email is already registered' });
    const user = await User.create({ email, password: await bcrypt.hash(password, 10) });
    res.status(201).json(sign(user));
  } catch (e) { res.status(500).json({ message: e.message }); }
});

router.post('/login', async (req, res) => {
  try {
    const user = await User.findOne({ email: (req.body.email || '').toLowerCase() });
    if (!user || !(await bcrypt.compare(req.body.password || '', user.password)))
      return res.status(401).json({ message: 'Wrong email or password' });
    res.json(sign(user));
  } catch (e) { res.status(500).json({ message: e.message }); }
});

module.exports = router;
