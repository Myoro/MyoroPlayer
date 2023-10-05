import React, { useState } from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function FooterSongInformation() {
  const darkMode              = useSelector(state => state.darkMode);
  const currentSong           = useSelector(state => state.currentSong);
  const listeningMode         = useSelector(state => state.listeningMode);
  const [ cover, setCover ]   = useState(null);
  const [ title, setTitle ]   = useState(null);
  const [ artist, setArtist ] = useState(null);

  React.useEffect(() => {
    if(currentSong === null) return;

    let cover, artist;

    switch(listeningMode) {
      case "local":
        cover  = currentSong.cover;
        artist = currentSong.artist;
        break;
      case "youtube":
        cover  = currentSong.pfp;
        artist = currentSong.channel;
        break;
      case "soundcloud":
        cover  = currentSong.cover;
        artist = currentSong.artist;
        break;
      default: break;
    }

    setCover(cover ? cover : (darkMode ? LogoDark : LogoLight));
    setTitle(currentSong.title);
    setArtist(artist);
  // eslint-disable-next-line
  }, [currentSong]);

  React.useEffect(() => setCover(darkMode ? LogoDark : LogoLight), [darkMode]);

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
