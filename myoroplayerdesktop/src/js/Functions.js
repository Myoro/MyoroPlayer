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
export function quit()                        { ipcRenderer.send("quit"); }
export function initializeDatabase()          { ipcRenderer.send("initializeDatabase"); }
export function setShuffleRepeat(mode, value) { ipcRenderer.send("setShuffleRepeat", { mode: mode, value: value }); }



// darkMode
export async function getDarkMode() {
  const result = await oneArgIPC("getDarkMode");
  return result;
}
export function setDarkMode() {
  const darkMode = Store.getState().darkMode
  ipcRenderer.send("setDarkMode", darkMode ? 0 : 1);
  Store.dispatch({ type: "setDarkMode", payload: darkMode ? false : true });
}



// Scrapers
export async function scrapeYouTube(query, related) {
  const result = await twoArgIPC("searchYouTube", { query: query, related: related });
  return result;
}
export async function scrapeSoundCloud(query) {
  const result = await twoArgIPC("searchSoundCloud", query);
  return result;
}
export async function scrapeSoundCloudRecommended(query) {
  const result = await twoArgIPC("searchSoundCloudRecommended", query);
  return result;
}



// YouTube / SoundCloud to MP3 functions
export function YouTubeToMP3(video) {
  let videoID = null;

  // Making sure the video is valid
  if(video.length > 11) {
    // Checking for a link like this https://www.youtube.com/watch?v=IYAjG0oAJPQ
    let split = video.split('=');
    if(/^[A-Za-z0-9_-]{11}$/.test(split[split.length - 1])) videoID = split[split.length - 1];
    else if(split.length > 2) {
      split = split[split.length - 2].split('/');
      split = split[split.length - 1].substr(0, split[split.length - 1].length - 3);
      if(/^[A-Za-z0-9_-]{11}$/.test(split)) videoID = split;
    } else video = null;
  } else if(/^[A-Za-z0-9_-]{11}$/.test(video)) {
    video = videoID;
  } else video = null;

  if(videoID === null) {
    alert("Bad Input");
    return;
  }

  ipcRenderer.send("YouTubeToMP3", videoID);
  ipcRenderer.once("YouTubeToMP3Complete", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Download Completed";
    setTimeout(() => { document.getElementById("converterPercentage").innerHTML = ""; }, 2000);
  });
  ipcRenderer.on("YouTubeToMP3Progress", (event, percentage) => {
    document.getElementById("converterPercentage").innerHTML = percentage + '%';
  });
  ipcRenderer.once("YouTubeToMP3Error", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Error Downloading";
    setTimeout(() => { document.getElementById("converterPercentage").innerHTML = ""; }, 2000);
  });

  Store.dispatch({ type: "disableModal" });
}
export function SoundCloudToMP3(url) {
  if(!/^(https?:\/\/)?soundcloud\.com\/\S+\/\S+$/.test(url)) {
    alert("Bad Input");
    return;
  }

  ipcRenderer.send("SoundCloudToMP3", url);
  ipcRenderer.once("SoundCloudToMP3Scraping", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Scraping Song";
  });
  ipcRenderer.once("SoundCloudToMP3Downloading", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Downloading to System";
  });
  ipcRenderer.once("SoundCloudToMP3Complete", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Download Complete";
    setTimeout(() => { document.getElementById("converterPercentage").innerHTML = ""; }, 2000);
  });
  ipcRenderer.once("SoundCloudToMP3Error", (event) => {
    document.getElementById("converterPercentage").innerHTML = "Error Downloading";
    setTimeout(() => { document.getElementById("converterPercentage").innerHTML = ""; }, 2000);
  });

  Store.dispatch({ type: "disableModal" });
}



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
function toggleSideBarFooterControls(id) {
  const obj = document.getElementById(id);
  if(window.getComputedStyle(obj).display === "none") {
    if(id === "sideBar") obj.style.display = "block";
    else                 obj.style.display = "flex";
  } else obj.style.display = "none";
}
export function toggleSideBar()        { toggleSideBarFooterControls("sideBar"); }
export function toggleFooterControls() { toggleSideBarFooterControls("footerControls"); }



// FooterSongControls
export async function getShuffleRepeatValues() {
  const result = await oneArgIPC("getShuffleRepeat");
  return result;
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

    if(mode === "playlist") {
      contextMenu.style.top  = (((window.innerHeight - event.clientY) < 103) ? (window.innerHeight - 103) : event.clientY) + "px";
      contextMenu.style.left = ((event.clientX < 5) ? 5 : event.clientX) + "px";
    } else if(mode === "song" || mode === "youtube" || mode === "soundcloud") {
      contextMenu.style.top  = (((window.innerHeight - event.clientY) < 140) ? (window.innerHeight - 140) : event.clientY) + "px";
      contextMenu.style.left = (((window.innerWidth - event.clientX) < 300) ? (window.innerWidth - 300) : event.clientX) + "px";
    }
  } else if(contextMenu && contextMenuSelected === obj) Store.dispatch({ type: "disableContextMenu" });
}



// SearchBar
export async function toggleSearchBar(mode) {
  const searchBar = Store.getState().searchBar;

  if(searchBar.show && (searchBar.mode === mode || !mode)) {
    if(searchBar.mode === "search") Store.dispatch({ type: "setSongs", payload: searchBar.songsCopy });
    Store.dispatch({ type: "disableSearchBar" });
  } else {
    switch(mode) {
      case "search":
        const songs = Store.getState().songs;
        if(songs.length > 0) {
          await Store.dispatch({ type: "enableSearchBar", payload: { mode: mode, songsCopy: songs }});
          document.getElementById("searchBar").focus();
        }
        break;
      case "youtube":
        await Store.dispatch({ type: "setListeningMode", payload: "youtube" });
        await Store.dispatch({ type: "setSongs", payload: [] });
        await Store.dispatch({ type: "enableSearchBar", payload: { mode: mode, songsCopy: null }});
        document.getElementById("searchBar").focus();
        break;
      case "soundcloud":
        await Store.dispatch({ type: "setListeningMode", payload: "soundcloud" });
        await Store.dispatch({ type: "setSongs", payload: [] });
        await Store.dispatch({ type: "enableSearchBar", payload: { mode: mode, songsCopy: null }});
        document.getElementById("searchBar").focus();
        break;
      default: break;
    }
  }
}
