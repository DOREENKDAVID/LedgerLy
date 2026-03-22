import express from 'express';
import dotenv from 'dotenv';
import sequelize from './config/database.js';
import loginroutes from './routers/loginRouter.js';
import V1 from './routers/businessRouter.js';
import V2 from './routers/saleRouter.js';
import V3 from './routers/insightsRouter.js';
import cors from 'cors';
import productsRouter from './routers/productsRouter.js';

dotenv.config();

const app = express();
app.use(express.json());

// ✅ Allow frontend
app.use(
  cors({
    origin: '*', // Allow all origins (for development)
    // credentials: true,
  })
);

// ✅ REGISTER ROUTES FIRST
app.use('/api/auth', loginroutes);
app.use('/api/v1', productsRouter);
app.use('/api/v1', V1);
app.use('/api/v2', V2);
app.use('/api/v3', V3);

// ✅ START SERVER FUNCTION
async function startServer() {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connected');

    // 🔥 AUTO SYNC (DEV ONLY)
    const isDev = process.env.NODE_ENV !== 'production';

    await sequelize.sync(isDev ? { alter: true } : {});
    console.log('✅ Database synced');

    const PORT = process.env.PORT || 5000;

    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });

  } catch (err) {
    console.error('❌ Failed to start server:', err);
  }
}

startServer();