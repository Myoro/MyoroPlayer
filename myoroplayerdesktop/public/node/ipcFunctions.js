const { dialog } = require("electron");

function openPlaylist(win) {
  dialog.showOpenDialog(
    win,
    { properties: [ "openDirectory", "multiSelections" ] }
  ).then(result => {
    if(result.canceled) return;

    // 1. Check if the playlist is already created in the database
    // 2. Add playlists that have not been duplicated
    console.log(result.filePaths);
  });
}

function newPlaylist(event, win) {
  console.log("Start");
}

module.exports = {
  openPlaylist,
  newPlaylist
};
