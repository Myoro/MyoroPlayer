import React from "react";
import { useSelector } from "react-redux";
import "../../css/TopBar.css";
import {
  quit,
  hoverButton,
  openPlaylist,
  newPlaylist,
  cleanTopBarDropdowns as cleanDropdowns,
  toggleSearchBar
} from "../Functions.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function TopBar() {
  const darkMode    = useSelector(state => state.darkMode);
  const [ buttons ] = React.useState([
    {
      name: "File",
      options: [
        {
          name:     "Open Playlist",
          shortcut: "Ctrl + O",
          onClick:  openPlaylist
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
        },
        {
          name:     "Search Songs",
          shortcut: "/",
          onClick:  () => toggleSearchBar("search")
        }
      ]
    },
    {
      name: "Streaming",
      options: [
        {
          name:     "Search YouTube",
          shortcut: "Ctrl + Y",
          onClick:  () => toggleSearchBar("youtube")
        },
        {
          name:     "Search SoundCloud",
          shortcut: "Ctrl + S",
          onClick:  () => toggleSearchBar("soundcloud")
        },
        {
          name:     "YouTube to MP3",
          shortcut: "Shft + Y"
        },
        {
          name:     "SoundCloud to MP3",
          shortcut: "Shft + S"
        }
      ]
    },
    {
      name: "View",
      options: [
        {
          name:     "Toggle Dark Mode",
          shortcut: "Alt + D"
        },
        {
          name:     "Toggle Sidebar",
          shortcut: "Alt + S"
        },
        {
          name:     "Toggle Controls",
          shortcut: "Alt + C"
        }
      ]
    },
    {
      name: "Misc",
      options: [
        {
          name:     "About MyoroPlayer",
          shortcut: "Alt + A"
        },
        {
          name:     "Donate",
          shortcut: "Alt + D"
        }
      ]
    }
  ]);

  const styles = {
    border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818",
    text:  darkMode ? "#EDE6D6" : "#181818"
  };

  function mapButtons() {
    return buttons.map((button, index) =>
      <div key={index}>
        <button
          key={index}
          className="topBarButton"
          style={{
            borderRight: styles.border,
            color:       styles.text
          }}
          onMouseOver={hoverButton}
          onMouseOut={hoverButton}
          onClick={openDropdown}
        >{button.name}</button>

        <ul
          id={button.name}
          style={{
            background:  darkMode ? "#181818" : "#EDE6D6",
            borderLeft:  styles.border,
            borderRight: styles.border
          }}
        >
          {
            button.options.map((option, index) =>
              <li
                key={index}
                style={{ borderBottom: styles.border }}
                onMouseOver={hoverDropdownButton}
                onMouseOut={hoverDropdownButton}
                onClick={option.onClick}
              >
                <button style={{ color: styles.text }}>{option.name}</button>
                <button style={{ color: styles.text }}>{option.shortcut}</button>
              </li>
            )
          }
        </ul>
      </div>
    );
  }

  function hoverDropdownButton(event) {
    let li = event.target;
    if(li.tagName !== "LI") li = li.parentNode;

    let hovered = true;
    if(window.getComputedStyle(li).backgroundColor === "rgba(0, 0, 0, 0)")
      hovered = false;

    li.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    for(let i = 0; i < li.childNodes.length; i++)
      li.childNodes[i].style.color = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : styles.text;
  }

  function openDropdown(event) {
    const dropdown        = document.getElementById(event.target.innerHTML);
    const dropdownDisplay = window.getComputedStyle(dropdown).display;

    cleanDropdowns();

    if(dropdownDisplay === "none") dropdown.style.display = "block";
    else                           dropdown.style.display = "none";
  }

  return(
    <header
      id="topBar"
      style={{ borderBottom: styles.border }}
    >
      {/* Logo */}
      <img
        alt="logo"
        src={darkMode ? LogoDark : LogoLight}
        style={{ borderRight: styles.border }}
      />

      { mapButtons() }
    </header>
  );
}

export default React.memo(TopBar);
