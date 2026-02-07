import mysql from 'mysql2';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

// Try to find SSL certificate in multiple locations
function findSSLCertificate() {
  const possiblePaths = [
    path.join(__dirname, 'DigiCertGlobalRootCA.crt.pem'),
    path.join(process.cwd(), 'DigiCertGlobalRootCA.crt.pem'),
    path.join(process.cwd(), 'Backend', 'DigiCertGlobalRootCA.crt.pem'),
    '/home/site/wwwroot/Backend/DigiCertGlobalRootCA.crt.pem',
    '/home/site/wwwroot/DigiCertGlobalRootCA.crt.pem'
  ];

  for (const certPath of possiblePaths) {
    if (fs.existsSync(certPath)) {
      console.log(`✓ SSL Certificate found at: ${certPath}`);
      return fs.readFileSync(certPath);
    }
  }

  console.warn('⚠ SSL Certificate not found in any expected location');
  console.warn('Searched paths:', possiblePaths);
  return null;
}

// SSL configuration for Azure MySQL
const sslCert = findSSLCertificate();
const sslConfig = sslCert 
  ? {
      ca: sslCert,
      rejectUnauthorized: true
    }
  : {
      // Fallback if certificate not found
      rejectUnauthorized: false
    };

console.log('Database Configuration:');
console.log('- Host:', process.env.DB_HOST);
console.log('- User:', process.env.DB_USER);
console.log('- Database:', process.env.DB_NAME);
console.log('- SSL Certificate:', sslCert ? 'Loaded' : 'Not found (using fallback)');
console.log('- Reject Unauthorized:', sslConfig.rejectUnauthorized);

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
    console.log('✓ Database connection successful.');
  } catch (err) {
    console.error('✗ Database connection failed:', err.message);
    console.error('Error code:', err.code);
    if (err.code === 'ECONNREFUSED') {
      console.error('→ Database server is not reachable');
    } else if (err.message.includes('insecure transport')) {
      console.error('→ SSL certificate is required but not properly configured');
      console.error('→ Make sure DigiCertGlobalRootCA.crt.pem is deployed to Azure');
    }
  }
};

export { promisePool, testConnection };
