import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import Store from "../ReduxStore.js";
import { renamePlaylist, YouTubeToMP3, SoundCloudToMP3 } from "../Functions.js";

function InputDialog({ hoverButton }) {
  const darkMode                = useSelector(state => state.darkMode);
  const modal                   = useSelector(state => state.modal);
  const [ buttons, setButtons ] = React.useState([]);

  React.useEffect(() => {
    switch(modal.mode) {
      case "renamePlaylist":
        setButtons([
          { name: "Rename", onClick: () => renamePlaylist(modal.selected, document.getElementById("input").value) },
          { name: "Cancel", onClick: () => Store.dispatch({ type: "disableModal" }) }
        ]);
        break;
      case "yt2mp3":
        setButtons([
          { name: "Download", onClick: () => YouTubeToMP3(document.getElementById("input").value) },
          { name: "Cancel",   onClick: () => Store.dispatch({ type: "disableModal" }) }
        ]);
        document.getElementById("input").focus();
        document.getElementById("input").placeholder = "Video ID (i.e. IYAjG0oAJPQ)";
        break;
      case "sc2mp3":
        setButtons([
          { name: "Download", onClick: () => SoundCloudToMP3(document.getElementById("input").value) },
          { name: "Cancel",   onClick: () => Store.dispatch({ type: "disableModal" }) }
        ]);
        document.getElementById("input").focus();
        document.getElementById("input").placeholder = "URL (i.e. https://soundcloud.com/artist/title)";
        break;
      default: break;
    }
  }, [modal]);

  const styles = {
    background: darkMode ? "#181818" : "#EDE6D6",
    border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
  };


  function mapButtons() {
    return buttons.map((button, index) =>
      <button
        key={index}
        className="dialogButton"
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
        onClick={button.onClick}
        style={{
          background: styles.background,
          border:     styles.border
        }}
      >{button.name}</button>
    );
  }

  function onKeyDown(event) {
    if(event.key === "Enter") {
      switch(modal.mode) {
        case "renamePlaylist":
          renamePlaylist(modal.selected, document.getElementById("input").value);
          break;
        case "yt2mp3":
          YouTubeToMP3(document.getElementById("input").value);
          break;
        case "sc2mp3":
          SoundCloudToMP3(document.getElementById("input").value);
          break;
        default:
          break;
      }
    }
  }

  if(modal.mode === "renamePlaylist" || modal.mode === "yt2mp3" || modal.mode === "sc2mp3") {
    return(
      <div className="dialog" id="inputDialog">
        <input
          id="input"
          type="text"
          placeholder=""
          onKeyDown={onKeyDown}
          style={{
            background: styles.background,
            border:     styles.border
          }}
        />
        <div className="dialogButtonFlexBox">
          { mapButtons() }
        </div>
      </div>
    );
  } else return null;
}

export default React.memo(InputDialog);
