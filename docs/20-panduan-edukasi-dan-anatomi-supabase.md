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
15. [Panduan Lengkap Optimasi Query & Database Indexes (Query Optimization Masterclass)](#-15-panduan-lengkap-optimasi-query--database-indexes-query-optimization-masterclass)
    - [15.1 Mengapa Database Index Sangat Penting bagi SaaS Multi-Tenant?](#151-mengapa-database-index-sangat-penting-bagi-saas-multi-tenant)
    - [15.2 Anatomi Tipe-Tipe Index di PostgreSQL & Rekomendasi Penggunaannya](#152-anatomi-tipe-tipe-index-di-postgresql--rekomendasi-penggunaannya)
    - [15.3 Teknik Optimasi Lanjutan (Composite, Partial & Covering Index)](#153-teknik-optimasi-lanjutan-advanced-saas-indexing-strategies)
    - [15.4 Memeriksa Kinerja Query dengan EXPLAIN ANALYZE](#154-memeriksa-kinerja-query-dengan-explain-analyze)
    - [15.5 Fitur Supabase Index Advisor](#155-fitur-supabase-index-advisor-tombol-di-kanan-atas)
16. [Bedah Lengkap Database Publications, Policies (RLS), & Roles Architecture](#-16-bedah-lengkap-database-publications-policies-rls--roles-architecture)
    - [16.1 Database Publications (supabase_realtime & Event Toggles)](#161-database-publications-supabase_realtime)
    - [16.2 Policies (Row Level Security Visual Manager)](#162-policies-row-level-security-visual-manager)
    - [16.3 Database Roles (Hierarki Peran PostgreSQL & Arsitektur Keamanan)](#163-database-roles-hierarki-peran-postgresql--arsitektur-keamanan)
    - [16.4 Anatomi Drawer "Create a new role" & Privilese Database](#164-anatomi-drawer-create-a-new-role--privilese-database)
17. [Bedah Lengkap Database Settings (Password, Connection Pooling, SSL, & Security)](#-17-bedah-lengkap-database-settings-password-connection-pooling-ssl--security)
    - [17.1 Database Password & Dampak Reset Password](#171-database-password--dampak-reset-password)
    - [17.2 Connection Pooling (Supavisor): Solusi 200 Koneksi di Free Tier](#172-connection-pooling-supavisor-solusi-200-koneksi-di-free-tier)
    - [17.3 SSL Configuration (Enkripsi Data In-Transit)](#173-ssl-configuration-enkripsi-data-in-transit)
    - [17.4 Network Restrictions (IP Whitelist) & Network Bans](#174-network-restrictions-ip-whitelist--network-bans)
    - [17.5 Connection Logging (log_connections & log_disconnections)](#175-connection-logging-log_connections--log_disconnections)

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

## ⚡ 15. Panduan Lengkap Optimasi Query & Database Indexes (*Query Optimization Masterclass*)

Menu **Database ➔ Indexes** (icon ⚡) dan panduan resmi [Supabase Query Optimization](https://supabase.com/docs/guides/database/query-optimization) menjelaskan strategi krusial untuk memastikan database MariFlow tetap cepat, hemat memori, dan mampu melayani ribuan request per detik tanpa *slow queries*.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚡ Database Indexes  [schema public ▼]  [🔍 Search for an index...]         [📖 Docs] [💡 Index Advisor]│
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ TABLE                    │ COLUMNS                                  │ NAME                             │
├──────────────────────────┼──────────────────────────────────────────┼──────────────────────────────────┤
│ public.workspaces        │ owner_id                                 │ idx_workspaces_owner_id          │
│ public.workspace_members │ workspace_id, user_id                   │ idx_workspace_members_ws_user    │
│ public.projects          │ workspace_id, status                     │ idx_projects_workspace_status    │
│ public.tasks             │ workspace_id, status, assigned_to        │ idx_tasks_workspace_status_pic  │
│ public.tasks             │ created_at DESC                          │ idx_tasks_created_at_desc        │
└──────────────────────────┴──────────────────────────────────────────┴──────────────────────────────────┘
```

---

### 15.1 Mengapa Database Index Sangat Penting bagi SaaS Multi-Tenant?

Tanpa indeks, setiap kali pengguna membuka papan Kanban di MariFlow, PostgreSQL harus melakukan **Sequential Scan (Seq Scan)** — yaitu membaca jutaan baris data dari awal hingga akhir disk satu per satu.

Dengan membuat **Index**, PostgreSQL membangun struktur data pohon seimbang (**B-Tree**) yang bertindak seperti *Daftar Isi Buku*. Query pencarian dapat langsung melompat ke baris yang dituju dalam waktu mikrodetik (**Index Scan**).

```text
Tanpa Index (Seq Scan):  [Baris 1] ➔ [Baris 2] ➔ [Baris 3] ... ➔ [Baris 100.000] (Lambat: ~350ms)
Dengan Index (B-Tree):   [Root Node] ➔ [Branch Node] ➔ [Leaf Pointer]             (Cepat: ~2ms 🚀)
```

---

### 15.2 Anatomi Tipe-Tipe Index di PostgreSQL & Rekomendasi Penggunaannya

Saat membuat indeks di Supabase, Anda dapat memilih tipe struktur data berikut:

| Tipe Index | Karakteristik & Operator yang Didukung | Kapan Digunakan di MariFlow SaaS? |
| :--- | :--- | :--- |
| **`B-Tree`** *(Default & Paling Populer)* | Mendukung pencarian kesetaraan (`=`), perbandingan (`<`, `>`, `<=`, `>=`), rentang (`BETWEEN`, `IN`), dan pengurutan (`ORDER BY`). | **Wajib di seluruh Foreign Key**: `workspace_id`, `project_id`, `assigned_to`, dan kolom tanggal `due_date`. |
| **`GIN`** *(Generalized Inverted Index)* | Indeks terbalik untuk mencari elemen di dalam array (`text[]`), dokumen JSON (`jsonb` dengan operator `@>`, `?`), dan pencarian teks penuh (*Full-Text Search* `tsvector`). | Digunakan jika tugas memiliki kolom `tags text[]` atau `metadata jsonb`. |
| **`GiST`** *(Generalized Search Tree)* | Indeks hierarkis untuk data geometri spasial (PostGIS) dan tipe data rentang waktu (`tsrange`). | Digunakan jika fitur pelacakan durasi kerja (*Time Tracking Range*) diaktifkan. |
| **`BRIN`** *(Block Range Index)* | Indeks berukuran sangat kecil (hanya beberapa KB) untuk tabel raksasa (jutaan baris) yang tersimpan berurutan secara fisik. | Sangat ideal untuk tabel riwayat log sistem **`activity_logs`** pada kolom `created_at`. |
| **`Hash`** | Hanya mendukung pencocokan kesetaraan persis (`=`). | Jarang digunakan karena B-Tree jauh lebih fleksibel. |

---

### 15.3 Teknik Optimasi Lanjutan (*Advanced SaaS Indexing Strategies*)

#### 1. Composite Index (Indeks Gabungan Multi-Kolom)
Jika query frontend Anda sering memfilter berdasarkan beberapa kolom sekaligus (misal: mengambil tugas berdasarkan `workspace_id` dan `status`):
```sql
-- Mempercepat query: SELECT * FROM tasks WHERE workspace_id = '...' AND status = 'in_progress'
CREATE INDEX idx_tasks_workspace_status ON public.tasks (workspace_id, status);
```

#### 2. Partial Index (Indeks Sebagian / Bersyarat)
Teknik brilian untuk menghemat ruang disk hingga **80%** di Free Tier dengan hanya mengindeks data aktif:
```sql
-- Hanya mengindeks tugas yang BELUM selesai (mengabaikan jutaan riwayat tugas 'completed')
CREATE INDEX idx_active_tasks ON public.tasks (workspace_id) 
WHERE status != 'completed';
```

#### 3. Covering Index dengan Klausul `INCLUDE`
Menyertakan kolom payload tambahan ke dalam indeks agar PostgreSQL tidak perlu membuka tabel utama (*Index-Only Scan*):
```sql
CREATE INDEX idx_tasks_lookup ON public.tasks (workspace_id) 
INCLUDE (title, priority);
```

---

### 15.4 Memeriksa Kinerja Query dengan `EXPLAIN ANALYZE`

Untuk membuktikan apakah query Anda sudah optimal dan menggunakan indeks, jalankan perintah `EXPLAIN ANALYZE` di **SQL Editor**:

```sql
EXPLAIN ANALYZE
SELECT id, title, priority 
FROM public.tasks 
WHERE workspace_id = '10000000-0000-0000-0000-000000000001' 
  AND status = 'in_progress';
```

**Hasil yang Diharapkan**:
- Muncul teks `Index Scan using idx_tasks_workspace_status ...` (Bukan `Seq Scan`).
- `Execution Time`: Kurang dari `< 5ms`.

---

### 15.5 Fitur Supabase Index Advisor (Tombol di Kanan Atas)
- Tombol **`Index Advisor`** pada dashboard Supabase secara cerdas menganalisis log riwayat query aplikasi Anda dan secara otomatis merekomendasikan query `CREATE INDEX` yang paling berdampak untuk mempercepat performa database!

---

## 🛡️ 16. Bedah Lengkap Database Publications, Policies (RLS), & Roles Architecture

Menu **Publications** dan kelompok **ACCESS CONTROL** (`Policies` & `Roles`) adalah benteng pertahanan utama keamanan (*Security Boundary*) dan pipa replikasi real-time di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🛡️ ACCESS CONTROL & PUBLICATIONS ARCHITECTURE                                                          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📡 PUBLICATIONS (Replikasi WebSocket Realtime):                                                        │
│  - [supabase_realtime] ──► Event: [✓] INSERT  [✓] UPDATE  [✓] DELETE  [✓] TRUNCATE                    │
│    └─ Tabel Terdaftar: public.tasks, public.task_comments, public.notifications                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 👥 POSTGRESQL ROLES (Hierarki Akun Database):                                                          │
│  1. anon             : Pengguna publik tanpa token login (Hanya baca data landing/public).            │
│  2. authenticated    : Pengguna sah yang telah login (Membawa JWT auth.uid()).                        │
│  3. authenticator    : Gateway PostgREST yang memvalidasi JWT dan bertukar peran.                     │
│  4. service_role     : Kunci rahasia backend dengan privilese BYPASSRLS penuh.                        │
│  5. supabase_admin   : Superuser pengelola internal server PostgreSQL.                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔐 POLICIES (Row Level Security Visual Auditor):                                                       │
│  - SELECT Policy     : Hanya tampilkan tugas di mana pengguna menjadi anggota workspace aktif.         │
│  - INSERT Policy     : Hanya izinkan anggota dengan role minimal 'member' membuat tugas baru.          │
│  - UPDATE Policy     : Hanya izinkan pembuat tugas / assignee / admin mengubah status kanban.          │
│  - DELETE Policy     : Hanya izinkan Owner & Admin workspace menghapus tugas.                          │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 16.1 📡 Database Publications (`supabase_realtime`)

Pada menu **Database ➔ Publications**, Anda melihat publikasi bernama **`supabase_realtime`** (System ID: `16430`).

#### 1. Cara Kerja Publikasi Replikasi
- Supabase Realtime memanfaatkan fitur **PostgreSQL Logical Replication**.
- Saat ada data yang berubah di database, engine PostgreSQL akan menerbitkan (*publish*) rekaman perubahan ke *Replication Stream* yang kemudian ditangkap oleh Realtime Server Elixir untuk disiarkan ke frontend Vue melalui WebSocket.

#### 2. Event Toggles (`INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`)
- Anda dapat mengontrol tipe event apa saja yang disiarkan:
  - **`INSERT`**: Menyiarkan baris data baru saat tugas / komentar baru dibuat.
  - **`UPDATE`**: Menyiarkan perubahan data saat kartu tugas dipindah antar kolom Kanban.
  - **`DELETE`**: Menyiarkan notifikasi penghapusan baris data.
  - **`TRUNCATE`**: Menyiarkan pembersihan seluruh data tabel.

> [!TIP]
> **Best Practice SaaS (Hemat Kuota Free Tier)**:
> Jangan daftarkan seluruh tabel ke dalam `supabase_realtime`. Daftarkan hanya tabel yang membutuhkan kolaborasi langsung (*live sync*), seperti **`tasks`**, **`task_comments`**, dan **`notifications`**. Tabel statis seperti `profiles` atau `workspaces` cukup diambil saat *page load*.

---

### 16.2 🔐 Policies (Row Level Security Visual Manager)

Menu **Database ➔ Policies** adalah tempat Anda memantau dan mengaudit seluruh aturan keamanan baris (RLS) di seluruh tabel skema `public`.

- **Kenapa RLS Wajib di MariFlow SaaS?**:
  - Di arsitektur Backend-as-a-Service (BaaS), frontend Vue berinteraksi langsung dengan database PostgreSQL.
  - RLS bertindak sebagai *filter otomatis permanen di level kernel database*. Pengguna dari Workspace A **secara matematis mustahil** membaca atau memanipulasi data milik Workspace B, meskipun mereka mencoba mengirim raw SQL/HTTP request dari Postman!

---

### 16.3 👥 Database Roles (Hierarki Peran PostgreSQL & Arsitektur Keamanan)

Menu **Database ➔ Roles** menampilkan seluruh peran (*database roles*) yang dikelola oleh Supabase (`Roles managed by Supabase - PROTECTED`):

| Nama Role | Status Proteksi | Deskripsi & Perannya dalam Ekosistem Supabase |
| :--- | :--- | :--- |
| **`anon`** | 🟢 Terproteksi | Digunakan untuk request publik sebelum pengguna login. Hanya boleh membaca tabel publik (seperti landing page). |
| **`authenticated`** | 🟢 Terproteksi | Digunakan setelah user login via `supabase.auth.signInWithPassword()`. Seluruh query SQL otomatis memiliki konteks `auth.uid()`. |
| **`authenticator`** | 🟢 Terproteksi | Peran jembatan (*bridge role*) yang dipakai oleh API Gateway PostgREST. Saat HTTP request masuk dengan Bearer Token JWT, `authenticator` memvalidasi signature token, lalu secara dinamis berganti peran (*assume role*) menjadi `authenticated` atau `anon`. |
| **`service_role`** | 🟢 Terproteksi | Kunci rahasia administratif (*secret key*) yang memiliki privilese **`BYPASSRLS`**. **Dilarang keras dimasukkan ke frontend Vue**. Hanya digunakan di Edge Functions atau backend terisolasi. |
| **`dashboard_user`** | 🟢 Terproteksi | Peran yang digunakan oleh browser Anda saat mengoperasikan Table Editor atau SQL Editor di dashboard Supabase. |
| **`pgbouncer`** | 🟢 Terproteksi | Peran internal untuk mengelola *Connection Pooler* (Supavisor / PgBouncer). |
| **`supabase_admin`** | 🟢 Terproteksi | Peran superuser internal sistem Supabase untuk pemeliharaan cloud infrastructure. |
| **`supabase_auth_admin`**| 🟢 Terproteksi | Peran khusus yang mengelola tabel otentikasi `auth.users` dan `auth.identities`. |

---

### 16.4 ➕ Anatomi Drawer "Create a new role" & Privilese Database

Saat Anda mengklik tombol **`+ Add role`**, Anda dapat membuat custom role untuk kebutuhan khusus (misal: bot data analytics atau integrasi read-only ETL):

1. **`User can login` (`LOGIN`)**: Mengizinkan role ini terhubung ke database menggunakan username & password.
2. **`User can create roles` (`CREATEROLE`)**: Mengizinkan role ini membuat sub-role baru.
3. **`User can create databases` (`CREATEDB`)**: Mengizinkan pembuatan database baru.
4. **`User bypasses every row level security policy` (`BYPASSRLS`)**:
   - ⚠️ **Sangat Berbahaya**: Mengabaikan seluruh aturan RLS (seperti `service_role`). Jangan aktifkan untuk akun publik!
5. **`User can initiate streaming replication` (`REPLICATION`)**: Mengizinkan sinkronisasi data replikasi eksternal.
6. **Batasan Keamanan Cloud**:
   - *These privileges cannot be granted via the Dashboard: User is a Superuser*.
   - Supabase menonaktifkan pemberian hak akses Superuser murni demi menjaga integritas dan keamanan cloud database multi-tenant.

---

## ⚙️ 17. Bedah Lengkap Database Settings (Password, Connection Pooling, SSL, & Security)

Menu **Database ➔ Settings** (kelompok `CONFIGURATION`) adalah panel pengaturan konektivitas, performa *connection pooling*, enkripsi SSL, dan restriksi jaringan database.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚙️ Database Settings (Connections, Security, and Network Configuration)                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔑 DATABASE PASSWORD:                                                                                  │
│  - [Reset password] ──► Password tidak dapat dilihat ulang. Reset memutus koneksi aktif.              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🏊 CONNECTION POOLING (Supavisor):                                                                     │
│  - Compute Tier (Free): Nano                                                                           │
│  - Direct Pool Size   : 15 connections (Cluster Postgres)                                              │
│  - Max Client Pool    : 200 clients (Concurrent Pooler Supavisor - Port 6543)                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔒 SSL CONFIGURATION:                                                                                  │
│  - [🔘] Enforce SSL on incoming connections (Tolak koneksi tanpa enkripsi TLS)                         │
│  - [⬇️ Download certificate] (prod-ca-2021.crt untuk verifikasi root CA)                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 NETWORK RESTRICTIONS & BANS:                                                                        │
│  - Network Restrictions: Membatasi IP Whitelist yang boleh mengakses port database 5432/6543.          │
│  - Network Bans        : Daftar IP yang diblokir otomatis akibat percobaan brute-force.                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📋 CONNECTION LOGGING:                                                                                 │
│  - [🔘] Log connections    : Mencatat setiap koneksi baru yang berhasil.                              │
│  - [🔘] Log disconnections : Mencatat akhir sesi beserta durasi koneksi.                               │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 17.1 🔑 Database Password & Dampak Reset Password

- **Prinsip Keamanan**: Supabase tidak pernah menyimpan kata sandi database Anda dalam bentuk teks terbuka (*plaintext*). Sekali dibuat saat inisialisasi proyek, kata sandi tersebut tidak dapat dilihat kembali.
- **Tombol `Reset password`**:
  - Jika Anda lupa kata sandi database direct connection, Anda dapat meresetnya kapan saja.
  - ⚠️ **Peringatan**: Mereset kata sandi akan langsung memutus seluruh koneksi database aktif yang sedang menggunakan kata sandi lama (misalnya koneksi aplikasi GUI DBeaver, pgAdmin, atau migrasi CLI).

---

### 17.2 🏊 Connection Pooling (Supavisor): Solusi 200 Koneksi di Free Tier

Database PostgreSQL tradisional menggunakan model *process-based connection*, di mana setiap 1 koneksi baru memakan ~2-10 MB memori RAM. Pada serverless atau aplikasi SaaS dengan ratusan pengguna aktif, koneksi database langsung bisa cepat habis (*Connection Exhaustion / Too many clients*).

Supabase menyediakan **Supavisor** — *Connection Pooler* generasi terbaru:

1. **Direct Cluster Pool Size (`15 connections`)**:
   - Jumlah koneksi langsung maksimal ke engine PostgreSQL fisik pada paket Free Tier (Compute Nano).
   - Digunakan untuk koneksi berdurasi panjang seperti DDL migrasi skema tabel.
2. **Max Client Connections (`200 clients`)**:
   - Jumlah pengguna / request bersamaan yang dapat dilayani oleh Supavisor Transaction Pooler (Port 6543).
   - **Cara Kerja**: Supavisor memegang koneksi ke klien, namun hanya meminjamkan koneksi PostgreSQL fisik selama transaksi query SQL berlangsung (dalam hitungan milidetik), lalu mengembalikannya ke *pool* agar bisa dipakai oleh pengguna lain!

---

### 17.3 🔒 SSL Configuration (Enkripsi Data In-Transit)

1. **Toggle `Enforce SSL on incoming connections`**:
   - Saat diaktifkan, database akan **menolak secara mutlak** seluruh koneksi plaintext tanpa enkripsi TLS/SSL. Ini mencegah penyerang di jaringan publik menyadap query data atau password database Anda (*Man-In-The-Middle attack*).
2. **Tombol `Download certificate`**:
   - Mengunduh sertifikat Root CA resmi Supabase (`prod-ca-2021.crt`).
   - Digunakan saat Anda mengonfigurasi koneksi database di aplikasi eksternal (seperti DBeaver, Prisma, atau backend Node) dengan mode `sslmode=verify-full`.

---

### 17.4 🌐 Network Restrictions (IP Whitelist) & Network Bans

1. **`Network restrictions` (`Restrict all access` / `+ Add restriction`)**:
   - Membatasi IP address mana saja di internet yang diizinkan melakukan koneksi langsung ke port PostgreSQL 5432 / 6543.
   - Sangat direkomendasikan untuk SaaS tahap produksi agar hanya IP server aplikasi atau VPN kantor yang boleh mengakses database langsung.
2. **`Network bans`**:
   - Sistem pertahanan otomatis Supabase (*Intrusion Detection System*). Jika ada IP luar yang mencoba menebak kata sandi database secara berulang-ulang (*brute-force attack*), IP tersebut akan langsung diblokir sementara di firewall dan dicatat di panel ini.

---

### 17.5 📋 Connection Logging (`log_connections` & `log_disconnections`)

- **`Log connections`**: Mencatat stempel waktu (*timestamp*) dan detail setiap ada klien baru yang terhubung ke database.
- **`Log disconnections`**: Mencatat saat sesi klien berakhir beserta durasi koneksi yang digunakan.
- **Kapan Digunakan?**:
  - Aktifkan saat Anda melakukan audit keamanan atau mendiagnosis *connection leak* (koneksi yang tidak ditutup dengan benar di kode backend).
  - Nonaktifkan saat produksi normal agar log database tetap bersih dan tidak memakan kuota log.

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*









