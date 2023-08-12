import { Provider } from "react-redux";
import Store from "./Store.js";
import Root from "./components/Root.js";

function App() {
  return (
    <Provider store={Store}>
      <Root />
    </Provider>
  );
}

export default App;
