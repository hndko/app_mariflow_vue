# 👑 Platform Superadmin Role & Global SaaS Master Portal

Dokumen ini menjelaskan implementasi fitur **Platform Superadmin Role & SaaS Master Portal** pada aplikasi **MariFlow SaaS**.

---

## 🎯 1. Latar Belakang & Kebutuhan Bisnis

Sebagai pemilik (*Founder / Master Developer*) aplikasi SaaS MariFlow, dibutuhkan peran **Superadmin Global** di luar batasan tenant/workspace. Superadmin memiliki visibilitas penuh untuk memantau:
1. Total pertumbuhan seluruh workspace pelanggan (*Tenants*).
2. Total seluruh pengguna terdaftar (*Users*).
3. Penggunaan storage, proyek, dan tugas secara global.
4. Memberikan atau mencabut hak istimewa Superadmin kepada akun lain.

---

## 🏗️ 2. Arsitektur Database & PostgreSQL RLS

### 2.1 Migrasi Schema (`20260902_000004_add_superadmin_role.sql`)
- **Kolom Baru**: `public.profiles.is_superadmin BOOLEAN DEFAULT FALSE NOT NULL`.
- **Indeks Parsial**: `CREATE INDEX idx_profiles_is_superadmin ON public.profiles (is_superadmin) WHERE is_superadmin = TRUE;`.
- **Row Level Security (RLS)**:
  - Kebijakan RLS pada tabel `profiles` dan `workspaces` diperluas: Superadmin dapat membaca seluruh data profil dan workspace tanpa melanggar prinsip isolasi data antar-tenant pengguna biasa.
- **Fungsi RPC Superadmin**:
  - `get_superadmin_saas_metrics()`: Mengembalikan metrik agregasi global seluruh platform dengan proteksi `SECURITY DEFINER` dan pengecekan `auth.uid() = superadmin`.
  - `toggle_superadmin_status(target_user_id, new_status)`: Mengubah status superadmin akun lain.

---

## 🖥️ 3. Antarmuka Superadmin SaaS Portal (`/superadmin`)

1. **Global Platform KPIs**:
   - Total Workspace Tenant Aktif.
   - Total Pengguna Terdaftar & Total Superadmin.
   - Total Proyek Multi-Tenant & Tugas Kanban Selesai.
   - Total File Lampiran & Estimasi Kapasitas Storage.
2. **Master Tenants Table**:
   - Tabel seluruh workspace pelanggan lengkap dengan penomoran `#`, nama workspace, slug, pemilik (*tenant owner*), jumlah proyek, dan jumlah anggota.
3. **Master Users Table & Role Switcher**:
   - Tabel seluruh pengguna terdaftar dengan tombol aksi langsung untuk mengangkat (*Promote*) atau mencabut (*Revoke*) status Superadmin.
4. **Backend Engine Status**:
   - Status live koneksi PostgreSQL AWS Singapore, RLS Enforcement, Realtime WebSocket, dan Storage Buckets.

---

## 🔒 4. Cara Menjadikan Akun Anda Sebagai Superadmin di Supabase

Jalankan query SQL berikut di **SQL Editor** Supabase:

```sql
UPDATE public.profiles
SET is_superadmin = TRUE
WHERE email = 'hd.doko22@gmail.com';
```

---

*MariFlow SaaS — Simple Workspace & Task Management.*
