# 🚀 Panduan Lengkap Setup Proyek MariFlow SaaS & Supabase (Lokal & Live/Production)

Dokumen ini adalah **panduan langkah-demi-langkah (step-by-step master guide)** untuk menginstal, mengonfigurasi, dan menjalankan proyek **MariFlow SaaS** (`app_mariflow_vue`) secara menyeluruh, baik pada **lingkungan lokal (Local Development)** maupun **lingkungan produksi online (Live Deployment)**.

---

## 📋 Daftar Isi
1. [Ikhtisar Arsitektur](#-1-ikhtisar-arsitektur)
2. [Prasyarat Sistem (*Prerequisites*)](#-2-prasyarat-sistem-prerequisites)
3. [BAGIAN 1: Setup Lingkungan Lokal (Local Development)](#-3-bagian-1-setup-lingkungan-lokal-local-development)
   - [3.1 Kloning Repository & Install Dependensi](#31-kloning-repository--install-dependensi)
   - [3.2 Menyiapkan File Lingkungan (.env)](#32-menyiapkan-file-lingkungan-env)
   - [3.3 Menyiapkan Database Supabase (Metode Cloud Gratis / Lokal CLI)](#33-menyiapkan-database-supabase)
   - [3.4 Menjalankan Migrasi Database SQL & Seed Data](#34-menjalankan-migrasi-database-sql--seed-data)
   - [3.5 Menyiapkan Storage Buckets](#35-menyiapkan-storage-buckets)
   - [3.6 Menjalankan Aplikasi Lokal](#36-menjalankan-aplikasi-lokal)
4. [BAGIAN 2: Setup Lingkungan Live / Online (Production Deployment)](#-4-bagian-2-setup-lingkungan-live--online-production-deployment)
   - [4.1 Membuat Project di Supabase Cloud](#41-membuat-project-di-supabase-cloud)
   - [4.2 Eksekusi Migrasi SQL di Supabase Cloud](#42-eksekusi-migrasi-sql-di-supabase-cloud)
   - [4.3 Konfigurasi Authentication & Redirect URLs](#43-konfigurasi-authentication--redirect-urls)
   - [4.4 Konfigurasi Storage Buckets & RLS Policy](#44-konfigurasi-storage-buckets--rls-policy)
   - [4.5 Deploy Frontend ke Vercel / Netlify / VPS](#45-deploy-frontend-ke-vercel--netlify--vps)
5. [BAGIAN 3: Checklist Keamanan & RLS Database](#-5-bagian-3-checklist-keamanan--rls-database)
6. [BAGIAN 4: Panduan Troubleshooting Kendala Umum](#-6-bagian-4-panduan-troubleshooting-kendala-umum)

---

## 🏗️ 1. Ikhtisar Arsitektur

- **Frontend**: Vue 3 (Composition API `<script setup>`), TypeScript, Tailwind CSS 4, Pinia State Management, Vite.
- **Backend as a Service (BaaS)**: **Supabase** (PostgreSQL 15+, Supabase Auth, Row Level Security, Storage Buckets, Realtime Subscriptions, RPC Functions).
- **Keamanan**: Multi-tenant Row Level Security (RLS) di tingkat database PostgreSQL.

```text
┌─────────────────────────────────────────────────────────────┐
│                 MariFlow SaaS Frontend                      │
│             (Vue 3 + Vite + Tailwind CSS 4)                 │
└──────────────┬───────────────────────────────┬──────────────┘
               │ (VITE_SUPABASE_ANON_KEY)       │
               ▼                               ▼
┌──────────────────────────────┐ ┌────────────────────────────┐
│      Supabase Auth & Storage │ │  PostgreSQL Database + RLS  │
│  - Email/Password Sessions   │ │  - Workspaces & Members    │
│  - Avatars & Task Attachments│ │  - Projects, Tasks, Logs   │
└──────────────────────────────┘ └────────────────────────────┘
```

---

## 💻 2. Prasyarat Sistem (*Prerequisites*)

Sebelum memulai, pastikan perangkat Anda telah terpasang:
- **Node.js**: Versi `20.x` atau `22.x` (LTS direkomendasikan).
- **Package Manager**: `npm` (versi 10+) atau `pnpm` / `yarn`.
- **Git**: Versi 2.40+.
- **Browser Modern**: Google Chrome, Microsoft Edge, Mozilla Firefox, atau Safari.
- **Akun Supabase**: Daftar gratis di [supabase.com](https://supabase.com) jika belum memiliki akun.

---

## 🏠 3. BAGIAN 1: Setup Lingkungan Lokal (Local Development)

### 3.1 Kloning Repository & Install Dependensi

Buka terminal (PowerShell, Command Prompt, atau Bash) lalu jalankan:

```bash
# 1. Kloning repository proyek
git clone https://github.com/hndko/app_mariflow_vue.git

# 2. Masuk ke direktori proyek
cd app_mariflow_vue

# 3. Install seluruh dependensi npm
npm install
```

---

### 3.2 Menyiapkan File Lingkungan (`.env`)

Salin file contoh konfigurasi `.env.example` menjadi `.env`:

```bash
# Untuk Windows PowerShell / CMD:
copy .env.example .env

# Untuk Linux / macOS:
cp .env.example .env
```

Buka file `.env` dan isi kredensial Supabase Anda:

```env
# ==============================================================================
# MariFlow SaaS Environment Variables
# ==============================================================================
# PENTING: Gunakan ANON KEY (Kunci Publik). Dilarang keras menaruh SERVICE_ROLE_KEY di frontend!

VITE_SUPABASE_URL=https://rtazqheauyiujjteburi.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxxxxxxxxxxxxxxxxxx
```

> [!TIP]
> **Cara Mengambil Anon Key**:
> Pada dashboard project `mariflow-dev`, lihat bagian **"Get connected"** lalu klik kartu **"API Keys"** (atau buka menu **Project Settings** ➔ **API**). Salin nilai **`anon` `public`** key ke variabel `VITE_SUPABASE_ANON_KEY`.

---

### 3.3 Menyiapkan Database Supabase

Terdapat **2 cara** untuk menyiapkan backend Supabase pada lingkungan lokal:

#### Opsi A: Menggunakan Supabase Cloud Free Tier (*Paling Direkomendasikan & Cepat*)
1. Masuk ke [database.new](https://database.new) untuk membuat project baru di Supabase Cloud (contoh: `mariflow-dev`).
2. Region Database: **`Southeast Asia (Singapore) ap-southeast-1` 🇸🇬** (latensi rendah ~15-25ms).
3. Pada halaman **Project Overview**, salin **Project URL** (`https://rtazqheauyiujjteburi.supabase.co`) ke `VITE_SUPABASE_URL`.
4. Klik tombol **API Keys** pada kartu **Get connected**, salin **anon / public key** ke `VITE_SUPABASE_ANON_KEY` di file `.env` Anda.

#### Opsi B: Menggunakan Supabase Local CLI (Docker)
Jika Anda ingin 100% offline menggunakan Docker Desktop:
```bash
# Install Supabase CLI (jika belum ada)
npm install -g supabase

# Inisialisasi dan start container lokal
supabase start

# Dapatkan URL dan Anon Key lokal:
# API URL: http://127.0.0.1:54321
# anon key: eyJhbGciOi...
```

---

### 3.4 Menjalankan Migrasi Database SQL & Seed Data

Eksekusi file migrasi SQL yang berada di folder `supabase/migrations/` secara **berurutan**:

#### Urutan File Migrasi DDL Skema:
1. `supabase/migrations/20260902_000001_create_mariflow_schema.sql` (Schema DDL, Tabel, Relasi FK, Triggers, RLS Policies)
2. `supabase/migrations/20260902_000002_dashboard_rpc_functions.sql` (Fungsi RPC Agregasi Statistik Dashboard)
3. `supabase/migrations/20260902_000003_role_dashboard_analytics.sql` (Fungsi RPC Analytics Multi-Role)
4. `supabase/migrations/20260902_000004_add_superadmin_role.sql` (Penambahan Role Superadmin ke Enum `user_role`)

#### Menjalankan Seed Data (`supabase/seeders/`):
Seluruh data awal awal demo dan pengujian tersusun modular di dalam subfolder **`supabase/seeders/`**:
- `supabase/seeders/01_auth_users_and_profiles.sql` (Akun Demo: Superadmin, Owner, Admin, Member, Viewer)
- `supabase/seeders/02_workspaces_and_members.sql` (Workspace Mari Partner Hub, Client Projects, Mobile App Team)
- `supabase/seeders/03_projects.sql` (Proyek MariFlow v1.0, Landing Page, Payment System, Audit Keamanan)
- `supabase/seeders/04_tasks_kanban.sql` (11+ Tugas Kanban lengkap dengan status To Do, In Progress, Review, Completed)
- `supabase/seeders/05_task_comments_and_attachments.sql` (Komentar diskusi & berkas lampiran demo)
- `supabase/seeders/master_seed.sql` (**Master All-in-One Seeder** untuk eksekusi 1-klik)

#### Cara Eksekusi via Supabase Cloud SQL Editor:
1. Buka dashboard project `mariflow-dev` di Supabase.
2. Di sidebar kiri, klik menu **SQL Editor** (icon `>_`).
3. Klik tombol **+ New query**.
4. Buka file `supabase/migrations/20260902_000001_create_mariflow_schema.sql`, salin seluruh isinya, tempel ke SQL Editor, lalu klik **Run**.
5. Ulangi untuk file `20260902_000002_dashboard_rpc_functions.sql`, `20260902_000003_role_dashboard_analytics.sql`, dan `20260902_000004_add_superadmin_role.sql`.
6. Terakhir, buka file **`supabase/seeders/master_seed.sql`**, salin kodenya, tempel ke SQL Editor, lalu klik **Run** untuk mengisi seluruh data awal!

> [!TIP]
> **Daftar Akun Demo Hasil Seeder (Email @example.com & Kata Sandi: `password`)**:
> - **Superadmin**: `superadmin@example.com` | Kata Sandi: `password`
> - **Owner**: `owner@example.com` | Kata Sandi: `password`
> - **Admin**: `admin@example.com` | Kata Sandi: `password`
> - **Member**: `member@example.com` | Kata Sandi: `password`
> - **Viewer**: `viewer@example.com` | Kata Sandi: `password`

---

### 3.5 Menyiapkan Storage Buckets

Aplikasi MariFlow membutuhkan 2 buah Storage Bucket untuk avatar pengguna dan lampiran tugas kanban:

1. Buka menu **Storage** di sidebar dashboard Supabase.
2. Klik tombol **New bucket**.
3. Buat Bucket Pertama:
   - **Name**: `avatars`
   - **Public bucket**: Centang (*Enable / Public*).
   - Klik **Save**.
4. Buat Bucket Kedua:
   - **Name**: `task-attachments`
   - **Public bucket**: Centang (*Enable / Public*).
   - Klik **Save**.

---

### 3.6 Menjalankan Aplikasi Lokal

Setelah file `.env`, database, dan storage siap, jalankan server pengembangan:

```bash
npm run dev
```

Buka browser Anda di:
👉 **`http://localhost:5173`**

---

## 🌐 4. BAGIAN 2: Setup Lingkungan Live / Online (Production Deployment)

### 4.1 Membuat Project di Supabase Cloud

1. Kunjungi [supabase.com](https://supabase.com) dan login.
2. Klik **New Project** ➔ Pilih Organisasi Anda.
3. Masukkan rincian project:
   - **Name**: `MariFlow Production`
   - **Database Password**: *(Simpan password ini di tempat yang aman)*
   - **Region**: `Singapore (ap-southeast-1)` (untuk latensi tercepat dari Indonesia & Asia Tenggara)
   - **Pricing Plan**: Free (atau Pro jika untuk skala besar)
4. Klik **Create new project**.

---

### 4.2 Eksekusi Migrasi SQL di Supabase Cloud

1. Masuk ke **SQL Editor** pada project production.
2. Jalankan secara berurutan:
   - `20260902_000001_create_mariflow_schema.sql`
   - `20260902_000003_role_dashboard_analytics.sql`
   *(Catatan: `20260902_000002_seed_demo_data.sql` bersifat opsional di production jika ingin memulai dari database bersih).*

---

### 4.3 Konfigurasi Authentication & Redirect URLs

Agar fitur pendaftaran, login, dan reset password berfungsi dengan benar di domain live Anda:

1. Di dashboard Supabase, buka menu **Authentication** ➔ **URL Configuration**.
2. Atur **Site URL**:
   ```text
   https://app.mariflow.com   (atau URL Vercel/Netlify Anda)
   ```
3. Di bagian **Redirect URLs**, tambahkan URL berikut:
   ```text
   http://localhost:5173/**
   http://localhost:5173/reset-password
   https://app.mariflow.com/**
   https://app.mariflow.com/reset-password
   https://app.mariflow.com/login
   ```
4. Klik **Save**.
5. Buka menu **Authentication** ➔ **Providers** ➔ **Email**:
   - Pastikan **Enable Email provider** aktif (*ON*).
   - Jika ingin mempermudah demo tanpa verifikasi email: matikan opsi **Confirm email**.
6. *(Opsional)* Buka menu **Authentication** ➔ **Passkeys [BETA]**:
   - Jika ingin mengaktifkan login biometrik (Fingerprint / Face ID), masukkan **Relying Party Origins**: `http://localhost:5173, https://app.mariflow.com`.
7. **Siklus Token & Keamanan Sesi**:
   - Di menu **Authentication** ➔ **Sessions**, Access Token default berlaku 3600 detik (1 jam) dan Refresh Token Rotation aktif otomatis untuk mencegah replay attack.

---

### 4.4 Konfigurasi Storage Buckets & RLS Policy

1. Buka menu **Storage** ➔ Klik **+ New bucket**:
   - **Bucket 1: `avatars`**
     - Status: **Public bucket** (*ON*).
     - Restrict MIME types (*Opsional*): `image/jpeg, image/png, image/webp`.
     - File size limit (*Opsional*): `2 MB`.
   - **Bucket 2: `task-attachments`**
     - Status: **Public bucket** (*ON*).
     - File size limit: Mengikuti limit default Free Tier (maksimal **50 MB** per file).
2. **Storage RLS Policies**:
   - Seluruh kebijakan keamanan akses tabel `storage.objects` telah terkonfigurasi secara otomatis dari script SQL migrasi `20260902_000001_create_mariflow_schema.sql`.

---

### 4.5 Deploy Frontend ke Vercel / Netlify / VPS

Proyek MariFlow telah dilengkapi file [vercel.json](file:///d:/laragon/www/app_mariflow_vue/vercel.json) dan [public/_redirects](file:///d:/laragon/www/app_mariflow_vue/public/_redirects) untuk menangani Single Page Application (SPA) routing rewrite agar tidak terjadi error 404 saat pengguna me-refresh halaman.

#### Opsi 1: Deploy ke Vercel (*Paling Direkomendasikan*)
1. Masuk ke [vercel.com](https://vercel.com) dan hubungkan akun GitHub Anda.
2. Klik **Add New...** ➔ **Project** ➔ Import repository `app_mariflow_vue`.
3. Pada bagian **Build and Output Settings**:
   - **Framework Preset**: `Vite`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
   - **Install Command**: `npm install`
4. Pada bagian **Environment Variables**, tambahkan:
   - `VITE_SUPABASE_URL` = `https://your-project.supabase.co`
   - `VITE_SUPABASE_ANON_KEY` = `your-anon-key-here`
5. Klik **Deploy**. Aplikasi akan online dalam 1 menit! 🚀

#### Opsi 2: Deploy ke Netlify
1. Masuk ke [netlify.com](https://netlify.com) ➔ **Add new site** ➔ **Import an existing project**.
2. Pilih repository GitHub `app_mariflow_vue`.
3. Set Build command: `npm run build` dan Publish directory: `dist`.
4. Tambahkan Environment Variables: `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY`.
5. Klik **Deploy site**.

#### Opsi 3: Deploy ke VPS Linux (Nginx)
1. Build aplikasi secara lokal atau di server:
   ```bash
   npm run build
   ```
2. Salin isi folder `dist/` ke root web server Anda (misal: `/var/www/mariflow/html`).
3. Konfigurasikan blok server Nginx:
   ```nginx
   server {
       listen 80;
       server_name app.mariflow.com;
       root /var/www/mariflow/html;
       index index.html;

       location / {
           try_files $uri $uri/ /index.html;
       }

       location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
           expires 1y;
           add_header Cache-Control "public, immutable";
       }
   }
   ```
4. Reload Nginx: `sudo systemctl reload nginx`.

---

## 🛡️ 5. BAGIAN 3: Checklist Keamanan & RLS Database

| Komponen | Status Standar | Keterangan |
| :--- | :---: | :--- |
| **Row Level Security (RLS)** | ✅ **Wajib ON** | Aktif di seluruh 10 tabel (`profiles`, `workspaces`, `workspace_members`, `projects`, `tasks`, `task_assignees`, `task_comments`, `task_attachments`, `notifications`, `activity_logs`). |
| **Security Advisor (Splinter)**| ✅ **0 Errors** | Jalankan *Rerun linter* di menu **Advisors ➔ Security Advisor** untuk memastikan tidak ada celah izin atau tabel tanpa RLS. |
| **Kunci Anonim (`VITE_SUPABASE_ANON_KEY`)** | ✅ **Aman** | Kunci publik yang dibatasi sepenuhnya oleh kebijakan RLS database. |
| **Kunci Layanan (`SUPABASE_SERVICE_ROLE_KEY`)** | 🔒 **Dilarang di Frontend** | Tidak boleh pernah dimasukkan ke file `.env` frontend atau di-commit ke Git. |
| **Unsubscribe Realtime** | ✅ **Hygiene** | Seluruh subscription realtime di-unsubscribe pada hook `onBeforeUnmount()` di komponen Vue. |

---

## ❓ 6. BAGIAN 4: Panduan Troubleshooting Kendala Umum

### 1. Error: `Failed to fetch` atau `Invalid API Key`
- **Penyebab**: Nilai `VITE_SUPABASE_URL` atau `VITE_SUPABASE_ANON_KEY` pada file `.env` salah, tertukar, atau memiliki spasi ekstra.
- **Solusi**: Periksa kembali file `.env` dan pastikan Anda me-restart server Vite (`Ctrl+C` lalu `npm run dev`) setiap kali mengubah file `.env`.

### 2. Error: `new row violates row-level security policy`
- **Penyebab**: Pengguna mencoba membuat workspace/tugas tanpa sesi login aktif, atau mencoba mengakses data workspace orang lain di mana ia bukan anggota.
- **Solusi**: Pastikan pengguna telah login melalui form auth atau terdaftar di tabel `workspace_members` dengan peran aktif.

### 3. Error: `Bucket not found` saat upload file
- **Penyebab**: Bucket `avatars` atau `task-attachments` belum dibuat di menu Storage Supabase.
- **Solusi**: Masuk ke menu **Storage** di Supabase dan buat bucket `avatars` dan `task-attachments` dengan status *Public*.

### 4. Error: `Invalid login credentials` saat Login Akun Demo
- **Penyebab**: Di Supabase, kata sandi disimpan di skema terenkripsi privat **`auth.users`** (bukan di `public.profiles`). Jika database baru saja di-reset, akun demo belum terbuat atau format enkripsi GoTrue belum terkonfirmasi.
- **Solusi**: Jalankan script SQL aktivasi akun demo di SQL Editor atau jalankan `supabase/seeders/master_seed.sql` yang telah menyertakan password hash `crypt('password', gen_salt('bf', 10))` dan status konfirmasi email otomatis.

### 5. Error: Halaman 404 saat me-refresh browser di halaman modul (Vercel/Netlify)
- **Penyebab**: Web server mencoba mencari file fisik HTML yang sesuai dengan path rute (contoh: `/dashboard/index.html`).
- **Solusi**: File [vercel.json](file:///d:/laragon/www/app_mariflow_vue/vercel.json) dan [public/_redirects](file:///d:/laragon/www/app_mariflow_vue/public/_redirects) telah disediakan di repository untuk mengarahkan seluruh permintaan rute ke `/index.html`.

---

*MariFlow SaaS — Simple Workspace & Task Management.*
