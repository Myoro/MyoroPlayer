import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import InputDialog from "./InputDialog.js";
import ConfirmationDialog from "./ConfirmationDialog.js";

function Modal() {
  const darkMode = useSelector(state => state.darkMode);
  const modal    = useSelector(state => state.modal);

  function hoverButton(event) {
    if(window.getComputedStyle(event.target).backgroundColor === (darkMode ? "rgb(24, 24, 24)" : "rgb(237, 230, 214)")) {
      event.target.style.background = darkMode ? "#EDE6D6" : "#181818";
      event.target.style.color      = darkMode ? "#181818" : "#EDE6D6";
    } else {
      event.target.style.background = darkMode ? "#181818" : "#EDE6D6";
      event.target.style.color      = darkMode ? "#EDE6D6" : "#181818";
    }
  }

  if(modal.show) {
    return(
      <div id="modal">
        <InputDialog hoverButton={hoverButton} />
        <ConfirmationDialog hoverButton={hoverButton} />
      </div>
    );
  } else return null;
}

export default React.memo(Modal);
