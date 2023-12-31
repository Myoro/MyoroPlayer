import { createStore } from "redux";

const initialState = {
  // Theme
  darkMode: false,
  // Playlists used by SideBar
  playlists: [],
  // Abstract context menu
  contextMenu: { show: false, mode: null, selected: null },
  // Modal
  modal: { show: false, mode: null, selected: null },
  // Loading bar displayed in SongList
  showLoadingBar: false,
  // Songs displayed in SongList
  songs: [],
  // Local player current song
  currentSong: null,
  // State to invoke functions
  streamPlayerCommand: { command: null, song: null, seekTo: null },
  streamPlayerPlaying: false,
  streamPlayerVolume:  0.5,
  // Slider values in FooterSongControls
  songSlider:   { value: 50, max: 100 },
  volumeSlider: 50,
  // Allows components to not cause errors with the Database
  databaseInitialized: false,
  // Queue list shown in FooterMiscControls
  queueList: { show: false, queue: [] },
  // SearchBar
  searchBar: { show: false, mode: null, songsCopy: null },
  // Either local, YouTube, or SoundCloud
  listeningMode: "local"
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    //
    case "appendPlaylists":
      return { ...state, playlists: [ ...state.playlists, ...action.payload ] };
    case "clearPlaylists":
      return { ...state, playlists: [] };
    //
    case "enableContextMenu":
      return {
        ...state,
        contextMenu: {
          show:     true,
          mode:     action.payload.mode,
          selected: action.payload.selected
        }
      };
    case "disableContextMenu":
      return {
        ...state,
        contextMenu: {
          show:     false,
          mode:     null,
          selected: null
        }
      };
    //
    case "enableModal":
      return {
        ...state,
        modal: {
          show:     true,
          mode:     action.payload.mode,
          selected: action.payload.selected
        }
      };
    case "disableModal":
      return {
        ...state,
        modal: {
          show:     false,
          modal:    null,
          selected: null
        }
      };
    //
    case "setShowLoadingBar":
      return { ...state, showLoadingBar: action.payload };
    //
    case "setSongs":
      return { ...state, songs: action.payload };
    //
    case "setCurrentSong":
      return { ...state, currentSong: action.payload };
    //
    case "invokeStreamPlayerCommand":
      return { ...state, streamPlayerCommand: { command: action.payload.command, song: action.payload.song, seekTo: action.payload.seekTo } };
    case "setStreamPlayerPlaying":
      return { ...state, streamPlayerPlaying: action.payload };
    case "setStreamPlayerVolume":
      return { ...state, streamPlayerVolume: action.payload };
    //
    case "setSongSliderValue":
      return { ...state, songSlider: { ...state.songSlider, value: action.payload } };
    case "setSongSliderMax":
      return { ...state, songSlider: { ...state.songSlider, max: action.payload } };
    case "setVolumeSlider":
      return { ...state, volumeSlider: action.payload };
    //
    case "setDatabaseInitialized":
      return { ...state, databaseInitialized: true };
    //
    case "enableQueueList":
      return { ...state, queueList: { show: true, queue: action.payload } };
    case "disableQueueList":
      return { ...state, queueList: { show: false, queue: [] } };
    //
    case "enableSearchBar":
      return { ...state, searchBar: { show: true, mode: action.payload.mode, songsCopy: action.payload.songsCopy } };
    case "disableSearchBar":
      return { ...state, searchBar: { show: false, mode: null, songsCopy: null } };
    //
    case "setListeningMode":
      return { ...state, listeningMode: action.payload };
    //
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
