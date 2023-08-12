import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";

function FooterControls() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <footer
      id="footerControls"
      style={{ borderTop: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
    >
    </footer>
  );
}

export default React.memo(FooterControls);
