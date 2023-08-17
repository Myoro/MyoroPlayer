const fs                        = require("fs");
const { dialog, BrowserWindow } = require("electron");
const {
  getPlaylists,
  insertPlaylist,
  getPlaylistSongs,
  insertSong
} = require("./Database.js");

async function openPlaylists(win, event) {
  const data = await dialog.showOpenDialog(
    win,
    {
      title:      "Open Playlist(s)",
      properties: [ "openDirectory", "multiSelections" ]
    }
  ).then(result => {
    if(result.canceled) return null;

    const data = [];
    for(let i = 0; i < result.filePaths.length; i++) {
      let directory = result.filePaths[i].replaceAll('\\', '/');
      const split   = directory.split('/');
      let name      = split[split.length - 1];
      if(directory === '/')                                           name = "/";
      else if(directory.length === 3 && directory.substr(1) === ":/") name = directory[0] + " Drive";
      if(directory[directory.length - 1] !== '/') directory += '/';
      data.push({ directory: directory, name: name });
    } return data;
  });

  if(data === null) event.reply("openPlaylists", []);

  // Checking for duplicate directories
  const playlists     = await getPlaylists();
  const nonduplicates = [];
  for(let i = 0; i < data.length; i++) {
    let duplicate = false;
    for(let o = 0; o < playlists.length; o++)
      if(data[i].directory === playlists[o].directory)
        duplicate = true;
    if(!duplicate) nonduplicates.push(data[i]);
  }

  event.reply("openPlaylists", data);

  // Inserting playlists to playlists table
  for(let i = 0; i < data.length; i++)
    insertPlaylist(data[i].directory, data[i].name);
}

async function newPlaylist(win, event) {
  const data = await dialog.showSaveDialog(
    win,
    {
      title: "Create New Playlist",
      properties: [ "createDirectory" ]
    }
  ).then(result => {
    if(result.canceled) return null;

    let directory = result.filePath.replaceAll('\\', '/');
    const split   = directory.split('/');
    let name      = split[split.length - 1];
    if(directory === '/')                                           name = "/";
    else if(directory.length === 3 && directory.substr(1) === ":/") name = directory[0] + " Drive";
    if(directory[directory.length - 1] !== '/') directory += '/';

    return { directory: directory, name: name };
  });

  if(data === null) event.reply("newPlaylist", []);

  // Checking for duplicate directories
  const playlists = await getPlaylists();
  for(let i = 0; i < playlists.length; i++) {
    if(playlists[i].directory === data.directory) {
      event.reply("newPlaylist", []);
      return;
    }
  }

  // Creating the directory
  fs.mkdir(data.directory, (error) => {
    if(error) {
      console.log(error);
      event.reply("newPlaylist", []);
      return;
    }

    // Inserting playlist to playlists table
    insertPlaylist(data.directory, data.name);

    event.reply("newPlaylist", data);
  });
}

async function getPlaylistsIpc(event) {
  const playlists = await getPlaylists();
  event.reply("getPlaylists", playlists);
}

async function openPlaylist(event, directory) {
  const songDirectories = [];

  // Step 1: Grabbing all .mp3 files from directory (scans subdirs too)
  async function getSongs(directory) {
    const files = fs.readdirSync(directory);
    for(let i = 0; i < files.length; i++) {
      const stat  = fs.statSync(directory + files[i]);
      const split = files[i].split('.');
      if(stat.isFile() && split[split.length - 1].toUpperCase() === "MP3")
        songDirectories.push(directory + files[i]);
      else if(stat.isDirectory())
        await getSongs(directory + files[i] + '/');
    }
  }

  await getSongs(directory);

  // Step 2: Grabbing songs from playlist & creating an array of noninserted songs
  const playlistSongs = await getPlaylistSongs(directory).then(songs => {
    const result = songs.filter((song) => { return song.songDirectory });
    return result;
  });
  const newSongs = songDirectories.filter((song) => { return !playlistSongs.includes(song); });

  // Step 3: Grabbing id3 information from newSongs (multithreaded)
  //// Creating thread pool
  const threads    = [];
  const threadPool = 5;
  for(let i = 0; i < threadPool; i++) {
    const thread = new BrowserWindow({
      show: false,
      webPreferences: {
        nodeIntegration:  true,
        contextIsolation: false
      }
    }); thread.loadURL("about:blank");
    threads.push(thread);
  }
  //// Creating buffers from newSongs
  const buffers = [];
  while(newSongs.length > 0) buffers.push(newSongs.splice(0, 25));

  async function workerFunction(buffer) {
    const NodeID3                       = window.require("node-id3");
    const { getAudioDurationInSeconds } = window.require("get-audio-duration");

    const result                = [];
    const audioDurationPromises = [];

    for(let i = 0; i < buffer.length; i++) {
      const id3  = NodeID3.read(buffer[i]);
      const json = {
        songDirectory:     null,
        playlistDirectory: null,
        cover:             null,
        name:              null,
        artist:            null,
        album:             null,
        lengthStr:         null,
        lengthInt:         null
      };

      if(id3.title) {
        json.name = id3.title;
      } else {
        const split = buffer[i].split('/');
        const file  = split[split.length - 1];
        for(let o = (file.length - 1); o >= 0; o--) {
          if(file[o] === '.') {
            json.name = file.substr(0, o);
            break;
          }
        }
      }

      json.artist = id3.artist || "";
      json.album  = id3.album  || "";

      if(id3.image && id3.image.imageBuffer) {
        const imageData    = id3.image.imageBuffer;
        const base64string = Buffer.from(imageData).toString("base64");
        json.cover         = `data:${id3.image.mime};base64,${base64string}`;
      } else json.cover = "";

      result.push(json);
      audioDurationPromises.push(
        getAudioDurationInSeconds(buffer[i]).then((duration) => {
          const minutes     = Math.floor(duration / 60);
          const seconds     = Math.floor(duration % 60);
          const durationStr = minutes.toString() + ':' + seconds.toString().padStart(2, '0');
          return { lengthStr: durationStr, lengthInt: duration };
        })
      );
    }

    const resolvedPromises = await Promise.all(audioDurationPromises);
    for(let i = 0; i < result.length; i++) {
      result[i].lengthStr = resolvedPromises[i].lengthStr;
      result[i].lengthInt = resolvedPromises[i].lengthInt;
    }

    return result;
  }

  //// Concurrently running workerFunction until buffer is empty
  const songs = [];
  while(buffers.length > 0) {
    const promises = [];
    for(let i = 0; i < threadPool; i++) {
      if(buffers.length > 0) {
        promises.push(threads[i].webContents.executeJavaScript(`(${workerFunction.toString()})(${JSON.stringify(buffers[0])});`));
        buffers.shift();
      } else break;
    }
    const resolutions = await Promise.all(promises);
    for(let i = 0; i < resolutions.length; i++)
      songs.push(...resolutions[i]);
    for(let i = 0; i < songs.length; i++)
      songs[i].playlistDirectory = directory;
  }

  event.reply("openPlaylist", [ ...playlistSongs, ...songs ]);

  //// Destroying threads
  for(let i = 0; i < threadPool; i++)
    threads[i].destroy();

  // Inserting songs to songs table
  for(let i = 0; i < songs.length; i++)
    insertSong(songs[i]);
}

module.exports = {
  openPlaylists,
  newPlaylist,
  getPlaylistsIpc,
  openPlaylist
};
