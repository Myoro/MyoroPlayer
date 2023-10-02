import React from "react";
import { Provider } from "react-redux";
import Store from "./ReduxStore.js";
import {
  quit,
  openPlaylist,
  newPlaylist,
  getPlaylists,
  initializeDatabase,
  cleanTopBarDropdowns,
  toggleSearchBar
} from "./Functions.js";
import Root from "./components/Root.js";

function App() {
  React.useEffect(() => {
    initializeDatabase();

    // Allows other components to wait until database is initialized to avoid errors
    Store.dispatch({ type: "setDatabaseInitialized", payload: true });

    getPlaylists();

    const darkMode = Store.getState().darkMode;
    document.documentElement.style.setProperty("--primary",       darkMode ? "#EDE6D6" : "#181818");
    document.documentElement.style.setProperty("--primary-hover", darkMode ? "#CCC3B3" : "#000000");
    document.documentElement.style.setProperty("--secondary",     darkMode ? "#181818" : "#EDE6D6");

    document.addEventListener("click", click);
    document.addEventListener("keydown", keydown);

    return () => {
      document.removeEventListener("click", click);
      document.removeEventListener("keydown", keydown);
    }
  }, []);

  function click(event) {
    // Always disable ContextMenu on left clicks
    Store.dispatch({ type: "disableContextMenu" });

    // Clean dropdowns whenever topBarButton is not clicked
    if(event.target.className !== "topBarButton") cleanTopBarDropdowns();

    // Clean queue list shown in FooterMiscControls on left clicks
    if(event.target.id !== "queueList") Store.dispatch({ type: "disableQueueList" });
  }

  function keydown(event) {
    /* Escape key shortcuts */
    // TopBar buttons & queue list in FooterMiscControls
    if(event.key === "Escape") {
      cleanTopBarDropdowns();
      Store.dispatch({ type: "disableQueueList" });
    }
    // Modal
    if(event.key === "Escape" && Store.getState().modal.show) Store.dispatch({ type: "disableModal" });
    // SearchBar
    if(event.key === "Escape" && Store.getState().searchBar.show) toggleSearchBar();

    // SearchBar
    if(event.key === '/') { event.preventDefault(); toggleSearchBar(); }

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

  return (
    <Provider store={Store}>
      <Root />
    </Provider>
  );
}

export default App;
