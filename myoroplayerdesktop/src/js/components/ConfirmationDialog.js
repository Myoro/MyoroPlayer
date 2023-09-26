import React, { useState } from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import Store from "../ReduxStore.js";
import { hardDeletePlaylist } from "../Functions.js";

function ConfirmationDialog({ hoverButton }) {
  const darkMode                = useSelector(state => state.darkMode);
  const modal                   = useSelector(state => state.modal);
  const [ text, setText ]       = React.useState("Are you sure you want to do this?");
  const [ buttons, setButtons ] = useState([]);

  const styles = {
    background: darkMode ? "#181818" : "#EDE6D6",
    border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
  };

  React.useEffect(() => {
    switch(modal.mode) {
      case "deletePlaylist":
        setText("Are you sure you want to delete " + modal.selected.name);
        setButtons([
          { name: "Yes", onClick: hardDeletePlaylist },
          { name: "No",  onClick: () => Store.dispatch({ type: "disableModal" }) }
        ]);
        break;
      default: break;
    }
  }, [modal]);

  function mapButtons() {
    return buttons.map((button, index) =>
      <button
        key={index}
        className="dialogButton"
        style={{
          background: styles.background,
          border:     styles.border
        }}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
        onClick={button.onClick}
      >{button.name}</button>
    );
  }

  if(modal.mode === "deletePlaylist") {
    return(
      <div className="dialog" id="confirmationDialog">
        <p
          style={{
            background: styles.background,
            border:     styles.border
          }}
        >{text}</p>

        <div className="dialogButtonFlexBox">
          { mapButtons() }
        </div>
      </div>
    );
  } else return null;
}

export default React.memo(ConfirmationDialog);
