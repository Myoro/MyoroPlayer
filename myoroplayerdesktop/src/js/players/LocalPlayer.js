// Where songs stored on the computer are played
import Store from "../ReduxStore.js";

const player    = new Audio();
const queue     = [];
const previous  = [];

player.volume       = 0.5;
player.ontimeupdate = () => { Store.dispatch({ type: "setSongSliderValue", payload: player.currentTime }); };

export function addToQueue(song) { queue.push(song); }

export function playSong(song) {
  cacheSong();
  loadSong(song, true);
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
