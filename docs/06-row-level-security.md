# Row Level Security (RLS) & Authorization — MariFlow SaaS (Milestone 4)

## 1. Objective
Menjelaskan arsitektur keamanan PostgreSQL Row Level Security (RLS) yang menegakkan isolasi data multi-tenant dan otorisasi berbasis peran (Owner, Admin, Member, Viewer) di level database engine.

---

## 2. Concept & Security Boundary
Prinsip utama: **Frontend permission (`v-if`) hanya untuk kenyamanan antarmuka (UX), sedangkan otorisasi sebenarnya selalu ditegakkan di PostgreSQL RLS**.

```text
[ Incoming Request (JWT Token) ]
              │
              ▼
[ PostgreSQL RLS Engine ]
              │
   Is auth.uid() a member of target workspace?
         ├── NO  ──► 403 Forbidden / Empty Result
         └── YES ──► Check Role-Based Policy:
                       - Owner: Full Access (CRUD + Delete Workspace)
                       - Admin: Manage Projects, Tasks, Members
                       - Member: Create/Edit Tasks, Comments, Attachments
                       - Viewer: Read-only access
```

---

## 3. RLS Helper Functions
Fungsi PL/pgSQL dengan `SECURITY DEFINER` untuk evaluasi efisien:
```sql
CREATE OR REPLACE FUNCTION public.is_workspace_member(ws_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.workspace_members
        WHERE workspace_id = ws_id AND user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
```

---

## 4. Matriks Hak Akses (RBAC)

| Aksi / Resource | Owner | Admin | Member | Viewer |
| :--- | :---: | :---: | :---: | :---: |
| **Lihat Data Workspace & Proyek** | ✅ | ✅ | ✅ | ✅ |
| **Buat Proyek Baru** | ✅ | ✅ | ✅ | ❌ |
| **Edit Proyek** | ✅ | ✅ | ✅ | ❌ |
| **Hapus Proyek** | ✅ | ✅ | ❌ | ❌ |
| **Buat & Edit Tugas (Task)** | ✅ | ✅ | ✅ | ❌ |
| **Hapus Tugas** | ✅ | ✅ | Creator only | ❌ |
| **Komentar & Upload Lampiran** | ✅ | ✅ | ✅ | ❌ |
| **Undang / Hapus Anggota** | ✅ | ✅ | ❌ | ❌ |
| **Hapus Workspace** | ✅ | ❌ | ❌ | ❌ |

---

## 5. Testing & Security Verification
- **Cross-workspace Test**: Pengguna A mencoba request task ID milik workspace B -> PostgreSQL otomatis mengembalikan *0 rows* / error permission.
- **Viewer Role Test**: Akun dengan peran `viewer` mencoba mengirim request `INSERT/UPDATE` -> Ditolak oleh policy database `WITH CHECK`.
- **Policy Audit**: Tidak ada tabel privat yang menggunakan policy `USING (true)`.

---

## 6. Production Checklist
- [x] RLS aktif di seluruh 10 tabel.
- [x] Helper functions `is_workspace_member()` dan `get_workspace_role()` terpasang.
- [x] Kebijakan granular per role teruji.
