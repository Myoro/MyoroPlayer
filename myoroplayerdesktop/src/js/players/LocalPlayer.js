// Where songs stored on the computer are played
import Store from "../ReduxStore.js";
import { getShuffleRepeatValues } from "../Functions.js";

const player    = new Audio();
const queue     = [];
const previous  = [];
var   playlist  = { directory: null, songs: [] };

player.volume       = 0.5;
player.ontimeupdate = () => { Store.dispatch({ type: "setSongSliderValue", payload: player.currentTime }); };
player.onended      = () => nextSong();

export function addToQueue(song) { queue.push(song); }
export function getQueue()       { return queue; }

export function playSong(song) {
  playlist.directory = song.playlistDirectory;
  playlist.songs     = Store.getState().songs;
  cacheSong();
  loadSong(song, true);
}
export function playQueuedSong(index) {
  cacheSong();
  loadSong(queue.splice(index, 1)[0], true);
}

export function previousSong() {
  if(previous.length === 0) return;
  loadSong(previous.pop(), false);
}

export function togglePlay() {
  if(!player.src)        { return null; }
  else if(player.paused) { player.play();  return "playing"; }
  else                   { player.pause(); return "paused"; }
}
export function pause() {
  if(!player.src)         return;
  else if(!player.paused) player.pause();
}

export async function nextSong() {
  const { shuffle, repeat } = await getShuffleRepeatValues();

  // Step 1: Check if repeat is enabled
  if(repeat === 1 && player.src) {
    player.currentTime = 0;
    player.play();

    // Triggering useEffects
    const currentSong = Store.getState().currentSong;
    await Store.dispatch({ type: "setCurrentSong", payload: null });
    Store.dispatch({ type: "setCurrentSong", payload: currentSong });

    return;
  }

  // Step 2: Check if queue is empty
  if(queue.length > 0) {
    cacheSong();
    loadSong(queue.shift(), true);
    return;
  }

  // Step 3: Check if a playlist is null (in order to choose next song)
  if(playlist.directory === null) return;

  // Step 4: Grabbing last song from loaded playlist
  let   lastPlaylistSong = null;
  const currentSong      = Store.getState().currentSong;
  if(currentSong.playlistDirectory === playlist.directory) {
    lastPlaylistSong = currentSong;
  } else {
    for(let i = (previous.length - 1); i >= 0; i--) {
      if(previous[i].playlistDirectory === playlist.songs) {
        lastPlaylistSong = previous[i];
        break;
      }
    }
  }

  // Exit case, playlist has not been loaded yet, can't decide next song
  if(lastPlaylistSong === null) return;

  // Last step: Check if shuffle is enabled, and choose song accordingly
  const lastPlaylistSongIndex = playlist.songs.indexOf(lastPlaylistSong);
  let   nextSongIndex;
  if(shuffle === 0) {
    if(lastPlaylistSongIndex === (playlist.songs.length - 1))
      nextSongIndex = 0;
    else
      nextSongIndex = lastPlaylistSongIndex + 1;
  } else {
    do {
      nextSongIndex = Math.floor(Math.random() * playlist.songs.length);
    } while(nextSongIndex === lastPlaylistSongIndex);
  }

  cacheSong();
  loadSong(playlist.songs[nextSongIndex], true);
}

export function setSongPosition(event) {
  player.currentTime = event.target.value;
  Store.dispatch({ type: "setSongSliderValue", payload: event.target.value });
}

export function setVolume(event) {
  player.volume = event.target.value / 100;
  Store.dispatch({ type: "setVolumeSlider", payload: event.target.value });
}

function loadSong(song, cache) {
  Store.dispatch({ type: "setCurrentSong", payload: song });
  player.src  = "file://" + song.songDirectory;
  player.name = cache ? "cache" : "noCache";
  player.play();
}

function cacheSong() {
  if(!player.src || player.name === "noCache") return;
  previous.push(Store.getState().currentSong);
}
