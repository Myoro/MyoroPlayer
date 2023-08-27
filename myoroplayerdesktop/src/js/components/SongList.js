import React from "react";
import { useSelector } from "react-redux";
import "../../css/SongList.css";
import Store from "../Store.js";
import { directPlay } from "../players/LocalPlayer.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function SongList() {
  const darkMode                  = useSelector(state => state.darkMode);
  const songs                     = useSelector(state => state.songs);
  const showLoadingBar            = useSelector(state => state.showLoadingBar);
  const searchBarOptions          = useSelector(state => state.searchBarOptions);
  const [ selected, setSelected ] = React.useState(null);

  function toggleHover(button, hovered) {
    button.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none"; 
    if(button.childNodes[0].src.includes(!hovered ? (darkMode ? "LogoDark" : "LogoLight") : (darkMode ? "LogoLight" : "LogoDark")))
      button.childNodes[0].src = !hovered ? (darkMode ? LogoLight : LogoDark) : (darkMode ? LogoDark : LogoLight);
    const textStyle = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
    for(let i = 0; i < button.childNodes[1].childNodes.length; i++)
      button.childNodes[1].childNodes[i].style.color = textStyle;
    button.childNodes[2].style.color = textStyle;
    button.childNodes[3].style.color = textStyle;
  }

  function hoverButton(event, index) {
    if(selected === index) return;

    let button = event.target;
    while(button.tagName !== "BUTTON") button = button.parentNode;

    let hovered = false;
    if(window.getComputedStyle(button).backgroundColor !== "rgba(0, 0, 0, 0)") hovered = true;

    toggleHover(button, hovered); 
  }

  function onClick(index) {
    setSelected(index);
    const songListChildren = document.getElementById("songList").childNodes;
    for(let i = 0; i < songListChildren.length; i++)
      if(i !== index)
        toggleHover(songListChildren[i], true);
  }

  function searchBarKeyDown(event) {
    const newSongs = searchBarOptions.songsCopy.filter(song => {
      return song.songDirectory.toUpperCase().includes(event.target.value.toUpperCase());
    });
    Store.dispatch({ type: "setSongs", payload: newSongs });
  }

  return(
    <>
      <ul id="songList">
        {
          !showLoadingBar
          ?
          songs.map((song, index) =>
            <button
              key={index}
              name={index}
              className="songListButton"
              onMouseOver={(event) => hoverButton(event, index)}
              onMouseOut={(event) => hoverButton(event, index)}
              onClick={() => onClick(index)}
              onDoubleClick={() => directPlay(song)}
            >
              <img
                draggable={false}
                alt="cover"
                src={song.cover ? song.cover : (darkMode ? LogoDark : LogoLight)}
              />

              <div>
                <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.name}</p>
                <p
                  style={{
                    color:  darkMode ? "#EDE6D6" : "#181818",
                    height: !song.artist && 0
                  }}
                >{song.artist || ""}</p>
              </div>

              <p
                style={{
                  color: darkMode ? "#EDE6D6" : "#181818",
                  flex: !song.album && 0
                }}
              >{song.album || ""}</p>

              <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.lengthStr}</p>
            </button>
          )
          :
          <div style={{ border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}>
            <div style={{ background: darkMode ? "#EDE6D6" : "#181818" }}></div>
          </div>
        }
      </ul>

      {
        searchBarOptions.show
        &&
        <input
          id="searchBar"
          type="text"
          style={{
            color:     darkMode ? "#EDE6D6" : "#181818",
            borderTop: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
          }}
          onKeyUp={searchBarKeyDown}
          autofocus
        />
      }
    </>
  );
}

export default React.memo(SongList);
