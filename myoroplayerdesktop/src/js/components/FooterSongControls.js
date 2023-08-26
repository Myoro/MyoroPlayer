import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import { songSliderOnChange } from "../players/LocalPlayer.js";
import ShuffleDark from "../../img/ShuffleDark.svg";
import ShuffleLight from "../../img/ShuffleLight.svg";
import RepeatDark from "../../img/RepeatDark.svg";
import RepeatLight from "../../img/RepeatLight.svg";

function FooterSongControls({ controlButtons, hoverButton }) {
  const darkMode     = useSelector(state => state.darkMode);
  const sliderValues = useSelector(state => state.sliderValues);

  return(
    <section id="controls">
      <div id="musicSliderContainer">
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{sliderValues.song.valueStr}</p>
        <input
          className="slider"
          id="musicSlider"
          type="range"
          min="0"
          max={sliderValues.song.maxInt}
          value={sliderValues.song.valueInt}
          onChange={songSliderOnChange}
        />
        <p style={{ color: darkMode ? "#EDE6D6" : "#181818" }}>{sliderValues.song.maxStr}</p>
      </div>
      <div id="controlButtons">
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
  );
}

export default React.memo(FooterSongControls);
