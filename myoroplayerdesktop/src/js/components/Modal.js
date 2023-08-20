import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import { hoverButton } from "../Functions.js";

function Modal() {
  const darkMode = useSelector(state => state.darkMode);
  const modal    = useSelector(state => state.modal);

  const styles = {
    container: {
      background: darkMode ? "#181818" : "#EDE6D6",
      border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
    },
    object: {
      color:  darkMode ? "#EDE6D6" : "#181818",
      border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
    }
  };

  function onKeyDown(event) {
    if(event.key === "Enter")
      modal.buttons[0].onClick();
  }

  function mapDialogButtons() {
    return modal.buttons.map((button, index) =>
      <button
        key={index}
        className="dialogButton"
        style={styles.object}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
        onClick={button.onClick}
      >{button.name}</button>
    )
  }

  function mapDialog() {
    if(modal.dialog === "rename") {
      return(
        <section
          id="renameDialog"
          style={styles.container}
        >
          <input
            id="renameDialogInput"
            type="text"
            placeholder=""
            style={styles.object}
            autoFocus
            onKeyDown={onKeyDown}
          />
          <div>{mapDialogButtons()}</div>
        </section>
      );
    } else if(modal.dialog === "delete") {
      let playlistName;
      for(let i = (modal.directory.length - 2); i >= 0; i--) {
        if(modal.directory[i] === '/') {
          playlistName = modal.directory.substr(i + 1);
          playlistName = playlistName.substr(0, playlistName.length - 1);
          break;
        }
      }

      return(
        <section
          id="deleteDialog"
          style={styles.container}
        >
          <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>Delete {playlistName}?</p>
          <div>{mapDialogButtons()}</div>
        </section>
      );
    }
  }

  if(modal.show) {
    return(
      <div id="modal">
        { mapDialog() }
      </div>
    );
  } else return null;
}

export default React.memo(Modal);
