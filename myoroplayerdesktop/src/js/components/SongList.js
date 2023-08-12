import React from "react";
import { useSelector } from "react-redux";
import "../../css/SongList.css";

function SongList() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <ul id="songList">
    </ul>
  );
}

export default React.memo(SongList);
