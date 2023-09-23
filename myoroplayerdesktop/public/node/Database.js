const sqlite3 = require("sqlite3").verbose();
const clear   = require("clear");
const fs      = require("fs");

var db = null;

function initializeDatabase() {
  clear();

  // Moving MyoroPlayer.db to ./public/ will cause reloads (BAD!!!)
  db = new sqlite3.Database("./MyoroPlayer.db", (error) => {
    if(error) console.log("Error opening MyoroPlayer.db");
    else      console.log("MyoroPlayer.db opened");
  });

  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="playlists";`,
    (error, row) => {
      if(error)    console.log("Error fetching 'playlists' table's existence");
      else if(row) console.log("'playlists' table already exists");
      else {
        db.run(
          `
            CREATE TABLE playlists(
              id        INTEGER PRIMARY KEY AUTOINCREMENT,
              directory TEXT,
              name      TEXT
            );
          `,
          (error) => {
            if(error) console.log("Error creating 'playlists' table");
            else      console.log("'playlists' table created");
          }
        );
      }
    }
  );

  setTimeout(() => console.log("\n\n\n"), 100);
}



// Getters
function getPlaylists() {
  return new Promise((resolve, reject) => {
    db.all(
      `SELECT directory, name FROM playlists;`,
      (error, rows) => {
        if(error) reject(error);

        const goodDirectories = [];

        if(rows.length > 0) {
          for(let i = 0; i < rows.length; i++) {
            try {
              const stat = fs.statSync(rows[i].directory);
              goodDirectories.push(rows[i]);
            } catch(error) { deletePlaylist(rows[i]); }
          }

          resolve(goodDirectories);
        } else resolve([]);
      }
    );
  });
}



// Insertions
function insertPlaylist(playlist) {
  db.run(
    `INSERT INTO playlists (directory, name) VALUES (?, ?);`,
    [ playlist.directory, playlist.name ],
    (error) => { if(error) console.log("Error inserting playlist (Database:insertPlaylist)") }
  );
}



// Updates
function renamePlaylist(event, playlist, name) {
  let newDirectory;
  for(let i = (playlist.directory.length - 2); i >= 0; i--) {
    if(playlist.directory[i] === '/') {
      newDirectory = playlist.directory.substr(0, i + 1) + name + '/';
      break;
    }
  }

  fs.rename(playlist.directory, newDirectory, (error) => {
    if(error) { event.reply("renamePlaylist", undefined); return; }

    db.run(
      `UPDATE playlists SET directory = ?, name = ? WHERE directory = ? AND name = ?;`,
      [ newDirectory, name, playlist.directory, playlist.name ],
      (error) => {
        if(error) event.reply("renamePlaylist", undefined);
        else      event.reply("renamePlaylist", true);
      }
    );
  });
}



// Deletions
function deletePlaylist(playlist) {
  db.run(
    `DELETE FROM playlists WHERE directory = ? AND name = ?;`,
    [ playlist.directory, playlist.name ],
    (error) => { if(error) console.log(error); }
  );
}



module.exports = {
  initializeDatabase,
  getPlaylists,
  insertPlaylist,
  renamePlaylist
};
