# Authentication & Profile Management — MariFlow SaaS (Milestone 2)

## 1. Objective
Mengimplementasikan modul otentikasi menyeluruh menggunakan Supabase Auth (Register, Login, Logout, Session Persistence, Forgot Password, Reset Password), sinkronisasi profil pengguna ke tabel PostgreSQL `profiles`, rute terproteksi (Route Guards), serta halaman pengaturan profil dengan avatar upload.

---

## 2. Concept
Arsitektur otentikasi MariFlow memanfaatkan standar JWT token terenkripsi dari Supabase Auth:
```text
Pengguna Register / Login
           │
           ▼
Supabase Auth (auth.users)
           │
           ├────────► Trigger Otomatis / Service
           │                │
           ▼                ▼
Simpan Sesi (JWT)     Sinkronisasi ke `public.profiles`
           │
           ▼
Pinia Store (`useAuthStore`) ──► State Reaktif di UI (Avatar, Nama, Email)
```

---

## 3. Supabase Auth Configuration
- **Auth Provider**: Email & Password.
- **Auto-confirm**: Email confirmation dapat diaktifkan atau dinonaktifkan di dashboard Supabase.
- **Session Persistence**: Dikelola secara otomatis oleh Supabase JS client di `localStorage`.
- **Auto Token Refresh**: Supabase client secara otomatis merefresh token sebelum masa berlaku habis.

---

## 4. Database: Table `profiles`
Tabel profil pengguna tersimpan di skema `public.profiles`:
```sql
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    avatar_url TEXT,
    email TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 4. Database: Table `profiles` vs `auth.users`

### 4.1 Mengapa Tidak Ada Kolom `password` di Tabel `public.profiles`?
Di ekosistem Supabase & PostgreSQL, sistem menerapkan pemisahan tanggung jawab (*Separation of Concerns*) dan kepatuhan keamanan industri (OWASP Security Standard):

```text
┌───────────────────────────────────────────────────────────┐
│                 🔒 SKEMA PRIVAT: auth.users               │
│  - id (UUID Primary Key)                                  │
│  - email (Tervalidasi)                                    │
│  - encrypted_password (Hash Bcrypt Standar GoTrue)        │
│  - email_confirmed_at (Status Verifikasi Akun)            │
│  - role: 'authenticated'                                  │
└─────────────────────────────┬─────────────────────────────┘
                              │
                              │ Relasi Foreign Key (id)
                              ▼
