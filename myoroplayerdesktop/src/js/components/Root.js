import React from "react";
import { useSelector } from "react-redux";
import "../../css/Root.css";
import TopBar from "./TopBar.js";
import SideBar from "./SideBar.js";
import ContextMenu from "./ContextMenu.js";
import Modal from "./Modal.js";

function Root() {
  const darkMode = useSelector(state => state.darkMode);

  return(
    <>
      <ContextMenu />
      <Modal />

      <div
        id="root"
        style={{ background: darkMode ? "#181818" : "#EDE6D6" }}
      >
        <TopBar />

        <main>
          <SideBar />

          <div>
          </div>
        </main>
      </div>
    </>
  );
}

export default React.memo(Root);
