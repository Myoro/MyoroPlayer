import React from "react";
import { Provider } from "react-redux";
import Store from "./Store.js";
import Root from "./components/Root.js";
import {
  noArgIpcCall,
  newPlaylist,
  openPlaylists,
  quit
} from "./Functions.js";

function App() {
  React.useEffect(() => {
    // Initializing database & grabbing playlists from it
    (async function getPlaylists() {
      const init      = await noArgIpcCall("initializeDatabase");
      if(!init) quit();
      const playlists = await noArgIpcCall("getPlaylists");
      Store.dispatch({ type: "setPlaylists", payload: playlists });
    })();

    document.addEventListener("click", click);
    document.addEventListener("keydown", keydown);

    return () => {
      document.removeEventListener("click", click);
      document.removeEventListener("keydown", keydown);
    };
  }, []);

  function click(event) {
    // Disable all topbar dropdowns if topbar button not clicked
    if(event.target.className !== "topBarButton") {
      const dropdowns = document.getElementsByClassName("topBarButtonDropdown");
      for(let i = 0; i < dropdowns.length; i++)
        dropdowns[i].style.display = "none";
    }
  }

  function keydown(event) {
    if(event.ctrlKey) {
      switch(event.key.toUpperCase()) {
        // Open playlist(s)
        case "O":
          openPlaylists();
          break;
        // New Playlist
        case "N":
          newPlaylist();
          break;
        // Quit MyoroPlayer
        case "Q":
          quit();
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
