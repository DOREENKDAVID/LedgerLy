import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

// Serverless-friendly pool: a single function invocation handles one request,
// so we keep `max` low and let idle connections close quickly.
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST || 'localhost',
    dialect: process.env.DB_DIALECT || 'mysql',
    port: process.env.DB_PORT || 3306,
    logging: false,
    pool: {
      max: 2,
      min: 0,
      idle: 1000,
      acquire: 30000,
      evict: 1000,
    },
    dialectOptions:
      process.env.DB_SSL === 'true'
        ? { ssl: { require: true, rejectUnauthorized: false } }
        : {},
  }
);

export default sequelize;
