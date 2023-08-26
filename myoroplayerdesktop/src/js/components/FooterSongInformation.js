import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";

function FooterSongInformation({ coverSrc, songName, artist }) {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <section id="songInformation"> {/* 220px */}
      <img draggable={false} alt="cover" src={coverSrc} />
      <div>
        {/* eslint-disable-next-line */}
        <marquee
          id="footerSongName"
          behavior="scroll"
          diration="left"
          style={{ color: darkMode ? "#EDE6D6" : "#181818" }}
        >{songName}</marquee>
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{artist}</p>
      </div>
    </section>
  );
}

export default React.memo(FooterSongInformation);
