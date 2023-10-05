import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import Store from "../ReduxStore.js";

function TextDialog({ hoverButton }) {
  const darkMode          = useSelector(state => state.darkMode);
  const modal             = useSelector(state => state.modal);
  const [ text, setText ] = React.useState("");

  const styles = {
    background: darkMode ? "#181818" : "#EDE6D6",
    border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
  };

  React.useEffect(() => {
    if(modal.mode === "about")
      setText("MyoroPlayer is free & open source software with functionality to stream/download content from YouTube, SoundCloud, & of course your computer. Remember... MUSIC IS FREE!");
    else if(modal.mode === "donate")
      setText("If you are looking to donate, please visit my PayPal at <>\nI really appreciate it :)");
  }, [modal]);

  if(modal.mode === "about" || modal.mode === "donate") {
    return(
      <div
        className="dialog"
        id="textDialog"
        style={{ background: styles.background, border: styles.border }}
      >
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{text}</p>
        <button
          className="dialogButton"
          style={{ background: styles.background, border: styles.border, width: "80px" }}
          onMouseOver={hoverButton}
          onMouseOut={hoverButton}
          onClick={() => Store.dispatch({ type: "disableModal" })}
        >Close</button>
      </div>
    );
  } else return null;
}

export default React.memo(TextDialog);
