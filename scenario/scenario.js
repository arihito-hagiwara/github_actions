import sql from "k6/x/sql";
import driver from "k6/x/sql/driver/mysql";
import { Counter } from 'k6/metrics';
import encoding from 'k6/encoding';

export const options = {
  duration: '300s',
  vus: 100,
};


function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

// The second argument is a MySQL connection string, e.g.
// myuser:mypass@tcp(127.0.0.1:3306)/mydb
//const db = sql.open(driver, "root:siu2w_J3@m^E1*85A4@tcp(10.0.150.98:4000)/k6db");
const db = sql.open(driver, encoding.b64decode(__ENV.DB_INFO,"std", "s"));
const queryCounter = new Counter('query_count');

export function setup() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS roster
      (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        given_name VARCHAR(50) NOT NULL,
        family_name VARCHAR(50) NULL
      );
  `);
}

export function teardown() {
  db.close();
}

export default function () {
  let result = db.exec(`
    INSERT INTO roster
      (given_name, family_name)
    VALUES
      ('Peter', 'Pan'),
      ('Wendy', 'Darling'),
      ('Tinker', 'Bell'),
      ('James', 'Hook');
  `);
  console.log(`${result.rowsAffected()} rows inserted`);
  queryCounter.add(1);

  let rows = db.query("SELECT * FROM roster WHERE id = ?;", getRandomInt(10000));
  for (const row of rows) {
    // Convert array of ASCII integers into strings. See https://github.com/grafana/xk6-sql/issues/12
    console.log(`${String.fromCharCode(...row.family_name)}, ${String.fromCharCode(...row.given_name)}`);
  }
  queryCounter.add(1);
}
