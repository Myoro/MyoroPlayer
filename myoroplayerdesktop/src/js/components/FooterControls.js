import React, { useState } from "react";
import { useSelector } from "react-redux";
import "../../css/FooterControls.css";
import Store from "../Store.js";
import {
  setShuffleRepeat as setShuffleRepeatDb,
  getShuffleRepeat as getShuffleRepeatDb,
} from "../Functions.js";
import {
  togglePlay,
  previousPlay,
  nextPlay,
  toggleQueueList
} from "../players/LocalPlayer.js";
import FooterSongInformation from "./FooterSongInformation.js";
import FooterSongControls from "./FooterSongControls.js";
import FooterMiscControls from "./FooterMiscControls.js";
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
  const darkMode                                    = useSelector(state => state.darkMode);
  const databaseInitialized                         = useSelector(state => state.databaseInitialized);
  const currentSong                                 = useSelector(state => state.currentSong);
  const [ coverSrc, setCoverSrc ]                   = useState(darkMode ? LogoDark : LogoLight);
  const [ songName, setSongName ]                   = useState("");
  const [ artist, setArtist ]                       = useState("");
  const [ controlButtons, setControlButtons ]       = useState([
    {
      alt:     "shuffle",
      src:     darkMode ? ShuffleDark : ShuffleLight,
      onClick: setShuffleRepeat,
      value:   0
    },
    {
      alt:     "previous",
      src:     darkMode ? PreviousDark : PreviousLight,
      onClick: previousPlay
    },
    {
      alt:     "play",
      src:     darkMode ? PlayDark : PlayLight,
      onClick: playOnClick
    },
    {
      alt:     "next",
      src:     darkMode ? NextDark : NextLight,
      onClick: nextPlay
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
      onClick: toggleQueueList
    }
  ]);

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

  React.useEffect(() => {
    if(currentSong === null) return;

    setCoverSrc(currentSong.cover || (darkMode ? LogoDark : LogoLight));
    setSongName(currentSong.name);
    setArtist(currentSong.artist);
    Store.dispatch({
      type: "setSongSliderValues",
      payload: {
        valueStr: "0:00",
        valueInt: 0,
        maxStr:   currentSong.lengthStr,
        maxInt:   currentSong.lengthInt
      }
    });

    setControlButtons(previous => {
      const result  = [ ...previous ];
      result[2].src = darkMode ? PauseDark : PauseLight;
      return result;
    });
  }, [currentSong, darkMode]);

  function playOnClick() {
    const state = togglePlay();
    if(state === null)
      return;

    setControlButtons(previous => {
      const result  = [ ...previous ];

      if(state === "playing")
        result[2].src = darkMode ? PauseLight : PauseDark;
      else
        result[2].src = darkMode ? PlayLight : PlayDark;

      return result;
    });
  }

  function setShuffleRepeat(event) {
    let img = event.target;
    if(img.tagName !== "IMG") img = img.childNodes[0];

    let index, value, src;
    if(img.alt === "shuffle") {
      index = 0;
      // eslint-disable-next-line
      if(controlButtons[index].value == 0) {
        value = 1;
        src   = darkMode ? ShuffleLight : ShuffleDark;
      } else {
        value = 0;
        src   = darkMode ? ShuffleDark : ShuffleLight;
      }
    } else {
      index = 4
      // eslint-disable-next-line
      if(controlButtons[index].value == 0) {
        value = 1;
        src   = darkMode ? RepeatLight : RepeatDark;
      } else {
        value = 0;
        src   = darkMode ? RepeatDark : RepeatLight;
      }
    }

    setControlButtons(previous => {
      const result = [ ...previous ];
      result[index].src   = src;
      result[index].value = value;
      return result;
    });

    setShuffleRepeatDb(img.alt, value);
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
          if(result[index].src.includes("Play"))
            result[index].src = !hovered ? (darkMode ? PlayLight : PlayDark) : (darkMode ? PlayDark : PlayLight);
          else
            result[index].src = !hovered ? (darkMode ? PauseLight : PauseDark) : (darkMode ? PauseDark : PauseLight);
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
      <FooterSongInformation
        coverSrc={coverSrc}
        songName={songName}
        artist={artist}
      />

      <FooterSongControls
        controlButtons={controlButtons}
        hoverButton={hoverButton}
      />

      <FooterMiscControls
        controlButtons={controlButtons}
        hoverButton={hoverButton}
      />
    </footer>
  );
}

export default React.memo(FooterControls);
