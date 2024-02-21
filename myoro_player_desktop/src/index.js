import React from 'react';
import ReactDOM from 'react-dom/client';
import './css/index.css';
import App from './components/App.js';
import reportWebVitals from './misc/reportWebVitals.js';

// Strict mode disabled to only run useEffect once
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  // <React.StrictMode>
    <App />
  // </React.StrictMode>
);

reportWebVitals();