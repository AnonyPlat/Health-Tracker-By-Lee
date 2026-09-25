-- Users (single or multi user, siap dipakai keduanya)
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  gender TEXT CHECK(gender IN ('male','female')) DEFAULT 'male',
  age INTEGER,
  height_cm REAL,
  activity_level TEXT CHECK(activity_level IN ('sedentary','light','moderate','active','very_active')) DEFAULT 'moderate',
  goal TEXT CHECK(goal IN ('cut','maintain','bulk')) DEFAULT 'maintain',
  created_at TEXT DEFAULT (datetime('now'))
);

-- Log makanan / minuman
CREATE TABLE IF NOT EXISTS food_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  name TEXT NOT NULL,
  meal TEXT CHECK(meal IN ('breakfast','lunch','dinner','snack')) NOT NULL,
  calories REAL NOT NULL DEFAULT 0,
  protein_g REAL DEFAULT 0,
  carbs_g REAL DEFAULT 0,
  fat_g REAL DEFAULT 0,
  water_ml REAL DEFAULT 0,
  logged_at TEXT DEFAULT (datetime('now')),
  log_date TEXT NOT NULL
);

-- Jadwal & sesi gym
CREATE TABLE IF NOT EXISTS gym_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  split_type TEXT CHECK(split_type IN ('chest','back','legs','shoulders','arms','core','cardio','full_body','rest')) NOT NULL,
  session_date TEXT NOT NULL,
  start_time TEXT,
  duration_min INTEGER,
  notes TEXT,
  completed INTEGER DEFAULT 0
);

-- Exercise per sesi gym
CREATE TABLE IF NOT EXISTS gym_exercises (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES gym_sessions(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  sets INTEGER,
  reps INTEGER,
  weight_kg REAL,
  order_index INTEGER DEFAULT 0
);

-- Berat badan & body metrics
CREATE TABLE IF NOT EXISTS weight_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  weight_kg REAL NOT NULL,
  log_date TEXT NOT NULL,
  UNIQUE(user_id, log_date)
);

-- Tidur
CREATE TABLE IF NOT EXISTS sleep_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  hours REAL NOT NULL,
  quality INTEGER CHECK(quality BETWEEN 1 AND 5) DEFAULT 3,
  log_date TEXT NOT NULL,
  UNIQUE(user_id, log_date)
);
