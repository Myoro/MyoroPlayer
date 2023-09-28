// Where extra global functions go
import Store from "./ReduxStore.js";
const { ipcRenderer } = window.require("electron");

// Electron IPC call abstractions
function oneArgIPC(arg) {
  return new Promise(resolve => {
    ipcRenderer.send(arg);
    ipcRenderer.once(arg, (event, data) => resolve(data));
  });
}
function twoArgIPC(event, data) {
  return new Promise(resolve => {
    ipcRenderer.send(event, data);
    ipcRenderer.once(event, (evt, data) => resolve(data));
  });
}



// Electron one-liner IPC calls
export function quit()               { ipcRenderer.send("quit"); }
export function initializeDatabase() { ipcRenderer.send("initializeDatabase"); }



// Playlist oriented
export async function openPlaylist() {
  const newPlaylists = await oneArgIPC("openPlaylist");
  if(!newPlaylists) return;
  else              Store.dispatch({ type: "appendPlaylists", payload: newPlaylists });
}
export async function newPlaylist() {
  const newPlaylist = await oneArgIPC("newPlaylist");
  if(!newPlaylist) return;
  else             Store.dispatch({ type: "appendPlaylists", payload: [ newPlaylist ] });
}
export async function renamePlaylist(playlist, name) {
  const success = await twoArgIPC("renamePlaylist", { playlist: playlist, name: name });
  if(success === true) {
    await Store.dispatch({ type: "clearPlaylists" });
    getPlaylists();
  }
  Store.dispatch({ type: "disableModal" });
}
export async function getPlaylists() {
  const playlists = await oneArgIPC("getPlaylists");
  Store.dispatch({ type: "appendPlaylists", payload: playlists });
}
export async function softDeletePlaylist() {
  // eslint-disable-next-line
  const success = await twoArgIPC("softDeletePlaylist", Store.getState().contextMenu.selected);
  Store.dispatch({ type: "clearPlaylists" });
  getPlaylists();
}
export async function hardDeletePlaylist() {
  // eslint-disable-next-line
  const success = await twoArgIPC("hardDeletePlaylist", Store.getState().modal.selected);
  Store.dispatch({ type: "clearPlaylists" });
  Store.dispatch({ type: "disableModal" });
  getPlaylists();
}
export async function hardDeleteSong() {
  const selected = Store.getState().modal.selected;
  const success  = await twoArgIPC("hardDeleteSong", selected.songDirectory);
  if(!success) return;
  Store.dispatch({ type: "disableModal" });
  loadPlaylist(selected.playlistDirectory);
}
export async function copySongToPlaylists(song) {
  // eslint-disable-next-line
  const success = await twoArgIPC("copySongToPlaylists", song);
}
export async function moveSongToPlaylist(song) {
  const success = await twoArgIPC("moveSongToPlaylist", song);
  if(success) loadPlaylist(song.playlistDirectory);
}
export async function loadPlaylist(playlist) {
  await Store.dispatch({ type: "setShowLoadingBar", payload: true });
  const loadingBar = document.getElementById("loadingBar");

  ipcRenderer.send("loadPlaylist", playlist);
  ipcRenderer.on("loadPlaylistProgress", (event, percentage) => {
    loadingBar.style.width = percentage + '%';
  });
  ipcRenderer.once("loadPlaylist", async (event, data) => {
    loadingBar.style.width = "0%";
    await Store.dispatch({ type: "setShowLoadingBar", payload: false });
    Store.dispatch({ type: "setSongs", payload: data });
  });
}



// Basic UI functions
export function hoverButton(event) {
  const darkMode = Store.getState().darkMode;

  if(window.getComputedStyle(event.target).backgroundColor === "rgba(0, 0, 0, 0)") {
    event.target.style.background = darkMode ? "#EDE6D6" : "#181818";
    event.target.style.color      = darkMode ? "#181818" : "#EDE6D6";
  } else {
    event.target.style.background = "none";
    event.target.style.color      = darkMode ? "#EDE6D6" : "#181818";
  }
}
export function cleanTopBarDropdowns() {
    const topBarButtons = document.getElementsByClassName("topBarButton");
    for(let i = 0; i < topBarButtons.length; i++)
      document.getElementById(topBarButtons[i].innerHTML).style.display = "none";
}



// Context menu functions
export async function toggleContextMenu(event, mode, obj) {
  let contextMenu           = document.getElementById("contextMenu");
  const contextMenuSelected = Store.getState().contextMenu.selected;

  if(!contextMenu || (contextMenu && contextMenuSelected !== obj)) {
    await Store.dispatch({
      type: "enableContextMenu",
      payload: {
        mode:     mode,
        selected: obj
      }
    });

    contextMenu = document.getElementById("contextMenu");

    switch(mode) {
      case "playlist":
        contextMenu.style.top  = (((window.innerHeight - event.clientY) < 100) ? (window.innerHeight - 103) : event.clientY) + "px";
        contextMenu.style.left = ((event.clientX < 5) ? 5 : event.clientX) + "px";
        break;
      case "song":
        contextMenu.style.top  = (((window.innerHeight - event.clientY) < 140) ? (window.innerHeight - 140) : event.clientY) + "px";
        contextMenu.style.left = (((window.innerWidth - event.clientX) < 260) ? (window.innerWidth - 300) : event.clientX) + "px";
        break;
      default: break;
    }

  } else if(contextMenu && contextMenuSelected === obj) {
    Store.dispatch({ type: "disableContextMenu" });
  }
}
