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
  }
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    //
    case "appendPlaylists":
      return { ...state, playlists: [ ...state.playlists, ...action.payload ] };
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
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
