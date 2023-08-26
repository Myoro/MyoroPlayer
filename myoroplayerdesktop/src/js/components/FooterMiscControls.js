import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import { volumeSliderOnChange } from "../players/LocalPlayer.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function FooterMiscControls({ controlButtons, hoverButton }) {
  const darkMode  = useSelector(state => state.darkMode);
  const queueList = useSelector(state => state.queueList);

  function hoverQueueButton(event) {
    let button = event.target;
    while(button.tagName !== "BUTTON") button = button.parentNode;

    let hovered = true;
    if(window.getComputedStyle(button).backgroundColor === "rgba(0, 0, 0, 0)")
      hovered = false;

    button.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    if(button.childNodes[0].src.includes("LogoDark") || button.childNodes[0].src.includes("LogoLight"))
      button.childNodes[0].src = !hovered ? (darkMode ? LogoLight : LogoDark) : (darkMode ? LogoDark : LogoLight);
    for(let i = 0; i < button.childNodes[1].childNodes.length; i++)
      button.childNodes[1].childNodes[i].style.color = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
  }

  return(
    <section id="miscControls"> {/* 220px */}

      <div>
        {
          controlButtons.map((button, index) => {
            if(index < 5) return null;
            else if(index === 5) return(
              <button
                className="miscControlButton"
                key={index}
                onMouseOver={(event) => hoverButton(event, index)}
                onMouseOut={(event) => hoverButton(event, index)}
                onClick={button.onClick}
              >
                <img
                  draggable={false}
                  alt={button.alt}
                  src={button.src}
                />
              </button>
            );
            else return(
              <div
                id="queueButtonWrapper"
                key={index}
              >
                {/* Queue list */}
                <ul
                  id="queueList"
                  style={{
                    background: darkMode ? "#181818" : "#EDE6D6",
                    border:     darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
                  }}
                >
                  {
                    queueList.map((song, index) =>
                      <button
                        key={index}
                        onMouseOver={hoverQueueButton}
                        onMouseOut={hoverQueueButton}
                      >
                        <img
                          alt="cover"
                          src={song.cover || (darkMode ? LogoDark : LogoLight)}
                        />
                        <div>
                          <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.name}</p>
                          <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{song.artist}</p>
                        </div>
                      </button>
                    )
                  }
                </ul>

                <button
                  className="miscControlButton"
                  onMouseOver={(event) => hoverButton(event, index)}
                  onMouseOut={(event) => hoverButton(event, index)}
                  onClick={button.onClick}
                >
                  <img
                    draggable={false}
                    alt={button.alt}
                    src={button.src}
                  />
                </button>
              </div>
            );
          })
        }
      </div>

      <input
        className="slider"
        id="volumeSlider"
        type="range"
        min="0"
        max="100"
        value={queueList.volume}
        onChange={volumeSliderOnChange}
      />
    </section>
  );
}

export default React.memo(FooterMiscControls);
