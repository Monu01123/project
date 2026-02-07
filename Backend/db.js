import mysql from 'mysql2';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

// SSL configuration for Azure MySQL
const sslConfig = process.env.NODE_ENV === 'production' 
  ? {
      // For Azure deployment - try certificate first, fallback to basic SSL
      ca: fs.existsSync(path.join(__dirname, 'DigiCertGlobalRootCA.crt.pem'))
        ? fs.readFileSync(path.join(__dirname, 'DigiCertGlobalRootCA.crt.pem'))
        : undefined,
      rejectUnauthorized: false // Temporarily set to false for Azure deployment
    }
  : {
      // For local development
      rejectUnauthorized: false
    };

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: sslConfig,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0
});


const promisePool = pool.promise();

const testConnection = async () => {
  try {
    await promisePool.query('SELECT 1');
    console.log('Database connection successful.');
  } catch (err) {
    console.error('Database connection failed:', err.message);
    console.error('SSL Config:', sslConfig);
  }
};

export { promisePool, testConnection };
