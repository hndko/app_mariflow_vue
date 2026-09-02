# 📋 MariFlow SaaS — Engineering & Agent Guidelines (`AGENTS.md`)

Dokumen ini adalah **acuan utama dan aturan baku** dalam pengembangan proyek **MariFlow SaaS** (`app_mariflow_vue`). Seluruh agen coding, developer, dan kontributor wajib mematuhi panduan ini secara konsisten tanpa deviasi.

---

## 🎯 1. Identitas & Visi Proyek

- **Nama Aplikasi**: MariFlow
- **Brand / Ekosistem**: Mari Partner
- **Tagline**: Simple Workspace & Task Management
- **Tujuan**: Membantu tim kecil mengelola Workspace, Proyek, Tugas (Kanban), Anggota Tim, Komentar, Notifikasi, Lampiran File, dan Dashboard Analytics dengan integrasi backend Supabase secara end-to-end.

---

## 🛠️ 2. Tech Stack & Arsitektur Utama

- **Frontend**: Vue.js 3 (Composition API `<script setup>`), Vite, TypeScript / JavaScript, Tailwind CSS 4.
- **UI Theme**: TailAdmin Vue (TailAdmin Design Language).
- **State Management**: Pinia (`src/stores/`).
- **Routing**: Vue Router 4 (`src/router/`).
- **Backend & Database**: Supabase (PostgreSQL, Supabase Auth, Supabase Storage, Supabase Realtime, Supabase Edge Functions, Row Level Security).
- **Security Boundary**: Database PostgreSQL & RLS (bukan sekadar `v-if` di frontend).

> [!WARNING]
> **Larangan Backend Custom**: Dilarang membuat backend server tersendiri (seperti Laravel, Express, NestJS). Supabase adalah backend utama aplikasi.

---

## 📁 3. Aturan Struktur Folder (Foldering Standards)

Struktur direktori wajib terorganisir secara modular dan simetris:

### 3.1 Views (`src/views/`)
- `src/views/auth/`: Komponen otentikasi (`Login.vue`, `Register.vue`, `ForgotPassword.vue`, `ResetPassword.vue`).
- `src/views/modules/`: Seluruh modul fitur aplikasi yang dikelompokkan ke dalam subfolder masing-masing:
  - `src/views/modules/dashboard/` (`DashboardView.vue`)
  - `src/views/modules/workspaces/` (`WorkspaceListView.vue`, `WorkspaceDetailView.vue`)
  - `src/views/modules/projects/` (`ProjectListView.vue`, `ProjectDetailView.vue`)
  - `src/views/modules/tasks/` (`TaskBoardView.vue`, `TaskListView.vue`)
  - `src/views/modules/members/` (`MemberListView.vue`)
  - `src/views/modules/notifications/` (`NotificationCenterView.vue`)
  - `src/views/modules/settings/` (`ProfileSettingsView.vue`, `WorkspaceSettingsView.vue`)
  - `src/views/modules/supabase-lab/` (`SupabaseLabView.vue`)
- `src/views/public/`: Halaman publik atau landing page (`LandingView.vue`).
- `src/layouts/`:
  - `app-auth.vue`: Layout bersih untuk halaman login / register.
  - `app-modules.vue`: Layout utama dengan Sidebar, Header, Breadcrumb, dan Theme Toggler.
  - `app-public.vue`: Layout landing page publik.

### 3.2 Services (`src/services/`)
- `src/services/supabase.ts`: Inisialisasi terpusat client Supabase.
- `src/services/auth/auth.service.ts`: Logika otentikasi & session.
- `src/services/modules/`: Logika query Supabase per fitur (`workspace.service.ts`, `project.service.ts`, `task.service.ts`, `member.service.ts`, `notification.service.ts`, `storage.service.ts`).

### 3.3 Pinia Stores (`src/stores/`)
- `src/stores/auth.ts`, `workspace.ts`, `project.ts`, `task.ts`, `notification.ts`.

### 3.4 Database Migrations (`supabase/migrations/`)
- Seluruh DDL SQL, table creation, foreign keys, indexing, triggers, database functions, dan RLS policies wajib tersimpan di file SQL migrasi berurutan.

---

## 🎨 4. Standar UI/UX Wajib

### 4.1 Form Inputs
- Setiap input (Text, Email, Password, Select, Date, Textarea) **wajib memiliki Icon Group + Placeholder informatif**.
- Gunakan base components yang konsisten (`BaseInput.vue`, `BaseSelect.vue`, `BaseTextarea.vue`).

