import Store from "../Store.js";

const player   = new Audio();
player.volume  = 0.5;
const queue    = [];
const cache    = [];
var playlist   = null; // Playlist used to get new songs from (i.e. next song)

export function addToQueue(directory) { queue.push(directory); }

export function togglePlay() {
  if(!player.src) {
    return null;
  } else if(player.paused) {
    player.play();
    return "playing";
  } else {
    player.pause();
    return "paused";
  }
}

// When a user double clicks a song
export function directPlay(songDirectory, playlistDirectory) {
  cacheSong();
  playlist = playlistDirectory;
  playSong(songDirectory, 1);
}
export function previousPlay() {
  if(cache.length === 0) return;
  playSong(cache.pop(), 0);
}
export function nextPlay() {
  alert("Hello tomorrow's me");
}

// Caches player.src
function cacheSong() {
  if(!player.src || player.name === 0) return;
  cache.push(decodeURIComponent(player.src.substr(7, player.src.length)));
}

function playSong(directory, cacheSong) {
  player.src  = "file://" + directory;
  player.name = cacheSong;
  player.play();
  Store.dispatch({ type: "setPlaySrc", payload: "playing" });
}
