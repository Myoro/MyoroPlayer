import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
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

function FooterSongControls() {
  const darkMode                 = useSelector(state => state.darkMode);
  const [ buttons, setButtons ]  = React.useState([
    {
      src: darkMode ? ShuffleDark : ShuffleLight,
      alt: "shuffle"
    },
    {
      src: darkMode ? PreviousDark : PreviousLight,
      alt: "previous"
    },
    {
      src: darkMode ? PlayDark : PlayLight,
      alt: "play"
    },
    {
      src: darkMode ? NextDark : NextLight,
      alt: "next"
    },
    {
      src: darkMode ? RepeatDark : RepeatLight,
      alt: "repeat"
    }
  ]);

  function hoverButton(event) {
    let hovered = false;
    if(window.getComputedStyle(event.target).backgroundColor !== "rgba(0, 0, 0, 0)")
      hovered = true;

    event.target.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";

    setButtons(previousButtons => {
      const result = [ ...previousButtons ];

      switch(event.target.alt) {
        case "shuffle":
          result[0].src = !hovered ? (darkMode ? ShuffleLight : ShuffleDark) : (darkMode ? ShuffleDark : ShuffleLight);
          break;
        case "previous":
          result[1].src = !hovered ? (darkMode ? PreviousLight : PreviousDark) : (darkMode ? PreviousDark : PreviousLight);
          break;
        case "play":
          result[2].src = !hovered ? (darkMode ? PlayLight : PlayDark) : (darkMode ? PlayDark : PlayLight);
          break;
        case "next":
          result[3].src = !hovered ? (darkMode ? NextLight : NextDark) : (darkMode ? NextDark : NextLight);
          break;
        case "repeat":
          result[4].src = !hovered ? (darkMode ? RepeatLight : RepeatDark) : (darkMode ? RepeatDark : RepeatLight);
          break;
        default: break;
      }

      return result;
    });
  }

  function mapButtons() {
    return buttons.map((button, index) =>
      <img
        key={index}
        draggable={false}
        src={button.src}
        alt={button.alt}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
        style={{
          width:  (button.alt === "shuffle" || button.alt === "repeat") ? "20px" : "30px",
          height: (button.alt === "shuffle" || button.alt === "repeat") ? "20px" : "30px"
        }}
      />
    );
  }

  return(
    <section id="footerSongControls">
      {/* Song Position Slider */}
      <input className="slider" type="range" min={0} max={100} value={50} />

      <div>{mapButtons()}</div>
    </section>
  );
}

export default React.memo(FooterSongControls);
