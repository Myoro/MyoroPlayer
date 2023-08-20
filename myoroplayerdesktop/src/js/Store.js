import { createStore } from "redux";

const initialState = {
  darkMode:       true,
  //
  playlists:      [],    // Playlists shown in SideBar
  //
  songs:          [],    // Opened playlist's songs in SongList
  showLoadingBar: false,
  //
  contextMenu:    { show: false, buttons: [] },
  //
  modal:          { show: false, dialog: null, directory: null, buttons: [] }
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
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
