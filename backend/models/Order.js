const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema({
  customerName: { type: String, default: 'Stephanie' },
  items: [{ name: String, price: Number }],
  total: { type: Number, required: true },
  status: { type: String, default: 'Confirmado' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Order', OrderSchema);
