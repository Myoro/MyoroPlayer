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
      if(result.filePaths[i] === '/') {
        newPlaylists.push({ directory: '/', name: '/' });
      } else if(result.filePaths[i].length === 3 && result.filePaths[i].substr(1) === ":/") {
        newPlaylists.push({
          directory: result.filePaths[i].replaceAll('\\', '/'),
          name:      result.filePaths[i][0] + "Drive"
        });
      }else {
        for(let o = (result.filePaths[i].length); o >= 0; o--) {
          if(result.filePaths[i][o] === '/') {
            newPlaylists.push({
              directory: result.filePaths[i].replaceAll('\\', '/') + '/',
              name:      result.filePaths[i].substr(o + 1)
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

    const newPlaylist = { directory: null, name: null };
    if(result.filePath === '/') {
      newPlaylist.directory = '/';
      newPlaylist.name      = '/';
    } else if(result.filePath.length === 3 && result.filePath.substr(1) === ":/") {
      newPlaylist.directory = result.filePath.replaceAll('\\', '/');
      newPlaylist.name      = result.filePath[0] + " Drive";
    } else {
      for(let i = (result.filePath.length - 1); i >= 0; i--) {
        if(result.filePath[i] === '/') {
          newPlaylist.directory = result.filePath.replaceAll('\\', '/') + '/';
          newPlaylist.name      = result.filePath.substr(i + 1);
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
