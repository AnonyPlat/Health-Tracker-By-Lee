# Ritme — Health Tracker

Full stack health tracker: kalori/air minum, jadwal gym (chest/leg/back day dll), berat badan + BMI, dan tidur. Semua kalkulasi target (BMR/TDEE/BMI) pakai rumus standar (Mifflin-St Jeor), bukan AI.

## Stack
- Backend: Node.js + Express + SQLite (`better-sqlite3`, file-based, gak perlu server DB terpisah)
- Auth: JWT + bcrypt
- Frontend: HTML/CSS/JS vanilla, single dashboard, served langsung dari Express

## Jalanin di VPS (Ubuntu, PM2 — samain kayak setup Meridian bot lo)

```bash
# 1. Upload folder ini ke VPS, lalu masuk foldernya
cd health-tracker

# 2. Install dependencies
npm install

# 3. Setup environment
cp .env.example .env
nano .env   # isi JWT_SECRET dengan string acak yang panjang

# 4. Jalanin dengan PM2
pm2 start server.js --name health-tracker
pm2 save
```

Akses via `http://IP_VPS:3000` (atau setup Nginx reverse proxy + domain kalau mau lebih rapi/HTTPS).

## Struktur folder

```
health-tracker/
  server.js              # entrypoint Express
  db/
    schema.sql           # skema tabel SQLite
    db.js                # koneksi + auto-init DB
    health.db             # dibuat otomatis saat pertama run
  routes/
    auth.js               # register, login, profil
    food.js                # log makanan/minuman/air
    gym.js                  # jadwal & sesi gym, streak
    health.js               # berat badan, tidur, ringkasan
  middleware/auth.js         # JWT guard
  utils/health-calc.js        # rumus BMR/TDEE/BMI/air (non-AI)
  public/                       # frontend (index.html, style.css, app.js)
```

## API singkat

| Endpoint | Fungsi |
|---|---|
| `POST /api/auth/register` | Daftar akun baru |
| `POST /api/auth/login` | Login, dapat JWT |
| `GET/PUT /api/auth/me` | Lihat/update profil + target kalori |
| `POST/GET /api/food` | Catat & lihat log makanan per tanggal |
| `POST /api/food/water` | Quick-add air minum |
| `GET /api/food/weekly` | Statistik kalori & air 7 hari |
| `POST/GET /api/gym/sessions` | Jadwalkan & lihat sesi gym (dengan exercises) |
| `PUT /api/gym/sessions/:id` | Update/tandai selesai |
| `GET /api/gym/streak` | Hitung streak konsistensi gym |
| `POST/GET /api/health/weight` | Catat berat badan + histori BMI |
| `POST/GET /api/health/sleep` | Catat jam & kualitas tidur |
| `GET /api/health/summary` | Ringkasan dashboard hari ini |

## Catatan pengembangan lanjut (opsional)

- Tambah backup otomatis file `db/health.db` (misal cron `cp` ke folder lain tiap malam)
- Kalau mau multi-device beneran real-time, tinggal tambah polling/interval refresh di `app.js`
- Kalau nanti mau migrasi ke PostgreSQL (misal userbase makin besar), tinggal ganti `db/db.js` — semua query udah terisolasi di layer routes
