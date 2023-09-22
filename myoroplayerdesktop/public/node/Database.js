const sqlite3 = require("sqlite3").verbose();
const clear   = require("clear");

var db = null;

function initializeDatabase() {
  clear();

  db = new sqlite3.Database("../MyoroPlayer.db", (error) => {
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
}

module.exports = {
  initializeDatabase
};
