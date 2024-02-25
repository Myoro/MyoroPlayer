const { app, BrowserWindow, ipcMain } = require("electron");
const path                            = require("path");
const isDev                           = require("electron-is-dev");
const {
  openPlaylist,
  newPlaylist,
  getPlaylists,
  loadPlaylist,
  copySongToPlaylists,
  moveSongToPlaylist,
  searchYouTube,
  searchSoundCloud,
  searchSoundCloudRecommended,
  YouTubeToMP3,
  SoundCloudToMP3
} = require("./ipcFunctions.js");
const {
  initializeDatabase,
  renamePlaylist,
  softDeletePlaylist,
  hardDeletePlaylist,
  hardDeleteSong,
  getShuffleRepeat,
  setShuffleRepeat,
  getDarkMode,
  setDarkMode
} = require("./Database.js");

function createWindow() {
  const win = new BrowserWindow({
    title:     "MyoroPlayer",
    width:     600,
    height:    600,
    minWidth:  600,
    minHeight: 600,
    icon:      path.join(__dirname, "../icon.png"),
    webPreferences: {
      nodeIntegration:  true,
      contextIsolation: false, // Allows Electron IPC to function within React
      webSecurity:      false  // Allows audio to be played locally from PC
    }
  });

  win.loadURL(
    isDev
      ? `http://localhost:3000`
      : `file://${path.join(__dirname, "../index.html")}`
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
  ipcMain.on("copySongToPlaylists", (event, song) => copySongToPlaylists(event, win, song));
  ipcMain.on("moveSongToPlaylist", (event, song) => moveSongToPlaylist(event, win, song));
  ipcMain.on("hardDeleteSong", (event, songDirectory) => hardDeleteSong(event, songDirectory));
  ipcMain.on("getShuffleRepeat", (event) => getShuffleRepeat(event));
  ipcMain.on("setShuffleRepeat", (event, data) => setShuffleRepeat(data));
  ipcMain.on("searchYouTube", (event, data) => searchYouTube(event, data.query, data.related));
  ipcMain.on("searchSoundCloud", (event, query) => searchSoundCloud(event, query));
  ipcMain.on("searchSoundCloudRecommended", (event, query) => searchSoundCloudRecommended(event, query));
  ipcMain.on("YouTubeToMP3", (event, videoID) => YouTubeToMP3(win, event, videoID));
  ipcMain.on("SoundCloudToMP3", (event, url) => SoundCloudToMP3(win, event, url));
  ipcMain.on("getDarkMode", (event) => getDarkMode(event));
  ipcMain.on("setDarkMode", (event, value) => setDarkMode(value));
  ipcMain.on("quit", () => app.exit(0)); 
}

app.whenReady().then(createWindow);