┌───────────────────────────────────────────────────────────┐
│                🌐 SKEMA PUBLIK: public.profiles           │
│  - id (UUID PK REFERENCES auth.users(id))                 │
│  - full_name (Nama Lengkap Pengguna)                      │
│  - avatar_url (URL Gambar Profil)                         │
│  - role (User Role: superadmin / owner / admin / member)  │
│  - created_at & updated_at                                │
└───────────────────────────────────────────────────────────┘
```

1. **Keamanan Kredensial**: Kata sandi terenkripsi (hash Bcrypt) disimpan murni di tabel privat `auth.users` yang dikelola oleh GoTrue engine Supabase. Kolom ini tidak boleh dan tidak pernah diekspos ke tabel publik atau client-side JavaScript.
2. **Fleksibilitas Metadata**: Tabel `public.profiles` hanya menyimpan data publik yang diperlukan oleh antarmuka aplikasi dan dapat di-query dengan aman oleh pengguna terotentikasi melalui Row Level Security (RLS).

---

## 5. Security & Route Protection
- Route Guards di `src/router/index.ts` memeriksa status sesi otentikasi sebelum merender modul aplikasi.
- Halaman tamu (`/login`, `/register`, `/forgot-password`) dilindungi oleh `guestOnly: true` (pengguna yang sudah login langsung dialihkan ke `/dashboard`).
- Endpoint data Supabase dilindungi oleh RLS policy sehingga pengguna hanya dapat membaca dan mengubah profil miliknya sendiri.

---

## 6. Frontend Implementation
- **Service**: `src/services/auth/auth.service.ts`
- **Store**: `src/stores/auth.ts`
- **Views**:
  - `src/views/auth/Login.vue` (Icon Group + Placeholder, Remember Me, Interactive Eye Toggle, 1-Click Demo Fill, 100% Toast Alerts)
  - `src/views/auth/Register.vue` (Validation, Agreement Checkbox, BaseButton, Toast Alert)
  - `src/views/auth/ForgotPassword.vue` & `ResetPassword.vue`
  - `src/views/modules/settings/ProfileSettingsView.vue` (Personal Info, BaseDropzone avatar upload, Change Password modal)

---

## 7. Testing & Verification
1. **Register**: Mengisi form registrasi, memastikan user terbuat di `auth.users` dan data tersinkron di `profiles`.
2. **Login**: Verifikasi token JWT tersimpan di state Pinia dan routing diarahkan ke `/dashboard`.
3. **Session Restore**: Refresh browser (F5) untuk memastikan sesi login tetap aktif tanpa logout mendadak.
4. **Update Profile**: Mengubah nama lengkap dan mengunggah foto profil baru.
5. **Change Password**: Validasi minimal 6 karakter dan verifikasi kesamaan password.
6. **Logout**: Memastikan token terhapus dan router dialihkan ke `/login`.

---

## 8. Common Errors & Troubleshooting

### 8.1 Error `invalid_credentials` ("Invalid login credentials")
- **Penyebab 1: Akun Belum Ada di `auth.users`**: Database baru saja di-reset sehingga tabel `auth.users` belum berisi akun demo.
- **Penyebab 2: Hash Password Belum Sesuai GoTrue Format**: Password tidak di-hash menggunakan algoritma Bcrypt standar GoTrue (`crypt('password', gen_salt('bf', 10))`) atau status `email_confirmed_at` masih NULL.
- **Solusi**: Jalankan script SQL aktivasi akun demo di Supabase SQL Editor.

### 8.2 Script SQL Aktivasi & Reset Password Akun Demo
```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
    confirmation_token, recovery_token, email_change_token_new, email_change
) VALUES 
(
    '00000000-0000-0000-0000-000000000001'::UUID, '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'superadmin@example.com',
    crypt('password', gen_salt('bf', 10)), NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Super Administrator"}'::jsonb,
    NOW(), NOW(), '', '', '', ''
),
(
    '00000000-0000-0000-0000-000000000002'::UUID, '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'owner@example.com',
    crypt('password', gen_salt('bf', 10)), NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Budi Santoso (Owner)"}'::jsonb,
    NOW(), NOW(), '', '', '', ''
),
(
    '00000000-0000-0000-0000-000000000003'::UUID, '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'admin@example.com',
    crypt('password', gen_salt('bf', 10)), NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Siti Rahma (Admin)"}'::jsonb,
    NOW(), NOW(), '', '', '', ''
),
(
    '00000000-0000-0000-0000-000000000004'::UUID, '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'member@example.com',
    crypt('password', gen_salt('bf', 10)), NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Rian Pratama (Member)"}'::jsonb,
    NOW(), NOW(), '', '', '', ''
),
(
    '00000000-0000-0000-0000-000000000005'::UUID, '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'viewer@example.com',
    crypt('password', gen_salt('bf', 10)), NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Maya Indah (Viewer)"}'::jsonb,
    NOW(), NOW(), '', '', '', ''
)
ON CONFLICT (id) DO UPDATE SET 
    encrypted_password = crypt('password', gen_salt('bf', 10)),
    email_confirmed_at = NOW(),
    updated_at = NOW();
```

### 8.3 Error Lainnya
- **PGRST116 (No rows found)**: Terjadi jika profil baru belum tergenerate. Ditangani dengan fallback data dari `user_metadata`.
- **JWT Expired**: Supabase client dikonfigurasi dengan `autoRefreshToken: true`.

---

## 9. Production Checklist
- [x] Register, Login, Logout terintegrasi.
- [x] Sesi login persist di browser.
- [x] Form input terbungkus icon group dan placeholder.
- [x] Route navigation guard aktif.
- [x] Pengaturan profil & ubah password siap digunakan.
- [x] Dokumentasi arsitektur auth & solusi invalid credentials lengkap.
