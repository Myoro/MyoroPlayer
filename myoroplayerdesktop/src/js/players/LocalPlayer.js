import Store from "../Store.js";
import { getShuffleRepeat, oneArgIpcCall } from "../Functions.js";

const player   = new Audio();
player.volume  = 0.5;
const queue    = [];
const cache    = [];
var playlist   = { directory: null, songs: [] }; // Playlist used to get new songs from (i.e. next song)

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
export async function directPlay(songDirectory, playlistDirectory) {
  cacheSong();
  playSong(songDirectory, 1);
  playlist.directory = playlistDirectory;
  playlist.songs     = await oneArgIpcCall("openPlaylist", playlistDirectory);
}
export function previousPlay() {
  if(cache.length === 0) return;
  playSong(cache.pop(), 0);
}
export async function nextPlay() {
  if(queue.length > 0) {
    cacheSong();
    playSong(queue.pop(), 1);
    Store.dispatch({ type: "setPlaySrc", payload: "playing" });
    return;
  }

  const { shuffle, repeat } = await getShuffleRepeat();

  // eslint-disable-next-line
  if(repeat == 1 && player.src) {
    player.currentTime = 0;
    player.play();
    Store.dispatch({ type: "setPlaySrc", payload: "playing" });
    return;
  }

  if(playlist.directory === null) return;

  let lastPlaylistSongIndex = null;
  const songs               = [];
  for(let i = 0; i < playlist.songs.length; i++)
    songs.push(playlist.songs[i].songDirectory);

  if(player.src) {
    const currentSong = decodeURIComponent(player.src.substr(7, player.src.length));
    if(currentSong.includes(playlist.directory))
      lastPlaylistSongIndex = songs.indexOf(currentSong);
  }

  if(lastPlaylistSongIndex === null) {
    for(let i = 0; i < cache.length; i++) {
      if(cache[i].includes(playlist.directory)) {
        lastPlaylistSongIndex = songs.indexOf(cache[i]);
        break;
      }
    }

    if(lastPlaylistSongIndex === null) return;
  }

  // eslint-disable-next-line
  let nextSongIndex;
  if(shuffle == 0) {
    if(lastPlaylistSongIndex === (songs.length - 1))
      nextSongIndex = 0;
    else
      nextSongIndex = lastPlaylistSongIndex + 1;
  } else {
    do {
      nextSongIndex = Math.floor(Math.random() * songs.length);
    } while(nextSongIndex === lastPlaylistSongIndex)
  }

  cacheSong();
  playSong(songs[nextSongIndex], 1);
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
