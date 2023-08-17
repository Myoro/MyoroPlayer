import React from "react";
import { useSelector } from "react-redux";
import "../../css/SongList.css";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function SongList() {
  const darkMode = useSelector(state => state.darkMode);
  const songs    = useSelector(state => state.songs);

  function hoverButton(event) {
    let button = event.target;
    while(button.tagName !== "BUTTON") button = button.parentNode;

    let hovered = false;
    if(window.getComputedStyle(button).backgroundColor !== "rgba(0, 0, 0, 0)") hovered = true;

   
    button.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none"; 
    if(button.childNodes[0].src.includes(!hovered ? (darkMode ? "LogoDark" : "LogoLight") : (darkMode ? "LogoLight" : "LogoDark")))
      button.childNodes[0].src = !hovered ? (darkMode ? LogoLight : LogoDark) : (darkMode ? LogoDark : LogoLight);
    const textStyle = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
    for(let i = 0; i < button.childNodes[1].childNodes.length; i++)
      button.childNodes[1].childNodes[i].style.color = textStyle;
    button.childNodes[2].style.color = textStyle;
    button.childNodes[3].style.color = textStyle;
  }

  return(
    <ul id="songList">
      {
        songs.map((song, index) =>
          <button
            key={index}
            onMouseOver={hoverButton}
            onMouseOut={hoverButton}
          >
            <img
              draggable={false}
              alt="cover"
              src={song.cover ? song.cover : (darkMode ? LogoDark : LogoLight)}
            />

            <div>
              <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.name}</p>
              {
                song.artist
                &&
                <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.artist}</p>
              }
            </div>

            {
              song.album
              &&
              <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>song.album</p>
            }

            <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>420:00</p>
          </button>
        )
      }
    </ul>
  );
}

export default React.memo(SongList);
