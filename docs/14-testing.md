# Testing & Verification Matrix — MariFlow SaaS (Milestone 16)

## 1. Objective
Menyediakan checklist verifikasi menyeluruh untuk pengujian fungsionalitas, keamanan otorisasi multi-tenant, interaksi drag & drop, debounce, dan responsive UI.

---

## 2. Verification Checklist Matrix

| Modul Fitur | Test Case | Ekspektasi | Status |
| :--- | :--- | :--- | :---: |
| **Authentication** | Pendaftaran Akun Baru | Record terbuat di `auth.users` dan otomatis tersinkron ke `profiles`. | ✅ Lolos |
| **Authentication** | Login & Sesi Persistence | Token tersimpan di `localStorage` dan tidak hilang saat browser di-refresh. | ✅ Lolos |
| **Workspaces** | Pembuatan Workspace | User otomatis menjadi `owner` di `workspace_members`. | ✅ Lolos |
| **Workspaces** | Multi-Tenancy Isolation | Data workspace A tidak terlihat oleh anggota workspace B. | ✅ Lolos |
| **Projects** | Project CRUD & Filter Status | Tabel memiliki penomoran `#` dan filter debounce bekerja mulus. | ✅ Lolos |
| **Tasks & Kanban** | Drag & Drop Kartu | Status kartu berpindah secara instan (optimistic UI update). | ✅ Lolos |
| **File Storage** | Upload Lampiran Drag & Drop | File list muncul di bawah dropzone lengkap dengan nama, size, dan preview. | ✅ Lolos |
| **Realtime** | Broadcast Notifikasi | Notifikasi masuk secara instan tanpa reload browser. | ✅ Lolos |
| **UI Standards** | Form Icon Group + Placeholder | Seluruh input memiliki prefix icon dan placeholder yang jelas. | ✅ Lolos |
| **UI Standards** | Button Text+Icon & Table Icon-only | Tombol aksi tabel ringkas (icon-only), tombol form memiliki icon+text. | ✅ Lolos |
| **UI Standards** | Table Auto Numbering | Seluruh tabel memiliki kolom `#` yang terhitung otomatis. | ✅ Lolos |
