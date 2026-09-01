# Project Analysis — MariFlow SaaS (Milestone 0)

## 1. Objective
Melakukan analisis menyeluruh terhadap fondasi proyek `app_mariflow_vue`, arsitektur antarmuka pengguna (TailAdmin Vue), dependensi paket, kesenjangan arsitektur, dan menyusun strategi integrasi end-to-end dengan Supabase.

---

## 2. Concept
MariFlow adalah SaaS sederhana namun berstandar *production-ready* untuk manajemen workspace, proyek, tugas Kanban, anggota tim, lampiran file, notifikasi realtime, dan analitik performa.

Aplikasi mengadopsi pola arsitektur **Serverless Backend-as-a-Service (BaaS)** menggunakan Supabase:
```text
[ Browser / Vue 3 App ] 
        │
        ├── Supabase Auth ─────────► [ JWT & User Session ]
        ├── Supabase Database ─────► [ PostgreSQL + Row Level Security (RLS) ]
        ├── Supabase Storage ──────► [ Object Storage (Buckets: task-attachments, avatars) ]
        ├── Supabase Realtime ─────► [ PostgreSQL CDC / Websockets ]
        └── Supabase Functions ────► [ Deno Edge Runtime ]
```

---

## 3. Struktur Proyek & Analisis File

### 3.1 Struktur Direktori Eksisting
- `package.json`: TailAdmin Vue Pro v2.3.0 berbasis Vue 3.5, Vite 6, Tailwind CSS 4, Lucide Vue, Dropzone, Apexcharts, Flatpickr.
- `src/components/`: Komponen template dasar TailAdmin (header, sidebar, charts, basic-tables, forms, ui elements).
- `src/views/`: Halaman template demo (Ecommerce, Forms, BasicTables, Auth/Signin, Auth/Signup).
- `src/router/index.ts`: Definisi routing demo bawaan.

### 3.2 Kebutuhan Modifikasi & Penambahan
1. **Dependensi Baru**:
   - `@supabase/supabase-js`: Client library resmi untuk interaksi dengan seluruh layanan Supabase.
   - `pinia`: Global state management untuk session auth, active workspace, task cache, dan realtime notifications.
2. **Struktur Modular Baru**:
   - `src/layouts/`: `app-auth.vue`, `app-modules.vue`, `app-public.vue`.
   - `src/views/auth/`: Login, Register, ForgotPassword, ResetPassword.
   - `src/views/modules/`: `dashboard/`, `workspaces/`, `projects/`, `tasks/`, `members/`, `notifications/`, `settings/`, `supabase-lab/`.
   - `src/services/`: `supabase.ts`, `auth/`, `modules/`.
   - `src/stores/`: `auth.ts`, `workspace.ts`, `project.ts`, `task.ts`, `notification.ts`.
   - `supabase/migrations/`: Seluruh skema DDL, constraint, indeks, fungsi RPC, trigger, dan RLS policies.

---

## 4. Analisis Komponen UI (TailAdmin)

| Komponen TailAdmin | Status | Rencana Pemanfaatan / Modifikasi |
| :--- | :--- | :--- |
| **AppSidebar** | Tersedia | Menyesuaikan navigasi menu ke modul MariFlow: Dashboard, Workspaces, Projects, Tasks, Team Members, Notifications, Settings, Supabase Lab. |
| **AppHeader** | Tersedia | Integrasi dengan Profile avatar Supabase, Theme toggler, Notification popover menu, dan Workspace switcher. |
| **InputGroup** | Tersedia | Ditingkatkan menjadi `BaseInput.vue` dengan standardisasi icon group dan placeholder. |
| **Dropzone** | Tersedia | Diadaptasi menjadi `BaseDropzone.vue` dengan drag & drop upload ke Supabase Storage dan menampilkan preview card file di bawah form. |
| **BasicTableOne** | Tersedia | Ditingkatkan menjadi `BaseTable.vue` dengan penomoran otomatis kolom `#`, empty state, loading skeleton, dan action buttons icon-only. |
| **Button** | Tersedia | Standardisasi variant primary/outline/danger dengan icon + text. |
| **Modal** | Tersedia | Digunakan untuk dialog konfirmasi, pembuatan project/task, dan invite member. |
| **ApexCharts** | Tersedia | Digunakan pada Dashboard Analytics untuk chart distribusi status task, prioritas, dan timeline aktivitas. |

