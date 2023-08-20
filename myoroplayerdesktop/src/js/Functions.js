// Where multi-file functions are stored
import Store from "./Store.js";
const { ipcRenderer } = window.require("electron");

export function quit() { ipcRenderer.send("quit"); }

// Basic hover function for buttons only containing text
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

export function noArgIpcCall(evt) {
  return new Promise(resolve => {
    ipcRenderer.send(evt);
    ipcRenderer.once(evt, (event, data) => resolve(data));
  });
}
export function oneArgIpcCall(evt, data) {
  return new Promise(resolve => {
    ipcRenderer.send(evt, data);
    ipcRenderer.once(evt, (event, data) => resolve(data));
  });
}

export async function openPlaylists() {
  const data = await noArgIpcCall("openPlaylists");
  Store.dispatch({ type: "addPlaylists", payload: data });
}

export async function newPlaylist() {
  const data = await noArgIpcCall("newPlaylist");
  Store.dispatch({ type: "addPlaylist", payload: data });
}

export async function openPlaylist(directory) {
  Store.dispatch({ type: "setShowLoadingBar", payload: true });
  const songs = await oneArgIpcCall("openPlaylist", directory);
  await Store.dispatch({ type: "setShowLoadingBar", payload: false });
  Store.dispatch({ type: "setSongs", payload: songs });
}

export async function renamePlaylist(directory) {
  const newName   = document.getElementById("renameDialogInput").value;
  if(newName === "") return;
  // eslint-disable-next-line
  const success   = await oneArgIpcCall("renamePlaylist", { newName: newName, directory: directory });
  const playlists = await noArgIpcCall("getPlaylists");
  Store.dispatch({ type: "setPlaylists", payload: playlists });
  Store.dispatch({ type: "resetModal" });
}

export async function softDeletePlaylist(directory) {
  // eslint-disable-next-line
  const success   = await oneArgIpcCall("softDeletePlaylist", directory);
  const playlists = await noArgIpcCall("getPlaylists");
  Store.dispatch({ type: "setPlaylists", payload: playlists });
}

export async function hardDeletePlaylist(directory) {
  // eslint-disable-next-line
  const success   = await oneArgIpcCall("hardDeletePlaylist", directory);
  const playlists = await noArgIpcCall("getPlaylists");
  Store.dispatch({ type: "setPlaylists", payload: playlists });
  Store.dispatch({ type: "resetModal" });
}

export async function copySongToPlaylists(directory) {
  // eslint-disable-next-line
  const success = await oneArgIpcCall("copySongToPlaylists", directory);
}

function removeFromSongsState(directory) {
  const songList = document.getElementById("songList");
  for(let i = 0; i < songList.childNodes.length; i++) {
    if(songList.childNodes[i].name === directory) {
      songList.removeChild(songList.childNodes[i]);
      let songs = Store.getState().songs;
      songs.splice(i, 1);
      Store.dispatch({ type: "setSongs", payload: songs });
      return;
    }
  }
}

export async function moveSongToPlaylist(directory) {
  // eslint-disable-next-line
  const success  = await oneArgIpcCall("moveSongToPlaylist", directory);
  removeFromSongsState(directory);
}

export async function hardDeleteSong(directory) {
  // eslint-disable-next-line
  const success = await oneArgIpcCall("hardDeleteSong", directory);
  removeFromSongsState(directory);
  Store.dispatch({ type: "resetModal" });
}
