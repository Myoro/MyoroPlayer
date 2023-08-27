import { createStore } from "redux";

const initialState = {
  darkMode: true,
  //
  databaseInitialized: false,
  //
  playlists: [], // Playlists shown in SideBar
  //
  songs:            [], // Opened playlist's songs in SongList
  showLoadingBar:   false,
  searchBarOptions: { show: false, songsCopy: [] },
  //
  contextMenu: { show: false, buttons: [] },
  //
  modal: { show: false, dialog: null, directory: null, buttons: [] },
  //
  currentSong: null,
  //
  queueList: [], // Queued songs that the user can view in Footer(Misc)Controls
  //
  sliderValues: {
    song: {
      valueStr: "0:00",
      valueInt: 0,
      maxStr:   "0:00",
      maxInt:   100
    },
    volume: 0
  }
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    //
    case "setDatabaseInitialized":
      return { ...state, databaseInitialized: action.payload };
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
    case "setSearchBarOptions":
      return { ...state, searchBarOptions: { show: true, songsCopy: action.payload } };
    case "resetSearchBarOptions":
      return { ...state, searchBarOptions: { show: false, songsCopy: [] } };
    //
    case "setContextMenu":
      return {
        ...state,
        contextMenu: {
          show:    true,
          buttons: action.payload
        }
      };
    case "resetContextMenu":
      return {
        ...state,
        contextMenu: {
          show:    false,
          buttons: []
        }
      };
    //
    case "setModal":
      return {
        ...state,
        modal: {
          show:      true,
          dialog:    action.payload.dialog,
          directory: action.payload.directory,
          buttons:   action.payload.buttons
        }
      };
    case "resetModal":
      return {
        ...state,
        modal: {
          show:      false,
          dialog:    null,
          directory: null,
          buttons:   []
        }
      };
    //
    case "setCurrentSong":
      return { ...state, currentSong: action.payload };
    //
    case "setQueueList":
      return { ...state, queueList: action.payload };
    //
    case "setSongSliderValues":
      return { ...state, sliderValues: { ...state.sliderValues, song: action.payload } };
    case "setVolumeSliderValue":
      return { ...state, sliderValues: { ...state.sliderValues, volume: action.payload } };
    //
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
