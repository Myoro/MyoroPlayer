import React, { useState } from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function FooterSongInformation() {
  const darkMode              = useSelector(state => state.darkMode);
  const currentSong           = useSelector(state => state.currentSong);
  const [ cover, setCover ]   = useState(darkMode ? LogoDark : LogoLight);
  const [ title, setTitle ]   = useState(null);
  const [ artist, setArtist ] = useState(null);

  React.useEffect(() => {
    if(currentSong === null) return;
    setCover(currentSong.cover ? currentSong.cover : (darkMode ? LogoDark : LogoLight));
    setTitle(currentSong.title);
    setArtist(currentSong.artist);
  // eslint-disable-next-line
  }, [currentSong]);

  return(
    <section id="footerSongInformation">
      {/* Album cover */}
      <img alt="albumCover" draggable={false} src={cover} />

      {/* Song title & artist */}
      <div>
        <div>
          <span style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{title}</span>
        </div>
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{artist}</p>
      </div>
    </section>
  );
}

export default React.memo(FooterSongInformation);
