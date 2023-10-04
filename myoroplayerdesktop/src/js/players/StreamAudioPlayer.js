import React from "react";
import { useSelector } from "react-redux";
import Store from "../ReduxStore.js";
import ReactPlayer from "react-player";

function StreamAudioPlayer() {
  const listeningMode       = useSelector(state => state.listeningMode);
  const streamPlayerCommand = useSelector(state => state.streamPlayerCommand);

  const player              = React.useRef(null);
  const [ URL, setURL ]     = React.useState(null);
  const [ cache, setCache ] = React.useState(false);

  const previous = [];
  const queue    = [];
  var   query    = null; // Equivalent to the playlist variable in LocalPlayer.js

  React.useEffect(() => {
    if(streamPlayerCommand.command === null) return;

    switch(streamPlayerCommand.command) {
      case "playSong": playSong(); break;
      default:                     break;
    }

    Store.dispatch({ type: "invokeStreamPlayerCommand", payload: { command: null, song: null }});
  // eslint-disable-next-line
  }, [streamPlayerCommand]);

  function playSong() {
    query = Store.getState().songs;
    // cacheSong();
    loadSong(streamPlayerCommand.song, true);
  }

  function loadSong(song, cachable) {
    // Store.dispatch({ type: "setCurrentSong", payload: song });

    if(listeningMode === "youtube")
      setURL("https://www.youtube.com/watch?v=" + song.videoID);
    else
      setURL(song.url);
  }

  /*
  React.useEffect(() => {
    if(currentStream === null) return;

    switch(listeningMode) {
      case "local":      setURL(null);                                                       break;
      case "youtube":    setURL("https://www.youtube.com/watch?v=" + currentStream.videoID); break;
      case "soundcloud": setURL(currentStream.url);                                          break;
      default:                                                                               break;
    }
    if(listeningMode === "youtube")         setURL("https://www.youtube.com/watch?v=" + currentStream.videoID);
    else if(listeningMode === "soundcloud") setURL(currentStream.url);
  }, [currentStream]);
  */

  return(
    <ReactPlayer
      ref={player}
      url={URL}
      controls={false}
      playing={true}
    />
  );
}

export default React.memo(StreamAudioPlayer);
