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
3. [Anatomi Menu Organisasi — Bagian 2 (Configuration, Security & OAuth)](#-3-anatomi-menu-organisasi--bagian-2)
   - [3.1 Data Privacy & Supabase AI Opt-in Level](#31-data-privacy--supabase-ai-opt-in-level)
   - [3.2 Organization Security & MFA Enforcement](#32-organization-security--mfa-enforcement)
   - [3.3 SSO Configuration & Domain Access Control](#33-sso-configuration--domain-access-control)
   - [3.4 OAuth Apps (Published & Authorized Apps)](#34-oauth-apps-published--authorized-apps)
4. [Anatomi Menu Organisasi — Bagian 3 (Compliance, Legal & Usage Metrics)](#-4-anatomi-menu-organisasi--bagian-3)
   - [4.1 Compliance: Audit Log Drains & Legal Documents (DPA, TIA, SOC2, HIPAA)](#41-compliance-audit-log-drains--legal-documents)
   - [4.2 Usage Dashboard: Analisis 10 Metrik Kuota Realtime](#42-usage-dashboard-analisis-10-metrik-kuota-realtime)
   - [4.3 Egress Breakdown & Penghematan Bandwidth](#43-egress-breakdown--penghematan-bandwidth)
5. [Rekomendasi Konfigurasi & Optimasi Kode untuk MariFlow SaaS](#-5-rekomendasi-konfigurasi--optimasi-kode-untuk-mariflow-saas)
6. [Anatomi Menu Tingkat Project (Backend & Database Engine)](#-6-anatomi-menu-tingkat-project)
   - [6.1 Table Editor](#61-table-editor-gui-database)
   - [6.2 SQL Editor](#62-sql-editor-eksekusi-query--migrasi)
   - [6.3 Database & PostgreSQL Schemas](#63-database-schema-triggers--functions)
   - [6.4 Row Level Security (RLS) Policies](#64-row-level-security-rls-policies)
   - [6.5 Authentication & URL Configuration](#65-authentication-providers--redirect-urls)
   - [6.6 Storage Buckets](#66-storage-buckets-file-management)
   - [6.7 Edge Functions & Realtime Engine](#67-edge-functions--realtime-engine)
   - [6.8 Project Settings & API Keys (Anon vs Service Role)](#68-project-settings--api-keys)
7. [Perbedaan Mendasar: Platform RBAC vs Application Multi-Tenant RBAC](#-7-perbedaan-mendasar-platform-rbac-vs-application-rbac)

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
  🚀 PROJECT: marifin-backend     🚀 PROJECT: mariflow-prod
  (Postgres, Auth, Storage, etc.)
         │
         ▼
  🗄️ DATABASE SCHEMA (public)
  (profiles, workspaces, tasks, etc.)
```

---

## 🖥️ 2. Anatomi Menu Organisasi — Bagian 1

### 2.1 Projects & Usage Quota Monitoring
- **Daftar Project**: Menampilkan seluruh instance database aktif (contoh: `marifin-backend` di AWS `ap-northeast-1` / Tokyo).
- **Tombol `+ New project`**: Digunakan saat Anda ingin membuat database baru khusus untuk **MariFlow SaaS**.

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

## ⚙️ 3. Anatomi Menu Organisasi — Bagian 2

### 3.1 Data Privacy & Supabase AI Opt-in Level
- **🔘 Disabled**: AI tidak membaca skema tabel Anda sama sekali.
- **🟢 Schema Only (*Rekomendasi Terbaik*)**: Mengizinkan AI membaca metadata skema (nama tabel, kolom, tipe data) tanpa membaca isi baris data sensitif pengguna.
- **🟡 Schema & Logs**: AI membaca skema + log query error.
- **🔴 Schema, Logs & Database Data**: AI membaca seluruh data baris database.

### 3.2 Organization Security & MFA Enforcement
Mewajibkan (*enforce*) seluruh developer mengaktifkan Two-Factor Authentication (2FA) saat masuk ke dashboard Supabase (khusus paket Pro ke atas).

### 3.3 OAuth Apps (Published & Authorized Apps)
- **Published Apps**: Untuk mempublikasikan integrasi OAuth pihak ketiga buatan Anda.
- **Authorized Apps**: Daftar aplikasi pihak ketiga (seperti Vercel, Retool, Zapier) yang diizinkan mengakses data Supabase Anda.

---

## 📜 4. Anatomi Menu Organisasi — Bagian 3 (Compliance, Legal & Usage Metrics)

Berdasarkan 5 screenshot lanjutan pada menu **Compliance** dan **Usage**:

### 4.1 Compliance: Audit Log Drains & Legal Documents

1. **Audit Log Drains**:
   - Fitur enterprise (Team Plan) untuk mengekspor rekaman log keamanan platform ke sistem monitoring pihak ketiga seperti Datadog, AWS CloudWatch, Splunk, atau Logflare.
2. **Data Processing Addendum (DPA)**:
   - Dokumen perjanjian hukum kepatuhan privasi data antara organisasi Anda dan Supabase. Otomatis berlaku untuk seluruh pengguna gratis maupun berbayar.
3. **Transfer Impact Assessment (TIA)**:
   - Dokumen penilaian transfer data internasional yang mematuhi regulasi privasi Eropa (**GDPR**).
4. **SOC2 Type 2 & ISO 27001**:
   - Sertifikasi standar keamanan industri internasional tingkat tinggi yang dimiliki oleh pusat data Supabase.
5. **HIPAA (Health Insurance Portability and Accountability Act)**:
   - Add-on berbayar khusus untuk aplikasi kesehatan yang memproses data medis pasien di Amerika Serikat.

---

### 4.2 Usage Dashboard: Analisis 10 Metrik Kuota Realtime

Pada menu **Usage** (`03 Aug 2026 - 03 Sep 2026` di Free Plan):

| Metrik Kuota | Batas Free Plan | Penggunaan Saat Ini | Keterangan untuk Aplikasi MariFlow |
| :--- | :---: | :---: | :--- |
| 🗄️ **Database Size** | **500 MB (0.5 GB)** | **27 MB (5%)** | Total ukuran tabel PostgreSQL (`workspaces`, `tasks`, `projects`, `comments`). Cukup untuk jutaan baris data teks! |
| 🌐 **Egress (Network Out)** | **5 GB** | **0 GB (<1%)** | Total transfer data dari database/storage ke browser pengguna. |
| ⚡ **Cached Egress** | **5 GB** | **0 GB** | Data yang disajikan melalui CDN cache global Supabase. |
| 👥 **Monthly Active Users (MAU)** | **50.000 MAU** | **0 MAU** | Jumlah user unik yang login ke MariFlow dalam 1 siklus bulan. |
| 👥 **Third-Party MAU** | **50.000 MAU** | **0 MAU** | User yang login melalui OAuth (Google, GitHub, Discord). |
| 📦 **Storage Size** | **1 GB** | **0 GB** | Total ukuran file avatar dan dokumen lampiran tugas kanban. |
| 📡 **Realtime Peak Connections** | **200 koneksi** | **0** | Maksimal pengguna yang membuka Papan Kanban secara bersamaan dalam 1 detik. |
| 💬 **Realtime Messages** | **2.000.000 pesan** | **0** | Jumlah event websocket (misal event drag-and-drop pindah kolom kanban). |
| ⚡ **Edge Function Invocations** | **500.000 panggilan** | **0** | Panggilan fungsi serverless backend Deno. |
| 🖼️ **Storage Image Transformation** | *Pro Feature* | *Unavailable* | Fitur resize gambar otomatis di CDN Storage (memerlukan Pro). |

---

### 4.3 Egress Breakdown & Penghematan Bandwidth

- **Egress** mencakup seluruh lalu lintas keluar: Database API, File Storage Download, Realtime WebSocket, Supabase Auth, dan Edge Functions.
- **Strategi Efisiensi MariFlow**:
  1. Frontend Vue 3 memilih kolom spesifik (`.select('id, name, status')`) alih-alih `select('*')`.
  2. Search bar dan filter tanggal menerapkan debounce 300-500ms agar tidak memicu panggilan query berulang saat pengguna mengetik.

---

## 🎯 5. Rekomendasi Konfigurasi & Optimasi Kode untuk MariFlow SaaS

Berikut adalah poin-poin actionable yang dapat diterapkan langsung pada project kita:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│              REKOMENDASI ACTIONABLE UNTUK MARIFLOW SAAS                 │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. Data Privacy ➔ Aktifkan "Schema Only"                                │
│    Manfaat: Supabase AI di SQL Editor bisa langsung menulis query DDL   │
│    dan agregasi dashboard analytics secara presisi sesuai tabel kita.   │
│                                                                         │
│ 2. Storage Upload File Size Limit (Proteksi Kuota 1 GB)                 │
│    Terapkan batas maksimal ukuran file upload (misal: 10 MB per file)   │
│    pada komponen BaseDropzone.vue agar kuota 1 GB tidak cepat habis.    │
│                                                                         │
│ 3. Realtime Connection Hygiene (Proteksi Kuota 200 Koneksi)             │
│    Pastikan seluruh subscription Supabase Realtime di-unsubscribe pada  │
│    hook onBeforeUnmount() di Vue 3 saat pengguna berpindah halaman.     │
│                                                                         │
│ 4. Integrasi Vercel                                                     │
│    Hubungkan Supabase ke Vercel di menu Integrations untuk auto-sync    │
│    variabel lingkungan VITE_SUPABASE_URL & VITE_SUPABASE_ANON_KEY.      │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ 6. Anatomi Menu Tingkat Project (Di Dalam Database)

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

---

## ⚖️ 7. Perbedaan Mendasar: Platform RBAC vs Application RBAC

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
