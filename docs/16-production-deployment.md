# Production Readiness & Deployment Guide — MariFlow SaaS (Milestone 18)

## 1. Objective
Memberikan panduan langkah-demi-langkah bagi pemilik proyek untuk melakukan deployment mandiri ke production hosting (Vercel / Netlify / Cloudflare Pages) dan menghubungkan proyek dengan instance Supabase resmi.

---

## 2. Persiapan Supabase Production

1. Buka [Supabase Dashboard](https://supabase.com/dashboard) dan buat project baru.
2. Buka **SQL Editor** pada project Supabase Anda.
3. Jalankan file migrasi secara berurutan:
   - `supabase/migrations/20260902_000001_create_mariflow_schema.sql`
   - `supabase/migrations/20260902_000002_dashboard_rpc_functions.sql`
4. Buat Storage Bucket di menu **Storage**:
   - Bucket `avatars` (Set Public: Yes)
   - Bucket `task-attachments` (Set Public: No / Private)
5. Salin `Project URL` dan `anon/public key` dari menu **Project Settings -> API**.

---

## 3. Build & Deployment Frontend

### 3.1 Environment Variables
Set environment variables pada platform hosting Anda (Vercel / Netlify):
```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 3.2 Build Command
```bash
npm run build
```
Output build direktori: `dist/`.

---

## 4. Production Checklist Selesai
- [x] RLS policies terkonfirmasi aktif di seluruh tabel.
- [x] Storage policies terpasang untuk isolasi file workspace.
- [x] Responsive layout teruji di desktop, tablet, dan mobile.
- [x] Build produksi teroptimasi tanpa error.
