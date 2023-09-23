import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import Store from "../ReduxStore.js";
import { renamePlaylist } from "../Functions.js";

function InputDialog() {
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
      default: break;
    }
  }, [modal]);

  const styles = {
    background: darkMode ? "#181818" : "#EDE6D6",
    border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
  };

  function hoverButton(event) {
    if(window.getComputedStyle(event.target).backgroundColor === (darkMode ? "rgb(24, 24, 24)" : "rgb(237, 230, 214)")) {
      event.target.style.background = darkMode ? "#EDE6D6" : "#181818";
      event.target.style.color      = darkMode ? "#181818" : "#EDE6D6";
    } else {
      event.target.style.background = darkMode ? "#181818" : "#EDE6D6";
      event.target.style.color      = darkMode ? "#EDE6D6" : "#181818";
    }
  }

  function mapButtons() {
    return buttons.map((button, index) =>
      <button
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
    if(modal.mode === "renamePlaylist" && event.key === "Enter")
      renamePlaylist(modal.selected, document.getElementById("input").value);
  }

  if(modal.mode === "renamePlaylist") {
    return(
      <div id="inputDialog">
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
        <div>
          { mapButtons() }
        </div>
      </div>
    );
  } else return null;
}

export default React.memo(InputDialog);
