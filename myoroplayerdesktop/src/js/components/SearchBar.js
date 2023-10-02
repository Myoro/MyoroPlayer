import React from "react";
import { useSelector } from "react-redux";
import "../../css/SearchBar.css";
import Store from "../ReduxStore.js";

function SearchBar() {
  const darkMode  = useSelector(state => state.darkMode);
  const searchBar = useSelector(state => state.searchBar);

  function searchSongs(event) {
    const newSongs = searchBar.songsCopy.filter(song => {
      return song.title.toUpperCase().includes(event.target.value.toUpperCase());
    }); Store.dispatch({ type: "setSongs", payload: newSongs });
  }

  if(searchBar.show) {
    return(
      <input
        id="searchBar"
        type="text"
        style={{
          background: darkMode ? "#181818" : "#EDE6D6",
          borderTop:  darkMode ? "2px solid #EDE6D6" : "2px solid #181818"
        }}
        onKeyDown={searchSongs}
      />
    );
  } else return null;
}

export default React.memo(SearchBar);
