import React from "react";
import { useSelector } from "react-redux";
import "../../css/SideBar.css";
import { hoverButton } from "../Functions.js";

function SideBar() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <aside
      id="sideBar"
      style={{
        borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
      }}
    >
      <button
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
      >Example Playlist</button>
    </aside>
  );
}

export default React.memo(SideBar);
