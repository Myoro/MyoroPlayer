import React from "react";
import { useSelector } from "react-redux";
import "../../css/ContextMenu.css";
import Store from "../ReduxStore.js";
import {
  hoverButton,
  softDeletePlaylist,
  copySongToPlaylists,
  moveSongToPlaylist,
  YouTubeToMP3,
  SoundCloudToMP3,
  scrapeYouTube,
  scrapeSoundCloudRecommended,

} from "../Functions.js";
import { addToQueue } from "../players/LocalPlayer.js";

function ContextMenu() {
  const darkMode                = useSelector(state => state.darkMode);
  const contextMenu             = useSelector(state => state.contextMenu);
  const [ options, setOptions ] = React.useState([]);

  const styles = { border: darkMode ? "2px solid #EDE6D6" : "2px solid #181818" };

  React.useEffect(() => {
    switch(contextMenu.mode) {
      case "playlist":
        setOptions([
          {
            name: "Rename Playlist",
            onClick: async () => {
              await Store.dispatch({
                type: "enableModal",
                payload: {
                  mode:     "renamePlaylist",
                  selected: contextMenu.selected
                }
              });

              document.getElementById("input").focus();
            }
          },
          {
            name:    "Delete Playlist from MyoroPlayer",
            onClick: softDeletePlaylist
          },
          {
            name:    "Delete Playlist from Computer",
            onClick: () => {
              Store.dispatch({
                type: "enableModal",
                payload: {
                  mode:    "deletePlaylist",
                  selected: contextMenu.selected
                }
              })
            }
          }
        ]);
        break;
      case "song":
        setOptions([
          {
            name:    "Add to Queue",
            onClick: () => addToQueue(contextMenu.selected)
          },
          {
            name:    "Copy to Another Playlist(s)",
            onClick: () => copySongToPlaylists(contextMenu.selected)
          },
          {
            name:    "Move to Another Playlist",
            onClick: () => moveSongToPlaylist(contextMenu.selected)
          },
          {
            name:    "Delete Song from Computer",
            onClick: () => {
              Store.dispatch({
                type: "enableModal",
                payload: {
                  mode:     "deleteSong",
                  selected: contextMenu.selected
                }
              });
            }
          }
        ]);
        break;
      case "youtube":
        setOptions([
          {
            name:    "Add to Queue",
            onClick: () => Store.dispatch({ type: "invokeStreamPlayerCommand", payload: { command: "addToQueue", song: contextMenu.selected }})
          },
          {
            name:    "Convert Video to Playlist",
            onClick: () => YouTubeToMP3(contextMenu.selected.videoID)
          },
          {
            name:    "Search Related Videos",
            onClick: () => searchRelated("youtube", contextMenu.selected.title)
          }
        ]);
        break;
      case "soundcloud":
        setOptions([
          {
            name:    "Add to Queue",
            onClick: () => Store.dispatch({ type: "invokeStreamPlayerCommand", payload: { command: "addToQueue", song: contextMenu.selected }})
          },
          {
            name:    "Convert Song to Playlist",
            onClick: () => SoundCloudToMP3(contextMenu.selected.url)
          },
          {
            name:    "Search Related Songs",
            onClick: () => searchRelated("soundcloud", contextMenu.selected.url)
          }
        ]);
        break;
      default: break;
    }
  }, [contextMenu]);

  async function searchRelated(site, query) {
    await Store.dispatch({ type: "setShowLoadingBar", payload: true });
    document.getElementById("loadingBar").style.animation = "loading 2.2s linear infinite";

    let result;
    if(site === "youtube")         result = await scrapeYouTube(query, true);
    else if(site === "soundcloud") result = await scrapeSoundCloudRecommended(query);

    document.getElementById("loadingBar").style.animation = "none";
    await Store.dispatch({ type: "setShowLoadingBar", payload: false });
    Store.dispatch({ type: "setSongs", payload: result });
  }

  function mapOptions() {
    return options.map((option, index) =>
      <li
        key={index}
        onMouseOver={hoverButton}
        onMouseOut={hoverButton}
        onClick={option.onClick}
        style={{ borderBottom: styles.border }}
      >{option.name}</li>
    );
  }

  if(contextMenu.show) {
    return(
      <ul
        id="contextMenu"
        style={{
          background:  darkMode ? "#181818" : "#EDE6D6",
          borderTop:   styles.border,
          borderLeft:  styles.border,
          borderRight: styles.border
        }}
      >
        { mapOptions() }
      </ul>
    );
  } else return null;
}

export default React.memo(ContextMenu);