---

## 5. Security & Row Level Security (RLS) Strategy

1. **Enforce RLS pada Seluruh Tabel**:
   - Tidak ada data privat yang dapat dibaca atau ditulis tanpa melewati validasi PostgreSQL RLS.
   - Akses dibatasi ketat berdasarkan relasi keanggotaan di `workspace_members`.
2. **Hierarki Hak Akses (Role-Based Authorization)**:
   - **Owner**: Kontrol penuh atas workspace, transfer kepemilikan, dan penghapusan workspace.
   - **Admin**: Mengelola anggota tim, proyek, tugas, dan pengaturan workspace.
   - **Member**: Membuat dan memperbarui tugas, komentar, mengunggah lampiran, melihat proyek.
   - **Viewer**: Read-only access terhadap data workspace, proyek, dan tugas.
3. **Storage Security**:
   - Bucket `task-attachments` dibatasi hanya untuk member dari workspace terkait.
   - Bucket `avatars` bersifat public-read dengan restricted-write (hanya pemilik profil).

---

## 6. Rencana Integrasi Supabase

```text
Milestone 1: Setup Supabase Client & Config
      ↓
Milestone 2: Supabase Auth (JWT, Session, Profiles)
      ↓
Milestone 3: Database Foundation (Workspaces & Members)
      ↓
Milestone 4: PostgreSQL RLS Policies
      ↓
Milestone 5-6: Projects & Tasks (Kanban)
      ↓
Milestone 7-8: Comments & Supabase Storage (Attachments)
      ↓
Milestone 9-11: Realtime Subscriptions & Activity Triggers
      ↓
Milestone 12-14: RPC Aggregations & Dashboard Analytics
      ↓
Milestone 15-18: Supabase Lab, Verification, Security & Production Prep
```

---

## 7. Frontend Implementation Architecture

```text
[ Vue 3 Component ]
       │ (dispatches actions)
       ▼
[ Pinia Store ]
       │ (calls service)
       ▼
[ Modular Service Layer (src/services/modules/*) ]
       │ (executes query)
       ▼
[ Supabase JS Client (src/services/supabase.ts) ]
       │ (HTTPS / WSS)
       ▼
[ Supabase PostgreSQL + RLS + Storage ]
```

---

## 8. Testing & Quality Assurance Plan

- **Linting & Type Safety**: `npm run lint`, `vue-tsc --build`.
- **Unit & Logic Testing**: Verifikasi service layer queries, status transitions, role permission helpers.
- **Manual End-to-End Verification**:
  - Auth: Pendaftaran, login, token refresh, logout, session restoration.
  - Multi-tenancy: Isolasi data antar akun workspace yang berbeda.
  - Drag & drop upload: Validasi ukuran file, tipe MIME, rendering list preview hasil upload.
  - Table: Verifikasi penomoran otomatis kolom `#` dan pagination.
  - Realtime: Uji pembaruan data instan antar dua tab/browser yang berbeda tanpa reload.

---

## 9. Common Errors & Mitigation

| Potensi Masalah | Mitigasi Arsitektur |
| :--- | :--- |
| **Bocornya Service Role Key** | Frontend hanya menggunakan `VITE_SUPABASE_ANON_KEY`. Kunci service role hanya boleh berada di backend/Edge Functions. |
| **N+1 Query pada Relasi Data** | Gunakan join syntax Supabase JS (`.select('*, profiles(*)')`) alih-alih query di dalam loop. |
| **Memory Leak Realtime** | Seluruh subscription realtime wajib memiliki `supabase.removeChannel()` di `onBeforeUnmount`. |
| **Spam Query pada Search/Filter** | Gunakan `useDebounce` (300ms) pada event pencarian. |

---

## 10. Production Checklist

- [x] Milestone 0 Analisis Proyek selesai.
- [ ] Dependensi `@supabase/supabase-js` dan `pinia` terpasang.
- [ ] `.env.example` terdokumentasi tanpa hardcoded secret.
- [ ] Layouts modular (`app-auth`, `app-modules`, `app-public`) terimplementasi.
- [ ] Seluruh reusable components (`BaseInput`, `BaseDropzone`, `BaseTable`, `BaseButton`) mematuhi standar UI wajib.
- [ ] Seluruh SQL migrations dan RLS policies teruji di PostgreSQL.
- [ ] Build lulus tanpa error type check (`npm run build`).
