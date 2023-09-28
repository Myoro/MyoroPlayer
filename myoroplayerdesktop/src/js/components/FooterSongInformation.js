import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";

import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function FooterSongInformation() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <section id="footerSongInformation">
      {/* Album cover */}
      <img alt="albumCover" draggable={false} src={darkMode ? LogoDark : LogoLight} />

      {/* Song title & artist */}
      <div>
        <div>
          <span style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>Song Name</span>
        </div>
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>Artist</p>
      </div>
    </section>
  );
}

export default React.memo(FooterSongInformation);
