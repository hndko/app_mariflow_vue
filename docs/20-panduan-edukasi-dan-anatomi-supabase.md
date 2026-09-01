# 📘 Masterclass Supabase: Panduan Edukasi & Anatomi Lengkap Seluruh Menu Platform

Dokumen ini disusun sebagai **materi pembelajaran mendalam (Masterclass Guide)** mengenai ekosistem **Supabase**, anatomi seluruh fiturnya dari tingkat **Organisasi** hingga **Project**, serta keterkaitannya langsung dengan aplikasi **MariFlow SaaS**.

---

## 📑 Daftar Isi
1. [Konsep Inti & Hirarki Supabase (Organization vs Project)](#-1-konsep-inti--hirarki-supabase)
2. [Anatomi Menu Organisasi — Bagian 1 (Projects, Team, Integrations)](#-2-anatomi-menu-organisasi--bagian-1)
   - [2.1 Projects & Usage Quota Monitoring](#21-projects--usage-quota-monitoring)
   - [2.2 Membuat Organisasi Baru (Create Organization)](#22-membuat-organisasi-baru-create-organization)
   - [2.3 Team & Platform Access Control (RBAC)](#23-team--platform-access-control-rbac)
   - [2.4 Single Sign-On (SSO) Enterprise](#24-single-sign-on-sso-enterprise)
   - [2.5 Integrasi Eksternal (GitHub & Vercel)](#25-integrasi-eksternal-github--vercel)
3. [Anatomi Menu Organisasi — Bagian 2 (Organization Settings & Compliance)](#-3-anatomi-menu-organisasi--bagian-2-organization-settings)
   - [3.1 Data Privacy & Supabase AI Opt-in Level](#31-data-privacy--supabase-ai-opt-in-level)
   - [3.2 Organization Security & MFA Enforcement](#32-organization-security--mfa-enforcement)
   - [3.3 SSO Configuration & Domain Access Control](#33-sso-configuration--domain-access-control)
   - [3.4 OAuth Apps (Published & Authorized Apps)](#34-oauth-apps-published--authorized-apps)
   - [3.5 Compliance: Audit Logs, Drains, & Legal Documents](#35-compliance-audit-logs-drains--legal-documents)
4. [Rekomendasi Konfigurasi Khusus untuk Project MariFlow SaaS](#-4-rekomendasi-konfigurasi-khusus-untuk-project-mariflow-saas)
5. [Anatomi Menu Tingkat Project (Backend & Database Engine)](#-5-anatomi-menu-tingkat-project)
   - [5.1 Table Editor](#51-table-editor-gui-database)
   - [5.2 SQL Editor](#52-sql-editor-eksekusi-query--migrasi)
   - [5.3 Database & PostgreSQL Schemas](#53-database-schema-triggers--functions)
   - [5.4 Row Level Security (RLS) Policies](#54-row-level-security-rls-policies)
   - [5.5 Authentication & URL Configuration](#55-authentication-providers--redirect-urls)
   - [5.6 Storage Buckets](#56-storage-buckets-file-management)
   - [5.7 Edge Functions & Realtime](#57-edge-functions--realtime-engine)
   - [5.8 Project Settings & API Keys (Anon vs Service Role)](#58-project-settings--api-keys)
6. [Perbedaan Mendasar: Platform RBAC vs Application Multi-Tenant RBAC](#-6-perbedaan-mendasar-platform-rbac-vs-application-rbac)

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

---

## 🖥️ 2. Anatomi Menu Organisasi — Bagian 1

### 2.1 Projects & Usage Quota Monitoring
- **Daftar Project**: Menampilkan seluruh instance database aktif (contoh: `marifin-backend` di AWS `ap-northeast-1`).
- **Indikator Free Plan Usage (Batas Kuota Gratis)**:
  - **Egress (0 MB / 5 GB)**: Bandwidth transfer data keluar per bulan.
  - **Database Size (27 MB / 500 MB)**: Total ukuran data dan tabel PostgreSQL.
  - **Monthly Active Users (0 / 50.000 MAU)**: Kuota pengguna yang login tiap bulan.
  - **File Storage (0 GB / 1 GB)**: Total kapasitas file lampiran dan avatar.

### 2.2 Membuat Organisasi Baru (*Create Organization*)
- **Name**: Nama wadah (contoh: `Mari Partner`).
- **Type**: `Personal`, `Company/Startup`, atau `Agency/Client`.
- **Plan**: `Free` ($0/bln), `Pro` ($25/bln), `Team` ($599/bln).

### 2.3 Team & Platform Access Control (RBAC)
Mengatur hak akses developer di dashboard Supabase:
- 👑 **Owner**: Akses mutlak (hapus org, pindah project, ubah billing).
- ⚡ **Administrator**: Kelola anggota, billing, project settings.
- 🛠️ **Developer**: Jalankan SQL, edit data, kelola storage, deploy functions.

### 2.4 Single Sign-On (SSO) Enterprise
Protokol SAML 2.0 untuk mewajibkan login developer via Google Workspace atau Okta perusahaan (khusus Team Plan ke atas).

### 2.5 Integrasi Eksternal (*GitHub & Vercel*)
- **GitHub**: Mengaktifkan *Database Branching* otomatis pada Pull Request.
- **Vercel**: Mengalirkan environment variables (`VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`) secara otomatis ke dashboard Vercel.

---

## ⚙️ 3. Anatomi Menu Organisasi — Bagian 2 (Organization Settings)

Berdasarkan 5 screenshot lanjutan pada menu **Organization Settings**:

### 3.1 Data Privacy & Supabase AI Opt-in Level

Menu ini mengatur sejauh mana **Supabase AI Assistant** (asisten kecerdasan buatan pada SQL Editor) diizinkan membaca struktur data Anda:

| Opsi Level | Penjelasan & Akses AI | Tingkat Privasi Data |
| :--- | :--- | :---: |
| 🔘 **Disabled** *(Bawaan)* | AI tidak membaca skema apapun. Respon AI akan bersifat generik dan tidak tahu nama tabel proyek Anda. | 🔒 **Maksimal** |
| 🟢 **Schema Only** *(Sangat Direkomendasikan)* | AI diizinkan membaca **metadata skema** (nama tabel: `workspaces`, `tasks`, nama kolom, relasi FK), tetapi **TIDAK BISA membaca isi baris data sensitif**. | 💡 **Optimal & Aman** |
| 🟡 **Schema & Logs** | AI membaca skema dan log query error untuk mendiagnosis masalah teknis secara otomatis. | ⚠️ **Menengah** |
| 🔴 **Schema, Logs & Database Data** | AI diberi hak akses penuh membaca isi baris tabel database. | 🚨 **Kurang Direkomendasikan** |

---

### 3.2 Organization Security & MFA Enforcement

- **Fungsi**: Memaksa (*enforce*) seluruh developer di organisasi `Mari Partner` untuk menyalakan autentikasi dua faktor (MFA/2FA) saat login ke Supabase.
- **Status di Free Plan**: Opsi *Organization-wide enforcement* memerlukan Pro Plan. Namun, setiap individu developer tetap bisa mengaktifkan MFA secara mandiri pada pengaturan profilnya.

---

### 3.3 SSO Configuration & Domain Access Control

- **Fungsi**: Membatasi agar hanya email dengan domain resmi perusahaan (contoh: `@maripartner.com`) yang diizinkan login ke organisasi via Identity Provider (SAML 2.0).
- **Status di Free Plan**: Tersedia pada paket Team Plan ke atas.

---

### 3.4 OAuth Apps (Published & Authorized Apps)

- **Published Apps**: Digunakan jika Anda ingin membuat aplikasi integrasi pihak ketiga (misalnya ekstensi VS Code atau plugin Raycast) yang meminta izin user Supabase lain via protokol OAuth 2.0.
- **Authorized Apps**: Daftar aplikasi pihak ketiga (seperti Vercel, Retool, Zapier) yang telah Anda beri wewenang untuk membaca atau mengelola project Supabase Anda.

---

### 3.5 Compliance: Audit Logs, Drains, & Legal Documents

- **Audit Logs**: Rekaman jejak audit 62 hari mengenai siapa yang membuat/menghapus project, mengubah environment variables, atau mengundang anggota baru (standar kepatuhan SOC2 / HIPAA).
- **Audit Log Drains**: Fitur untuk mengekspor log keamanan secara real-time ke layanan monitoring eksternal seperti Datadog, Splunk, atau AWS CloudWatch.
- **Legal Documents**: Surat perjanjian perlindungan data bisnis (Data Processing Addendum / BAA).

---

## 💡 4. Rekomendasi Konfigurasi Khusus untuk Project MariFlow SaaS

Berikut adalah pengaturan praktis yang disarankan untuk diterapkan pada project kita:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│              REKOMENDASI ACTIONABLE UNTUK MARIFLOW SAAS                 │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. Data Privacy ➔ Aktifkan "Schema Only"                                │
│    Manfaat: Supabase AI di SQL Editor bisa langsung menulis query DDL   │
│    dan agregasi dashboard analytics secara presisi sesuai tabel kita.   │
│                                                                         │
│ 2. Integrations ➔ Pasang Vercel Integration                             │
│    Manfaat: Saat deploy MariFlow ke Vercel, Vercel langsung otomatis    │
│    mengenali URL dan Anon Key tanpa perlu input manual di dashboard.    │
│                                                                         │
│ 3. Application Activity Logs (Built-in)                                 │
│    Karena Audit Logs platform memerlukan paket Team, MariFlow SaaS      │
│    telah dilengkapi tabel mandiri `activity_logs` di PostgreSQL yang    │
│    mencatat audit perubahan status tugas kanban pada Free Plan!         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ 5. Anatomi Menu Tingkat Project (Di Dalam Database)

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

### 5.1 Table Editor
Antarmuka visual untuk melihat dan memverifikasi data tabel `workspaces`, `projects`, `tasks`, dan `profiles`.

### 5.2 SQL Editor
Terminal eksekusi skrip migrasi SQL secara berurutan:
1. `20260902_000001_create_mariflow_schema.sql`
2. `20260902_000002_seed_demo_data.sql`
3. `20260902_000003_role_dashboard_analytics.sql`

### 5.3 Database & RLS
- **RLS (Row Level Security)**: Wajib aktif di seluruh tabel untuk mengisolasi data antar-workspace secara multi-tenant.

### 5.4 Storage Buckets
- `avatars` (Public): Foto profil pengguna.
- `task-attachments` (Public): Berkas dokumen/gambar tugas tim.

---

## ⚖️ 6. Perbedaan Mendasar: Platform RBAC vs Application RBAC

```text
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. PLATFORM RBAC (Di Dashboard Supabase: Owner, Administrator, Developer)│
│    ➔ Mengatur siapa developer yang berhak membuka database backend.     │
├─────────────────────────────────────────────────────────────────────────┤
│ 2. APPLICATION MULTI-TENANT RBAC (Di dalam Aplikasi MariFlow)           │
│    ➔ Owner, Admin, Member, Viewer (Tabel workspace_members)             │
│    ➔ Mengatur siapa pengguna bisnis yang berhak mengelola tugas.        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*
