import { createStore } from "redux";

const initialState = {
  // Theme
  darkMode: false,
  // Playlists used by SideBar
  playlists: [],
  // Abstract context menu
  contextMenu: {
    show:     false,
    mode:     null,
    selected: null
  },
  // Modal
  modal: {
    show:     false,
    mode:     null,
    selected: null
  },
  // Loading bar displayed in SongList
  showLoadingBar: false,
  // Songs displayed in SongList
  songs: []
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
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
