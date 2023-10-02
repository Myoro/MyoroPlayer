import React from "react";
import { useSelector } from "react-redux";
import "../../css/SideBar.css";
import Store from "../ReduxStore.js";
import { loadPlaylist, toggleContextMenu } from "../Functions.js";

function SideBar() {
  const darkMode                  = useSelector(state => state.darkMode);
  const playlists                 = useSelector(state => state.playlists);
  const [ selected, setSelected ] = React.useState(null);

  function hoverButton(event, index) {
    if(selected === index) return;

    if(window.getComputedStyle(event.target).backgroundColor === "rgba(0, 0, 0, 0)") {
      event.target.style.background = darkMode ? "#EDE6D6" : "#181818";
      event.target.style.color      = darkMode ? "#181818" : "#EDE6D6";
    } else {
      event.target.style.background = "none";
      event.target.style.color      = darkMode ? "#EDE6D6" : "#181818";
    }
  }

  function mapPlaylists() {
    return playlists.map((playlist, index) =>
      <button
        key={index}
        name={JSON.stringify(playlist)}
        onMouseOver={(event) => hoverButton(event, index)}
        onMouseOut={(event) => hoverButton(event, index)}
        onClick={() => onClick(playlist, index)}
        onContextMenu={(event) => toggleContextMenu(event, "playlist", playlist)}
      >{playlist.name}</button>
    );
  }

  function onClick(playlist, index) {
    setSelected(index);
    const playlists = document.getElementById("sideBar").childNodes;
    for(let i = 0; i < playlists.length; i++) {
      if(playlists[i].name !== JSON.stringify(playlist)) {
        playlists[i].style.background = "none";
        playlists[i].style.color      = darkMode ? "#EDE6D6" : "#181818";
      }
    }

    Store.dispatch({ type: "setListeningMode", payload: "local" });
    loadPlaylist(playlist.directory);
  }

  return(
    <aside
      id="sideBar"
      style={{
        borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
      }}
    >
      { mapPlaylists() }
    </aside>
  );
}

export default React.memo(SideBar);
