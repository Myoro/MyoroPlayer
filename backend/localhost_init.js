// For testing
const express = require('express');
const app = express();
const PORT = 3001;

app.get('/', (request, resolution) => {
  resolution.send('Hello, World!');
});

app.list(PORT, () => {
  console.log(`Server started on http://localhost:${PORT}`);
});
