// Where extra global functions go
import Store from "./ReduxStore.js";
const { ipcRenderer } = window.require("electron");

// Electron IPC calls
export function quit()               { ipcRenderer.send("quit"); }
export function openPlaylist()       { ipcRenderer.send("openPlaylist"); }
export function newPlaylist()        { ipcRenderer.send("newPlaylist"); }
export function initializeDatabase() { ipcRenderer.send("initializeDatabase"); }

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
