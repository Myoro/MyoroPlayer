import React from "react";
import { useSelector } from "react-redux";
import "../../css/SideBar.css";
import { hoverButton } from "../Functions.js";

function SideBar() {
  const darkMode  = useSelector(state => state.darkMode);
  const playlists = useSelector(state => state.playlists);

  function mapPlaylists() {
    return playlists.map((playlist, index) =>
      <button
        key={index}
        name={JSON.stringify(playlist)}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
      >{playlist.name}</button>
    );
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
