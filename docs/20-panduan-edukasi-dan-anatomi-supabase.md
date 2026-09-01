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
3. **Project Name**: Ketik `mariflow-backend`.
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
8. Tunggu proses provisi server (~1-2 menit).
9. Buka **Project Settings** ➔ **API** ➔ Salin `Project URL` dan `anon / public key` ke file `.env` proyek Anda!

---

## 🗄️ 7. Anatomi Menu Tingkat Project (Di Dalam Database)

Setelah project selesai dibuat, jalankan file SQL migrasi di **SQL Editor**:
1. `supabase/migrations/20260902_000001_create_mariflow_schema.sql`
2. `supabase/migrations/20260902_000002_seed_demo_data.sql`
3. `supabase/migrations/20260902_000003_role_dashboard_analytics.sql`

Lalu buat 2 bucket di menu **Storage**:
- `avatars` (Public: ON)
- `task-attachments` (Public: ON)

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*
