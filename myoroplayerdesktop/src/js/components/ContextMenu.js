import React from "react";
import { useSelector } from "react-redux";
import "../../css/ContextMenu.css";
import { hoverButton } from "../Functions.js";

function ContextMenu() {
  const darkMode    = useSelector(state => state.darkMode);
  const contextMenu = useSelector(state => state.contextMenu);

  if(contextMenu.show) {
    return(
      <ul
        id="contextMenu"
        style={{
          background:  darkMode ? "#181818" : "#EDE6D6",
          borderTop:   darkMode ? "2px solid #EDE6D6" : "2px solid #181818",
          borderLeft:  darkMode ? "2px solid #EDE6D6" : "2px solid #181818",
          borderRight: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
        }}
      >
        {
          contextMenu.buttons.map((button, index) =>
            <button
              key={index}
              style={{
                color: darkMode ? "#EDE6D6" : "#181818",
                borderBottom: darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
              }}
              onMouseOver={hoverButton}
              onMouseOut={hoverButton}
              onClick={button.onClick}
            >{button.name}</button>
          )
        }
      </ul>
    );
  } else return null;
}

export default React.memo(ContextMenu);
