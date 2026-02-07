import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

async function testDatabaseConnection() {
  console.log('Testing Azure MySQL Database Connection...');
  console.log('==========================================');
  
  const config = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
      ca: fs.existsSync(path.join(__dirname, 'DigiCertGlobalRootCA.crt.pem'))
        ? fs.readFileSync(path.join(__dirname, 'DigiCertGlobalRootCA.crt.pem'))
        : undefined,
      rejectUnauthorized: false
    }
  };

  console.log('\nConnection Config:');
  console.log('Host:', config.host);
  console.log('User:', config.user);
  console.log('Database:', config.database);
  console.log('SSL Certificate:', config.ssl.ca ? 'Loaded' : 'Not found');

  try {
    console.log('\n1. Testing connection...');
    const connection = await mysql.createConnection(config);
    console.log('✓ Connection successful!');

    console.log('\n2. Testing SELECT query...');
    const [rows] = await connection.query('SELECT 1 as test');
    console.log('✓ Query successful:', rows);

    console.log('\n3. Testing categories table...');
    const [categories] = await connection.query('SELECT * FROM categories LIMIT 5');
    console.log(`✓ Found ${categories.length} categories`);
    console.log('Categories:', JSON.stringify(categories, null, 2));

    console.log('\n4. Testing users table...');
    const [users] = await connection.query('SELECT user_id, email, role FROM users LIMIT 3');
    console.log(`✓ Found ${users.length} users`);
    console.log('Users:', JSON.stringify(users, null, 2));

    await connection.end();
    console.log('\n✓ All tests passed!');
  } catch (error) {
    console.error('\n✗ Database test failed:');
    console.error('Error:', error.message);
    console.error('Code:', error.code);
    console.error('SQL State:', error.sqlState);
    console.error('\nFull error:', error);
  }
}

testDatabaseConnection();
