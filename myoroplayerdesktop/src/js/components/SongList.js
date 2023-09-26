import React from "react";
import { useSelector } from "react-redux";
import "../../css/SongList.css";
import LogoDark from "../../img/LogoDark.svg";
import LogoLight from "../../img/LogoLight.svg";

function SongList() {
  const darkMode                  = useSelector(state => state.darkMode);
  const [ selected, setSelected ] = React.useState(null);

  const styles = {
    text: darkMode ? "#EDE6D6" : "#181818"
  };

  function hoverButton(event) {
    let li = event.target;
    while(li.tagName !== "LI") li = li.parentNode;

    let hovered = true;
    if(window.getComputedStyle(li).backgroundColor === "rgba(0, 0, 0, 0)")
      hovered = false;

    const text          = !hovered ? (darkMode ? "#181818" : "#EDE6D6") : (darkMode ? "#EDE6D6" : "#181818");
    li.style.background = !hovered ? (darkMode ? "#EDE6D6" : "#181818") : "none";
    if(li.childNodes[0].src.includes(!hovered ? (darkMode ? "LogoDark" : "LogoLight") : (darkMode ? "LogoLight" : "LogoDark")))
      li.childNodes[0].src = !hovered ? (darkMode ? LogoLight : LogoDark) : (darkMode ? LogoDark : LogoLight);
    for(let i = 0; i < li.childNodes[1].childNodes.length; i++)
      li.childNodes[1].childNodes[i].style.color = text;
    li.childNodes[2].style.color = text;
    li.childNodes[3].style.color = text;
  }

  return(
    <ul id="songList">
      <p>SELECT SONG ON SINGLE CLICK</p>
      <li
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
      >
        {/* Album cover */}
        <img alt="cover" src={darkMode ? LogoDark : LogoLight} />

        {/* Song title & artist */}
        <div>
          <p style={{ color: styles.text }}>Song titqwoiejwqoirtjhreoigsdhnfdfngojnfgole</p>
          <p style={{ color: styles.text }}>Ski Mask the Slump Poo Poo God</p>
        </div>

        {/* Album */}
        <p style={{ color: styles.text }}>Madvillainyqweoijqgofjegoisdjfioj</p>

        {/* Song duration */}
        <p style={{ color: styles.text }}>420:00</p>
      </li>
    </ul>
  );
}

export default React.memo(SongList);
