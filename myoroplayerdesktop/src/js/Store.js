import { createStore } from "redux";

const initialState = {
  darkMode: true,
  //
  playlists:      [],    // Playlists shown in SideBar
  //
  songs:          [],    // Opened playlist's songs in SongList
  showLoadingBar: false
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    //
    case "addPlaylist":
      return { ...state, playlists: [ ...state.playlists, action.payload ] };
    case "addPlaylists":
      return { ...state, playlists: [ ...state.playlists, ...action.payload ] };
    case "setPlaylists":
      return { ...state, playlists: action.payload };
    //
    case "setSongs":
      return { ...state, songs: action.payload };
    case "setShowLoadingBar":
      return { ...state, showLoadingBar: action.payload };
    //
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
