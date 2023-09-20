const { app, BrowserWindow, ipcMain } = require("electron");
const path                            = require("path");
const isDev                           = require("electron-is-dev");

function createWindow() {
  const win = new BrowserWindow({
    title:     "MyoroPlayer",
    width:     600,
    height:    600,
    minWidth:  600,
    minHeight: 600,
    webPreferences: {
      nodeIntegration:  true,
      contextIsolation: false, // Allows Electron IPC to function within React
      webSecurity:      false  // Allows audio to be played locally from PC
    }
  });

  win.loadURL(
    isDev
      ? `http://localhost:3000`
      : `file://${path.join(__dirname, "../build/index.html")}`
  );
  win.setMenu(null);

  ipcMain.on("quit", () => app.exit(0)); 
}

app.whenReady().then(createWindow);
