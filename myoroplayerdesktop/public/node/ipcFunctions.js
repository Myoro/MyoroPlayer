const fs = require("fs");
const {
  dialog,
  BrowserWindow
} = require("electron");
const {
  getPlaylists: getPlaylistsDb,
  insertPlaylist,
  getPlaylistSongs,
  insertSong
} = require("./Database.js");

function openPlaylist(event, win) {
  dialog.showOpenDialog(
    win,
    {
      title:      "Open Playlist(s)",
      properties: [ "openDirectory", "multiSelections" ]
    }
  ).then(async (result) => {
    if(result.canceled) { event.reply("openPlaylist", undefined); return; }

    const newPlaylists = [];
    for(let i = 0; i < result.filePaths.length; i++) {
      const directory = result.filePaths[i].replaceAll('\\', '/');

      if(directory === '/') {
        newPlaylists.push({ directory: '/', name: '/' });
      } else if(directory.length === 3 && directory.substr(1) === ":/") {
        newPlaylists.push({
          directory: directory,
          name:      directory[0] + " Drive"
        });
      } else {
        for(let o = (directory.length - 1); o >= 0; o--) {
          if(directory[o] === '/') {
            newPlaylists.push({
              directory: directory + '/',
              name:      directory.substr(o + 1)
            });
            break;
          }
        }
      }
    }

    const oldPlaylists  = await getPlaylistsDb();
    const notDuplicates = [];
    for(let i = 0; i < newPlaylists.length; i++) {
      if(oldPlaylists.length === 0) {
        notDuplicates.push(newPlaylists[i]);
      } else {
        for(let o = 0; o < oldPlaylists.length; o++) {
          if(newPlaylists[i].directory === oldPlaylists[o].directory || newPlaylists[i].name === oldPlaylists[o].name)
            break;
          else if((newPlaylists[i].directory !== oldPlaylists[o].directory && newPlaylists[i].name !== oldPlaylists[o].name) && o === (oldPlaylists.length - 1))
            notDuplicates.push(newPlaylists[i]);
        }
      }
    }

    for(let i = 0; i < notDuplicates.length; i++)
      insertPlaylist(notDuplicates[i]);

    if(notDuplicates.length > 0) event.reply("openPlaylist", notDuplicates);
    else                         event.reply("openPlaylist", undefined);
  });
}

function newPlaylist(event, win) {
  dialog.showSaveDialog(
    win,
    {
      title:      "Create New Playlist",
      properties: [ "createDirectory" ]
    }
  ).then(async (result) => {
    if(result.canceled) { event.reply("newPlaylist", undefined); return; }

    const directory   = result.filePath.replaceAll('\\', '/');
    const newPlaylist = { directory: null, name: null };

    if(directory === '/') {
      newPlaylist.directory = '/';
      newPlaylist.name      = '/';
    } else if(directory.length === 3 && directory.substr(1) === ":/") {
      newPlaylist.directory = directory;
      newPlaylist.name      = directory[0] + " Drive";
    } else {
      for(let i = (directory.length - 1); i >= 0; i--) {
        if(directory[i] === '/') {
          newPlaylist.directory = directory + '/';
          newPlaylist.name      = directory.substr(i + 1);
          break;
        }
      }
    }

    const playlists = await getPlaylistsDb();
    for(let i = 0; i < playlists.length; i++) {
      if(playlists[i].directory === newPlaylist.directory || playlists[i].name === newPlaylist.name) {
        break;
      } else if((playlists[i].directory !== newPlaylist.directory && playlists[i].name !== newPlaylist.name) && (i === playlists.length - 1)) {
        fs.mkdir(newPlaylist.directory, (error) => {
          if(error) {
            console.log(error);
            event.reply("newPlaylist", undefined);
            return;
          }

          insertPlaylist(newPlaylist);
          event.reply("newPlaylist", newPlaylist);
        });
      }
    }
  });
}

async function getPlaylists(event) {
  const playlists = await getPlaylistsDb();
  event.reply("getPlaylists", playlists);
}

