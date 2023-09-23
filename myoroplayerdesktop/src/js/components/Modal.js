import React from "react";
import { useSelector } from "react-redux";
import "../../css/Modal.css";
import InputDialog from "./InputDialog.js";

function Modal() {
  const modal = useSelector(state => state.modal);

  if(modal.show) {
    return(
      <div id="modal">
        <InputDialog />
      </div>
    );
  } else return null;
}

export default React.memo(Modal);