### 4.2 File Upload (Drag & Drop)
- Form upload wajib mengusung konsep **Drag & Drop** (`BaseDropzone.vue`).
- **Wajib menampilkan daftar hasil upload di bawah area dropzone**:
  - Thumbnail preview (untuk gambar) atau file type icon (PDF, DOCX, ZIP, dll).
  - Nama file lengkap dan ukuran file (KB / MB).
  - Progress bar status upload (0-100%).
  - Tombol aksi hapus / remove file.

### 4.3 Buttons
- **Tombol Standar**: Wajib memiliki **Icon + Text** (contoh: `<PlusIcon /> Tambah Workspace`).
- **Tombol Aksi Tabel**: Khusus tombol di kolom "Aksi" tabel, **hanya menampilkan Icon saja** dengan tooltip / accessible `title` / `aria-label`.

### 4.4 Data Tables
- Setiap tabel data wajib memiliki kolom penomoran otomatis dengan header **`#`** atau **`No`**.
- Dilengkapi dengan skeleton loading state, empty state yang komunikatif, dan pagination jika data melebihi limit.

### 4.5 Standar Alert & Konfirmasi (Toast Alert & SweetAlert)
- **Alert Biasa / Notifikasi Sistem**: Wajib menggunakan **Toast Alert** (`showToast.success()`, `showToast.error()`, `showToast.warning()`, `showToast.info()`) mengambang di pojok layar dengan auto-dismiss, progress bar, dan dukungan tema terang/gelap.
- **Konfirmasi Aksi (Confirm Dialog)**: Wajib menggunakan **SweetAlert Modal** (`showConfirm()`) dengan ikon visual modern, teks penjelasan tegas, dan tombol aksi terstandarisasi.
- **Larangan**: Dilarang keras menggunakan `alert()`, `confirm()`, atau banner statis yang tidak seragam.

---

## 🛡️ 5. Keamanan, Otorisasi & PostgreSQL RLS

1. **Prinsip Otorisasi Multi-Tenant**:
   - `auth.users` ➔ `profiles` ➔ `workspace_members` (Owner, Admin, Member, Viewer).
   - Pengguna hanya boleh membaca dan mengubah data di workspace tempat ia menjadi anggota aktif.
2. **Row Level Security (RLS)**:
   - RLS **wajib aktif** di seluruh tabel: `profiles`, `workspaces`, `workspace_members`, `projects`, `tasks`, `task_assignees`, `task_comments`, `task_attachments`, `notifications`, `activity_logs`.
   - Dilarang membuat policy `USING (true)` untuk data privat.
3. **Storage Security**:
   - Bucket `task-attachments` dan `avatars` wajib memiliki Storage Policies berbasis workspace membership dan user ownership.
4. **Proteksi Kredensial**:
   - Dilarang keras mengekspos `SUPABASE_SERVICE_ROLE_KEY` ke frontend.
   - Frontend hanya boleh menggunakan `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY`.
   - File `.env` wajib masuk ke `.gitignore`.

---

## ⚡ 6. Performa, Skalabilitas & Anti-Patterns

1. **Pencegahan N+1 Query**:
   - Gunakan fitur relational select Supabase (contoh: `.select('*, profiles:assigned_to(id, full_name, avatar_url)')`).
2. **Debounce pada Search & Filter**:
   - Terapkan debounce (300-500ms) pada seluruh search bar atau form filter agar tidak membebani database request.
3. **Realtime Subscription Hygiene**:
   - Seluruh subscription channel Supabase Realtime wajib di-unsubscribe pada hook `onBeforeUnmount()` untuk mencegah memory leak.
4. **Error Handling & Sanitasi**:
   - Tangani 4 state pada setiap request data: `loading`, `success`, `error`, dan `empty`.
   - Jangan tampilkan raw database stack trace / SQL error langsung ke pengguna. Tampilkan pesan yang ramah pengguna.
5. **Database Indexing**:
   - Index wajib dibuat pada foreign keys (`workspace_id`, `project_id`, `assigned_to`), filter status (`status`), dan sorting (`created_at DESC`).

---

## 🔄 7. Alur Pengerjaan Bertahap (Step-by-Step Workflow)

