import React from "react";
import { Provider } from "react-redux";
import Store from "./ReduxStore.js";
import {
  quit,
  openPlaylist,
  newPlaylist,
  getPlaylists,
  initializeDatabase,
  cleanTopBarDropdowns
} from "./Functions.js";
import Root from "./components/Root.js";

function App() {
  React.useEffect(() => {
    initializeDatabase();

    getPlaylists();

    const darkMode = Store.getState().darkMode;
    document.documentElement.style.setProperty("--primary",       darkMode ? "#EDE6D6" : "#181818");
    document.documentElement.style.setProperty("--primary-hover", darkMode ? "#CCC3B3" : "#000000");
    document.documentElement.style.setProperty("--secondary",     darkMode ? "#181818" : "#EDE6D6");

    document.addEventListener("click", click);
    document.addEventListener("keydown", keydown);
    document.addEventListener("contextmenu", contextmenu);

    return () => {
      document.removeEventListener("click", click);
      document.removeEventListener("keydown", keydown);
      document.removeEventListener("contextmenu", contextmenu);
    }
  }, []);

  function click(event) {
    // Always disable ContextMenu on left clicks
    Store.dispatch({ type: "disableContextMenu" });

    // Clean dropdowns whenever topBarButton is not clicked
    if(event.target.className !== "topBarButton") cleanTopBarDropdowns();
  }

  function keydown(event) {
    if(event.key === "Escape") cleanTopBarDropdowns();

    // Ctrl key keyboard shortcuts
    if(event.ctrlKey) {
      switch(event.key.toUpperCase()) {
        // Quit MyoroPlayer
        case 'Q':
          quit();
          break;
        // Open playlist
        case 'O':
          openPlaylist();
          break;
        // New playlist
        case 'N':
          newPlaylist();
          break;
        default:
          break;
      }
    }
  }

  async function contextmenu(event) {
    // Context menu for playlists displayed in SideBar
    if(event.target.parentNode.id === "sideBar") {
      await Store.dispatch({
        type: "enableContextMenu",
        payload: {
          mode:     "playlist",
          selected: JSON.parse(event.target.name)
        }
      });

      const contextMenu      = document.getElementById("contextMenu");
      contextMenu.style.top  = (((window.innerHeight - event.clientY) < 100) ? (window.innerHeight - 103) : event.clientY) + "px";
      contextMenu.style.left = ((event.clientX < 5) ? 5 : event.clientX) + "px";
    } else Store.dispatch({ type: "disableContextMenu" });
  }

  return (
    <Provider store={Store}>
      <Root />
    </Provider>
  );
}

export default App;
