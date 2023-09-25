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
  alert("Comes later when songs table comes into play");
  /*
  const success = await twoArgIPC("softDeletePlaylist", Store.getState().contextMenu.selected);
  Store.dispatch({ type: "disableContextMenu" });
  */
}
export async function hardDeletePlaylist() {
  alert("Comes later when songs table comes into play");
}
export async function loadPlaylist(playlist) {
  const songs = await twoArgIPC("loadPlaylist", playlist);
  // ipcRenderer.on("loadPlaylistProgress", (event, percentage) => console.log(percentage));
  alert("Time to create songs Redux state: " + songs.length);
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
