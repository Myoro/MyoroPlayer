import React from "react";
import { useSelector } from "react-redux";
import "../../css/SearchBar.css";

function SearchBar() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <input
      id="searchBar"
      type="text"
      style={{
        borderTop: darkMode ? "2px solid #EDE6D6" : "2px solid #181818",
        color:     darkMode ? "#EDE6D6" : "#181818"
      }}
    />
  );
}

export default React.memo(SearchBar);
