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

  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="songs";`,
    (error, row) => {
      if(error)    console.log("Error fetching 'songs' table's existence");
      else if(row) console.log("'songs' table already exists");
      else {
        db.run(
          `
            CREATE TABLE songs(
              id                INTEGER PRIMARY KEY AUTOINCREMENT,
              songDirectory     TEXT,
              playlistDirectory TEXT,
              title             TEXT,
              artist            TEXT,
              album             TEXT,
              cover             TEXT,
              lengthStr         TEXT,
              lengthInt         INTEGER
            );
          `,
          (error) => {
            if(error) console.log("Error creating 'songs' table");
            else      console.log("'songs' table created");
          }
        );
      }
    }
  );

  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="shuffle_repeat";`,
    (error, row) => {
      if(error)    console.log("Error fetching 'shuffle_repeat' table's existence");
      else if(row) console.log("'shuffle_repeat' table already exists");
      else {
        db.run(
          `
            CREATE TABLE shuffle_repeat(
              id      INTEGER PRIMARY KEY,
              shuffle INTEGER,
              repeat  INTEGER
            );
          `,
          (error) => {
            if(error) console.log("Error creating 'shuffle_repeat' table");
            else {
              db.all(
                `INSERT INTO shuffle_repeat(shuffle, repeat) VALUES(0, 0)`,
                (error) => {
                  if(error) console.log("Error creating 'shuffle_repeat' table");
                  else      console.log("'shuffle_repeat' table created");
                }
              );
            }
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
function getPlaylistSongs(directory) {
  return new Promise((resolve, reject) => {
    db.all(
      `
        SELECT
          songDirectory,
          playlistDirectory,
          title,
          artist,
          album,
          cover,
          lengthStr,
          lengthInt
        FROM songs WHERE playlistDirectory = ?;
      `,
      [ directory ],
      (error, rows) => {
        if(error) {
          reject(error);
        } else {
          const result = [];

          for(let i = 0; i < rows.length; i++) {
            try {
              const stat = fs.statSync(rows[i].songDirectory);
              result.push(rows[i]);
            } catch(error) { deleteSong(rows[i].songDirectory); }
          }

          resolve(result);
        }
      }
    );
  });
}
function getShuffleRepeat(event) {
  db.get(
    `SELECT shuffle, repeat FROM shuffle_repeat;`,
    (error, row) => {
      if(error) console.log(error);
      else      event.reply("getShuffleRepeat", row);
    }
  );
}



// Insertions
function insertPlaylist(playlist) {
  db.run(
    `INSERT INTO playlists (directory, name) VALUES (?, ?);`,
    [ playlist.directory, playlist.name ],
    (error) => { if(error) console.log("Error inserting playlist (Database:insertPlaylist)") }
  );
}
function setShuffleRepeat(data) {
  db.run(
    `UPDATE shuffle_repeat SET ${data.mode} = ?;`,
    [ data.value ],
    (error) => { if(error) console.log(error); }
  );
}

function insertSong(song) {
  db.run(
    `
      INSERT INTO songs(
        songDirectory,
        playlistDirectory,
        cover,
        title,
        artist,
        album,
        lengthStr,
        lengthInt
      ) VALUES(?, ?, ?, ?, ?, ?, ?, ?);
    `,
    [
      song.songDirectory,
      song.playlistDirectory,
      song.cover,
      song.title,
      song.artist,
      song.album,
      song.lengthStr,
      song.lengthInt
    ],
    (error) => { if(error) console.log(error); }
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
    (error) => {
      if(error) { console.log(error); return; }

      db.run(
        `DELETE FROM songs WHERE playlistDirectory = ?`,
        [ playlist.directory ],
        (error) => { if(error) console.log(error); }
      );
    }
  );
}
function softDeletePlaylist(event, playlist) {
  deletePlaylist(playlist);
  event.reply("softDeletePlaylist", true);
}
function hardDeletePlaylist(event, playlist) {
  fs.rmdir(playlist.directory.substr(0, playlist.directory.length - 1), { recursive: true }, (error) => {
    if(error) {
      event.reply("hardDeletePlaylist", false);
      return;
    } else {
      deletePlaylist(playlist);
      event.reply("hardDeletePlaylist", true);
    }
  });
}
function hardDeleteSong(event, songDirectory) {
  fs.unlink(songDirectory, (error) => {
    if(error) event.reply("hardDeleteSong", false);
    else      { deleteSong(songDirectory); event.reply("hardDeleteSong", true); }
  });
}

function deleteSong(directory) {
  db.run(
    `DELETE FROM songs WHERE songDirectory = ?;`,
    [ directory ],
    (error) => { if(error) console.log(error); }
  );
}



module.exports = {
  initializeDatabase,
  getPlaylists,
  insertPlaylist,
  renamePlaylist,
  getPlaylistSongs,
  insertSong,
  softDeletePlaylist,
  hardDeletePlaylist,
  hardDeleteSong,
  deleteSong,
  getShuffleRepeat,
  setShuffleRepeat
};
