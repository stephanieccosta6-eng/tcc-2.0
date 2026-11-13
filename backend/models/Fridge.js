const mongoose = require('mongoose');

const FridgeSchema = new mongoose.Schema({
  ownerEmail: { type: String, default: 'stephanie@glowup.com' },
  temperature: { type: Number, default: 6.0 },
  mode: { type: String, default: 'Ideal' },
  items: [
    {
      name: String,
      idealTemp: String,
      expiryNote: String,
      addedAt: { type: Date, default: Date.now }
    }
  ],
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Fridge', FridgeSchema);
