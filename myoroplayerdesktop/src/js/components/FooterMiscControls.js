import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import Store from "../ReduxStore.js";
import { setVolume, getQueue, playQueuedSong } from "../players/LocalPlayer.js";
import { hoverButton as basicHover } from "../Functions.js";
import QueueDark from "../../img/QueueDark.svg";
import QueueLight from "../../img/QueueLight.svg";
import YouTubePlayerDark from "../../img/YouTubePlayerDark.png";
import YouTubePlayerLight from "../../img/YouTubePlayerLight.png";
import SoundCloudPlayerDark from "../../img/SoundCloudPlayerDark.png";
import SoundCloudPlayerLight from "../../img/SoundCloudPlayerLight.png";

function FooterMiscControls() {
  const darkMode                = useSelector(state => state.darkMode);
  const volumeSlider            = useSelector(state => state.volumeSlider);
  const queueList               = useSelector(state => state.queueList);
  const [ buttons, setButtons ] = React.useState([
    {
      src:     darkMode ? QueueDark : QueueLight,
      alt:     "queue",
      onClick: toggleQueueList
    },
    {
      src: darkMode ? YouTubePlayerDark : YouTubePlayerLight,
      alt: "listeningMode"
    }
  ]);

  const styles = { border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" };

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

  function toggleQueueList() {
    const queue = getQueue();
    if(Store.getState().queueList.show === true) Store.dispatch({ type: "disableQueueList" });
    else if(queue.length > 0)                    Store.dispatch({ type: "enableQueueList", payload: queue });
  }

  function mapButtons() {
    return buttons.map((button, index) => {
      if(button.alt === "queue") {
        return(
          <div>
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
              key={index}
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
