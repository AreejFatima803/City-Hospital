const mongoose = require('mongoose');
module.exports = mongoose.model('Doctor', new mongoose.Schema({
  name: { type: String, required: true },
  specialization: { type: String, required: true, index: true },
  image: String,
  timings: String,
}));
