# 🌊 MariFlow — Simple Workspace & Task Management SaaS

> Platform SaaS modern untuk manajemen workspace, proyek, tugas Kanban, anggota tim, lampiran file, dan analitik performa berbasis Vue 3 dan Supabase.

---

## 📑 Daftar Isi

- [🎯 Deskripsi Proyek](#-deskripsi-proyek)
- [✨ Fitur Utama](#-fitur-utama)
- [🛠️ Tech Stack & Prasyarat](#️-tech-stack--prasyarat)
- [🚀 Panduan Instalasi](#-panduan-instalasi)
- [💻 Penggunaan](#-penggunaan)
- [🗄️ Konfigurasi Database Supabase](#️-konfigurasi-database-supabase)
- [📐 Standar Komponen UI & Kode](#-standar-komponen-ui--kode)
- [🤝 Panduan Kontribusi](#-panduan-kontribusi)
- [📄 Lisensi](#-lisensi)

---

## 🎯 Deskripsi Proyek

**MariFlow** adalah platform SaaS yang dirancang untuk membantu tim kecil dan menengah mengorganisasi alur kerja digital dalam satu ekosistem terpadu. MariFlow menyelesaikan kendala fragmentasi tugas, miskomunikasi tim, dan pelacakan progres proyek yang lambat melalui integrasi antarmuka modern yang cepat dan backend *Serverless Backend-as-a-Service* (BaaS) berbasis **Supabase**.

---

## ✨ Fitur Utama

- 🏢 **Multi-Tenant Workspaces**: Pengelolaan multi-workspace dengan isolasi data ketat berbasis *Row Level Security* (RLS).
- 📌 **Papan Tugas Kanban Interaktif**: Pembaruan status tugas secara *drag-and-drop* dengan kartu informatif (prioritas, tenggat waktu, assignee).
- 📁 **Manajemen Proyek**: Pelacakan status perencanaan, aktif, selesai, dan arsip proyek dengan filter terpadu.
- 👥 **Kolaborasi Tim & Multi-Role**: Manajemen hak akses berjenjang (*Owner*, *Admin*, *Member*, *Viewer*) serta modal undang anggota via email.
- 💬 **Komentar & Threading**: Diskusi kontekstual pada setiap kartu tugas secara realtime.
- 📎 **Drag & Drop File Attachments**: Unggah lampiran tugas dan foto profil ke *Supabase Storage* dengan visual list dan preview instan di bawah form.
- 🔔 **Pusat Notifikasi Realtime**: Notifikasi in-app otomatis saat ditugaskan atau menerima komentar baru.
- 📊 **Dashboard Analytics**: Agregasi KPI instan dan visualisasi grafik interaktif (*ApexCharts*) berbasis *PostgreSQL RPC*.
- 🧪 **Supabase Educational Lab**: Dokumentasi interaktif end-to-end untuk mempelajari arsitektur Supabase.

---

## 🛠️ Tech Stack & Prasyarat

Sebelum menjalankan proyek ini di komputer lokal, pastikan perangkat Anda telah memenuhi prasyarat minimum berikut:

### Prasyarat Sistem
- **Node.js**: Versi `18.x` atau lebih baru (direkomendasikan `20.x` / `22.x LTS`)
- **npm**: Versi `9.x` atau lebih baru (atau `pnpm` / `yarn`)
- **Git**: Versi `2.x`
- **Akun Supabase**: [Supabase Cloud](https://supabase.com) atau instance lokal via Supabase CLI

### Teknologi Utama
- **Frontend Framework**: [Vue.js 3](https://vuejs.org/) (Composition API `<script setup>`)
- **Build Tool**: [Vite 6](https://vite.dev/)
- **Styling & Design Language**: [Tailwind CSS 4](https://tailwindcss.com/) & [TailAdmin](https://tailadmin.com/)
- **State Management**: [Pinia](https://pinia.vuejs.org/)
- **Client Routing**: [Vue Router 4](https://router.vuejs.org/)
- **Backend & Database**: [Supabase](https://supabase.com/) (PostgreSQL 15+, Supabase Auth, Storage, Realtime, RLS)

---

## 🚀 Panduan Instalasi

Ikuti langkah-langkah berikut untuk memasang proyek dari terminal:

### 1. Klon Repositori
```bash
git clone https://github.com/hndko/app_mariflow_vue.git
cd app_mariflow_vue
```

### 2. Pasang Dependensi Proyek
```bash
npm install
```

### 3. Konfigurasi Environment Variable
Salin file `.env.example` menjadi `.env`:
```bash
cp .env.example .env
```
Buka file `.env` dan masukkan kredensial Supabase Anda:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-supabase-anon-key
```

> [!CAUTION]
> **Dilarang keras** memasukkan `SUPABASE_SERVICE_ROLE_KEY` ke dalam file `.env` frontend atau source code.

---

## 💻 Penggunaan

### Menjalankan Development Server
Jalankan perintah berikut untuk memulai server lokal dengan fitur *Hot Module Replacement* (HMR):
```bash
npm run dev
```
Buka browser pada alamat: [http://localhost:5173](http://localhost:5173)

### Menjalankan Pemeriksaan Tipe (Type-Check)
```bash
npm run type-check
```

### Kompilasi untuk Lingkungan Produksi (Build)
```bash
npm run build
```
Output berkas statis siap rilis akan disimpan pada direktori `dist/`.

### Menjalankan Pratinjau Build (Preview)
```bash
npm run preview
```

### Format & Linter Kode
```bash
npm run lint
npm run format
```

---

## 🗄️ Konfigurasi Database Supabase

Untuk menyiapkan database PostgreSQL di instance Supabase Anda:

1. Buka **SQL Editor** pada project Supabase Anda.
2. Jalankan file migrasi secara berurutan:
   - `supabase/migrations/20260902_000001_create_mariflow_schema.sql` (Skema tabel, relasi foreign key, indeks, trigger pendaftaran, dan kebijakan RLS)
   - `supabase/migrations/20260902_000002_dashboard_rpc_functions.sql` (Fungsi RPC statistik dashboard dan trigger activity log)
3. Buat bucket penyimpanan pada menu **Storage**:
   - `avatars` (*Public Read*: Ya)
   - `task-attachments` (*Public Read*: Tidak / Privat)

---

## 📐 Standar Komponen UI & Kode

MariFlow menerapkan aturan ketat pada setiap antarmuka pengguna:
- 🏷️ **Form Input**: Setiap input memiliki *Icon Group* prefix/suffix dan placeholder yang informatif (`BaseInput.vue`, `BaseSelect.vue`).
- 📥 **Drag & Drop Upload**: Form upload file berkonsep *Drag & Drop* dan **wajib menampilkan daftar hasil upload di bawah form** lengkap dengan preview thumbnail, nama file, ukuran, dan tombol hapus (`BaseDropzone.vue`).
- 🔘 **Buttons**: Seluruh tombol standar memiliki format **Icon + Text**, sedangkan tombol aksi pada kolom tabel disederhanakan menjadi **Icon-only** dengan tooltip aksesibilitas (`BaseButton.vue`).
- 🔢 **Penomoran Tabel Otomatis**: Setiap tabel data menyertakan kolom nomor urut otomatis berlabel **`#`** (`BaseTable.vue`).
- ⚡ **Debouncing**: Pencarian dan filter dilengkapi mekanisme *debounce* (300ms) untuk mencegah beban request berlebih.

---

## 🤝 Panduan Kontribusi

Kontribusi dari pengembang terbuka sangat dihargai. Silakan ikuti aturan standar berikut:

### 1. Buat Branch Baru
```bash
git checkout -b feat/nama-fitur-baru
```

### 2. Gunakan Semantic Commit Messages (Conventional Commits)
Format wajib: `<type>(<scope>): <description>`
- `feat(tasks)`: Tambah fitur filter prioritas pada papan Kanban
- `fix(auth)`: Perbaiki validasi konfirmasi kata sandi
- `docs(readme)`: Perbarui instruksi instalasi
- `refactor(services)`: Optimasi query join Supabase

### 3. Buat Pull Request (PR)
- Pastikan `npm run build` dan `npm run type-check` berhasil tanpa pesan error.
- Buat Pull Request ke branch `main` dengan deskripsi perubahan yang jelas.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah lisensi **MIT**. Anda bebas menggunakan, memodifikasi, dan mendistribusikan kode ini sesuai dengan ketentuan lisensi.

Hak Cipta &copy; 2026 **Mari Partner — MariFlow SaaS Team**.
