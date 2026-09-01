# Database Triggers — MariFlow SaaS (Milestone 12)

## 1. Objective
Mendokumentasikan trigger otomatis di level database PostgreSQL untuk otomatisasi pendaftaran pengguna dan pencatatan audit log aktivitas secara handal.

---

## 2. Trigger Inventory

### 2.1 `on_auth_user_created` (User Onboarding)
- **Tabel**: `auth.users`
- **Aksi**: `AFTER INSERT`
- **Fungsi**: Otomatis membuat record profil di `public.profiles`, membuat workspace personal default di `public.workspaces`, mendaftarkan user sebagai `owner` di `public.workspace_members`, dan mengirim notifikasi selamat datang.

### 2.2 `trg_log_task_activity` (Audit Trail)
- **Tabel**: `public.tasks`
- **Aksi**: `AFTER INSERT OR UPDATE`
- **Fungsi**: Otomatis mencatat pembuatan task baru dan perubahan status ke tabel `public.activity_logs`.

### 2.3 `trg_*_updated_at` (Timestamp Tracking)
- **Tabel**: Seluruh tabel entitas
- **Aksi**: `BEFORE UPDATE`
- **Fungsi**: Memperbarui kolom `updated_at` dengan timestamp `NOW()` terkini.
