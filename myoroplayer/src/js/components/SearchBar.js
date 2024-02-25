import React from "react";
import { useSelector } from "react-redux";
import "../../css/SearchBar.css";
import Store from "../ReduxStore.js";
import {
  toggleSearchBar,
  scrapeYouTube,
  scrapeSoundCloud
} from "../Functions.js";

function SearchBar() {
  const darkMode  = useSelector(state => state.darkMode);
  const searchBar = useSelector(state => state.searchBar);

  function onKeyDown(event) {
    function searchSongs(event) {
      const newSongs = searchBar.songsCopy.filter(song => {
        return song.title.toUpperCase().includes(event.target.value.toUpperCase());
      }); Store.dispatch({ type: "setSongs", payload: newSongs });
    }

    async function searchOnline(event, site) {
      if(event.key !== "Enter") return;

      const query = event.target.value;

      toggleSearchBar();

      let result;

      await Store.dispatch({ type: "setShowLoadingBar", payload: true });
      document.getElementById("loadingBar").style.animation = "loading 2.2s linear infinite";

      if(site === "youtube")         result = await scrapeYouTube(query, false);
      else if(site === "soundcloud") result = await scrapeSoundCloud(query);

      document.getElementById("loadingBar").style.animation = "none";
      await Store.dispatch({ type: "setShowLoadingBar", payload: false });

      Store.dispatch({ type: "setSongs", payload: result });
    }

    switch(searchBar.mode) {
      case "search":     searchSongs(event);                break;
      case "youtube":    searchOnline(event, "youtube");    break;
      case "soundcloud": searchOnline(event, "soundcloud"); break;
      default:                                              break;
    }
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
        onKeyDown={onKeyDown}
        placeholder={(searchBar.mode === "youtube" || searchBar.mode === "soundcloud") ? "Press Enter to Search" : ''}
      />
    );
  } else return null;
}

export default React.memo(SearchBar);
