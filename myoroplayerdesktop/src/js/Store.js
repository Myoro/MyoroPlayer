import { createStore } from "redux";

const initialState = {
  darkMode: true
};

function reducer(state = initialState, action) {
  switch(action.type) {
    case "setDarkMode":
      return { ...state, darkMode: action.payload };
    default:
      return state;
  }
}

const Store = createStore(reducer);
export default Store;
