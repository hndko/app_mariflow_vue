# Supabase Storage & File Attachments — MariFlow SaaS (Milestone 8)

## 1. Objective
Mendokumentasikan konfigurasi Supabase Storage, pengelolaan bucket file (`task-attachments` dan `avatars`), implementasi form upload *Drag & Drop* (`BaseDropzone`), penyimpanan metadata di PostgreSQL, serta kebijakan keamanan Storage Policies.

---

## 2. Concept & Bucket Topology
MariFlow memisahkan object binary storage ke dalam 2 bucket terisolasi:

```text
[ Supabase Storage ]
       ├── Bucket: `avatars` (Public Read, Owner Update)
       └── Bucket: `task-attachments` (Private, Protected by Workspace Membership)
```

Struktur folder di dalam bucket `task-attachments`:
```text
task-attachments/{workspace_id}/{task_id}/{timestamp}-{random_hash}.{ext}
```

---

## 3. Storage Policies (RLS for Storage)
Didefinisikan pada skema `storage.objects`:
```sql
-- 1. Baca lampiran: Hanya jika pengguna adalah member workspace terkait
CREATE POLICY "Allow workspace members to read attachments"
ON storage.objects FOR SELECT TO authenticated
USING (
    bucket_id = 'task-attachments' AND
    public.is_workspace_member((storage.foldername(name))[1]::uuid)
);

-- 2. Upload lampiran: Hanya jika pengguna adalah member workspace
CREATE POLICY "Allow workspace members to upload attachments"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
    bucket_id = 'task-attachments' AND
    public.is_workspace_member((storage.foldername(name))[1]::uuid)
);
```

---

## 4. Frontend Drag & Drop Implementation
Komponen `BaseDropzone.vue` mengimplementasikan:
1. Area drag over responsif dengan indikator visual.
2. Validasi ekstensi MIME dan batas ukuran file (maks 10MB untuk task, maks 2MB untuk avatar).
3. **Daftar Hasil Upload di Bawah Form**:
   - Preview thumbnail gambar atau icon tipe file.
   - Nama file dan formatted size (KB/MB).
   - Progress bar proses upload.
   - Tombol download dan hapus file.

---

## 5. Security & Verification
- Binary file tidak disimpan langsung di PostgreSQL melainkan di object storage.
- Storage RLS mencegah eksfiltrasi file lintas workspace.
- Nama file di-sanitize menggunakan unique hash untuk mencegah file collision dan path traversal.
