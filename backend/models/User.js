const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, default: '123456' },
  skinType: { type: String, default: 'Pele Mista' },
  skinGoal: { type: String, default: 'Hidratação & Luminosidade' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', UserSchema);
