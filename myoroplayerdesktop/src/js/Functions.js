// Where multi-file functions are stored
import Store from "./Store.js";

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
