import React from "react";
import { Provider } from "react-redux";
import Store from "./ReduxStore.js";
import { quit, cleanTopBarDropdowns } from "./Functions.js";
import Root from "./components/Root.js";

function App() {
  React.useEffect(() => {
    document.addEventListener("click", click);
    document.addEventListener("keydown", keydown);

    return () => {
      document.removeEventListener("click", click);
      document.removeEventListener("keydown", keydown);
    }
  }, []);

  function click(event) {
    // Clean dropdowns whenever topBarButton is not clicked
    if(event.target.className !== "topBarButton") cleanTopBarDropdowns();
  }

  function keydown(event) {
    if(event.key === "Escape") cleanTopBarDropdowns();

    // Ctrl key keyboard shortcuts
    if(event.ctrlKey) {
      switch(event.key.toUpperCase()) {
        // Quit MyoroPlayer
        case 'Q':
          quit();
          break;
        default:
          break;
      }
    }
  }

  return (
    <Provider store={Store}>
      <Root />
    </Provider>
  );
}

export default App;
