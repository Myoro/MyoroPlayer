import React, { useState } from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import {
  setShuffleRepeat as setShuffleRepeatDb,
  getShuffleRepeat as getShuffleRepeatDb
} from "../Functions.js";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";
import ShuffleDark from "../../img/ShuffleDark.svg";
import ShuffleLight from "../../img/ShuffleLight.svg";
import PreviousDark from "../../img/PreviousDark.svg";
import PreviousLight from "../../img/PreviousLight.svg";
import PlayDark from "../../img/PlayDark.svg";
import PlayLight from "../../img/PlayLight.svg";
import PauseDark from "../../img/PauseDark.svg";
import PauseLight from "../../img/PauseLight.svg";
import NextDark from "../../img/NextDark.svg";
import NextLight from "../../img/NextLight.svg";
import RepeatDark from "../../img/RepeatDark.svg";
import RepeatLight from "../../img/RepeatLight.svg";
import LocalPlayerDark from "../../img/LocalPlayerDark.svg";
import LocalPlayerLight from "../../img/LocalPlayerLight.svg";
import QueueDark from "../../img/QueueDark.svg";
import QueueLight from "../../img/QueueLight.svg";

function FooterControls() {
  const darkMode                              = useSelector(state => state.darkMode);
  const databaseInitialized                   = useSelector(state => state.databaseInitialized);
  const [ coverSrc, setCoverSrc ]             = useState(darkMode ? LogoDark : LogoLight);
  const [ controlButtons, setControlButtons ] = useState([
    {
      alt:     "shuffle",
      src:     darkMode ? ShuffleDark : ShuffleLight,
      onClick: setShuffleRepeat,
      value:   0
    },
    {
      alt:     "previous",
      src:     darkMode ? PreviousDark : PreviousLight,
      onClick: () => alert("Previous")
    },
    {
      alt:     "play",
      src:     darkMode ? PlayDark : PlayLight,
      onClick: () => alert("Play/pause")
    },
    {
      alt:     "next",
      src:     darkMode ? NextDark : NextLight,
      onClick: () => alert("Next")
    },
    {
      alt:     "repeat",
      src:     darkMode ? RepeatDark : RepeatLight,
      onClick: setShuffleRepeat,
      value:   0
    },
    {
      alt:     "player",
      src:     darkMode ? LocalPlayerDark : LocalPlayerLight,
      onClick: () => alert("Change music player")
    },
    {
      alt:     "queue",
      src:     darkMode ? QueueDark : QueueLight,
      onClick: () => alert("View queue")
    }
  ]);
  const [ sliderValues, setSliderValues ]   = useState({
    music: {
      max:   "100",
      value: "50"
    },
    volume: {
      value: "50"
    }
  });

  // Grabbing shuffle & repeat values from db
  React.useEffect(() => {
    if(!databaseInitialized) return;

    (async function getShuffleRepeat() {
      const values = await getShuffleRepeatDb();
      setControlButtons(previous => {
        const result = [ ...previous ];
        result[0].value = values.shuffle;
        result[4].value = values.repeat;
        return result;
      });
    })();
  }, [databaseInitialized]);

  function setShuffleRepeat(event) {
    let button = event.target;
    if(button.tagName === "IMG") button = button.parentNode;

    if(button.childNodes[0].alt === "shuffle") {
      let value, src;
      // eslint-disable-next-line
      if(controlButtons[0].value == 0) {
        value = 1;
        src   = darkMode ? ShuffleLight : ShuffleDark;
      } else {
        value = 0;
        src   = darkMode ? ShuffleDark : ShuffleLight;
      }
      setControlButtons(previous => {
        const result = [ ...previous ];
        result[0].src   = src;
        result[0].value = value;
        return result;
      });
      setShuffleRepeatDb("shuffle", value);
    } else {
      let value, src;
      // eslint-disable-next-line
      if(controlButtons[4].value == 0) value = 1;
      else                             value = 0;
      setControlButtons(previous => {
        const result = [ ...previous ];
        result[4].value = value;
        return result;
      });
      setShuffleRepeatDb("repeat", value);
    }
  }

  function hoverButton(event, index) {
    let button = event.target;
    if(button.tagName !== "BUTTON") button = button.parentNode;

    let alt = button.childNodes[0].alt;
    // eslint-disable-next-line
    if(alt === "shuffle" || alt === "repeat") {
      if(window.getComputedStyle(button).border.includes("none"))
        button.style.border = darkMode ? "2px solid #EDE6D6" : "2px solid #181818";
      else
        button.style.border = "none";
      return;
    }

    let hovered;
    if(window.getComputedStyle(button).backgroundColor === "rgba(0, 0, 0, 0)") {
      hovered                 = false;
      button.style.background = darkMode ? "#EDE6D6" : "#181818";
    } else {
      hovered                 = true;
      button.style.background = "none";
    }

    setControlButtons(previous => {
      const result = [ ...previous ];

      switch(index) {
        case 0:
          result[index].src = !hovered ? (darkMode ? ShuffleLight : ShuffleDark) : (darkMode ? ShuffleDark : ShuffleLight);
          break;
        case 1:
          result[index].src = !hovered ? (darkMode ? PreviousLight : PreviousDark) : (darkMode ? PreviousDark : PreviousLight);
          break;
        case 2:
          result[index].src = !hovered ? (darkMode ? PlayLight : PlayDark) : (darkMode ? PlayDark : PlayLight);
          break;
        case 3:
          result[index].src = !hovered ? (darkMode ? NextLight : NextDark) : (darkMode ? NextDark : NextLight);
          break;
        case 4:
          result[index].src = !hovered ? (darkMode ? RepeatLight : RepeatDark) : (darkMode ? RepeatDark : RepeatLight);
          break;
        case 5:
          result[index].src = !hovered ? (darkMode ? LocalPlayerLight : LocalPlayerDark) : (darkMode ? LocalPlayerDark : LocalPlayerLight);
          break;
        case 6:
          result[index].src = !hovered ? (darkMode ? QueueLight : QueueDark) : (darkMode ? QueueDark : QueueLight);
          break;
        default:
          break;
      }

      return result;
    });
  }

  return(
    <footer
      id="footerControls"
      style={{ borderTop: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" }}
    >
      <section id="songInformation"> {/* 220px */}
        <img draggable={false} alt="cover" src={coverSrc} />
        <div>
          {/* eslint-disable-next-line */}
          <marquee
            behavior="scroll"
            diration="left"
            style={{ color: darkMode ? "#EDE6D6" : "#181818" }}
          >Song Name</marquee>
          <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>Artists Name Here qweqweqeqweqwe</p>
        </div>
      </section>

      <section id="controls">
        <input
          className="slider"
          id="musicSlider"
          type="range"
          min="0"
          max={sliderValues.music.max}
          value={sliderValues.music.value}
        />
        <div>
          {
            controlButtons.map((button, index) => {
              if(index > 4) return null;
              else {
                // For shuffle/repeat buttons
                let hover;
                let src = null;
                if(!button.value) {
                  hover = null;
                // eslint-disable-next-line
                } else if(button.value == 1) {
                  hover = true;
                  if(index === 0)      src = darkMode ? ShuffleLight : ShuffleDark;
                  else if(index === 4) src = darkMode ? RepeatLight : RepeatDark;
                } else hover = false;

                return(
                  <button
                    key={index}
                    onMouseOver={(event) => hoverButton(event, index)}
                    onMouseOut={(event) => hoverButton(event, index)}
                    onClick={button.onClick}
                    style={{ background: hover ? (darkMode ? "#EDE6D6" : "#181818") : "none" }}
                  >
                    <img
                      draggable={false}
                      alt={button.alt}
                      src={src || button.src}
                    />
                  </button>
                );
              }
            })
          }
        </div>
      </section>

      <section id="miscControls"> {/* 220px */}
        <div>
          {
            controlButtons.map((button, index) => {
              if(index < 5) return null;
              else return(
                <button
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
            })
          }
        </div>

        <input
          className="slider"
          id="volumeSlider"
          type="range"
          min="0"
          max="100"
          value={sliderValues.volume.value}
        />
      </section>
    </footer>
  );
}

export default React.memo(FooterControls);
