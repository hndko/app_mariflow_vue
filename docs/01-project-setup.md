# Project Setup & Foundation — MariFlow SaaS (Milestone 1)

## 1. Objective
Menginisialisasi konfigurasi dasar proyek, mengintegrasikan `@supabase/supabase-js` dan `pinia`, menyiapkan variable environment aman, mengimplementasikan 3 varian layout modular (`app-auth`, `app-modules`, `app-public`), serta membangun pustaka *reusable base components* (`BaseInput`, `BaseSelect`, `BaseTextarea`, `BaseButton`, `BaseTable`, `BaseDropzone`, `BaseBadge`, `BaseModal`) yang mematuhi standar UI wajib.

---

## 2. Concept
Fondasi antarmuka dan service layer dibangun secara *loose-coupling* dan terstandardisasi:
- **Centralized Client**: Instance Supabase terpusat di `src/services/supabase.ts`.
- **Icon Group + Placeholder**: Seluruh komponen form input terbungkus rapi dengan styling TailAdmin & Tailwind CSS 4.
- **Drag & Drop with Results List**: Uploader file menampilkan daftar file, progress bar, thumbnail preview, dan aksi hapus langsung di bawah area dropzone.
- **Automatic Row Numbering**: Komponen `BaseTable` menghitung nomor urut baris secara otomatis (`#` / `No`).
- **Icon + Text Action Buttons**: Tombol standar menyertakan icon + label, sedangkan tombol aksi tabel disederhanakan menjadi icon-only dengan accessible tooltip.

---

## 3. Supabase Configuration
Frontend dikonfigurasi melalui file environment `.env`:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```
Inisialisasi client:
```typescript
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
})
```

---

## 4. Database Schema Types
File `src/types/database.types.ts` mendefinisikan tipe entitas lengkap:
- `Profile`
- `Workspace` & `WorkspaceMember` (`owner`, `admin`, `member`, `viewer`)
- `Project` (`planning`, `active`, `completed`, `archived`)
- `Task` (`todo`, `in_progress`, `review`, `completed`, `cancelled`) & `TaskPriority`
- `TaskAssignee`, `TaskComment`, `TaskAttachment`
- `AppNotification` & `ActivityLog`

---

## 5. Security & Isolation
- `SUPABASE_SERVICE_ROLE_KEY` tidak diekspos di client.
- `.env` diabaikan oleh Git via `.gitignore`.
- Seluruh input form divalidasi tipe dan ukurannya sebelum request dikirim.

---

## 6. Frontend Reusable Components

| Komponen | Lokasi | Karakteristik Utama |
| :--- | :--- | :--- |
| `BaseInput` | `src/components/common/BaseInput.vue` | Prefix/Suffix slot, icon group, placeholder, error message. |
| `BaseSelect` | `src/components/common/BaseSelect.vue` | Prefix icon, dropdown chevron, error state. |
| `BaseTextarea` | `src/components/common/BaseTextarea.vue` | Multiline text dengan border state & error handler. |
| `BaseButton` | `src/components/common/BaseButton.vue` | Icon + Text, variant primary/outline/danger, icon-only table actions, loading spinner. |
| `BaseTable` | `src/components/common/BaseTable.vue` | Penomoran otomatis (`#`), loading skeleton, empty state, row slot. |
| `BaseDropzone` | `src/components/common/BaseDropzone.vue` | Drag & drop, validation MIME/size, **daftar hasil upload di bawah form**, preview thumbnail. |
| `BaseBadge` | `src/components/common/BaseBadge.vue` | Status tag dengan dot indicator & variant warna. |
| `BaseModal` | `src/components/common/BaseModal.vue` | Dialog box, backdrop blur, header, body & footer slot. |

---

## 7. Testing & Verification
- `npm install`: Sukses terinstall tanpa missing dependencies.
- Pinia Store terdaftar di `src/main.ts`.
- Reusable components lulus verifikasi template syntax.

---

## 8. Production Checklist
- [x] `@supabase/supabase-js` terinstall.
- [x] `pinia` terinstall dan terkonfigurasi di `main.ts`.
- [x] `.env.example` dan `.env` terkonfigurasi.
- [x] `src/services/supabase.ts` dibuat terpusat.
- [x] Base UI components (`BaseInput`, `BaseButton`, `BaseTable`, `BaseDropzone`, dll) siap digunakan.
- [x] 3 Layouts modular (`app-auth`, `app-modules`, `app-public`) terpasang.
