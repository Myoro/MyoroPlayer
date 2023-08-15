const sqlite3 = require("sqlite3").verbose();
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
            )
          `,
          (error) => {
            if(error) console.log(error);
            else      console.log("Playlists table created");
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
        if(error)      reject(error);
        else           resolve(rows);
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

module.exports = {
  initializeDatabase,
  getPlaylists,
  insertPlaylist
};
