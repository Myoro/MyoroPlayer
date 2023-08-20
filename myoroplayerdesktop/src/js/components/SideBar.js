import React from "react";
import { useSelector } from "react-redux";
import "../../css/SideBar.css";
import { openPlaylist } from "../Functions.js";

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

  function onClick(index, directory) {
    setSelected(index);
    const sideBarChildren = document.getElementById("sideBar").childNodes;
    for(let i = 0; i < sideBarChildren.length; i++) {
      if(i !== index) {
        sideBarChildren[i].style.background = "none";
        sideBarChildren[i].style.color      = darkMode ? "#EDE6D6" : "#181818";
      }
    }
    openPlaylist(directory);
  }

  return(
    <aside
      id="sideBar"
      style={{ borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
    >
      {
        playlists.map((playlist, index) =>
          <button
            key={index}
            name={playlist.directory}
            style={{ color: darkMode ? "#EDE6D6" : "#181818" }}
            onMouseOver={(event) => hoverButton(event, index)}
            onMouseOut={(event) => hoverButton(event, index)}
            onClick={() => onClick(index, playlist.directory)}
          >{playlist.name}</button>
        )
      }
    </aside>
  );
}

export default React.memo(SideBar);
