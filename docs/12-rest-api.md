# REST API & Data Access Layer — MariFlow SaaS (Milestone 12)

## 1. Objective
Mendokumentasikan pola query REST API menggunakan Supabase JavaScript Client (`@supabase/supabase-js`) secara terstruktur melalui Service Layer.

---

## 2. Service Layer Architecture
Seluruh query Supabase dipisahkan dari komponen UI ke dalam `src/services/modules/`:
- `workspace.service.ts`: Manajemen workspace dan member.
- `project.service.ts`: CRUD proyek dan filter status.
- `task.service.ts`: Manajemen tugas, drag & drop status, komentar, dan lampiran storage.
- `notification.service.ts`: Query notifikasi dan listener realtime.

---

## 3. Relational Select Query Pattern (Anti N+1)
Supabase JS client memanfaatkan PostgREST resource embedding:
```typescript
const { data, error } = await supabase
  .from('tasks')
  .select(`
    *,
    assignee:assigned_to (id, full_name, avatar_url),
    project:project_id (id, name)
  `)
  .eq('workspace_id', workspaceId);
```
Query ini hanya melakukan 1 HTTP request tunggal dengan join di level PostgreSQL, sehingga 100% bebas dari isu performa N+1 query.
