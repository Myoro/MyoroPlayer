import React from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import Store from "../ReduxStore.js";
import { previousSong, togglePlay, setSongPosition } from "../players/LocalPlayer.js";
import { getShuffleRepeatValues, setShuffleRepeat as setShuffleRepeatDb } from "../Functions.js";
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
  const currentSong              = useSelector(state => state.currentSong);
  const songSlider               = useSelector(state => state.songSlider);
  const databaseInitialized      = useSelector(state => state.databaseInitialized);
  const [ buttons, setButtons ]  = React.useState([
    {
      src:     darkMode ? ShuffleDark : ShuffleLight,
      alt:     "shuffle",
      value:   0,
      onClick: (event) => setShuffleRepeat(event, "shuffle")
    },
    {
      src:     darkMode ? PreviousDark : PreviousLight,
      alt:     "previous",
      onClick: previousSong
    },
    {
      src:     darkMode ? PlayDark : PlayLight,
      alt:     "play",
      onClick: playOnClick
    },
    {
      src: darkMode ? NextDark : NextLight,
      alt: "next"
    },
    {
      src:     darkMode ? RepeatDark : RepeatLight,
      alt:     "repeat",
      value:   0,
      onClick: (event) => setShuffleRepeat(event, "repeat")
    }
  ]);

  React.useEffect(() => {
    if(databaseInitialized === false) return;

    getShuffleRepeatValues().then(values => {
      setButtons(previousButtons => {
        const result = [ ...previousButtons ];

        result[0].value = values.shuffle;
        if(values.shuffle === 0) result[0].src = darkMode ? ShuffleDark : ShuffleLight;
        else                     result[0].src = darkMode ? ShuffleLight : ShuffleDark;

        result[4].value = values.repeat;
        if(values.repeat === 0)  result[4].src = darkMode ? RepeatDark : RepeatLight;
        else                     result[4].src = darkMode ? RepeatLight : RepeatDark;

        return result;
      });

      // Setting background colour
      const buttons = document.getElementById("footerSongControls").childNodes[1].childNodes;
      if(values.shuffle === 1) buttons[0].style.background = darkMode ? "#EDE6D6" : "#181818";
      if(values.repeat === 1)   buttons[4].style.background = darkMode ? "#EDE6D6" : "#181818";
    });
  // eslint-disable-next-line
  }, [databaseInitialized]);

  React.useEffect(() => {
    // Initial start of the program
    if(currentSong === null) return;

    setButtons(previousButtons => {
      const result  = [ ...previousButtons ];
      result[2].src = darkMode ? PauseDark : PauseLight;
      return result;
    });

    Store.dispatch({ type: "setSongSliderValue", payload: 0 });
    Store.dispatch({ type: "setSongSliderMax", payload: currentSong.lengthInt });
  // eslint-disable-next-line
  }, [currentSong]);

  function setShuffleRepeat(event, mode) {
    setButtons(previousButtons => {
      const result = [ ...previousButtons ];

      if(mode === "shuffle") {
        result[0].value = (result[0].value === 0) ? 1 : 0;
        setShuffleRepeatDb("shuffle", result[0].value);
      } else if(mode === "repeat") {
        result[4].value = (result[4].value === 0) ? 1 : 0;
        setShuffleRepeatDb("repeat", result[4].value);
      }

      return result;
    });
  }

  function playOnClick() {
    const result = togglePlay();
    if(result === null) return;

    setButtons(previousButtons => {
      const newButtons = [ ...previousButtons ];
      if(result === "playing") newButtons[2].src = darkMode ? PauseLight : PauseDark;
      else                     newButtons[2].src = darkMode ? PlayLight : PlayDark;
      return newButtons;
    });
  }

  function hoverButton(event) {
    let hovered = false;
    if(window.getComputedStyle(event.target).backgroundColor !== "rgba(0, 0, 0, 0)")
      hovered = true;


    if(event.target.alt !== "shuffle" && event.target.alt !== "repeat")
      event.target.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    else if((event.target.alt === "shuffle" && buttons[0].value === 0) || (event.target.alt === "repeat" && buttons[4].value === 0))
      event.target.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";

    setButtons(previousButtons => {
      const result = [ ...previousButtons ];

      switch(event.target.alt) {
        case "shuffle":
          if(result[0].value === 0)
            result[0].src = !hovered ? (darkMode ? ShuffleLight : ShuffleDark) : (darkMode ? ShuffleDark : ShuffleLight);
          break;
        case "previous":
          result[1].src = !hovered ? (darkMode ? PreviousLight : PreviousDark) : (darkMode ? PreviousDark : PreviousLight);
          break;
        case "play":
          if(result[2].src.includes("Play"))
            result[2].src = !hovered ? (darkMode ? PlayLight : PlayDark) : (darkMode ? PlayDark : PlayLight);
          else
            result[2].src = !hovered ? (darkMode ? PauseLight : PauseDark) : (darkMode ? PauseDark : PauseLight);
          break;
        case "next":
          result[3].src = !hovered ? (darkMode ? NextLight : NextDark) : (darkMode ? NextDark : NextLight);
          break;
        case "repeat":
          if(result[4].value === 0)
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
        onClick={button.onClick}
        style={{
          width:      (button.alt === "shuffle" || button.alt === "repeat") ? "20px" : "30px",
          height:     (button.alt === "shuffle" || button.alt === "repeat") ? "20px" : "30px"
        }}
      />
    );
  }

  return(
    <section id="footerSongControls">
      {/* Song Position Slider */}
      <input
        className="slider"
        type="range"
        min={0}
        max={songSlider.max}
        value={songSlider.value}
        onChange={setSongPosition}
      />

      <div>{mapButtons()}</div>
    </section>
  );
}

export default React.memo(FooterSongControls);
