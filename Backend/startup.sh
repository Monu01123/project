#!/bin/sh
# Azure App Service startup script for Node.js backend

echo "Starting Skillora Backend..."

# Navigate to the application directory
cd /home/site/wwwroot

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install --production
fi

# Start the application
echo "Starting server.js..."
node server.js
