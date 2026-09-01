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
12. [Bedah Lengkap Menu SQL Editor (Query Builder, AI Assistant & Chart Visualizer)](#-12-bedah-lengkap-menu-sql-editor-query-builder-ai-assistant--chart-visualizer)
    - [12.1 Anatomi Panel Kiri (Snippet Manager & References)](#121-anatomi-panel-kiri-snippet-manager--references)
    - [12.2 Fitur Unggulan Editor & Supabase AI (Ctrl+Shift+K)](#122-fitur-unggulan-editor--supabase-ai-ctrlshiftk)
    - [12.3 Panel Hasil Eksekusi: Tab Results & Chart](#123-panel-hasil-eksekusi-tab-results--chart)
13. [Bedah Komprehensif Menu Database (Schema Visualizer, Functions, Triggers & Access Control)](#-13-bedah-komprehensif-menu-database-schema-visualizer-functions-triggers--access-control)
    - [13.1 Kelompok 1: DATABASE MANAGEMENT (ERD, Functions RPC, Triggers, Enums, Extensions, Indexes, Publications)](#131-kelompok-1-database-management)
    - [13.2 Kelompok 2: ACCESS CONTROL (Policies RLS, Database Roles)](#132-kelompok-2-access-control)
    - [13.3 Kelompok 3: CONFIGURATION & PLATFORM (Settings, Replication, Backups, Migrations)](#133-kelompok-3-configuration--platform)
14. [Panduan Lengkap Ekstensi PostgreSQL (Database Extensions Masterclass)](#-14-panduan-lengkap-ekstensi-postgresql-database-extensions-masterclass)
    - [14.1 Mengapa Supabase Menggunakan Schema extensions?](#141-mengapa-supabase-menggunakan-schema-extensions)
    - [14.2 4 Ekstensi Utama yang Wajib Aktif untuk MariFlow](#142-4-ekstensi-utama-yang-wajib-aktif-enabled-by-default-untuk-mariflow)
    - [14.3 Ekstensi Pilihan SaaS Paling Berguna untuk Fitur Lanjutan](#143-ekstensi-pilihan-saas-paling-berguna-untuk-pengembangan-fitur-lanjutan)
    - [14.4 Cara Mengaktifkan Ekstensi via SQL Script](#144-cara-mengaktifkan-ekstensi-via-sql-script)

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

## 💻 12. Bedah Lengkap Menu SQL Editor (Query Builder, AI Assistant & Chart Visualizer)

Menu **SQL Editor** (icon `>_` pada sidebar) adalah pusat eksekusi perintah DDL (*Data Definition Language*) dan DML (*Data Manipulation Language*) PostgreSQL langsung di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 💻 SQL Editor   [+ New]   [🔍 Search queries...]           [♡] [≡] [🗄️ Database ▼] [Save Ctrl+S] [▶ Run Ctrl↵]│
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ 📁 SNIPPET ORGANIZER:    │ 1  -- Hit CTRL+SHIFT+K to generate query with Supabase AI                  │
│                          │ 2  SELECT                                                                   │
│  > SHARED (Team Snippets)│ 3      w.name AS workspace_name,                                            │
│  > FAVORITES (Starred)   │ 4      COUNT(t.id) AS total_tasks,                                          │
│  v PRIVATE               │ 5      COUNT(t.id) FILTER (WHERE t.status = 'completed') AS completed_tasks │
│    - 01_schema_ddl.sql   │ 6  FROM public.workspaces w                                                 │
│    - 02_rpc_analytics.sql│ 7  LEFT JOIN public.tasks t ON t.workspace_id = w.id                        │
│    - master_seed.sql     │ 8  GROUP BY w.id, w.name;                                                   │
│  > LOGS (Query History)  │                                                                             │
│                          ├─────────────────────────────────────────────────────────────────────────────┤
│ 📚 REFERENCE:            │ [📊 Results]  [📈 Chart]                                                    │
│  - Templates             ├──────────────────────────────────────────┬─────────────┬────────────────────┤
│  - Examples              │ workspace_name                           │ total_tasks │ completed_tasks    │
│                          ├──────────────────────────────────────────┼─────────────┼────────────────────┤
│  [View running queries]  │ Mari Partner Main Hub                    │ 11          │ 3                  │
│                          │ Client Projects & Marketing              │ 4           │ 2                  │
└──────────────────────────┴──────────────────────────────────────────┴─────────────┴────────────────────┘
```

---

### 12.1 Anatomi Panel Kiri (*Snippet Manager & References*)

1. **`SHARED` (Team Snippets)**:
   - Folder snippet SQL yang dapat dibaca dan dieksekusi oleh seluruh anggota tim di organisasi `Mari Partner`.
2. **`FAVORITES` (Starred Queries)**:
   - Tempat menyimpan query SQL yang sering Anda jalankan untuk pemeliharaan rutin atau audit metrik.
3. **`PRIVATE`**:
   - Workspace query pribadi akun Anda. Seluruh query yang Anda ketik akan **otomatis tersimpan (*auto-saved*)**.
4. **`LOGS` (Riwayat Eksekusi)**:
   - Menyimpan riwayat query yang pernah Anda jalankan sebelumnya, sangat berguna jika Anda ingin mengulang atau menelusuri query yang belum sempat di-bookmark.
5. **`REFERENCE` (`Templates` & `Examples`)**:
   - Kumpulan template SQL resmi bawaan Supabase:
     - *Quickstart RLS Policies* (Contoh kebijakan multi-tenant).
     - *Database Webhooks* (Trigger HTTP POST saat ada perubahan data).
     - *Stripe Billing Sync* (Skema langganan SaaS).
     - *Cron Scheduled Jobs* (`pg_cron` otomatisasi berkala).
6. **Tombol `View running queries` (`pg_stat_activity`)**:
   - Menampilkan daftar transaksi SQL yang sedang berjalan di PostgreSQL. Jika terjadi query berat yang macet (*stuck*), Anda dapat membatalkannya (*terminate/cancel backend*) dari modal ini.

---

### 12.2 Fitur Unggulan Editor & Supabase AI (`Ctrl+Shift+K`)

1. **Supabase AI Assistant (`Ctrl + Shift + K`)**:
   - Asisten kecerdasan buatan bawaan Supabase. Anda cukup mengetikkan prompt bahasa manusia (contoh: *"Buatkan query untuk menghitung persentase penyelesaian tugas per proyek"*), dan AI akan otomatis mengonversinya menjadi sintaks SQL PostgreSQL yang optimal.
2. **Target Connection Selector (`Database ▼`)**:
   - Memilih jalur koneksi eksekusi query:
     - **Direct Connection**: Koneksi langsung ke engine PostgreSQL (Port 5432).
     - **Connection Pooler (Supavisor)**: Koneksi melalui Transaction Pooler (Port 6543) yang hemat memori untuk query concurrent tinggi.
3. **Shortcut Eksekusi**:
   - **`Ctrl + ↵` (Windows)** / **`Cmd + ↵` (Mac)**: Menjalankan seluruh query atau blok teks yang sedang di-blok (*highlighted*).
   - **`Ctrl + S`**: Menyimpan query tab ke Snippet Organizer.

---

### 12.3 Panel Hasil Eksekusi: Tab `Results` & `Chart`

Supabase menyediakan dua tab visualisasi hasil query:

1. **Tab `Results` (Data Grid)**:
   - Menampilkan baris data dalam format tabel interaktif.
   - Dilengkapi tombol **Copy as CSV / JSON** untuk kemudahan ekspor data analisis.
   - Menampilkan durasi eksekusi query (contoh: `Success. 11 rows returned in 18ms`).
2. **Tab `Chart` (Visualisasi Grafik Instan)**:
   - **Fitur Cerdas**: Supabase secara otomatis dapat mengubah hasil query numerik menjadi grafik visual (**Bar Chart**, **Line Chart**, atau **Area Chart**) langsung di browser tanpa perlu menginstal aplikasi BI eksternal!

---

## 🗄️ 13. Bedah Komprehensif Menu Database (Schema Visualizer, Functions, Triggers & Access Control)

Menu **Database** (icon 🗄️ pada sidebar) adalah pusat kendali tingkat rendah (*low-level engine controller*) PostgreSQL di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🗄️ Database  [schema public ▼]                                                                         │
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ 📂 DATABASE MANAGEMENT:  │                                                                             │
│  - Schema Visualizer     │  ┌───────────────────────────────────────────────────────────────────────┐  │
│  - Tables                │  │ 🗺️ SCHEMA VISUALIZER (ER Diagram Interaktif)                          │  │
│  - Functions (RPC)       │  │                                                                       │  │
│  - Triggers              │  │  [workspaces] ────────1:N──────── [projects]                          │  │
│  - Enumerated Types      │  │        │                              │                               │  │
│  - Extensions            │  │        1:N                            1:N                             │  │
│  - Indexes               │  │        ▼                              ▼                               │  │
│  - Publications          │  │  [workspace_members]                  [tasks] ───1:N─── [task_comments]│  │
│                          │  └───────────────────────────────────────────────────────────────────────┘  │
│ 🛡️ ACCESS CONTROL:       │                                                                             │
│  - Policies (RLS)        │  ⚡ DATABASE FUNCTIONS (RPC):                                               │
│  - Roles (Postgres)      │  - rls_auto_enable (Definer)                                                │
│                          │  - get_role_dashboard_analytics (RPC KPI Analytics)                         │
│ ⚙️ CONFIGURATION:        │  - set_updated_at (Trigger Function)                                       │
│  - Settings              │                                                                             │
│                          │  🔔 DATABASE TRIGGERS:                                                      │
│ 🚀 PLATFORM:             │  - set_profiles_updated_at (BEFORE UPDATE ON profiles)                      │
│  - Replication [NEW]     │  - set_tasks_updated_at (BEFORE UPDATE ON tasks)                            │
│  - Backups               │                                                                             │
│  - Migrations            │                                                                             │
└──────────────────────────┴─────────────────────────────────────────────────────────────────────────────┘
```

---

### 13.1 Kelompok 1: DATABASE MANAGEMENT

#### 1. 🗺️ Schema Visualizer (Entity-Relationship Diagram Interaktif)
- **Fungsi**: Secara otomatis menggambar diagram relasi database (ERD) visual dengan menghubungkan tabel, kolom Primary Key (PK), dan Foreign Key (FK) garis penghubung secara interaktif.
- **Keterkaitannya dengan MariFlow**:
  - Anda dapat melihat peta relasi utuh dari `profiles` ➔ `workspace_members` ➔ `workspaces` ➔ `projects` ➔ `tasks` ➔ `task_comments` tanpa perlu aplikasi diagram eksternal seperti Draw.io atau DBeaver.

#### 2. 📋 Tables (Dashboard Metrik Tabel)
- **Fungsi**: Menampilkan daftar seluruh tabel dalam skema beserta metrik penting:
  - `COLUMNS`: Jumlah kolom pada tabel.
  - `ROWS (ESTIMATED)`: Perkiraan jumlah baris data yang tersimpan.
  - `SIZE (ESTIMATED)`: Perkiraan ukuran memori disk terpakai oleh tabel (dalam KB/MB).
  - `REALTIME`: Menandai apakah tabel telah aktif di replikasi WebSocket `supabase_realtime`.

#### 3. ⚡ Functions (Database Stored Procedures & Supabase RPC)
- **Fungsi**: Menyimpan fungsi PL/pgSQL atau SQL yang dapat dipanggil langsung dari frontend Vue via `supabase.rpc('function_name', { params })`.
- **Parameter Keamanan (*Security Context*)**:
  - **`SECURITY DEFINER`**: Fungsi dieksekusi dengan hak akses pemilik (*superuser/postgres*), mengabaikan RLS sementara. Sangat berguna untuk fungsi agregasi KPI seperti `get_role_dashboard_analytics` agar dapat menghitung total statistik tanpa terhambat batasan baris individual.
  - **`SECURITY INVOKER`**: Fungsi dieksekusi dengan hak akses pengguna yang sedang login (*auth.uid()*).

#### 4. 🔔 Triggers (Pemicu Otomatis)
- **Fungsi**: Mengeksekusi fungsi tertentu secara otomatis saat terjadi event database:
  - **Tab `Data` (DML Triggers)**: Pemicu saat data di-`INSERT`, `UPDATE`, atau `DELETE`. Contoh: Trigger `set_updated_at()` yang otomatis memperbarui nilai kolom `updated_at` menjadi waktu sekarang setiap kali kartu tugas diedit.
  - **Tab `Event` (DDL Triggers)**: Pemicu saat struktur skema berubah (`CREATE TABLE`, `DROP TABLE`). Contoh: `rls_auto_enable` yang otomatis mengaktifkan RLS saat tabel baru dibuat.
  - **Database Webhooks**: Memanggil HTTP REST endpoint eksternal saat data berubah (misal: mengirim pesan Telegram / Slack saat tugas baru dibuat).

#### 5. 🏷️ Enumerated Types (Custom ENUM Postgres)
- **Fungsi**: Menyimpan daftar tipe data pilihan kustom yang konsisten di level database:
  - `workspace_role`: `'owner'`, `'admin'`, `'member'`, `'viewer'`
  - `project_status`: `'planning'`, `'active'`, `'completed'`, `'archived'`
  - `task_status`: `'todo'`, `'in_progress'`, `'review'`, `'completed'`, `'cancelled'`
  - `task_priority`: `'low'`, `'medium'`, `'high'`, `'urgent'`
  - `user_role`: `'superadmin'`, `'owner'`, `'admin'`, `'member'`, `'viewer'`

#### 6. 🔌 Extensions (Ekstensi Ekosistem PostgreSQL)
- **Fungsi**: Mengaktifkan modul tambahan PostgreSQL dengan sekali klik (tanpa kompilasi server):
  - `uuid-ossp`: Menghasilkan UUID v4 (`uuid_generate_v4()`).
  - `pgcrypto`: Algoritma hashing kata sandi bcrypt (`crypt()`, `gen_salt()`).
  - `pgvector`: Penyimpanan vector embedding berkecepatan tinggi untuk fitur AI Search / LLM RAG.
  - `pg_cron`: Menjalankan scheduled cron job langsung di dalam database PostgreSQL.
  - `http`: Melakukan panggilan HTTP request langsung dari fungsi SQL.

#### 7. ⚡ Indexes (Indeks Pengoptimal Query)
- **Fungsi**: Mempercepat query pencarian dan penyaringan data (*filtering*) hingga ratusan kali lipat.
- **Wajib di MariFlow**: Indeks pada foreign key `workspace_id`, `project_id`, dan kolom status `status` serta `created_at DESC` untuk sorting cepat.

#### 8. 📡 Publications (Replikasi Logis Realtime)
- **Fungsi**: Mengatur publikasi PostgreSQL `supabase_realtime` yang menentukan tabel apa saja yang disiarkan ke client WebSocket frontend secara live.

---

### 13.2 Kelompok 2: ACCESS CONTROL

#### 1. 🛡️ Policies (Row Level Security Visual Manager)
- **Fungsi**: Tempat melihat, mengedit, dan mengaudit seluruh aturan RLS PostgreSQL secara visual. Anda dapat melihat policy mana yang aktif untuk operasi `SELECT`, `INSERT`, `UPDATE`, dan `DELETE`.

#### 2. 👥 Roles (PostgreSQL Database Roles)
- **Fungsi**: Hierarki akun sistem PostgreSQL internal:
  - `anon`: Pengguna tamu publik (sebelum login).
  - `authenticated`: Pengguna yang berhasil login dan memiliki token JWT valid.
  - `service_role`: Kunci rahasia backend dengan bypass RLS penuh (Dilarang ditaruh di frontend).
  - `postgres`: Superuser pemilik database.

---

### 13.3 Kelompok 3: CONFIGURATION & PLATFORM

#### 1. ⚙️ Settings (Konfigurasi Engine Postgres)
- Mengatur *Connection Pooling* (Supavisor), SSL mode enforce, parameter waktu *statement timeout* (mencegah query lambat menggantung server), dan zona waktu UTC.

#### 2. 🚀 Platform Tools (`Replication`, `Backups`, `Migrations`)
- **`Replication` [NEW]**: Replikasi data real-time ke database cadangan atau sinkronisasi data lake.
- **`Backups`**:
  - *Free Tier*: Backup manual via ekspor SQL / Supabase CLI.
  - *Pro Tier 🔒*: Backup harian otomatis dengan retensi 7 hari + Point-in-Time Recovery (PITR).
- **`Migrations`**: Riwayat pencatatan versioning skema database yang dieksekusi melalui Supabase CLI (`supabase migration up`).

---

## 🔌 14. Panduan Lengkap Ekstensi PostgreSQL (*Database Extensions Masterclass*)

Menu **Database ➔ Extensions** (icon 🔌) memungkinkan Anda mengaktifkan kemampuan tingkat lanjut (*superpowers*) pada database PostgreSQL hanya dengan satu kali klik toggle atau perintah SQL sederhana.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🔌 Database Extensions  [🔍 Search for an extension...]                                       [📖 Docs]│
├──────────────────────┬─────────┬────────────┬────────────────────────────────────────────┬─────────────┤
│ NAME                 │ VERSION │ SCHEMA     │ DESCRIPTION                                │ ENABLED     │
├──────────────────────┼─────────┼────────────┼────────────────────────────────────────────┼─────────────┤
│ 🟢 pgcrypto          │ 1.3     │ extensions │ Cryptographic functions & password hashing │ (🔘 ON)     │
│ 🟢 uuid-ossp         │ 1.1     │ extensions │ Generate universally unique identifiers    │ (🔘 ON)     │
│ 🟢 pg_stat_statements│ 1.11    │ extensions │ Track execution statistics of SQL queries  │ (🔘 ON)     │
│ 🟢 plpgsql           │ 1.0     │ pg_catalog │ PL/pgSQL procedural programming language   │ (🔘 ON)     │
│ ⚪ pg_net            │ 0.20.4  │ extensions │ Async HTTP client (Used by Webhooks)       │ (⚪ OFF)    │
│ ⚪ pg_cron           │ 1.6.4   │ extensions │ In-database job scheduler for PostgreSQL   │ (⚪ OFF)    │
│ ⚪ pgmq              │ 1.5.1   │ extensions │ Lightweight message queue (like AWS SQS)   │ (⚪ OFF)    │
│ ⚪ pg_hashids        │ 1.3.0   │ extensions │ Generate short alphanumeric YouTube-like ID│ (⚪ OFF)    │
│ ⚪ pgvector          │ 0.8.0   │ extensions │ Vector embeddings for AI & Semantic Search │ (⚪ OFF)    │
└──────────────────────┴─────────┴────────────┴────────────────────────────────────────────┴─────────────┘
```

---

### 14.1 Mengapa Supabase Menggunakan Schema `extensions`?

Secara default di PostgreSQL standar, ekstensi diinstal ke dalam skema `public`. Namun di Supabase, seluruh ekstensi diinstal secara rapi di dalam skema terpisah bernama **`extensions`**.

**Keuntungan Arsitektural**:
1. **Kebersihan Skema `public`**: Mencegah puluhan fungsi internal ekstensi mengotori daftar tabel/fungsi aplikasi MariFlow Anda di Table Editor.
2. **Keamanan Ekstra**: Skema `extensions` tidak diekspos secara publik oleh PostgREST API Gateway, sehingga aman dari potensi eksekusi fungsi kriptografi sewenang-wenang dari frontend.

---

### 14.2 4 Ekstensi Utama yang Wajib Aktif (*Enabled by Default*) untuk MariFlow

1. **`uuid-ossp` (v1.1)**:
   - **Fungsi**: Menyediakan fungsi `uuid_generate_v4()` untuk menghasilkan Primary Key unik global 128-bit pada tabel `workspaces`, `projects`, `tasks`, dan `comments`.
2. **`pgcrypto` (v1.3)**:
   - **Fungsi**: Menyediakan algoritma kriptografi canggih seperti `crypt()` dan `gen_salt('bf')` untuk mengenkripsi kata sandi akun pengguna demo di seeder serta fungsi HMAC/SHA256 untuk verifikasi signature.
3. **`pg_stat_statements` (v1.11)**:
   - **Fungsi**: Merekam metrik waktu eksekusi seluruh query SQL di latar belakang. Ekstensi ini menjadi fondasi bagi menu **Advisors** dan **Observability** untuk mendeteksi *Slow Queries*.
4. **`plpgsql` (v1.0)**:
   - **Fungsi**: Bahasa pemrograman prosedural inti PostgreSQL yang memungkinkan kita membuat stored procedures dan database triggers (seperti fungsi RPC statistik dashboard kita).

---

### 14.3 Ekstensi Pilihan SaaS Paling Berguna untuk Pengembangan Fitur Lanjutan

Berdasarkan daftar ekstensi yang ada di tangkapan layar, berikut adalah ekstensi terbaik yang dapat diaktifkan saat MariFlow berkembang:

| Nama Ekstensi | Deskripsi & Kegunaan Nyata untuk SaaS | Contoh Use Case di MariFlow |
| :--- | :--- | :--- |
| **`pg_net`** | **Async HTTP Networking Client**: Melakukan panggilan HTTP/HTTPS (GET, POST) asinkron langsung dari trigger database tanpa memblokir transaksi user. | Mengirim notifikasi webhook ke Slack, Discord, atau WhatsApp Gateway saat ada tugas kanban yang *Overdue*. |
| **`pg_cron`** | **In-Database Job Scheduler**: Menjadwalkan eksekusi query SQL berkala layaknya Linux Cron (`* * * * *`). | Mengarsipkan otomatis tugas yang sudah selesai lebih dari 30 hari atau mengirim rekap email mingguan setiap Senin pagi. |
| **`pgmq`** | **Lightweight Message Queue**: Sistem antrean pesan (Queue / Job Worker) murni di dalam PostgreSQL tanpa perlu Redis, RabbitMQ, atau AWS SQS. | Menangani antrean pengiriman email massal dan pemrosesan kompresi dokumen di latar belakang. |
| **`pg_hashids`** | **Short Unique ID Generator**: Mengubah ID integer menjadi kode pendek acak (seperti ID video YouTube `dQw4w9WgXcQ`). | Membuat tautan undangan workspace pendek yang ramah dibagikan (misal: `mariflow.app/invite/xK9jL2`). |
| **`index_advisor`** | **Query Optimization Advisor**: Menganalisis query yang Anda jalankan dan merekomendasikan pembuatan indeks yang tepat untuk mempercepat query. | Membantu menemukan kolom filter yang perlu diindeks saat jumlah data tugas mencapai puluhan ribu. |
| **`pg_jsonschema`** | **JSON Schema Validator**: Memvalidasi integritas struktur data kolom `jsonb` agar sesuai dengan skema JSON standar. | Memastikan kolom `metadata` atau `custom_fields` pada kartu tugas selalu memiliki tipe data yang valid. |
| **`fuzzystrmatch`** | **Fuzzy String Matching (Levenshtein)**: Algoritma pencocokan kemiripan string toleran saltik (*typo-tolerant search*). | Memungkinkan pencarian tugas tetap menemukan hasil meskipun pengguna salah mengetik 1-2 huruf pada judul tugas. |
| **`pg_repack`** | **Online Table Defragmentation**: Merapikan dan mengklaim kembali ruang disk kosong pada tabel besar tanpa mengunci (*table lock*) database. | Pemeliharaan database saat data lama dihapus secara massal agar ukuran database tetap hemat di Free Tier. |
| **`pgvector`** | **Vector Similarity Search**: Menyimpan dan mencari vektor embedding kecerdasan buatan. | Fitur AI Semantic Search untuk mencari tugas atau dokumen berdasarkan konteks makna, bukan sekadar kata kunci teks murni. |

---

### 14.4 Cara Mengaktifkan Ekstensi via SQL Script

Selain mengklik tombol toggle di dashboard, Anda dapat mengaktifkan ekstensi melalui SQL Editor:

```sql
-- Mengaktifkan ekstensi pgcrypto ke dalam skema extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;

-- Mengaktifkan ekstensi pg_net untuk Database Webhooks
CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA extensions;

-- Mengaktifkan ekstensi pg_cron untuk Scheduled Jobs
CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA extensions;
```

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*






