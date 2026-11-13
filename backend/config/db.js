const mongoose = require('mongoose');

const connectDB = async () => {
  if (!process.env.MONGODB_URI || process.env.MONGODB_URI.includes('SUA_SENHA_AQUI')) {
    console.log('ℹ️ MONGODB_URI não configurada no .env — rodando em modo fallback em memória.');
    return false;
  }
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Conectado ao MongoDB Atlas com sucesso!');
    return true;
  } catch (err) {
    console.warn('⚠️ Falha ao conectar no MongoDB Atlas (usando fallback em memória):', err.message);
    return false;
  }
};

module.exports = connectDB;
