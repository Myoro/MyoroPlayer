import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import FooterSongInformation from "./FooterSongInformation.js";
import FooterSongControls from "./FooterSongControls.js";
import FooterMiscControls from "./FooterMiscControls.js";

function FooterControls() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <footer
      id="footerControls"
      style={{ borderTop: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
    >
      <FooterSongInformation />
      <FooterSongControls />
      <div id="spacer"></div> {/* For when window width too small */}
      <FooterMiscControls />
    </footer>
  );
}

export default React.memo(FooterControls);
