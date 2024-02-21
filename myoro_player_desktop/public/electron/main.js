import { app, BrowserWindow } from 'electron';
import { join } from 'path';
import isDev from 'electron-is-dev';

function createWindow() {
  const window = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true
    }
  });

  window.loadURL(
    isDev
      ? `http://localhost:3000`
      : `file://${join(__dirname, '../build/index.html')}`
  );
  window.setMenu(null);
}

app.whenReady().then(createWindow);