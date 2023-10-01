import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import { setVolume } from "../players/LocalPlayer.js";
import QueueDark from "../../img/QueueDark.svg";
import QueueLight from "../../img/QueueLight.svg";
import YouTubePlayerDark from "../../img/YouTubePlayerDark.png";
import YouTubePlayerLight from "../../img/YouTubePlayerLight.png";
import SoundCloudPlayerDark from "../../img/SoundCloudPlayerDark.png";
import SoundCloudPlayerLight from "../../img/SoundCloudPlayerLight.png";

function FooterMiscControls() {
  const darkMode                = useSelector(state => state.darkMode);
  const volumeSlider            = useSelector(state => state.volumeSlider);
  const [ buttons, setButtons ] = React.useState([
    {
      src: darkMode ? QueueDark : QueueLight,
      alt: "queue"
    },
    {
      src: darkMode ? YouTubePlayerDark : YouTubePlayerLight,
      alt: "listeningMode"
    }
  ]);

  function hoverButton(event) {
    let hovered = false;
    if(window.getComputedStyle(event.target).backgroundColor !== "rgba(0, 0, 0, 0)")
      hovered = true;

    event.target.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";

    setButtons(previousButtons => {
      const result = [ ...previousButtons ];

      if(event.target.alt === "queue")
        result[0].src = !hovered ? (darkMode ? QueueLight : QueueDark) : (darkMode ? QueueDark : QueueLight);
      else
        result[1].src = !hovered ? (darkMode ? YouTubePlayerLight : YouTubePlayerDark) : (darkMode ? YouTubePlayerDark : YouTubePlayerLight);

      return result;
    });
  }

  function mapButtons() {
    return buttons.map((button, index) =>
      <img
        key={index}
        draggable={false}
        alt={button.alt}
        src={button.src}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
      />
    );
  }

  return(
    <section id="footerMiscControls">
      <div>{mapButtons()}</div>
      <input
        className="slider"
        type="range"
        min={0}
        max={100}
        value={volumeSlider}
        onChange={setVolume}
      />
    </section>
  );
}

export default React.memo(FooterMiscControls);
