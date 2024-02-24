const sqlite3 = require('sqlite3');

const database = new sqlite3.Database(
  'myoro_player.db',
  (error) => {
    if(error) {
      console.log(`Error initializing myoro_player.db: ${error}`);
      return;
    }

    database.run(
      `
        CREATE TABLE IF NOT EXISTS dark_mode(
          id      INTEGER PRIMARY KEY,
          enabled INTEGER
        );
      `,
      (error) => {
        if(error) {
          console.log(`Error creating dark_mode table: ${error}`);
          return;
        }

        database.get(
          'SELECT enabled FROM dark_mode;',
          (error, rows) => {
            if(error) {
              print(`Erroring selecting from dark_mode table: ${error}`);
              return;
            }

            if(rows) return;

            database.run(
              'INSERT INTO dark_mode(enabled) VALUES(1);',
              (error) => error
                ? console.log(error)
                : console.log('dark_mode table created or opened successfully'),
            );
          },
        );
      },
    );

    console.log('Database created or opened successfully');
  },
);

module.exports = database;