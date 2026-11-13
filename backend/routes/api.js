const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Fridge = require('../models/Fridge');
const Product = require('../models/Product');
const Order = require('../models/Order');

let memoryFridge = {
  temperature: 6.0,
  mode: 'Ideal',
  items: [
    { name: 'Sérum Vitamina C 10%', idealTemp: '5°C', expiryNote: 'Val: 45 dias' },
    { name: 'Roll-on Olhos Cafeína', idealTemp: '4°C', expiryNote: 'Val: 60 dias' },
    { name: 'Bruma Facial Calmante', idealTemp: '6°C', expiryNote: 'Val: 90 dias' }
  ]
};

const defaultProducts = [
  { name: 'Sérum Vitamina C 10% Pura', tag: 'Conservação 5°C', price: 89.90, description: 'Antioxidante de alta potência.' },
  { name: 'Gel Hidratante Ácido Hialurônico', tag: 'Todos os tipos', price: 74.50, description: 'Hidratação profunda.' },
  { name: 'Espuma de Limpeza Micelar', tag: 'pH Fisiológico', price: 49.90, description: 'Limpeza gentil.' },
  { name: 'Protetor Solar Invisível FPS 60', tag: 'Toque Seco', price: 65.00, description: 'Proteção UVA/UVB.' }
];

router.get('/status', (req, res) => {
  res.json({ status: 'online', app: 'GlowUp TCC API', dbConnected: req.dbConnected });
});

router.post('/user/quiz', async (req, res) => {
  const { email, name, skinType, skinGoal } = req.body;
  try {
    if (req.dbConnected && email) {
      const user = await User.findOneAndUpdate(
        { email },
        { name: name || 'Stephanie', skinType, skinGoal },
        { upsert: true, new: true }
      );
      return res.json({ success: true, user });
    }
    res.json({ success: true, user: { name: name || 'Stephanie', skinType, skinGoal } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/fridge', async (req, res) => {
  try {
    if (req.dbConnected) {
      let fridge = await Fridge.findOne();
      if (!fridge) fridge = await Fridge.create(memoryFridge);
      return res.json(fridge);
    }
    res.json(memoryFridge);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/fridge/temperature', async (req, res) => {
  const { temperature } = req.body;
  const mode = temperature >= 4 && temperature <= 8 ? 'Ideal' : 'Alerta';
  try {
    if (req.dbConnected) {
      let fridge = await Fridge.findOneAndUpdate(
        {},
        { temperature, mode, updatedAt: new Date() },
        { upsert: true, new: true }
      );
      return res.json(fridge);
    }
    memoryFridge.temperature = temperature;
    memoryFridge.mode = mode;
    res.json(memoryFridge);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/products', async (req, res) => {
  try {
    if (req.dbConnected) {
      let products = await Product.find();
      if (products.length === 0) products = await Product.insertMany(defaultProducts);
      return res.json(products);
    }
    res.json(defaultProducts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/orders', async (req, res) => {
  const { customerName, items, total } = req.body;
  try {
    if (req.dbConnected) {
      const order = await Order.create({ customerName, items, total });
      return res.json({ success: true, order });
    }
    res.json({ success: true, order: { customerName, items, total, status: 'Confirmado' } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
