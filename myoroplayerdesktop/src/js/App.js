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
  toggleUI,
  quit
} from "./Functions.js";
import { addToQueue, togglePlay } from "./players/LocalPlayer.js";

function App() {
  React.useEffect(() => {
    // Initializing database & grabbing playlists from it
    (async function getPlaylists() {
      const init      = await noArgIpcCall("initializeDatabase");
      if(!init) quit();
      Store.dispatch({ type: "setDatabaseInitialized", payload: true });
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
    // Play/pause
    if(event.keyCode === 32) {
      const state = togglePlay();
      if(state === null) return;
      Store.dispatch({ type: "setPlaySrc", payload: state });
    }

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
        // Toggle SideBar
        case "1":
          toggleUI("sideBar");
          break;
        // Toggle FooterControls
        case "2":
          toggleUI("footerControls");
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
        const songs = Store.getState().songs;
        await Store.dispatch({
          type: "setContextMenu",
          payload: [
            {
              name:    "Add to Queue",
              onClick: () => addToQueue(songs[songListButton.name])
            },
            {
              name:    "Copy to Other Playlist(s)",
              onClick: () => copySongToPlaylists(songs[songListButton.name].songDirectory)
            },
            {
              name:    "Move to Other Playlist",
              onClick: () => moveSongToPlaylist(songs[songListButton.name].songDirectory)
            },
            {
              name:    "Delete Song from Computer",
              onClick: () => Store.dispatch({
                type:    "setModal",
                payload: {
                  dialog:    "delete",
                  directory: songs[songListButton.name].songDirectory,
                  buttons:    [
                    { name: "Yes", onClick: () => hardDeleteSong(songs[songListButton.name].songDirectory) },
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
