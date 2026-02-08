
import http from 'http';

const options = {
  hostname: 'localhost',
  port: 8080,
  path: '/',
  method: 'GET'
};

const req = http.request(options, (res) => {
  console.log(`STATUS: ${res.statusCode}`);
  res.setEncoding('utf8');
  res.on('data', (chunk) => {
    console.log(`BODY: ${chunk}`);
  });
});

req.on('error', (e) => {
  console.error(`problem with request: ${e.message}`);
});

req.end();

const optionsHealth = {
  hostname: 'localhost',
  port: 8080,
  path: '/health',
  method: 'GET'
};

const reqHealth = http.request(optionsHealth, (res) => {
  console.log(`HEALTH STATUS: ${res.statusCode}`);
  res.setEncoding('utf8');
  res.on('data', (chunk) => {
    console.log(`HEALTH BODY: ${chunk}`);
  });
});

reqHealth.on('error', (e) => {
  console.error(`problem with health request: ${e.message}`);
});

reqHealth.end();
