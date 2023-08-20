import React from "react";
import { useSelector } from "react-redux";
import "../../css/Root.css";
import TopBar from "./TopBar.js";
import SideBar from "./SideBar.js";
import SongList from "./SongList.js";
import FooterControls from "./FooterControls.js";
import ContextMenu from "./ContextMenu.js";
import Modal from "./Modal.js";

function Root() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <div
      id="root"
      style={{ background: darkMode ? "#181818" : "#EDE6D6" }}
    >
      <ContextMenu />
      <Modal />

      <TopBar />

      {/* Container for SideBar & container with SongList & FooterControls */}
      <main>
        <SideBar />

        <section>
          <SongList />
          <FooterControls />
        </section>
      </main>
    </div>
  );
}

export default React.memo(Root);
