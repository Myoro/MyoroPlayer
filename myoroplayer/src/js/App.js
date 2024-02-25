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
  toggleSearchBar,
  toggleSideBar,
  toggleFooterControls,
  setDarkMode
} from "./Functions.js";
import Root from "./components/Root.js";

function App() {
  React.useEffect(() => {
    initializeDatabase();

    // Allows other components to wait until database is initialized to avoid errors
    Store.dispatch({ type: "setDatabaseInitialized", payload: true });

    getPlaylists();

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
    if(event.key === '/') { event.preventDefault(); toggleSearchBar("search"); }

    // Ctrl key keyboard shortcuts
    if(event.ctrlKey) {
      switch(event.key.toUpperCase()) {
        // Quit MyoroPlayer
        case 'Q': quit();                        break;
        // Open playlist
        case 'O': openPlaylist();                break;
        // New playlist
        case 'N': newPlaylist();                 break;
        // YouTube search
        case 'Y': toggleSearchBar("youtube");    break;
        // SoundCloud search
        case 'S': toggleSearchBar("soundcloud"); break;
        default:                                 break;
      }
    }

    // Shift key keyboard shortcuts
    if(event.shiftKey) {
      event.preventDefault();
      switch(event.key.toUpperCase()) {
        // YouTube to MP3
        case 'Y': Store.dispatch({ type: "enableModal", payload: { mode: "yt2mp3" }}); break;
        // SoundCloud to MP3
        case 'S': Store.dispatch({ type: "enableModal", payload: { mode: "sc2mp3" }}); break;
        default:                                                                       break;
      }
    }

    // Alt key keyboard shortcuts
    if(event.altKey) {
      switch(event.key.toUpperCase()) {
        // Toggle darkMode
        case 'D': setDarkMode();                                                       break;
        // Toggle SideBar
        case 'S': toggleSideBar();                                                     break;
        // Toggle FooterControls
        case 'C': toggleFooterControls();                                              break;
        // About MyoroPlayer
        case 'A': Store.dispatch({ type: "enableModal", payload: { mode: "about" }});  break;
        // Donate
        case 'M': Store.dispatch({ type: "enableModal", payload: { mode: "donate" }}); break;
        default:                                                                       break;
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
