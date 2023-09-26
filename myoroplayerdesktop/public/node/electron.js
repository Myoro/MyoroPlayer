const { app, BrowserWindow, ipcMain } = require("electron");
const path                            = require("path");
const isDev                           = require("electron-is-dev");
const {
  openPlaylist,
  newPlaylist,
  getPlaylists,
  loadPlaylist
} = require("./ipcFunctions.js");
const {
  initializeDatabase,
  renamePlaylist,
  softDeletePlaylist,
  hardDeletePlaylist
} = require("./Database.js");

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

  if(isDev) win.webContents.openDevTools(true);

  ipcMain.on("initializeDatabase", initializeDatabase);
  ipcMain.on("openPlaylist", (event) => openPlaylist(event, win));
  ipcMain.on("newPlaylist", (event) => newPlaylist(event, win));
  ipcMain.on("getPlaylists", (event) => getPlaylists(event));
  ipcMain.on("renamePlaylist", (event, data) => renamePlaylist(event, data.playlist, data.name));
  ipcMain.on("loadPlaylist", (event, playlist) => loadPlaylist(event, playlist));
  ipcMain.on("softDeletePlaylist", (event, playlist) => softDeletePlaylist(event, playlist));
  ipcMain.on("hardDeletePlaylist", (event, playlist) => hardDeletePlaylist(event, playlist));
  ipcMain.on("quit", () => app.exit(0)); 
}

app.whenReady().then(createWindow);
