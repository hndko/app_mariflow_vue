# 📘 Masterclass Supabase: Panduan Edukasi & Anatomi Lengkap Seluruh Menu Platform

Dokumen ini disusun sebagai **materi pembelajaran mendalam (Masterclass Guide)** mengenai ekosistem **Supabase**, anatomi seluruh fiturnya dari tingkat **Organisasi** hingga **Project**, serta keterkaitannya langsung dengan aplikasi **MariFlow SaaS**.

---

## 📑 Daftar Isi
1. [Konsep Inti & Hirarki Supabase (Organization vs Project)](#-1-konsep-inti--hirarki-supabase)
2. [Anatomi Form Pembuatan Project Baru (Create a New Project)](#-2-anatomi-form-pembuatan-project-baru)
   - [2.1 Pemilihan Region Database Terbaik](#21-pemilihan-region-database-terbaik)
   - [2.2 Konfigurasi Opsi Security & Automatic RLS Trigger](#22-konfigurasi-opsi-security--automatic-rls-trigger)
   - [2.3 Integrasi GitHub Repository](#23-integrasi-github-repository)
3. [Anatomi Menu Organisasi — Bagian 1 (Projects, Team, Integrations)](#-3-anatomi-menu-organisasi--bagian-1)
4. [Anatomi Menu Organisasi — Bagian 2 (Configuration, Security & OAuth)](#-4-anatomi-menu-organisasi--bagian-2)
5. [Anatomi Menu Organisasi — Bagian 3 (Compliance, Legal & Usage Metrics)](#-5-anatomi-menu-organisasi--bagian-3)
6. [Panduan Langkah-demi-Langkah Pengisian Form untuk MariFlow SaaS](#-6-panduan-langkah-demi-langkah-pengisian-form-mariflow)
7. [Anatomi Menu Tingkat Project (Backend & Database Engine)](#-7-anatomi-menu-tingkat-project)
8. [Anatomi Lengkap Project Dashboard (Project Overview)](#-8-anatomi-lengkap-project-dashboard-project-overview)
   - [8.1 Kartu Status Utama (Compute & Database Health)](#81-kartu-status-utama-project-header--compute-health)
   - [8.2 Bagian "Get Connected" (Pintu Integrasi)](#82-bagian-get-connected-pintu-masuk-integrasi)
   - [8.3 4 Pilar Metrik Layanan (API, Realtime, Storage, Postgres)](#83-4-pilar-metrik-layanan-service-metrics)
   - [8.4 Security & Performance Advisor](#84-security--performance-advisor)
9. [Anatomi Lengkap 13 Menu Sidebar Kiri Project](#-9-anatomi-lengkap-13-menu-sidebar-kiri-project-level)
10. [Bedah Lengkap Menu Table Editor & Modal "Create a New Table"](#-10-bedah-lengkap-menu-table-editor--modal-create-a-new-table)
    - [10.1 Komponen Halaman Utama Table Editor & Batch Edit](#101-komponen-halaman-utama-table-editor)
    - [10.2 Anatomi Modal Drawer "Create a new table under public"](#102-anatomi-modal-drawer-create-a-new-table-under-public)
    - [10.3 Penjelasan Detail Tiap Opsi Pembuatan Tabel (RLS, Realtime, Columns, FK, API)](#103-penjelasan-detail-tiap-opsi-pembuatan-tabel)
11. [Matriks Komparasi: FREE Tier vs PRO Tier (Panduan Batasan & Skalabilitas)](#-11-matriks-komparasi-free-tier-vs-pro-tier-panduan-batasan--skalabilitas)
    - [11.1 Rincian Fitur Bebas Pakai di FREE Tier](#111-rincian-fitur-bebas-pakai-di-free-tier-cukup-untuk-pengembangan--mvp)
    - [11.2 Daftar Fitur Eksklusif PRO TIER (Terkunci)](#112-daftar-fitur-eksklusif-pro-tier--wajib-diperhatikan)

---

## 🏛️ 1. Konsep Inti & Hirarki Supabase

```text
┌─────────────────────────────────────────────────────────────────┐
│                    🏢 AKUN PENGGUNA UTAMA                       │
│                   (misal: hd.doko22@gmail.com)                  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
     🏢 ORGANISASI: Mari Partner       🏢 ORGANISASI: Klien Lain
     (Team, Billing, SSO, Integrations)
                 │
         ┌───────┴───────────────────────┐
         ▼                               ▼
  🚀 PROJECT: marifin-backend     🚀 PROJECT: mariflow-backend
  (Postgres, Auth, Storage, etc.)
         │
         ▼
  🗄️ DATABASE SCHEMA (public)
  (profiles, workspaces, tasks, etc.)
```

---

## 🚀 2. Anatomi Form Pembuatan Project Baru (*Create a New Project*)

Berdasarkan 4 tangkapan layar form `Create a new project`:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                     FORM CREATE A NEW PROJECT                           │
├───────────────────────┬─────────────────────────────────────────────────┤
│ Organization          │ Mari Partner (FREE)                             │
│ GitHub (optional)     │ Link repository hndko/app_mariflow_vue          │
│ Project Name          │ mariflow-backend                                │
│ Database Password     │ Generate strong password (Simpan di aman)       │
│ Region                │ Southeast Asia (Singapore) ap-southeast-1 🇸🇬    │
│ Security - Data API   │ ☑️ Enable Data API                              │
│ Security - Expose     │ ☑️ Automatically expose new tables              │
│ Security - Auto RLS   │ ☑️ Enable automatic RLS (Event Trigger)         │
└───────────────────────┴─────────────────────────────────────────────────┘
```

### 2.1 Pemilihan Region Database Terbaik

Supabase menyediakan puluhan region data center AWS di seluruh dunia.

> [!IMPORTANT]
> **Rekomendasi Mutlak untuk Indonesia & Asia Tenggara**:
> **Pilih `Southeast Asia (Singapore) ap-southeast-1`** 🇸🇬.
> - **Latensi**: Tercepat dari Indonesia (~15-25 ms) karena jalur kabel fiber optik bawah laut langsung ke Singapura.
> - Region Tokyo (`ap-northeast-1`) atau Seoul (`ap-northeast-2`) memiliki latensi lebih tinggi (~80-120 ms dari Jakarta).

---

### 2.2 Konfigurasi Opsi Security & Automatic RLS Trigger

Tiga opsi keamanan di bagian bawah form:

1. ☑️ **Enable Data API** *(WAJIB CENTANG)*:
   - Membuat RESTful API otomatis untuk schema `public` sehingga frontend Vue 3 (`@supabase/supabase-js`) bisa berkomunikasi langsung dengan database.
2. ☑️ **Automatically expose new tables** *(CENTANG)*:
   - Memberikan hak istimewa API pada setiap tabel baru yang Anda buat.
3. ☑️ **Enable automatic RLS** *(SANGAT DIREKOMENDASIKAN DICENTANG)*:
   - Memasang PostgreSQL Event Trigger yang otomatis mengaktifkan **Row Level Security (RLS)** pada setiap tabel baru. Ini menjamin keamanan 100% agar tabel tidak pernah terekspos tanpa proteksi otorisasi secara tidak sengaja.

---

### 2.3 Integrasi GitHub Repository

- **GitHub (optional)**: Anda dapat memilih repository `hndko/app_mariflow_vue`.
- **Manfaat**: Memungkinkan integrasi pipeline otomatis (*agent-first workflow*), di mana setiap kali file SQL di folder `supabase/migrations/` diperbarui dan di-push ke GitHub, Supabase akan langsung mengaplikasikan migrasi tersebut ke database server!

---

## 🖥️ 3. Anatomi Menu Organisasi — Bagian 1

- **Projects**: Daftar instance database aktif.
- **Team**: Mengelola akses developer (Owner, Administrator, Developer).
- **Integrations**: GitHub & Vercel Auto-sync Environment Variables.

---

## ⚙️ 4. Anatomi Menu Organisasi — Bagian 2

- **Data Privacy**: Pilihan **Schema Only** direkomendasikan agar Supabase AI di SQL Editor memahami nama tabel kita tanpa membaca data privat.
- **Security & MFA**: Pengaturan 2FA akun developer.
- **OAuth Apps**: Integrasi aplikasi pihak ketiga.

---

## 📜 5. Anatomi Menu Organisasi — Bagian 3

- **Compliance & Legal**: DPA, TIA, SOC2, ISO 27001 (Kepatuhan GDPR).
- **Usage Metrics**: Database Size (500 MB), Egress (5 GB), MAU (50.000), Realtime Peak Connections (200), Realtime Messages (2 Juta).

---

## 🎯 6. Panduan Langkah-demi-Langkah Pengisian Form untuk MariFlow

Saat Anda mengisi form di layar tersebut, ikuti panduan berikut:

1. **Organization**: Biarkan terpilih `Mari Partner (FREE)`.
2. **GitHub (optional)**: Pilih repository `app_mariflow_vue` (jika sudah terhubung).
3. **Project Name**: Ketik `mariflow-dev`.
4. **Database Password**:
   - Klik **Generate a password**.
   - **PENTING**: Salin dan simpan kata sandi ini di catatan aman Anda.
5. **Region**:
   - Klik dropdown `Asia-Pacific` ➔ Pilih **`Southeast Asia (Singapore) ap-southeast-1`**.
6. **Security**:
   - Pastikan **Enable Data API** dicentang (☑️).
   - Pastikan **Automatically expose new tables** dicentang (☑️).
   - Centang juga **Enable automatic RLS** (☑️).
7. Klik tombol hijau **`Create new project`**.
8. Tunggu proses provisi server (~1-2 menit) hingga status menjadi **Healthy**.

---

## 🖥️ 8. Anatomi Lengkap Project Dashboard (`Project Overview`)

Berdasarkan tangkapan layar antarmuka dashboard project `mariflow-dev`, berikut adalah penjelasan komprehensif seluruh komponennya:

```text
┌───────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚡ Mari Partner [FREE] / 📦 mariflow-dev / 🌿 main [PRODUCTION]            [Connect] [Search Ctrl+K]│
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                   │
│  mariflow-dev                                       ┌──────────────────────────────────────────┐  │
│  https://rtazqheauyiujjteburi.supabase.co [Copy]    │ 🗄️ Primary Database                      │  │
│                                                     │ Southeast Asia (Singapore) ap-southeast-1│  │
│  🟢 STATUS: Healthy      ⚙️ COMPUTE: NANO           │ CPU 2%  │ Disk 14% │ RAM 49% │ 5/60 conns │  │
│  🐙 GITHUB: No repo      🌱 BRANCH: No branches     └──────────────────────────────────────────┘  │
│  📜 MIGRATION: 0         💾 BACKUP: No backups                                                    │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  🔌 GET CONNECTED:                                                                                │
│  [Framework]  [Server]  [Direct]  [ORM]  [MCP (AI Agent)]  [API Keys]                             │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  📊 METRICS (Last 60 mins):  12 Total Requests │ 91.7% Success Rate                               │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                  │
│  │ 🌐 API GATEWAY  │ │ 📡 REALTIME     │ │ 📦 STORAGE      │ │ 🗄️ POSTGRES     │                  │
│  │ 5 Requests      │ │ 4 Requests      │ │ 2 Requests      │ │ 1 Request       │                  │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                  │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  🛡️ SECURITY & ADVISOR: Advisor found no issues (No security or performance issues found)        │
│  📈 REPORTS: Build custom reports & query snippets                                                │
└───────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 8.1 Kartu Status Utama (*Project Header & Compute Health*)

1. **Project URL (`https://rtazqheauyiujjteburi.supabase.co`)**:
   - URL endpoint HTTPS dasar untuk seluruh REST API, Auth, dan Storage requests dari frontend MariFlow.
2. **Compute Tier (`NANO`)**:
   - Tingkat mesin komputasi virtual PostgreSQL Anda. Nano menyediakan resource yang sangat efisien untuk pengembangan dan tim kecil.
3. **Primary Database Health Widget**:
   - **`CPU 2%`**: Beban komputasi prosesor server database. Sangat enteng.
   - **`Disk 14%`**: Ruang penyimpanan disk SSD terpakai dari kuota 500 MB Free Tier.
   - **`RAM 49%`**: Memori PostgreSQL terpakai (~500 MB RAM).
   - **`5/60 conns`**: Jumlah koneksi database aktif saat ini (5 dari batas maksimal 60 koneksi langsung).

---

### 8.2 Bagian "Get Connected" (*Pintu Masuk Integrasi*)

Pada kartu **Get connected**, Supabase menyediakan 6 jalur integrasi utama:

1. **`Framework` (Client Library)**:
   - Menampilkan snippet inisialisasi `@supabase/supabase-js` untuk framework modern (Vue 3, React, Next.js, Flutter, Swift, Svelte). Inilah yang kita gunakan di `src/services/supabase.ts`.
2. **`Server` (API Handlers)**:
   - Panduan membuat API route aman di backend server (Express, NestJS, Laravel, FastAPI).
3. **`Direct` (Connection String)**:
   - URI koneksi database PostgreSQL standar (`postgresql://postgres:[PASSWORD]@db.rtazqheauyiujjteburi.supabase.co:5432/postgres`) untuk software database GUI seperti DBeaver, TablePlus, Navicat, atau pgAdmin.
4. **`ORM` (Object-Relational Mapping)**:
   - Konfigurasi untuk Prisma ORM, Drizzle, Kysely, TypeORM, atau Sequelize.
5. **`MCP` (Model Context Protocol)**:
   - **Fitur Baru Supabase**: Protokol standar terbuka yang memungkinkan AI Coding Agent (seperti Antigravity, Claude Code, Cursor) terhubung dan berinteraksi langsung dengan database Supabase secara cerdas dan aman!
6. **`API Keys` (Kunci Kredensial Project)**:
   - Kartu cepat untuk melihat dan menyalin **`anon` (public key)** untuk frontend dan **`service_role` (secret key)** untuk backend.

---

### 8.3 4 Pilar Metrik Layanan (*Service Metrics*)

Supabase membagi aktivitas sistem ke dalam 4 pilar visual:
1. **🌐 API GATEWAY**:
   - Mengukur jumlah request REST API yang masuk via PostgREST (contoh: query tabel `workspaces`, `tasks`, `projects`).
2. **📡 REALTIME**:
   - Mengukur koneksi WebSocket live yang menyinkronkan data tugas kanban secara instan ke layar pengguna lain tanpa perlu refresh halaman.
3. **📦 STORAGE**:
   - Mengukur request upload/download berkas avatar dan lampiran tugas kanban ke Supabase Storage S3-compatible engine.
4. **🗄️ POSTGRES**:
   - Mengukur query langsung dan transaksi database PostgreSQL murni.

---

### 8.4 Security & Performance Advisor

Supabase memiliki mesin audit internal pintar bernama **Supabase Advisor**:
- **Security Advisor**: Secara berkala memeriksa apakah ada tabel publik tanpa Row Level Security (RLS), kolom sensitif yang terekspos, atau policy yang bocor (`USING (true)`).
- **Performance Advisor**: Menganalisis query lambat (*slow queries*), merekomendasikan penambahan index pada foreign key yang sering difilter, serta mendeteksi query vacuum/bloat.
- **Ask Assistant**: Tombol asisten AI interaktif bawaan Supabase untuk membantu Anda menulis query SQL rumit atau memecahkan kendala database.

---

## 🧭 9. Anatomi Lengkap 13 Menu Sidebar Kiri (*Project Level*)

```text
┌────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│ Menu Sidebar                           │ Fungsi Utama & Keterkaitannya dengan MariFlow          │
├────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 🏠 1. Project Overview                 │ Ringkasan status, URL, compute health, & traffic.       │
│ 🗃️ 2. Table Editor                     │ Visual Spreadsheet editor untuk melihat & edit data DB.│
│ 💻 3. SQL Editor                       │ Menjalankan file migrasi SQL DDL & DML skema MariFlow. │
│ 🗄️ 4. Database                         │ Schema visualizer, foreign keys, triggers, RPC func.   │
│ 🔑 5. Authentication                   │ User management, Email OTP, OAuth, & Redirect URLs.    │
│ 📦 6. Storage                          │ Bucket file uploads (`avatars`, `task-attachments`).   │
│ ⚡ 7. Edge Functions                   │ Serverless function Deno untuk webhook / background job│
│ 📡 8. Realtime                         │ Konfigurasi realtime channel broadcast & Postgres sync.│
│ 💡 9. Advisors                         │ Laporan keamanan RLS & rekomendasi performa query.     │
│ 🔭 10. Observability                   │ Grafik latency, throughput, & pooler connection stats. │
│ 📋 11. Logs                            │ Catatan log request API Gateway, Database, & Auth.     │
│ 🧩 12. Integrations                    │ Menghubungkan GitHub, Vercel, Resend email SMTP, dll.  │
│ ⚙️ 13. Project Settings                │ Konfigurasi API keys, Connection Pooling, & Timezone.  │
└────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

---

## 🗃️ 10. Bedah Lengkap Menu Table Editor & Modal "Create a New Table"

Menu **Table Editor** (icon 🗃️ pada sidebar) adalah spreadsheet visual interaktif Supabase untuk mengelola dan memvisualisasikan data tabel PostgreSQL tanpa perlu menulis query SQL manual.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🗃️ Table Editor  [schema public ▼]  [+ New table]  [🔍 Search tables...]                           │
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────┤
│                          │  ┌───────────────────────────────────────────────────────────────────┐  │
│  DAFTAR TABEL:           │  │ ➕ Create a table (Design & create a new database table)           │  │
│  (No tables or views)    │  └───────────────────────────────────────────────────────────────────┘  │
│                          │                                                                         │
│  - profiles              │  🕒 RECENT ITEMS: No recent items yet                                   │
│  - workspaces            │                                                                         │
│  - workspace_members     │  ┌───────────────────────────────────────────────────────────────────┐  │
│  - projects              │  │ 💡 NEW FEATURE: Queue row edits in Table Editor                   │  │
│  - tasks                 │  │ Batch multiple row edits and review them before saving to database│  │
│                          │  └───────────────────────────────────────────────────────────────────┘  │
└──────────────────────────┴─────────────────────────────────────────────────────────────────────────┘
```

---

### 10.1 Komponen Halaman Utama Table Editor

1. **Dropdown Pemilih Schema (`schema public ▼`)**:
   - **`public`**: Schema utama tempat tabel aplikasi MariFlow berada (`profiles`, `workspaces`, `tasks`, dll).
   - **`auth`**: Schema privat milik Supabase Auth (`auth.users`, `auth.identities`, `auth.sessions`).
   - **`storage`**: Schema internal sistem penyimpanan file (`storage.buckets`, `storage.objects`).
   - **`realtime`**: Schema replikasi pesan WebSocket.
   - **`vault`**: Schema penyimpanan rahasia terenkripsi.

2. **Fitur "Queue row edits in Table Editor" (Batch Editing)**:
   - Fitur cerdas yang memungkinkan Anda mengedit puluhan sel data sekaligus layaknya Excel/Airtable secara offline di browser.
   - Perubahan akan di-review terlebih dahulu sebelum dikirim bersamaan (*atomic batch update*) ke server PostgreSQL. Hal ini mencegah terjadinya database lock dan request spam ke database.

---

### 10.2 Anatomi Modal Drawer "Create a new table under public"

Saat tombol **`+ New table`** diklik, Supabase membuka drawer konfigurasi tabel:

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Create a new table under public                                                               [X]  │
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                    │
│  Name:        [ workspaces                                                               ]         │
│  Description: [ Workspace multi-tenant untuk tim MariFlow                                ] (Opt)   │
│                                                                                                    │
│  ☑️ Enable Row Level Security (RLS)  [RECOMMENDED]                                                 │
│     Restrict access to your table by enabling RLS and writing Postgres policies.                   │
│                                                                                                    │
│  ┌──────────────────────────────────────────────────────────────────────────────────────────────┐  │
│  │ ℹ️ Policies are required to query data                                                       │  │
│  │    You need to create an access policy before you can query data from this table.            │  │
│  │    Without a policy, querying this table will return an empty array of results.              │  │
│  │    [ 📖 Documentation ]                                                                      │  │
│  └──────────────────────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                                    │
│  ☐ Enable Realtime                                                                                 │
│     Broadcast changes on this table to authorized subscribers.                                     │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  COLUMNS                                       [ 📖 About data types ]  [ 📥 Import data from CSV ]│
│  ┌──┬──────────────┬──────────────┬──────────────────┬──────────────┬───────────────────────────┐  │
│  │::│ Name         │ Type         │ Default Value    │ Primary (PK) │ Options (Gear)            │  │
│  ├──┼──────────────┼──────────────┼──────────────────┼──────────────┼───────────────────────────┤  │
│  │::│ id           │ uuid         │ uuid_generate_v4()│     ☑️       │ Is Unique: Yes            │  │
│  │::│ name         │ text         │ NULL             │     ☐        │ Is Nullable: No           │  │
│  │::│ slug         │ text         │ NULL             │     ☐        │ Is Unique: Yes            │  │
│  │::│ created_at   │ timestamptz  │ now()            │     ☐        │                           │  │
│  └──┴──────────────┴──────────────┴──────────────────┴──────────────┴───────────────────────────┘  │
│  [ + Add column ]                                                                                  │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  FOREIGN KEYS                                                                                      │
│  [ + Add foreign key relation ] ➔ (Contoh: owner_id REFERENCES auth.users(id) ON DELETE CASCADE)   │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  DATA API ACCESS                                                                                   │
│  (🔘 ON) Allow this table to be queried via Supabase client libraries or the API directly          │
│                                                                                                    │
│                                                                               [Cancel] [Save Ctrl↵]│
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 10.3 Penjelasan Detail Tiap Opsi Pembuatan Tabel

#### 1. 🛡️ Enable Row Level Security (RLS) [RECOMMENDED]
- **Fungsi**: Mengaktifkan proteksi tingkat baris (*Row Level Security*) pada tabel PostgreSQL.
- **Mengapa Sangat Penting?**:
  - Di Supabase, jika RLS aktif dan belum ada policy dibuat, maka **seluruh query dari client frontend akan mengembalikan array kosong (`[]`)**.
  - Ini adalah desain keamanan *Secure by Default* agar data sensitif pengguna tidak bocor ke publik.
  - Untuk MariFlow, setiap tabel wajib memiliki policy berbasis keanggotaan `workspace_members`.

#### 2. 📡 Enable Realtime
- **Fungsi**: Memasukkan tabel ke dalam publikasi PostgreSQL `supabase_realtime`.
- **Penggunaan di MariFlow**:
  - Wajib dicentang untuk tabel **`tasks`** dan **`task_comments`** agar perpindahan kartu kanban dan komentar baru langsung muncul di layar anggota tim lain secara realtime tanpa perlu reload browser!

#### 3. 🧩 Columns Builder (Definisi Kolom Data)
- **`Name`**: Nama kolom dengan aturan baku huruf kecil (*snake_case*).
- **`Type`**: Tipe data PostgreSQL:
  - `uuid`: Identifier unik global (128-bit) yang aman dari tebakan ID sekuensial.
  - `text` / `varchar`: String teks dinamis.
  - `timestamptz`: Tanggal & waktu lengkap beserta timezone (UTC).
  - `bool`: Nilai boolean (`true` / `false`).
  - `jsonb`: Struktur data JSON biner untuk metadata fleksibel.
  - `int8` / `int4`: Bilangan bulat (*integer*).
- **`Default Value`**:
  - `now()`: Otomatis mengisi waktu saat data dibuat.
  - `uuid_generate_v4()`: Otomatis menghasilkan ID UUID acak.
- **`Primary (PK)`**: Menandai kolom sebagai kunci primer unik tabel.
- **`Options (Gear Icon)`**:
  - `Is Unique`: Memastikan tidak ada data duplikat pada kolom tersebut (misal: `slug` workspace).
  - `Is Array`: Mendukung penyimpanan array (misal: `text[]`).

#### 4. 🔗 Foreign Keys Relation
- **Fungsi**: Membangun integritas referensial antar tabel di PostgreSQL.
- **Aksi Penghapusan (*Action on Delete*)**:
  - **`CASCADE`**: Jika baris induk dihapus, seluruh baris anak otomatis terhapus (contoh: jika sebuah *Workspace* dihapus, semua *Proyek* dan *Tugas* di dalamnya otomatis terhapus bersih).
  - **`SET NULL`**: Jika baris induk dihapus, kolom anak disetel menjadi `NULL` (contoh: jika user dihapus, kolom `assigned_to` pada tugas menjadi kosong tapi tugas tidak ikut terhapus).
  - **`RESTRICT`**: Mencegah penghapusan baris induk jika masih memiliki data anak terkait.

#### 5. 🌐 Data API Access Toggle Switch
- **Fungsi**: Menentukan apakah tabel ini otomatis diekspos ke REST PostgREST API dan SDK `@supabase/supabase-js`.
- **Status Default (ON)**: Wajib aktif agar frontend MariFlow dapat melakukan query `supabase.from('tasks').select('*')`.

---

## 💎 11. Matriks Komparasi: FREE Tier vs PRO Tier (Panduan Batasan & Skalabilitas)

Karena saat ini kita menggunakan **FREE Tier** di organisasi `Mari Partner`, berikut adalah panduan lengkap fitur yang **Bebas Digunakan Gratis** vs fitur yang **Terkunci di Paket PRO ($25/bulan)**:

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🟢 FREE TIER (Paket MariFlow Saat Ini)          vs          🔒 PRO TIER ($25/bulan)                    │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 💾 500 MB Database PostgreSQL Storage                       💾 8 GB Database Storage Included          │
│ ⚙️ Compute NANO (Shared CPU, 0.5 GB RAM)                    ⚙️ Micro / Small / Medium Dedicated Compute │
│ ⏸️ Auto-pause setelah 7 hari tidak aktif                    🚫 Bebas Pause (Selalu Aktif 24/7)         │
│ 📦 1 GB Storage Buckets (File Max 50 MB)                    📦 100 GB Storage Buckets (File Max 5 GB)  │
│ 📡 200 Realtime Concurrent Connections                      📡 500 Realtime Concurrent Connections     │
│ 🔑 50,000 Monthly Active Users (MAU)                        🔑 100,000 MAU + SAML SSO (Okta / Azure)   │
│ ⚡ 500,000 Edge Function Invocations/bln                    ⚡ 2,000,000 Invocations/bln               │
│ 📋 1 Hari Log Retention                                     📋 7 Hari Log Retention + PITR Backup      │
│ 🌿 1 Branch Produksi (Main)                                 🌿 Database Branching per Pull Request     │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 11.1 Rincian Fitur Bebas Pakai di FREE Tier (Cukup untuk Pengembangan & MVP)

1. **Database PostgreSQL Penuh**:
   - Bebas membuat tabel, skema, foreign key, triggers, views, dan RPC stored procedures tanpa batas jumlah tabel.
2. **Row Level Security (RLS)**:
   - 100% didukung penuh tanpa batasan pada Free Tier.
3. **Supabase Auth (Otentikasi)**:
   - Mendukung login Email/Password, Magic Link, dan Social Login OAuth (Google, GitHub, Discord, dll) hingga 50.000 pengguna aktif per bulan.
4. **Realtime WebSockets**:
   - Hingga 200 pengguna online bersamaan (*concurrent connections*) yang memantau Kanban board MariFlow secara sinkron.
5. **Storage Buckets**:
   - Hingga 1 GB total kapasitas berkas avatar dan lampiran dokumen tugas (ukuran per file maksimal 50 MB).

---

### 11.2 Daftar Fitur Eksklusif PRO TIER 🔒 (Wajib Diperhatikan)

Jika Anda melihat tombol atau opsi berikut di dashboard Supabase, fitur tersebut **memerlukan langganan PRO**:

| Fitur | Status Tier | Dampak & Alternatif untuk MariFlow (FREE) |
| :--- | :---: | :--- |
| **Point-in-Time Recovery (PITR)** | 🔒 **PRO** | Rollback database ke detik tertentu. Di Free Tier, gunakan ekspor SQL berkala via SQL Editor / CLI. |
| **Database Branching** | 🔒 **PRO** | Membuat clone database terpisah per Git Pull Request. Di Free Tier, gunakan Supabase Local CLI Docker untuk staging. |
| **Image Transformation (`/render/image/`)** | 🔒 **PRO** | Resize & kompresi gambar on-the-fly dari URL Storage. Di Free Tier, kompres gambar di sisi frontend Vue sebelum upload. |
| **Custom Domain Auth (auth.mariflow.com)** | 🔒 **PRO** | Menghilangkan URL `supabase.co` pada email verifikasi. Di Free Tier, gunakan redirect URL frontend. |
| **SAML 2.0 / Enterprise SSO** | 🔒 **PRO** | Login via Okta, Azure AD, OneLogin untuk perusahaan korporat besar. |
| **Log Retention > 1 Hari** | 🔒 **PRO** | Free Tier menyimpan log API Gateway & Postgres selama 24 jam terakhir. |
| **Inactivity Auto-pause** | ⚠️ **FREE Note** | Jika database tidak menerima query selama **7 hari berturut-turut**, project akan otomatis tidur (*paused*). Cukup klik tombol **Restore** di dashboard untuk membangunkannya kembali tanpa kehilangan data. |

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*



