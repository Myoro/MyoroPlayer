import { createStore } from "redux";

const initialState = {
  darkMode:  false,
  //
  playlists: []
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    case "appendPlaylists":
      return { ...state, playlists: [ ...state.playlists, ...action.payload ] };
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
