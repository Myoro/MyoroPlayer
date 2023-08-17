const { app, BrowserWindow, ipcMain } = require("electron");
const path                            = require("path");
const isDev                           = require("electron-is-dev");
const { initializeDatabase }          = require("./Database.js");
const {
  newPlaylist,
  openPlaylists,
  getPlaylistsIpc,
  openPlaylist
} = require("./ipcFunctions.js");

function createWindow() {
  const win = new BrowserWindow({
    title:     "MyoroPlayer",
    width:     800,
    height:    600,
    minWidth:  800,
    minHeight: 600,
    webPreferences: {
      nodeIntegration:  true,
      contextIsolation: false, // Allows IPC to function with React
      webSecurity:      false  // Allows audio to be played from hardware
    }
  });

  win.loadURL(isDev
    ? `http://localhost:3000`
    : `file://${path.join(__dirname, "../build/index.html")}`
  );
  win.setMenu(null);

  // if(isDev) win.webContents.openDevTools();



  // TopBar
  ipcMain.on("initializeDatabase", (event) => initializeDatabase(event));
  ipcMain.on("quit", (event) => app.exit(0));
  // Playlists
  ipcMain.on("openPlaylists", (event) => openPlaylists(win, event));                // Load playlist from computer
  ipcMain.on("openPlaylist", (event, directory) => openPlaylist(event, directory)); // Load songs from playlist
  ipcMain.on("newPlaylist", (event) => newPlaylist(win, event));
  ipcMain.on("getPlaylists", (event) => getPlaylistsIpc(event));
}

app.whenReady().then(createWindow);
