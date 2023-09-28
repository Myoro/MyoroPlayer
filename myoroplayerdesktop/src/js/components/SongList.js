import React from "react";
import { useSelector } from "react-redux";
import "../../css/SongList.css";
import { toggleContextMenu } from "../Functions.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function SongList() {
  const darkMode                  = useSelector(state => state.darkMode);
  const showLoadingBar            = useSelector(state => state.showLoadingBar);
  const songs                     = useSelector(state => state.songs);
  const [ selected, setSelected ] = React.useState(null);

  const styles = {
    text: darkMode ? "#EDE6D6" : "#181818"
  };

  function hoverButton(event, index) {
    if(selected === index) return;

    let li = event.target;
    while(li.tagName !== "LI") li = li.parentNode;

    let hovered = true;
    if(window.getComputedStyle(li).backgroundColor === "rgba(0, 0, 0, 0)")
      hovered = false;

    toggleHover(li, hovered);
  }

  function toggleHover(li, hovered) {
    const text          = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
    li.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    if(li.childNodes[0].src.includes(!hovered ? (darkMode ? "LogoDark" : "LogoLight") : (darkMode ? "LogoLight" : "LogoDark")))
      li.childNodes[0].src = !hovered ? (darkMode ? LogoLight : LogoDark) : (darkMode ? LogoDark : LogoLight);
    for(let i = 0; i < li.childNodes[1].childNodes.length; i++)
      li.childNodes[1].childNodes[i].style.color = text;
    li.childNodes[2].style.color = text;
    li.childNodes[3].style.color = text;
  }

  function mapSongs() {
    return songs.map((song, index) =>
      <li
        key={index}
        onMouseOver={(event) => hoverButton(event, index)}
        onMouseOut={(event) => hoverButton(event, index)}
        onClick={() => onClick(index)}
        onContextMenu={(event) => toggleContextMenu(event, "song", song)}
      >
        {/* Album cover */}
        <img alt="cover" src={song.cover ? song.cover : (darkMode ? LogoDark : LogoLight)} />

        {/* Song title & artist */}
        <div>
          <p style={{ color: styles.text }}>{song.title}</p>
          {
            song.artist
            &&
            <p style={{ color: styles.text }}>{song.artist}</p>
          }
        </div>

        {/* Album */}
        <p style={{ color: styles.text }}>{song.album ? song.album : ''}</p>

        {/* Song duration */}
        <p style={{ color: styles.text }}>{song.lengthStr}</p>
      </li>
    );
  }

  function onClick(index) {
    setSelected(index);
    const LIs = document.getElementById("songList").childNodes;
    for(let i = 0; i < LIs.length; i++)
      if(i !== index)
        toggleHover(LIs[i], true);
  }

  return(
    <ul id="songList">
      {
        !showLoadingBar

        ?

        mapSongs()

        :

        <div
          id="loading"
          style={{ border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
        >
          <div
            id="loadingBar"
            style={{ background: styles.text }}
          >
          </div>
        </div>
      }
    </ul>
  );
}

export default React.memo(SongList);
