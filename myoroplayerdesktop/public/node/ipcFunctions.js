const { dialog } = require("electron");
const fs         = require("fs");
const {
  getPlaylists: getPlaylistsDb,
  insertPlaylist
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

    console.log("Reached here: " + newPlaylists);

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

module.exports = {
  openPlaylist,
  newPlaylist,
  getPlaylists
};
