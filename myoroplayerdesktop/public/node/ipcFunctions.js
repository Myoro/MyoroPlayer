const fs                               = require("fs");
const { dialog }                       = require("electron");
const { getPlaylists, insertPlaylist } = require("./Database.js");

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
    const name    = split[split.length - 1];
    if(directory[directory.length - 1] !== '/') directory += '/';

    return { directory: directory, name: name };
  });

  if(data === false) event.reply("newPlaylist", null);

  // Checking for duplicate directories
  const playlists = await getPlaylists();
  for(let i = 0; i < playlists.length; i++) {
    if(playlists[i].directory === data.directory) {
      event.reply("newPlaylist", null);
      return;
    }
  }

  // Creating the directory
  fs.mkdir(data.directory, (error) => {
    if(error) {
      console.log(error);
      event.reply("newPlaylist", null);
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

module.exports = {
  newPlaylist,
  getPlaylistsIpc
};
