const sqlite3 = require("sqlite3").verbose();
const fs      = require("fs");
var db        = null;

function initializeDatabase(event) {
  db = new sqlite3.Database("MyoroPlayer.db", (error) => {
    if(error) { console.log(error); event.reply("initializeDatabase", false); }
    else      console.log("Database created/opened\n");
  });

  // Creating playlists table
  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="playlists";`,
    (error, row) => {
      if(error) {
        console.log(error);
        event.reply("initializeDatabase", false);
      } else if(row) {
        console.log("playlists table already created\n");
        event.reply("initializeDatabase", true);
      } else {
        db.run(
          `
            CREATE TABLE playlists(
              id        INTEGER PRIMARY KEY AUTOINCREMENT,
              directory TEXT,
              name      TEXT
            );
          `,
          (error) => {
            if(error) {
              console.log(error);
              event.reply("initializeDatabase", false);
            } else {
              console.log("playlists table created\n");
              event.reply("initializeDatabase", true);
            }
          }
        );
      }
    }
  );

  // Creating songs table
  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="songs";`,
    (error, row) => {
      if(error) {
        console.log(error);
        event.reply("initializeDatabase", false);
      } else if(row) {
        console.log("songs table already created\n");
        event.reply("initializeDatabase", true);
      } else {
        db.run(
          `
            CREATE TABLE songs(
              id                INTEGER PRIMARY KEY AUTOINCREMENT,
              songDirectory     TEXT,
              playlistDirectory TEXT,
              cover             TEXT,
              name              TEXT,
              artist            TEXT,
              album             TEXT,
              lengthStr         TEXT,
              lengthInt         INTEGER
            );
          `,
          (error) => {
            if(error) {
              console.log(error);
              event.reply("initializeDatabase", false);
            } else {
              console.log("songs table created\n");
              event.reply("initializeDatabase", true);
            }
          }
        )
      }
    }
  );

  // Creating shuffle_repeat table
  db.get(
    `SELECT name FROM sqlite_master WHERE type="table" AND name="songs";`,
    (error, row) => {
      if(error)    console.log(error);
      else if(row) console.log("shuffle_repeat already created\n");
      else {
        db.run(
          `
            CREATE TABLE shuffle_repeat(
              id      INTEGER PRIMARY KEY,
              shuffle TEXT,
              repeat  TEXT
            );
          `,
          (error) => {
            if(error) { console.log(error); return; }

            db.run(
              `INSERT INTO shuffle_repeat(shuffle, repeat) VALUES(?, ?);`,
              [ '0', '0' ],
              (error) => {
                if(error) console.log(error);
                else      console.log("shuffle_repeat table created\n");
              }
            );
          }
        );
      }
    }
  );

  event.reply("initializeDatabase", true);
}

function getPlaylists() {
  return new Promise((resolve, reject) => {
    db.all(
      `SELECT directory, name FROM playlists;`,
      (error, rows) => {
        if(error) reject(error);

        // Removing non-existent directories
        const badDirectories  = [];
        const goodDirectories = [];

        if(rows) {
          for(let i = 0; i < rows.length; i++) {
            try {
              const stat = fs.statSync(rows[i].directory);
              goodDirectories.push(rows[i]);
            } catch(error) { badDirectories.push(rows[i]); }
          }

          for(let i = 0; i < badDirectories.length; i++)
            deletePlaylist(badDirectories[i].directory, badDirectories[i].name);
        }

        resolve(goodDirectories);
      }
    );
  });
}

function insertPlaylist(directory, name) {
  db.run(
    `INSERT INTO playlists(directory, name) VALUES(?, ?);`,
    [ directory, name ],
    (error) => { if(error) console.log(error); }
  );
}

function deletePlaylist(directory, name) {
  db.run(
    `DELETE FROM playlists WHERE directory = ? AND name = ?;`,
    [ directory, name ],
    (error) => { if(error) console.log(error); }
  );
}

function getPlaylistSongs(directory) {
  return new Promise((resolve, reject) => {
    db.all(
      `
        SELECT
          songDirectory,
          playlistDirectory,
          cover,
          name,
          artist,
          album,
          lengthStr,
          lengthInt
        FROM songs WHERE playlistDirectory = ?;
      `,
      (error, rows) => {
        if(error) reject(error);
        else      resolve(rows);
      }
    );
  });
}

function insertSong(song) {
  db.run(
    `
      INSERT INTO songs(
        songDirectory,
        playlistDirectory,
        cover,
        name,
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
      song.name,
      song.artist,
      song.album,
      song.lengthStr,
      song.lengthInt
    ],
    (error) => { if(error) console.log(error); }
  );
}

function renamePlaylist(event, newName, directory) {
  directory = directory.substr(0, directory.length - 1);
  let oldName, newDirectory;
  for(let i = (directory.length - 1); i >= 0; i--) {
    if(directory[i] === '/') {
      oldName      = directory.substr(i + 1);
      newDirectory = directory.substr(0, i) + '/' + newName;
      break;
    }
  }

  fs.rename(directory, newDirectory, (error) => {
    if(error) { event.reply("renamePlaylist", false); return; }

    db.run(
      `UPDATE playlists SET directory=?,name=? WHERE directory=? AND name=?;`,
      [ newDirectory + '/', newName, directory + '/', oldName ],
      (error) => {
        if(error) event.reply("renamePlaylist", false);
        else      event.reply("renamePlaylist", true);
      }
    );
  });
}

function deletePlaylist(directory) {
  return new Promise((resolve, reject) => {
    db.run(
      `DELETE FROM playlists WHERE directory=?;`,
      [ directory ],
      (error) => {
        if(error) reject();

        db.run(
          `DELETE FROM songs WHERE playlistDirectory=?;`,
          [ directory ],
          (error) => {
            if(error) reject();
            else      resolve();
          }
        );
      }
    );
  });
}

function deleteSong(directory) {
  db.run(
    `DELETE FROM songs WHERE songDirectory=?;`,
    [ directory ],
    (error) => { if(error) console.log(error); }
  );
}

function setShuffleRepeat(event, mode, value) {
  if(mode === "shuffle") query = `UPDATE shuffle_repeat SET shuffle=?;`;
  else                   query = `UPDATE shuffle_repeat SET repeat=?;`;
  db.run(
    query,
    [ value ],
    (error) => {
      if(error) event.reply("setShuffleRepeat", false);
      else      event.reply("SetShuffleRepeat", true);
    }
  );
}

function getShuffleRepeat(event) {
  db.get(
    `SELECT shuffle, repeat FROM shuffle_repeat;`,
    (error, row) => {
      if(error) event.reply("getShuffleRepeat", null);
      else      event.reply("getShuffleRepeat", row);
    }
  );
}

module.exports = {
  initializeDatabase,
  getPlaylists,
  insertPlaylist,
  getPlaylistSongs,
  insertSong,
  renamePlaylist,
  deletePlaylist,
  deleteSong,
  setShuffleRepeat,
  getShuffleRepeat
};
