require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const authRoutes = require('./routes/auth');
const foodRoutes = require('./routes/food');
const gymRoutes = require('./routes/gym');
const healthRoutes = require('./routes/health');

const app = express();
const PORT = process.env.PORT || 3000;

if (!process.env.JWT_SECRET) {
  console.error('JWT_SECRET belum diset di .env. Copy .env.example ke .env dan isi dulu.');
  process.exit(1);
}

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/food', foodRoutes);
app.use('/api/gym', gymRoutes);
app.use('/api/health', healthRoutes);

app.use(express.static(path.join(__dirname, 'public')));
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Health tracker jalan di http://localhost:${PORT}`);
});
