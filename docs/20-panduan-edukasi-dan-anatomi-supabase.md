# 📘 Masterclass Supabase: Panduan Edukasi & Anatomi Lengkap Seluruh Menu Platform

Dokumen ini disusun sebagai **materi pembelajaran mendalam (Masterclass Guide)** mengenai ekosistem **Supabase**, anatomi seluruh fiturnya dari tingkat **Organisasi** hingga **Project**, serta keterkaitannya langsung dengan aplikasi **MariFlow SaaS**.

---

## 📑 Daftar Isi
1. [Konsep Inti & Hirarki Supabase (Organization vs Project)](#-1-konsep-inti--hirarki-supabase)
2. [Anatomi Menu Tingkat Organisasi (Berdasarkan Screenshot)](#-2-anatomi-menu-tingkat-organisasi)
   - [2.1 Projects & Usage Quota](#21-projects--usage-quota-monitoring)
   - [2.2 Membuat Organisasi Baru (Create Organization)](#22-membuat-organisasi-baru-create-organization)
   - [2.3 Team & Platform Access Control (RBAC)](#23-team--platform-access-control-rbac)
   - [2.4 Single Sign-On (SSO) Enterprise](#24-single-sign-on-sso-enterprise)
   - [2.5 Integrasi Eksternal (GitHub & Vercel)](#25-integrasi-eksternal-github--vercel)
   - [2.6 Billing & Organization Settings](#26-billing--organization-settings)
3. [Anatomi Menu Tingkat Project (Backend & Database)](#-3-anatomi-menu-tingkat-project)
   - [3.1 Table Editor](#31-table-editor-gui-database)
   - [3.2 SQL Editor](#32-sql-editor-eksekusi-query--migrasi)
   - [3.3 Database & PostgreSQL Schemas](#33-database-schema-triggers--functions)
   - [3.4 Row Level Security (RLS) Policies](#34-row-level-security-rls-policies)
   - [3.5 Authentication & URL Configuration](#35-authentication-providers--redirect-urls)
   - [3.6 Storage Buckets](#36-storage-buckets-file-management)
   - [3.7 Edge Functions & Realtime](#37-edge-functions--realtime-engine)
   - [3.8 Project Settings & API Keys (Anon vs Service Role)](#38-project-settings--api-keys)
4. [Perbedaan Mendasar: Platform RBAC vs Application Multi-Tenant RBAC](#-4-perbedaan-mendasar-platform-rbac-vs-application-rbac)
5. [Kompilasi Best Practices & Keamanan Skala Enterprise](#-5-kompilasi-best-practices--keamanan)

---

## 🏛️ 1. Konsep Inti & Hirarki Supabase

Supabase mengadopsi struktur hirarki bertingkat untuk memisahkan kepemilikan bisnis dari database teknis:

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
  🚀 PROJECT: mariflow-prod       🚀 PROJECT: mariflow-dev
  (Postgres, Auth, Storage, etc.)
         │
         ▼
  🗄️ DATABASE SCHEMA (public)
  (profiles, workspaces, tasks, etc.)
```

1. **User Account**: Akun personal Anda yang digunakan untuk masuk ke platform Supabase.
2. **Organization**: Wadah (*container*) bisnis untuk mengelompokkan project, mengatur tim developer, metode pembayaran (*billing*), Single Sign-On (SSO), dan integrasi pihak ketiga.
3. **Project**: Satu instans komputasi mandiri yang menjalankan PostgreSQL Database, Supabase Auth, Storage, Edge Functions, dan Realtime Engine.

---

## 🖥️ 2. Anatomi Menu Tingkat Organisasi

Berikut adalah bedah tuntas menu organisasi berdasarkan screenshot dashboard Supabase Anda:

### 2.1 Projects & Usage Quota Monitoring

Pada tampilan utama organisasi (`Projects`):
- **Daftar Project**: Menampilkan seluruh instance database aktif (contoh: `marifin-backend` di AWS `ap-northeast-1` / Tokyo).
- **Indikator Free Plan Usage (Batas Kuota Gratis)**:
  - **Egress (Bandwidth Keluar)**: Batas **5 GB / bulan**. Data yang dikirim dari database/storage ke pengguna internet.
  - **Database Size**: Batas **500 MB**. Total ukuran data teks, relasi, tabel, dan indeks PostgreSQL.
  - **Monthly Active Users (MAU)**: Batas **50.000 user aktif / bulan**. Pengguna yang login ke aplikasi Anda.
  - **File Storage**: Batas **1 GB**. Total ukuran file lampiran dan avatar yang diunggah ke bucket Storage.
- **Tombol `+ New project`**: Digunakan untuk membuat database baru (misalnya membuat project `mariflow-backend`).

---

### 2.2 Membuat Organisasi Baru (*Create Organization*)

Pada modal **Create a new organization**:
- **Name**: Nama perusahaan, tim, atau nama brand (contoh: `Mari Partner`).
- **Type**:
  - `Personal`: Untuk proyek hobi atau pengembangan portofolio mandiri.
  - `Startup / Company`: Untuk tim bisnis yang memiliki banyak developer.
  - `Agency / Client Project`: Untuk agensi yang mengelola database milik klien terpisah.
- **Plan**:
  - `Free ($0/bulan)`: 2 project gratis, jeda otomatis (*pause*) setelah 7 hari tidak aktif, kuota 500 MB DB.
  - `Pro ($25/bulan)`: Tanpa jeda, backup otomatis harian, 8 GB DB, 100 GB Storage, 250 GB Egress.
  - `Team / Enterprise`: SLA komputasi tinggi, SOC2, HIPAA, audit log, dan SSO SAML 2.0.

---

### 2.3 Team & Platform Access Control (RBAC)

Menu **Team** digunakan untuk mengelola siapa saja developer atau rekan kerja yang memiliki hak akses ke dasbor Supabase Anda.

> [!IMPORTANT]
> **Platform Access Control** mengatur hak akses ke **Dashboard Supabase & Server Database**, bukan hak akses user di dalam aplikasi MariFlow!

Supabase menyediakan 3 peran standar (*Role*):

| Role Platform | Hak Akses (*Permissions*) | Kapan Digunakan? |
| :--- | :--- | :--- |
| 👑 **Owner** | **Akses Mutlak (Superadmin)**.<br>Bisa menghapus organisasi, memindahkan (*transfer*) project, mengubah billing, dan mengundang Owner lain. | Hanya untuk Founder / Pemilik Akun Utama. |
| ⚡ **Administrator** | **Manajemen Operasional**.<br>Bisa mengelola anggota tim, melihat billing, mengubah pengaturan project, membuat dan menghapus project.<br>❌ *Tidak bisa menghapus organisasi atau mengubah Owner.* | Untuk Tech Lead / Project Manager / DevOps Lead. |
| 🛠️ **Developer** | **Manajemen Konten & Data**.<br>Bisa menjalankan SQL di SQL Editor, membaca/menghapus data tabel, mengelola file storage, dan deploy Edge Functions.<br>❌ *Tidak bisa mengubah billing, menghapus project, atau mengundang member.* | Untuk Full-stack / Backend / Frontend Developer. |

---

### 2.4 Single Sign-On (SSO) Enterprise

Fitur **Single Sign-On (SSO)** berbasis protokol **SAML 2.0**:
- **Fungsi**: Memaksa seluruh anggota tim (*developer*) untuk login ke dashboard Supabase menggunakan Akun Korporat (seperti **Google Workspace**, **Okta**, **Microsoft Azure Active Directory**, atau **PingIdentity**).
- **Keuntungan**:
  - **Sentralisasi Keamanan**: Saat seorang karyawan *resign* dan akun Google Workspacenya dinonaktifkan oleh IT, aksesnya ke seluruh database Supabase perusahaan otomatis terputus seketika.
  - **MFA Enforcement**: Mewajibkan autentikasi dua faktor (*Two-Factor Authentication*) terpusat.
- **Ketersediaan**: Tersedia pada paket **Team Plan** ke atas.

---

### 2.5 Integrasi Eksternal (*GitHub & Vercel*)

Menu **Integrations** menghubungkan Supabase langsung dengan pipeline CI/CD deployment modern:

1. **GitHub Integration**:
   - Menghubungkan repository GitHub ke project Supabase.
   - Mengaktifkan **Branch Previews**: Setiap kali Anda membuat Pull Request (PR) di GitHub, Supabase secara otomatis membuatkan *ephemeral preview database branch* khusus untuk menguji migrasi database tanpa mengganggu database production!
2. **Vercel Integration**:
   - Menghubungkan project Supabase dengan project frontend Vercel Anda.
   - **Environment Variable Auto-Sync**: Supabase akan secara otomatis menginjeksikan `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY` ke konfigurasi Vercel Anda setiap kali ada pembaruan, tanpa perlu *copy-paste* manual.

---

### 2.6 Billing & Organization Settings

- **Billing**: Mengatur metode pembayaran kartu kredit, mengunduh faktur (*invoices*), dan melihat kalkulasi *overage usage*.
- **Organization Settings**: Mengubah nama organisasi, melihat Organization ID (slug), atau menghapus organisasi secara permanen.

---

## 🗄️ 3. Anatomi Menu Tingkat Project (Di Dalam Database)

Saat Anda mengklik salah satu project (misalnya `mariflow-backend`), Anda akan masuk ke kontrol panel backend:

```text
┌─────────────────────────────────────────────────────────────────┐
│               PANEL KONTROL PROJECT SUPABASE                    │
├─────────────────┬───────────────────────────────────────────────┤
│ 🗄️ Table Editor │ Visualisasi data CRUD seperti spreadsheet Excel│
│ >_ SQL Editor   │ Menjalankan file migrasi SQL DDL & DML        │
│ 🛡️ Database     │ Kelola Schemas, Tables, Triggers, Indexes     │
│ 🔑 Auth         │ Manajemen Akun User, Providers, Redirect URLs │
│ 📦 Storage      │ Buckets untuk upload avatar dan lampiran file │
│ ⚡ Edge Function│ Serverless API Functions (Deno / TypeScript)   │
│ 📡 Realtime     │ WebSocket subscriptions (Live Kanban Updates) │
│ ⚙️ Settings     │ API Keys (Anon vs Service Role), DB Connection │
└─────────────────┴───────────────────────────────────────────────┘
```

### 3.1 Table Editor (GUI Database)
- Antarmuka visual mirip *Google Sheets / Airtable* untuk melihat, mengedit, menambah, dan menghapus baris data secara langsung.
- Sangat berguna saat tahap prototyping dan pengecekan cepat data tabel `workspaces`, `projects`, `tasks`, dan `profiles`.

### 3.2 SQL Editor (Eksekusi Query & Migrasi)
- Terminal SQL berbasis web tempat Anda menjalankan file migrasi SQL:
  1. `20260902_000001_create_mariflow_schema.sql`
  2. `20260902_000002_seed_demo_data.sql`
  3. `20260902_000003_role_dashboard_analytics.sql`
- Dilengkapi **Supabase AI Assistant** untuk membantu membuat query PostgreSQL secara natural.

### 3.3 Database (Schema, Triggers, & Functions)
- **Schemas**: Menampilkan schema `public` (aplikasi), `auth` (akun Supabase), dan `storage`.
- **Triggers**: Automasi database seperti `on_auth_user_created` yang otomatis menyalin data dari `auth.users` ke tabel `public.profiles` saat ada user baru mendaftar.
- **Extensions**: Modul tambahan PostgreSQL seperti `uuid-ossp` (pembuatan UUID v4) dan `pgcrypto`.

### 3.4 Row Level Security (RLS) Policies
- Fitur keamanan paling krusial di PostgreSQL.
- **Aturan Baku**: Menentukan baris data mana yang boleh dibaca (*SELECT*), ditambah (*INSERT*), diubah (*UPDATE*), atau dihapus (*DELETE*) oleh user tertentu.
- Contoh: Policy `workspace_members` memastikan hanya anggota aktif yang bisa melihat daftar tugas di workspace tersebut.

### 3.5 Authentication (Providers & URL Configuration)
- **Users**: Daftar seluruh pengguna yang mendaftar via email atau OAuth.
- **URL Configuration**:
  - **Site URL**: URL domain utama frontend Anda (misal `https://app.mariflow.com`).
  - **Redirect URLs**: Daftar URL tujuan setelah klik tautan konfirmasi email atau reset password (`https://app.mariflow.com/reset-password`).
- **Email Templates**: Menyesuaikan teks email konfirmasi akun dan lupa password.

### 3.6 Storage Buckets (File Management)
- Wadah penyimpanan berkas berbasis objek (kompatibel dengan AWS S3).
- **MariFlow Buckets**:
  - `avatars`: Foto profil pengguna.
  - `task-attachments`: Lampiran berkas tugas (gambar, PDF, dokumen).

### 3.7 Edge Functions & Realtime Engine
- **Edge Functions**: Kode serverless berbasis TypeScript (Deno) yang dieksekusi di edge network dengan latensi super rendah (misal untuk integrasi webhook payment gateway).
- **Realtime Engine**: Mengirimkan perubahan database secara instan via WebSocket sehingga saat rekan tim memindahkan kartu Kanban, kartu di layar Anda berpindah seketika tanpa refresh.

### 3.8 Project Settings & API Keys

Di menu **Project Settings** ➔ **API**:

| Kunci / Variabel | Lingkungan | Sifat | Keamanan |
| :--- | :---: | :---: | :--- |
| **`Project URL`** | Frontend & Backend | Publik | `https://xxxx.supabase.co` |
| **`anon / public key`** | Frontend (`VITE_SUPABASE_ANON_KEY`) | Publik | **Aman dibagikan ke browser**. Akses datanya dibatasi ketat oleh aturan RLS PostgreSQL. |
| **`service_role key`** | Backend Tertutup Saja | **Rahasia** | 🚨 **Dilarang keras ditaruh di frontend!** Kunci ini mengabaikan (*bypass*) seluruh RLS. |

---

## ⚖️ 4. Perbedaan Mendasar: Platform RBAC vs Application RBAC

Sering terjadi kesalahpahaman antara peran di **Dashboard Supabase** dan peran di **Aplikasi MariFlow**:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. PLATFORM RBAC (Supabase Dashboard Team)                              │
│    • Owner, Administrator, Developer                                    │
│    • Mengatur siapa developer yang boleh mengakses database / server.   │
├─────────────────────────────────────────────────────────────────────────┤
│ 2. APPLICATION MULTI-TENANT RBAC (MariFlow SaaS Application)            │
│    • Owner, Admin, Member, Viewer (Tabel workspace_members)             │
│    • Mengatur siapa pengguna bisnis yang boleh mengelola workspace tim. │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🛡️ 5. Kompilasi Best Practices & Keamanan

1. **Jaga Anon Key**: Hanya gunakan `VITE_SUPABASE_ANON_KEY` pada frontend Vue 3.
2. **Aktifkan RLS pada Setiap Tabel**: Jangan pernah membuat tabel privat di schema `public` tanpa mengaktifkan `ALTER TABLE nama_tabel ENABLE ROW LEVEL SECURITY;`.
3. **Konfigurasi CORS & Site URL**: Pastikan domain frontend production telah terdaftar di *URL Configuration* Supabase Auth agar token reset password tidak bocor ke domain asing.
4. **Optimasi Koneksi Database**:
   - Untuk koneksi aplikasi serverless/Vite frontend: Gunakan Supabase Client API REST/Realtime.
   - Untuk koneksi direct pooling: Gunakan port Transaction Pooler `6543`.

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*
