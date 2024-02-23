const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (request, resolution) => {
  resolution.send('Hello, World!');
});

app.listen(PORT, () => {
  console.log('Server started on port ${PORT}');
});
