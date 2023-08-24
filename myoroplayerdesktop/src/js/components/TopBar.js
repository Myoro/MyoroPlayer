import React from "react";
import { useSelector } from "react-redux";
import "../../css/TopBar.css";
import {
  hoverButton,
  newPlaylist,
  openPlaylists,
  toggleUI,
  quit
} from "../Functions.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function TopBar() {
  const darkMode    = useSelector(state => state.darkMode);
  const [ buttons ] = React.useState([
    {
      name: "File",
      buttons: [
        {
          name:     "Open Playlist(s)",
          shortcut: "Ctrl + O",
          onClick:  openPlaylists
        },
        {
          name:     "New Playlist",
          shortcut: "Ctrl + N",
          onClick:  newPlaylist
        },
        {
          name:     "Quit MyoroPlayer",
          shortcut: "Ctrl + Q",
          onClick:  quit
        }
      ]
    },
    {
      name: "View",
      buttons: [
        {
          name:     "Toggle Dark Mode",
          shortcut: "Ctrl +  D",
          onClick:  () => alert("Dark mode")
        },
        {
          name:     "Toggle Sidebar",
          shortcut: "Ctrl + 1",
          onClick:  () => toggleUI("sideBar")
        },
        {
          name:     "Toggle Footer Controls",
          shortcut: "Ctrl + 2",
          onClick:  () => toggleUI("footerControls")
        }
      ]
    },
    {
      name: "Streaming",
      buttons: [
        {
          name:     "Search YouTube",
          shortcut: "Ctrl + Y",
          onClick:  () => alert("Search YouTube")
        },
        {
          name:     "Search SoundCloud",
          shortcut: "Ctrl + S",
          onClick:  () => alert("Search SoundCloud")
        },
        {
          name:     "YouTube to MP3",
          shortcut: "Ctrl + C",
          onClick:  () => alert("YouTube to MP3")
        }
      ]
    },
    {
      name: "Misc",
      buttons: [
        {
          name:     "About MyoroPlayer",
          shortcut: "Ctrl + A",
          onClick:  () => alert("About MyoroPlayer")
        },
        {
          name:     "Donate",
          shortcut: "Ctrl + D",
          onClick:  () => alert("Donate")
        }
      ]
    }
  ]);

  function hoverDropdownButton(event) {
    let li = event.target;
    while(li.tagName !== "LI") li = li.parentNode;

    let hovered;
    if(window.getComputedStyle(li).backgroundColor === "rgba(0, 0, 0, 0)")
      hovered = false;
    else
      hovered = true;

    li.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    for(let i = 0; i < li.childNodes.length; i++)
      li.childNodes[i].style.color = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
  }

  function toggleDropdown(event) {
    const dropdown = event.target.parentNode.childNodes[1];
    let shown      = false;
    if(window.getComputedStyle(dropdown).display !== "none") shown = true;

    const dropdowns = document.getElementsByClassName("topBarButtonDropdown");
    for(let i = 0; i < dropdowns.length; i++)
      dropdowns[i].style.display = "none";

    if(!shown) dropdown.style.display = "block";
  }

  return(
    <header
      id="topBar"
      style={{ borderBottom: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
      onClick={(event) => { if(event.target.tagName === "HEADER") alert(event.target.offsetHeight) }}
    >
      {/* Logo */}
      <img
        alt="logo"
        src={darkMode ? LogoDark : LogoLight}
        style={{ borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
        draggable={false}
      />

      {/* TopBar button + dropdown mapping */}
      {
        buttons.map((button, index) =>
          <div key={index}>
            <button
              className="topBarButton"
              style={{
                color:       darkMode ? "#EDE6D6" : "#181818",
                borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
              }}
              onClick={toggleDropdown}
              onMouseOver={hoverButton}
              onMouseOut={hoverButton}
            >{button.name}</button>
            <ul
              className="topBarButtonDropdown"
              style={{
                background:   darkMode ? "#181818" : "#EDE6D6",
                borderLeft:   darkMode ? "2px solid #EDE6D6" : "2px solid #181818",
                borderRight:  darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
              }}
            >
              {
                button.buttons.map((dropdownButton, index) =>
                  <li
                    key={index}
                    style={{ borderBottom: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
                    onClick={dropdownButton.onClick}
                    onMouseOver={hoverDropdownButton}
                    onMouseOut={hoverDropdownButton}
                  >
                    <button style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{dropdownButton.name}</button>
                    <button style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{dropdownButton.shortcut}</button>
                  </li>
                )
              }
            </ul>
          </div>
        )
      }
    </header>
  );
}

export default React.memo(TopBar);