async function loadPlaylist(event, playlist) {
  // 1. Get all MP3 files from playlist folder (including subfolders)
  const songs = [];
  (function getSongs(directory) {
    const files = fs.readdirSync(directory);

    for(let i = 0; i < files.length; i++) {
      const stat  = fs.statSync(directory + files[i]);
      const split = files[i].split('.');

      if(stat.isFile() && split[split.length - 1].toUpperCase() === "MP3")
        songs.push(directory + files[i]);
      else if(stat.isDirectory())
        getSongs(directory + files[i] + '/');
    }
  })(playlist.directory);

  // 2. Analyze which songs have not been added to songs table yet
  const dbSongs           = await getPlaylistSongs(playlist.directory);
  const dbSongDirectories = [];
  for(let i = 0; i < dbSongs.length; i++)
    dbSongDirectories.push(dbSongs[i].songDirectory);

  const newSongs = songs.filter((song) => { return !dbSongDirectories.includes(song); });

  // 3. Multi-threadedly get unanalyzed songs and add them to the songs table
  const threads    = [];
  const threadPool = 5;
  for(let i = 0; i < threadPool; i++) {
    const thread = new BrowserWindow({
      show: false,
      webPreferences: {
        nodeIntegration:  true,
        contextIsolation: false // Able to use window.require
      }
    }); thread.loadURL("about:blank");

    threads.push(thread);
  }

  const buffers    = [];
  const bufferPool = 25;
  while(newSongs.length > 0) buffers.push(newSongs.splice(0, bufferPool));

  async function getID3Tags(buffer, playlistDirectory) {
    const NodeID3     = require("node-id3");
    const MP3Duration = require("mp3-duration");

    const songs               = [];
    const MP3DurationPromises = [];

    for(let i = 0; i < buffer.length; i++) {
      const tags = NodeID3.read(buffer[i]);

      songs.push({
        songDirectory:     buffer[i],
        playlistDirectory: playlistDirectory,
        title:             tags.title,
        artist:            tags.artist ? tags.artist : null,
        album:             tags.album ? tags.album : null,
        cover:             (tags.image && tags.image.imageBuffer) ? `data:${tags.image.mime};base64,${Buffer.from(tags.image.imageBuffer).toString("base64")}` : null,
        lengthStr:         null,
        lengthInt:         null
      });

      MP3DurationPromises.push(
        MP3Duration(buffer[0], (error, duration) => {
          if(error) console.log(error);
          else      return duration;
        })
      );
    }

    const resolvedMP3DurationPromises = await Promise.all(MP3DurationPromises);
    for(let i = 0; i < songs.length; i++) {
      const current      = resolvedMP3DurationPromises[i];
      songs[i].lengthInt = current;
      songs[i].lengthStr = Math.floor(current / 60).toString() + ':' + Math.floor(current % 60).toString().padStart(2, '0');
    }

    return songs;
  }

  const processedSongs = [];
  while(buffers.length > 0) {
    const promises = [];

    for(let i = 0; i < threadPool; i++) {
      if(buffers.length > 0) {
        promises.push(threads[i].webContents.executeJavaScript(`(${getID3Tags.toString()})(${JSON.stringify(buffers[0])}, ${JSON.stringify(playlist.directory)});`));
        buffers.shift();
      } else break;
    }

    const resolutions = await Promise.all(promises);
    for(let i = 0; i < resolutions.length; i++)
      processedSongs.push(...resolutions[i]);
  }

  // 4. Return array of all the songs
  event.reply("loadPlaylist", [ ...dbSongs, ...processedSongs ]);

  // 5. Destroy threads
  for(let i = 0; i < threadPool; i++)
    threads[i].destroy();

  // 6. Add songs to songs table
  for(let i = 0; i < processedSongs.length; i++)
    insertSong(processedSongs[i]);
}

module.exports = {
  openPlaylist,
  newPlaylist,
  getPlaylists,
  loadPlaylist
};
