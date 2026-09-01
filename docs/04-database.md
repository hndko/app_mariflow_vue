# Database Schema & Structure — MariFlow SaaS (Milestone 3)

## 1. Objective
Mendokumentasikan arsitektur database PostgreSQL di Supabase, struktur 10 entitas tabel utama, tipe data ENUM, constraint foreign key cascading, serta strategi indeks performa.

---

## 2. Concept
Database MariFlow dirancang sebagai sistem multi-tenant terisolasi berbasis workspace:
```text
auth.users
   │
   ▼
profiles
   │
   ├───► workspaces ◄───► workspace_members
   │         │
   │         ├───► projects
   │         │        │
   │         │        └───► tasks ──┬──► task_comments
   │         │                      ├──► task_attachments
   │         │                      └──► task_assignees
   │         ├───► notifications
   │         └───► activity_logs
```

---

## 3. Entitas & Kolom Database

### 3.1 `profiles`
- `id` (UUID, PK, FK `auth.users.id` ON DELETE CASCADE)
- `full_name` (TEXT)
- `avatar_url` (TEXT)
- `email` (TEXT NOT NULL)
- `created_at`, `updated_at` (TIMESTAMPTZ)

### 3.2 `workspaces`
- `id` (UUID, PK)
- `name` (TEXT NOT NULL)
- `slug` (TEXT NOT NULL)
- `description` (TEXT)
- `owner_id` (UUID, FK `auth.users.id` ON DELETE CASCADE)
- `created_at`, `updated_at` (TIMESTAMPTZ)

### 3.3 `workspace_members`
- `id` (UUID, PK)
- `workspace_id` (UUID, FK `workspaces.id` ON DELETE CASCADE)
- `user_id` (UUID, FK `auth.users.id` ON DELETE CASCADE)
- `role` (ENUM: `owner`, `admin`, `member`, `viewer`)
- `created_at` (TIMESTAMPTZ)
- *Constraint*: `UNIQUE(workspace_id, user_id)`

### 3.4 `projects`
- `id` (UUID, PK)
- `workspace_id` (UUID, FK `workspaces.id` ON DELETE CASCADE)
- `name` (TEXT NOT NULL)
- `description` (TEXT)
- `status` (ENUM: `planning`, `active`, `completed`, `archived`)
- `start_date`, `due_date` (DATE)
- `created_by` (UUID, FK `auth.users.id` ON DELETE SET NULL)
- `created_at`, `updated_at` (TIMESTAMPTZ)

### 3.5 `tasks`
- `id` (UUID, PK)
- `project_id` (UUID, FK `projects.id` ON DELETE CASCADE)
- `workspace_id` (UUID, FK `workspaces.id` ON DELETE CASCADE)
- `title` (TEXT NOT NULL)
- `description` (TEXT)
- `status` (ENUM: `todo`, `in_progress`, `review`, `completed`, `cancelled`)
- `priority` (ENUM: `low`, `medium`, `high`, `urgent`)
- `assigned_to` (UUID, FK `auth.users.id` ON DELETE SET NULL)
- `created_by` (UUID, FK `auth.users.id` ON DELETE CASCADE)
- `due_date` (DATE)
- `created_at`, `updated_at` (TIMESTAMPTZ)

---

## 4. Performance Indexes
- `idx_workspace_members_user`: Pencarian cepat workspace milik user.
- `idx_projects_workspace`: Filter proyek per workspace.
- `idx_tasks_project` & `idx_tasks_workspace`: Query daftar tugas Kanban.
- `idx_tasks_status` & `idx_tasks_assigned_to`: Agregasi statistik & filter tugas pengguna.
- `idx_tasks_created_at`: Sorting kronologis aktivitas tugas.
- `idx_notifications_user_unread`: Akses instan notifikasi belum dibaca.

---

## 5. Production Checklist
- [x] File SQL migrasi tersimpan di `supabase/migrations/20260902_000001_create_mariflow_schema.sql`.
- [x] Trigger `handle_new_user` otomatis membuat profil & default workspace saat pendaftaran.
- [x] Seluruh foreign key memiliki aksi referensial yang tepat (`CASCADE` / `SET NULL`).
- [x] Indeks performa siap untuk 10x data scale.
