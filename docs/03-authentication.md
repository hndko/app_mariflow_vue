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

## 5. Security & Route Protection
- Route Guards di `src/router/index.ts` memeriksa status sesi otentikasi sebelum merender modul aplikasi.
- Halaman tamu (`/login`, `/register`, `/forgot-password`) dilindungi oleh `guestOnly: true` (pengguna yang sudah login langsung dialihkan ke `/dashboard`).
- Endpoint data Supabase dilindungi oleh RLS policy sehingga pengguna hanya dapat membaca dan mengubah profil miliknya sendiri.

---

## 6. Frontend Implementation
- **Service**: `src/services/auth/auth.service.ts`
- **Store**: `src/stores/auth.ts`
- **Views**:
  - `src/views/auth/Login.vue` (Icon Group + Placeholder, Remember Me, BaseButton)
  - `src/views/auth/Register.vue` (Validation, Agreement Checkbox, BaseButton)
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

## 8. Common Errors & Mitigation
- **PGRST116 (No rows found)**: Terjadi jika profil baru belum tergenerate. Ditangani dengan fallback data dari `user_metadata`.
- **JWT Expired**: Supabase client dikonfigurasi dengan `autoRefreshToken: true`.

---

## 9. Production Checklist
- [x] Register, Login, Logout terintegrasi.
- [x] Sesi login persist di browser.
- [x] Form input terbungkus icon group dan placeholder.
- [x] Route navigation guard aktif.
- [x] Pengaturan profil & ubah password siap digunakan.
