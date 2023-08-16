const fs                               = require("fs");
const { dialog }                       = require("electron");
const { getPlaylists, insertPlaylist } = require("./Database.js");

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

module.exports = {
  openPlaylists,
  newPlaylist,
  getPlaylistsIpc
};
