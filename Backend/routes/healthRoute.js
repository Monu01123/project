import express from 'express';

const router = express.Router();

// Health check endpoint
router.get('/health', async (req, res) => {
  const healthCheck = {
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: {
      nodeEnv: process.env.NODE_ENV || 'development',
      port: process.env.PORT || 8080,
      hasDbHost: !!process.env.DB_HOST,
      hasDbUser: !!process.env.DB_USER,
      hasDbPassword: !!process.env.DB_PASSWORD,
      hasDbName: !!process.env.DB_NAME,
      hasJwtSecret: !!process.env.JWT_SECRET,
      dbHost: process.env.DB_HOST ? process.env.DB_HOST.substring(0, 20) + '...' : 'NOT SET'
    }
  };

  // Test database connection
  try {
    const { promisePool } = await import('../db.js');
    await promisePool.query('SELECT 1');
    healthCheck.database = 'Connected';
  } catch (error) {
    healthCheck.database = 'Failed';
    healthCheck.databaseError = error.message;
    healthCheck.status = 'ERROR';
  }

  const statusCode = healthCheck.status === 'OK' ? 200 : 500;
  res.status(statusCode).json(healthCheck);
});

export default router;
