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

app.use(
  cors({
    origin: '*',
  })
);

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/auth', loginroutes);
app.use('/api/v1', productsRouter);
app.use('/api/v1', V1);
app.use('/api/v2', V2);
app.use('/api/v3', V3);

// Local dev only: when invoked directly via `node src/app.js` or `npm start`,
// connect to the DB, optionally sync, and start an HTTP listener.
// In serverless (Vercel), the handler in /api/index.js imports `app` and
// hands it requests directly — no listener, no boot-time sync.
const isDirectRun = process.argv[1] && process.argv[1].endsWith('app.js');

if (isDirectRun) {
  (async () => {
    try {
      await sequelize.authenticate();
      console.log('Database connected');

      if (process.env.NODE_ENV !== 'production') {
        await sequelize.sync({ alter: true });
        console.log('Database synced');
      }

      const PORT = process.env.PORT || 5000;
      app.listen(PORT, () => {
        console.log(`Server running on port ${PORT}`);
      });
    } catch (err) {
      console.error('Failed to start server:', err);
      process.exit(1);
    }
  })();
}

export default app;
