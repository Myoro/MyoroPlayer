import React from "react";
import { Provider } from "react-redux";
import Store from "./Store.js";
import Root from "./components/Root.js";
import {
  noArgIpcCall,
  newPlaylist,
  openPlaylists,
  renamePlaylist,
  softDeletePlaylist,
  hardDeletePlaylist,
  copySongToPlaylists,
  moveSongToPlaylist,
  hardDeleteSong,
  quit
} from "./Functions.js";
import { addToQueue } from "./players/LocalPlayer.js";

function App() {
  React.useEffect(() => {
    // Initializing database & grabbing playlists from it
    (async function getPlaylists() {
      const init      = await noArgIpcCall("initializeDatabase");
      if(!init) quit();
      const playlists = await noArgIpcCall("getPlaylists");
      Store.dispatch({ type: "setPlaylists", payload: playlists });
    })();

    // Event listeners
    document.addEventListener("click", click);
    document.addEventListener("keydown", keydown);
    document.addEventListener("contextmenu", contextmenu);

    // Setting CSS variables
    const darkMode = Store.getState().darkMode;
    document.documentElement.style.setProperty("--secondary",     darkMode ? "#181818" : "#EDE6D6");
    document.documentElement.style.setProperty("--primary",       darkMode ? "#EDE6D6" : "#181818");
    document.documentElement.style.setProperty("--primary-hover", darkMode ? "#CCC3B3" : "#000000");

    return () => {
      document.removeEventListener("click", click);
      document.removeEventListener("keydown", keydown);
      document.removeEventListener("contextmenu", contextmenu);
    };
  }, []);

  function click(event) {
    // Always reset context menu on left clicks
    Store.dispatch({ type: "resetContextMenu" });

    // Disable all topbar dropdowns if topbar button not clicked
    if(event.target.className !== "topBarButton") {
      const dropdowns = document.getElementsByClassName("topBarButtonDropdown");
      for(let i = 0; i < dropdowns.length; i++)
        dropdowns[i].style.display = "none";
    }
    // Disable modal when clicking background
    if(event.target.id === "modal") Store.dispatch({ type: "resetModal" });
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

  async function contextmenu(event) {
    let songListButton = event.target;
    for(let i = 0; i < 3; i++) {
      if(songListButton.className !== "songListButton") {
        if(i === 2)                        songListButton = undefined;
        else if(songListButton.parentNode) songListButton = songListButton.parentNode;
        else                               songListButton = undefined;
      } else break;
    }

    // Playlist context menu
    if(event.target.parentNode.id === "sideBar" || songListButton) {
      let x = event.clientX;
      let y = event.clientY;

      if(event.target.parentNode.id === "sideBar") {
        await Store.dispatch({
          type: "setContextMenu",
          payload: [
            {
              name:    "Rename Playlist",
              onClick: () => Store.dispatch({
                type: "setModal",
                payload: {
                  dialog:    "rename",
                  directory: null,
                  buttons:   [
                    { name: "Yes", onClick: () => renamePlaylist(event.target.name) },
                    { name: "No",  onClick: () => Store.dispatch({ type: "resetModal" }) }
                  ]
                }
              })
            },
            {
              name:    "Remove Playlist from MyoroPlayer",
              onClick: () => softDeletePlaylist(event.target.name)
            },
            {
              name:    "Delete Playlist from Computer",
              onClick: () => Store.dispatch({
                type:    "setModal",
                payload: {
                  dialog:    "delete",
                  directory: event.target.name,
                  buttons:   [
                    { name: "Yes", onClick: () => hardDeletePlaylist(event.target.name) },
                    { name: "No",  onClick: () => Store.dispatch({ type: "resetModal" }) }
                  ]
                }
              })
            }
          ]
        });

        if(x <= 5)                          x = 5;
        if((window.innerHeight - y) <= 115) y = window.innerHeight - 115;
      } else if(songListButton) {
        await Store.dispatch({
          type: "setContextMenu",
          payload: [
            {
              name:    "Add to Queue",
              onClick: () => addToQueue(songListButton.name)
            },
            {
              name:    "Copy to Other Playlist(s)",
              onClick: () => copySongToPlaylists(songListButton.name)
            },
            {
              name:    "Move to Other Playlist",
              onClick: () => moveSongToPlaylist(songListButton.name)
            },
            {
              name:    "Delete Song from Computer",
              onClick: () => Store.dispatch({
                type:    "setModal",
                payload: {
                  dialog:    "delete",
                  directory: songListButton.name,
                  buttons:    [
                    { name: "Yes", onClick: () => hardDeleteSong(songListButton.name) },
                    { name: "No",  onClick: () => Store.dispatch({ type: "resetModal" }) }
                  ]
                }
              })
            }
          ]
        });

        if((window.innerWidth - x) <= 330)  x = window.innerWidth - 330;
        if((window.innerHeight - y) <= 155) y = window.innerHeight - 155;
      }

      const contextMenu      = document.getElementById("contextMenu");
      contextMenu.style.left = x + "px";
      contextMenu.style.top  = y + "px";
    } else Store.dispatch({ type: "resetContextMenu" });
  }

  return (
    <Provider store={Store}>
      <Root />
    </Provider>
  );
}

export default App;
