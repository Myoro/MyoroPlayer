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

export async function newPlaylist() {
  const data = await noArgIpcCall("newPlaylist");
  Store.dispatch({ type: "addPlaylist", payload: data });
}
