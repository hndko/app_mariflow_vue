# Database Relationships — MariFlow SaaS (Milestone 3)

## 1. Objective
Memetakan kardinalitas relasi antar entitas database PostgreSQL dan integritas referensial yang menjamin konsistensi data multi-tenant.

---

## 2. Diagram Relasi Entitas (ERD)

```text
+------------------+         1:N         +--------------------+
|    auth.users    | ------------------< |      profiles      |
+------------------+                     +--------------------+
         |
         | 1:N (Owner)
         v
+------------------+         1:N         +--------------------+
|    workspaces    | ------------------< | workspace_members  |
+------------------+                     +--------------------+
         |                                         ^
         | 1:N                                     |
         v                                         | N:1
+------------------+                               |
|     projects     | ------------------------------+
+------------------+
         |
         | 1:N
         v
+------------------+         1:N         +--------------------+
|      tasks       | ------------------< |   task_comments    |
+------------------+                     +--------------------+
         |
         | 1:N
         +-----------------------------< +--------------------+
         |                               |  task_attachments  |
         | 1:N                           +--------------------+
         +-----------------------------< +--------------------+
                                         |   task_assignees   |
                                         +--------------------+
```

---

## 3. Kardinalitas & Rules

1. **User ke Workspace (Many-to-Many via `workspace_members`)**:
   - Seorang pengguna dapat memiliki banyak workspace dan menjadi anggota di workspace lain dengan peran berbeda.
2. **Workspace ke Project (1-to-Many)**:
   - Satu workspace menampung banyak proyek. Jika workspace dihapus, seluruh proyek terkait ikut terhapus (`CASCADE`).
3. **Project ke Task (1-to-Many)**:
   - Satu proyek memiliki banyak tugas (todo, in_progress, review, completed).
4. **Task ke Sub-resources (1-to-Many)**:
   - Komentar (`task_comments`) dan lampiran file (`task_attachments`) terikat langsung ke satu task induk.
