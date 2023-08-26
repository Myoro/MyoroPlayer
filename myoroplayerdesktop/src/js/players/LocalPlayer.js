import Store from "../Store.js";
import { getShuffleRepeat } from "../Functions.js";

const player        = new Audio();
player.volume       = 0.5;
player.onended      = () => { nextPlay(); };
player.ontimeupdate = () => {
  const timeInt            = Math.floor(player.currentTime);
  const minutes            = Math.floor(timeInt / 60);
  const seconds            = Math.floor(timeInt % 60);
  const timeStr            = minutes + ':' + seconds.toString().padStart(2, '0');
  const { maxStr, maxInt } = Store.getState().sliderValues.song;
  Store.dispatch({
    type: "setSongSliderValues",
    payload: {
      valueStr: timeStr,
      valueInt: timeInt,
      maxStr:   maxStr,
      maxInt:   maxInt
    }
  });
}
const queue         = [];
const cache         = [];
var playlist        = { directory: null, songs: [] }; // Playlist used to get new songs from (i.e. next song)

export function addToQueue(song) { queue.push(song); }

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
export async function directPlay(song) {
  cacheSong();
  playSong(song, 1);
  playlist.directory       = song.playlistDirectory;
  playlist.songs           = Store.getState().songs;
  playlist.songDirectories = [];
  for(let i = 0; i < playlist.songs.length; i++)
    playlist.songDirectories.push(playlist.songs[i].songDirectory);
}
export function previousPlay() {
  if(cache.length === 0) return;
  playSong(cache.pop(), 0);
}
export async function nextPlay() {
  if(queue.length > 0) {
    cacheSong();
    playSong(queue.shift(), 1);
    return;
  }

  const { shuffle, repeat } = await getShuffleRepeat();

  // eslint-disable-next-line
  if(repeat == 1 && player.src) {
    player.currentTime = 0;
    player.play();
    return;
  }

  if(playlist.directory === null) return;

  let lastPlaylistSongIndex = null;

  if(player.src) {
    const currentSong = Store.getState().currentSong;
    if(currentSong.playlistDirectory === playlist.directory)
      lastPlaylistSongIndex = playlist.songDirectories.indexOf(currentSong.songDirectory);
  }

  if(lastPlaylistSongIndex === null) {
    for(let i = 0; i < cache.length; i++) {
      if(cache[i].playlistDirectory === playlist.directory) {
        lastPlaylistSongIndex = playlist.songDirectories.indexOf(cache[i].songDirectory);
        break;
      }
    }

    if(lastPlaylistSongIndex === null) return;
  }

  let nextSongIndex;
  // eslint-disable-next-line
  if(shuffle == 0) {
    if(lastPlaylistSongIndex === (playlist.songs.length - 1))
      nextSongIndex = 0;
    else
      nextSongIndex = lastPlaylistSongIndex + 1;
  } else {
    do {
      nextSongIndex = Math.floor(Math.random() * playlist.songDirectories.length);
    } while(nextSongIndex === lastPlaylistSongIndex)
  }

  cacheSong();
  playSong(playlist.songs[nextSongIndex], 1);
}

// Caches player.src
function cacheSong() {
  if(!player.src || player.name === 0) return;
  cache.push(Store.getState().currentSong);
}

function playSong(song, cacheSong) {
  player.src  = "file://" + song.songDirectory;
  player.name = cacheSong;
  player.play();
  Store.dispatch({ type: "setCurrentSong", payload: song });
}

export function toggleQueueList() {
  if(queue.length === 0) return;
  const queueList = document.getElementById("queueList");
  if(window.getComputedStyle(queueList).display === "none") {
    queueList.style.display = "flex";
    Store.dispatch({ type: "setQueueList", payload: queue });
  } else {
    queueList.style.display = "none";
    Store.dispatch({ type: "setQueueList", payload: [] });
  }
}

export function songSliderOnChange(event) {
  if(!player.src) return;

  player.currentTime = event.target.value;
  const minutes            = Math.floor(event.target.value / 60);
  const seconds            = Math.floor(event.target.value % 60);
  const timeStr            = minutes + ':' + seconds.toString().padStart(2, '0');
  const { maxStr, maxInt } = Store.getState().sliderValues.song;
  Store.dispatch({
    type: "setSongSliderValues",
    payload: {
      valueStr: timeStr,
      valueInt: event.target.value,
      maxStr:   maxStr,
      maxInt:   maxInt
    }
  });
}

export function volumeSliderOnChange(event) {
  player.volume = event.target.value / 100;
  Store.dispatch({ type: "setVolumeSliderValue", payload: player.volume });
}
