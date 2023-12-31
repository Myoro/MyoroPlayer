import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import Store from "../ReduxStore.js";
import { setVolume, getQueue, playQueuedSong } from "../players/LocalPlayer.js";
import { hoverButton as basicHover } from "../Functions.js";
import QueueDark from "../../img/QueueDark.svg";
import QueueLight from "../../img/QueueLight.svg";
import LocalPlayerDark from "../../img/LocalPlayerDark.png";
import LocalPlayerLight from "../../img/LocalPlayerLight.png";
import YouTubePlayerDark from "../../img/YouTubePlayerDark.png";
import YouTubePlayerLight from "../../img/YouTubePlayerLight.png";
import SoundCloudPlayerDark from "../../img/SoundCloudPlayerDark.png";
import SoundCloudPlayerLight from "../../img/SoundCloudPlayerLight.png";

function FooterMiscControls() {
  const darkMode                = useSelector(state => state.darkMode);
  const volumeSlider            = useSelector(state => state.volumeSlider);
  const queueList               = useSelector(state => state.queueList);
  const listeningMode           = useSelector(state => state.listeningMode);
  const [ buttons, setButtons ] = React.useState([]);

  const styles = { border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" };

  React.useEffect(() => {
    setButtons([
      {
        src:     darkMode ? QueueDark : QueueLight,
        alt:     "queue",
        onClick: toggleQueueList
      },
      {
        src: darkMode ? LocalPlayerDark : LocalPlayerLight,
        alt: "listeningMode"
      }
    ]);
  }, [darkMode]);

  React.useEffect(() => {
    setButtons(previousButtons => {
      const result = [ ...previousButtons ];
      let   src;

      switch(listeningMode) {
        case "local":      src = darkMode ? LocalPlayerDark : LocalPlayerLight;           break;
        case "youtube":    src = darkMode ? YouTubePlayerDark : YouTubePlayerLight;       break;
        case "soundcloud": src = darkMode ? SoundCloudPlayerDark : SoundCloudPlayerLight; break;
        default:                                                                          break;
      }
      result[1].src = src;

      return result;
    });
    // eslint-disable-next-line
  }, [listeningMode]);

  function hoverButton(event) {
    let hovered = false;
    if(window.getComputedStyle(event.target).backgroundColor !== "rgba(0, 0, 0, 0)")
      hovered = true;

    event.target.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";

    setButtons(previousButtons => {
      const result = [ ...previousButtons ];

      if(event.target.alt === "queue") {
        result[0].src = !hovered ? (darkMode ? QueueLight : QueueDark) : (darkMode ? QueueDark : QueueLight);
      } else {
        let src;
        switch(listeningMode) {
          case "local":
            src = !hovered ? (darkMode ? LocalPlayerLight : LocalPlayerDark) : (darkMode ? LocalPlayerDark : LocalPlayerLight);
            break;
          case "youtube":
            src = !hovered ? (darkMode ? YouTubePlayerLight : YouTubePlayerDark) : (darkMode ? YouTubePlayerDark : YouTubePlayerLight);
            break;
          case "soundcloud":
            src = !hovered ? (darkMode ? SoundCloudPlayerLight : SoundCloudPlayerDark) : (darkMode ? SoundCloudPlayerDark : SoundCloudPlayerLight);
            break;
          default: break;
        }
        result[1].src = src;
      }

      return result;
    });
  }

  function toggleQueueList() {
    const queue = getQueue();
    if(Store.getState().queueList.show === true) Store.dispatch({ type: "disableQueueList" });
    else if(queue.length > 0)                    Store.dispatch({ type: "enableQueueList", payload: queue });
  }

  function mapButtons() {
    return buttons.map((button, index) => {
      if(button.alt === "queue") {
        return(
          <div key={index}>
            {
              queueList.show
              &&
              <ul
                style={{
                  background:  darkMode ? "#181818" : "#EDE6D6",
                  borderTop:   styles.border,
                  borderLeft:  styles.border,
                  borderRight: styles.border
                }}
              >
                {
                  queueList.queue.map((song, index) =>
                    <li
                      key={index}
                      style={{ borderBottom: styles.border }}
                      onMouseOver={basicHover}
                      onMouseOut={basicHover}
                      onClick={() => playQueuedSong(index)}
                    >{song.title}</li>
                  )
                }
              </ul>
            }
            <img
              id="queueList"
              draggable={false}
              alt={button.alt}
              src={button.src}
              onMouseOver={hoverButton}
              onMouseOut={hoverButton}
              onClick={button.onClick}
            />
          </div>
        );
      } else {
        return(
          <img
            key={index}
            draggable={false}
            alt={button.alt}
            src={button.src}
            onMouseOver={hoverButton}
            onMouseOut={hoverButton}
            onClick={button.onClick}
          />
        );
      }
    });
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
