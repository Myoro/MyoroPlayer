const express = require('express');
const app = express();
const PORT = 80;
const HOST = '192.168.0.94';

app.get('/', (request, resolution) => {
  resolution.send('Hello, World!');
});

app.listen(PORT, HOST, () => {
  console.log(`Server started on http://${HOST}:${PORT}`);
});
