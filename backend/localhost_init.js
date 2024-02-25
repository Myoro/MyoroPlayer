// For testing
const express = require('express');
const database = require('./database/database.js');

const app = express();
const PORT = 3001;

app.get('/', (request, resolution) => {
  resolution.send('Hello, World!');
});

// Signup endpoint
app.post('/signup', (request, resolution) => {
  console.log(request.body);
  resolution.send('Signup');
});

app.listen(PORT, () => {
  console.log(`Server started on http://localhost:${PORT}`);
});