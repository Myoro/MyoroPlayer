import React, { useState } from "react";
import { useSelector } from "react-redux";
import Store from "../ReduxStore.js";
import ReactPlayer from "react-player";
import { getShuffleRepeatValues, scrapeYouTube } from "../Functions.js";

function StreamAudioPlayer() {
  const streamPlayerCommand = useSelector(state => state.streamPlayerCommand);
  const streamPlayerPlaying = useSelector(state => state.streamPlayerPlaying);
  const streamPlayerVolume  = useSelector(state => state.streamPlayerVolume);
  const currentSong         = useSelector(state => state.currentSong);

  const player                    = React.useRef(null);
  const [ URL, setURL ]           = useState(null);
  const [ cache, setCache ]       = useState(false);
  const [ previous, setPrevious ] = useState([]);
  const [ queue, setQueue ]       = useState([]);
  const [ query, setQuery ]       = useState(null); // Equivalent to the playlist variable in LocalPlayer.js

  React.useEffect(() => {
    if(streamPlayerCommand.command === null) return;

    switch(streamPlayerCommand.command) {
      case "playSong":
        playSong();
        break;
      case "addToQueue":
        setQueue(queued => Array.isArray(queued) ? [ ...queued, streamPlayerCommand.song ] : [streamPlayerCommand.song]);
        break;
      case "togglePlay":
        togglePlay();
        break;
      case "previousSong":
        previousSong();
        break;
      case "nextSong":
        nextSong();
        break;
      case "seekTo":
        seekTo(streamPlayerCommand.seekTo);
        break;
      default: break;
    }

    Store.dispatch({ type: "invokeStreamPlayerCommand", payload: { command: null, song: null }});
  // eslint-disable-next-line
  }, [streamPlayerCommand]);

  function seekTo(position)  { if(player.current) player.current.seekTo(position, "seconds"); }
  function onProgress(event) { Store.dispatch({ type: "setSongSliderValue", payload: event.playedSeconds }) };

  function togglePlay() {
    if(player.current) {
      if(!streamPlayerPlaying)
        Store.dispatch({ type: "setStreamPlayerPlaying", payload: true });
      else
        Store.dispatch({ type: "setStreamPlayerPlaying", payload: false });
    }
  }

  function playSong() {
    setQuery(Store.getState().songs);
    cacheSong();
    loadSong(streamPlayerCommand.song, true);
  }

  function previousSong() {
    if(previous.length === 0) return;

    setPrevious(previousSongs => {
      const result = [ ...previousSongs ];
      loadSong(result.pop(), false);
      return result;
    });
  }

  async function nextSong() {
    const { shuffle, repeat } = await getShuffleRepeatValues();

    // Step 1: Check if repeat is enabled
    if(repeat === 1 && player.current) {
      player.current.seekTo(0, "seconds");
      Store.dispatch({ type: "setStreamPlayerPlaying", payload: true });

      // Triggering useEffects
      const currentSong = Store.getState().currentSong;
      await Store.dispatch({ type: "setCurrentSong", payload: null });
      Store.dispatch({ type: "setCurrentSong", payload: currentSong });

      return;
    }

    // Step 2: Check if queue is empty
    if(queue.length > 0) {
      cacheSong();
      setQueue(queued => {
        const result = [ ...queued ];
        loadSong(result.shift(), true);
        return;
      });
      return;
    }

    // Step 3: Check if query is null in order to choose the next song
    if(query === null) return;

    let lastQuerySong = null;
    const currentSong = Store.getState().currentSong;
    if(query.includes(currentSong)) {
      lastQuerySong = currentSong;
    } else {
      for(let i = (previous.length - 1); i >= 0; i--) {
        if(query.includes(previous[i])) {
          lastQuerySong = previous[i];
          break;
        }
      }
    }

    // Exit case, can't decide a song
    if(lastQuerySong === null) return;

    // Last step: Check if shuffle is enabled, and choose song accordingly
    const lastQuerySongIndex = query.indexOf(lastQuerySong);
    let   nextSongIndex;
    if(shuffle === 0) {
      if(lastQuerySongIndex === (query.length - 1))
        nextSongIndex = 0;
      else
        nextSongIndex = lastQuerySongIndex + 1;
    } else {
      do {
        nextSongIndex = Math.floor(Math.random() * query.length);
      } while(nextSongIndex === lastQuerySongIndex);
    }

    // Setting a new query list since YouTube provides copies of the same song over n over again
    if(Store.getState().listeningMode === "youtube") {
      const newQuery = await scrapeYouTube(query[nextSongIndex], true);
      setQuery(newQuery);
    }

    cacheSong();
    loadSong(query[nextSongIndex], true);
  }

  function loadSong(song, cachable) {
    Store.dispatch({ type: "setCurrentSong", payload: song });

    if(song.hasOwnProperty("videoID"))
      setURL("https://www.youtube.com/watch?v=" + song.videoID);
    else
      setURL(song.url);

    Store.dispatch({ type: "setStreamPlayerPlaying", payload: true });
    setCache(cachable);
  }

  function cacheSong() {
    if(currentSong === null) return;
    if(cache && (currentSong.hasOwnProperty("url") || currentSong.hasOwnProperty("videoID")))
      previous.push(currentSong);
  }

  return(
    <ReactPlayer
      ref={player}
      url={URL}
      controls={false}
      volume={streamPlayerVolume}
      playing={streamPlayerPlaying}
      onEnded={nextSong}
      onProgress={onProgress}
    />
  );
}

export default React.memo(StreamAudioPlayer);
