import React from "react";
import { useSelector } from "react-redux";
import "../../css/SideBar.css";
import { hoverButton, openPlaylist } from "../Functions.js";

function SideBar() {
  const darkMode  = useSelector(state => state.darkMode);
  const playlists = useSelector(state => state.playlists);

  return(
    <aside
      id="sideBar"
      style={{ borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
    >
      {
        playlists.map((playlist, index) =>
          <button
            key={index}
            style={{ color: darkMode ? "#EDE6D6" : "#181818" }}
            onMouseOver={hoverButton}
            onMouseOut={hoverButton}
            onClick={() => openPlaylist(playlist.directory)}
          >{playlist.name}</button>
        )
      }
    </aside>
  );
}

export default React.memo(SideBar);