Sebelum dan sesudah menulis kode pada setiap milestone:
1. **Analisis Task**: Periksa requirement dan sebutkan daftar file yang akan dibuat/diubah.
2. **Implementasi Kode**: Tulis kode bersih (*Clean Code*), modular, dan sesuai standar UI/UX.
3. **Naikkan Versi Aplikasi (SemVer)**: Perbarui versi pada `package.json` dan `src/config/app.ts` sesuai kategori perubahan.
4. **Verifikasi**: Jalankan verifikasi build/linter/runtime (`npm run build`).
5. **Dokumentasikan**: Buat file dokumentasi teknis di folder `docs/` sesuai format standar PRD jika relevan.
6. **Otomatis Commit & Push**: Lakukan commit otomatis menggunakan format **Semantic Commit Messages** lalu push ke repository.

---

## 📦 8. Aturan Semantic Commit Messages (Conventional Commits)

Setiap commit **wajib** menggunakan format baku:

```text
<type>(<scope>): <description>
```

### 8.1 Daftar `<type>` Utama & Contoh
- **`feat`** (Fitur baru): `feat(auth): tambah fitur login dengan Google`
- **`fix`** (Perbaikan bug): `fix(cart): perbaiki perhitungan diskon ganda`
- **`docs`** (Perubahan dokumentasi): `docs(readme): perbarui cara instalasi aplikasi`
- **`style`** (Format kode, tanpa mengubah fungsi): `style(navbar): sesuaikan indentasi dan hapus spasi kosong`
- **`refactor`** (Restrukturisasi kode tanpa mengubah fitur): `refactor(user): pisahkan fungsi validasi ke file terpisah`
- **`perf`** (Peningkatan performa): `perf(images): kompres ukuran gambar untuk loading lebih cepat`
- **`test`** (Menambah atau mengubah unit test): `test(payment): tambah pengujian untuk transaksi gagal`
- **`chore`** (Tugas harian, konfigurasi, atau build tools): `chore(deps): perbarui pustaka Axios ke versi terbaru`
- **`build`** (Perubahan sistem build seperti Webpack, Vite, atau npm): `build(package): ganti skrip build untuk produksi`
- **`ci`** (Perubahan konfigurasi CI/CD): `ci(github-actions): tambah workflow untuk auto-lint`

### 8.2 Panduan Menulis Deskripsi yang Baik
1. **Gunakan kata kerja aktif** di awal deskripsi (contoh: `tambah`, `perbaiki`, `hapus`, `perbarui`).
2. **Gunakan huruf kecil semua** untuk deskripsi pendek.
3. **Jangan beri tanda titik (`.`)** di akhir pesan commit.
4. **Gunakan `<scope>` (opsional)** di dalam tanda kurung untuk menentukan modul/bagian kode yang berubah (contoh: `auth`, `workspace`, `tasks`, `kanban`, `ui`).
5. **Setiap pekerjaan selesai**, lakukan otomatis `git add`, `git commit`, dan `git push`.

---

## 🏷️ 9. Aturan Pemversian Semantik (Semantic Versioning / SemVer 2.0.0)

Format penomoran versi aplikasi MariFlow ditulis dalam format baku:

```text
MAJOR.MINOR.PATCH (contoh: 1.0.2)
```

### 9.1 Aturan Kenaikan Angka Versi
1. **MAJOR (Utama)**:
   - Naikkan angka pertama jika membuat perubahan besar pada arsitektur, API publik, atau skema database yang tidak lagi kompatibel dengan versi sebelumnya (*breaking changes*).
   - Contoh: `1.4.2` ➔ `2.0.0`.
2. **MINOR (Menengah)**:
   - Naikkan angka kedua jika menambahkan fitur baru atau modul baru yang tetap kompatibel secara ke belakang (*backward-compatible*).
   - Contoh: `1.0.2` ➔ `1.1.0`.
3. **PATCH (Tambahan)**:
   - Naikkan angka ketiga jika melakukan perbaikan bug (*bug fix*), optimasi performa ringan, perbaikan UI/UX kecil, atau refactor yang tetap kompatibel secara ke belakang.
   - Contoh: `1.0.1` ➔ `1.0.2`.

### 9.2 Lokasi Sinkronisasi & Penampilan Versi
- **Konfigurasi Sumber**: `package.json` (`"version": "X.Y.Z"`) dan [`src/config/app.ts`](file:///d:/laragon/www/app_mariflow_vue/src/config/app.ts) (`APP_CONFIG.version`).
- **Penampilan UI Wajib**:
  - **Sidebar Footer / Widget**: Menampilkan badge versi `vX.Y.Z` secara dinamis.
  - **Halaman Login**: Menampilkan badge `vX.Y.Z` pada header branding.
  - **Dokumentasi & Release Log**: Menyertakan nomor versi pada catatan rilis.
