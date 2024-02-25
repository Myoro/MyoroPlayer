import React from "react";
import { useSelector } from "react-redux";
import "../../css/Root.css";
import Store from "../ReduxStore.js";
import StreamAudioPlayer from "../players/StreamAudioPlayer.js";
import ContextMenu from "./ContextMenu.js";
import Modal from "./Modal.js";
import TopBar from "./TopBar.js";
import SideBar from "./SideBar.js";
import SongList from "./SongList.js";
import FooterControls from "./FooterControls.js";
import { getDarkMode } from "../Functions.js";

function Root() {
  const darkMode            = useSelector(state => state.darkMode);
  const databaseInitialized = useSelector(state => state.databaseInitialized);

  React.useEffect(() => {
    if(databaseInitialized === false) return;
    getDarkMode().then(result => {
      if(result.dark === 0) Store.dispatch({ type: "setDarkMode", payload: false });
      else                  Store.dispatch({ type: "setDarkMode", payload: true });
    });
  }, [databaseInitialized]);

  React.useEffect(() => {
    document.documentElement.style.setProperty("--primary",       darkMode ? "#EDE6D6" : "#181818");
    document.documentElement.style.setProperty("--primary-hover", darkMode ? "#CCC3B3" : "#000000");
    document.documentElement.style.setProperty("--secondary",     darkMode ? "#181818" : "#EDE6D6");
  }, [darkMode]);

  return(
    <>
      <StreamAudioPlayer />

      <ContextMenu />
      <Modal />

      <div
        id="root"
        style={{ background: darkMode ? "#181818" : "#EDE6D6" }}
      >
        <TopBar />

        <main>
          <SideBar />

          <section>
            <SongList />
            <FooterControls />
          </section>
        </main>
      </div>
    </>
  );
}

export default React.memo(Root);
