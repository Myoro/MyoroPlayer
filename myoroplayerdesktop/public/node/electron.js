const { app, BrowserWindow, ipcMain } = require("electron");
const path                            = require("path");
const isDev                           = require("electron-is-dev");
const {
  initializeDatabase,
  renamePlaylist
} = require("./Database.js");
const {
  newPlaylist,
  openPlaylists,
  getPlaylistsIpc,
  openPlaylist,
  softDeletePlaylist,
  hardDeletePlaylist,
  copySongToPlaylists,
  moveSongToPlaylist,
  hardDeleteSong
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
  // SideBar context menu operations
  ipcMain.on("renamePlaylist", (event, data) => renamePlaylist(event, data.newName, data.directory));
  ipcMain.on("softDeletePlaylist", (event, directory) => softDeletePlaylist(event, directory));
  ipcMain.on("hardDeletePlaylist", (event, directory) => hardDeletePlaylist(event, directory));
  // SongList context menu operations
  ipcMain.on("copySongToPlaylists", (event, directory) => copySongToPlaylists(win, event, directory));
  ipcMain.on("moveSongToPlaylist", (event, directory) => moveSongToPlaylist(win, event, directory));
  ipcMain.on("hardDeleteSong", (event, directory) => hardDeleteSong(event, directory));
}

app.whenReady().then(createWindow);
