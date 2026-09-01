# MASTER PROMPT — MariFlow SaaS

## 1. PROJECT IDENTITY

Saya ingin mengembangkan sebuah aplikasi SaaS bernama **MariFlow** sebagai bagian dari ekosistem bisnis **Mari Partner**.

MariFlow adalah SaaS sederhana untuk membantu tim kecil mengelola:

- Workspace
- Project
- Task
- Team Member
- Comment
- Activity
- Notification
- File Attachment
- Dashboard Analytics

Project ini sekaligus akan menjadi **learning/reference project untuk mempelajari Supabase secara end-to-end**.

Setiap fitur yang menggunakan Supabase wajib dibuat dengan implementasi yang benar dan nantinya didokumentasikan.

---

# 2. PROJECT DIRECTORY

Gunakan nama folder/project:

```text
app_mariflow_vue
```

Nama aplikasi:

```text
MariFlow
```

Project slug:

```text
mariflow
```

Business/brand:

```text
Mari Partner
```

Tagline:

```text
Simple Workspace & Task Management
```

---

# 3. OBJECTIVE

Bangun aplikasi SaaS production-ready secara bertahap menggunakan:

- Vue.js 3
- Vite
- Tailwind CSS
- TailAdmin sebagai UI Theme
- Vue Router
- Pinia
- Supabase
- PostgreSQL
- Supabase Auth
- Supabase Storage
- Supabase Realtime
- Supabase Edge Functions
- Row Level Security
- Git

Jangan membuat backend custom seperti Laravel, Express, NestJS, atau backend framework lain.

Supabase menjadi backend utama aplikasi.

---

# 4. IMPORTANT DEVELOPMENT PRINCIPLES

## 4.1 Jangan langsung membuat seluruh aplikasi

Kerjakan aplikasi secara bertahap berdasarkan milestone.

Setiap milestone harus:

1. Dianalisis
2. Diimplementasikan
3. Diuji
4. Diperbaiki jika ada error
5. Didokumentasikan
6. Baru lanjut ke milestone berikutnya

Jangan melompat ke milestone berikutnya jika milestone sebelumnya belum stabil.

---

# 5. FIRST TASK — ANALYZE PROJECT

Sebelum menulis kode:

1. Analisis seluruh struktur project yang tersedia.
2. Analisis TailAdmin yang tersedia.
3. Identifikasi:
   - Layout
   - Sidebar
   - Header
   - Components
   - Cards
   - Tables
   - Forms
   - Modals
   - Dropdown
   - Charts
   - Responsive behavior
4. Tentukan component mana yang dapat digunakan kembali.
5. Jangan mengganti UI theme jika TailAdmin sudah tersedia.
6. Jangan membuat desain baru jika komponen TailAdmin yang relevan sudah tersedia.
7. Ikuti design language TailAdmin secara konsisten.

Setelah analisis, buat dokumentasi:

```text
docs/00-project-analysis.md
```

Dokumentasi harus menjelaskan:

- Struktur project
- Struktur UI
- Component yang tersedia
- Layout yang digunakan
- Dependency yang tersedia
- Bagian yang perlu ditambahkan
- Rencana integrasi Supabase

---

# 6. TECHNOLOGY RULES

Gunakan:

```text
Vue 3
Vite
JavaScript
Tailwind CSS
Vue Router
Pinia
Supabase JS Client
```

Jika project sudah menggunakan JavaScript, jangan migrasikan ke TypeScript kecuali memang diperlukan.

Gunakan Composition API untuk Vue component baru.

Gunakan:

```js
<script setup>
```

Jangan mencampurkan pola Options API dan Composition API tanpa alasan yang jelas.

---

# 7. SUPABASE ARCHITECTURE

Supabase menjadi backend utama.

Gunakan:

```text
Supabase Auth
Supabase PostgreSQL
Supabase Storage
Supabase Realtime
Supabase Edge Functions
Supabase REST API
Row Level Security
Database Functions
Database Triggers
```

Frontend menggunakan:

```text
@supabase/supabase-js
```

Jangan pernah memasukkan:

```text
SUPABASE_SERVICE_ROLE_KEY
```

ke frontend.

Frontend hanya boleh menggunakan:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

atau publishable key yang sesuai dengan konfigurasi Supabase terbaru.

---

# 8. ENVIRONMENT VARIABLES

Gunakan:

```env
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
```

Jangan hardcode credential Supabase di source code.

Buat:

```text
.env.example
```

Contoh:

```env
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
```

Jangan commit:

```text
.env
```

ke Git.

Pastikan `.gitignore` mencakup:

```text
.env
.env.local
.env.*.local
```

---

# 9. SUPABASE CLIENT

Buat service khusus:

```text
src/services/supabase.js
```

Semua akses Supabase harus melalui konfigurasi client yang terpusat.

Hindari membuat instance Supabase berkali-kali di berbagai component.

---

# 10. APPLICATION MODULES

Aplikasi memiliki modul:

```text
Authentication
Dashboard
Workspace
Projects
Tasks
Members
Comments
Attachments
Activity
Notifications
Settings
Supabase Lab
```

---

# 11. AUTHENTICATION

Implementasikan:

```text
Register
Login
Logout
Session persistence
Forgot password
Reset password
Profile
Protected routes
Guest routes
```

Gunakan Supabase Auth.

Authentication flow:

```text
Register
    ↓
Supabase Auth
    ↓
Create Profile
    ↓
Login
    ↓
Session
    ↓
Dashboard
```

Profile pengguna disimpan pada:

```text
profiles
```

Jangan menyimpan password secara manual di database aplikasi.

---

# 12. USER PROFILE

Buat table:

```text
profiles
```

Minimal memiliki:

```text
id
full_name
avatar_url
email
created_at
updated_at
```

`id` harus berhubungan dengan:

```text
auth.users.id
```

Profile harus dapat diedit dari:

```text
Settings → Profile
```

---

# 13. WORKSPACE

User dapat membuat workspace.

Table:

```text
workspaces
```

Minimal:

```text
id
name
slug
description
owner_id
created_at
updated_at
```

Relasi:

```text
User
  ↓
Workspace
```

Satu user dapat memiliki banyak workspace.

---

# 14. WORKSPACE MEMBERS

Buat:

```text
workspace_members
```

Minimal:

```text
id
workspace_id
user_id
role
created_at
```

Role:

```text
owner
admin
member
viewer
```

Role harus dikontrol menggunakan RLS.

Jangan hanya mengandalkan permission di frontend.

Frontend permission hanya untuk UX.

Security sebenarnya harus ditegakkan di PostgreSQL RLS.

---

# 15. PROJECT

Buat:

```text
projects
```

Minimal:

```text
id
workspace_id
name
description
status
start_date
due_date
created_by
created_at
updated_at
```

Status:

```text
planning
active
completed
archived
```

Project hanya dapat diakses oleh member workspace terkait.

---

# 16. TASK

Buat:

```text
tasks
```

Minimal:

```text
id
project_id
workspace_id
title
description
status
priority
assigned_to
created_by
due_date
created_at
updated_at
```

Status:

```text
todo
in_progress
review
completed
cancelled
```

Priority:

```text
low
medium
high
urgent
```

---

# 17. TASK ASSIGNEE

Jika dibutuhkan untuk mendukung multiple assignee, gunakan:

```text
task_assignees
```

daripada menyimpan banyak user ID dalam satu kolom.

Relasi:

```text
tasks
   ↓
task_assignees
   ↓
profiles
```

---

# 18. COMMENTS

Buat:

```text
task_comments
```

Minimal:

```text
id
task_id
user_id
content
created_at
updated_at
```

User hanya dapat mengakses comment dari task yang dapat dia akses.

---

# 19. ATTACHMENTS

Gunakan:

```text
Supabase Storage
```

Jangan menyimpan binary file langsung di PostgreSQL.

Buat metadata table:

```text
task_attachments
```

Minimal:

```text
id
task_id
uploaded_by
file_name
file_path
file_size
mime_type
created_at
```

Storage bucket:

```text
task-attachments
```

Atur Storage Policy dengan benar.

User tidak boleh mengakses file milik workspace lain.

---

# 20. NOTIFICATIONS

Buat:

```text
notifications
```

Minimal:

```text
id
user_id
workspace_id
type
title
message
reference_type
reference_id
is_read
created_at
```

Notification digunakan untuk:

- Task assigned
- Task updated
- Comment
- Workspace invitation
- Mention
- Project update

Gunakan Realtime jika relevan.

---

# 21. ACTIVITY LOG

Buat:

```text
activity_logs
```

Minimal:

```text
id
workspace_id
user_id
entity_type
entity_id
action
metadata
created_at
```

Contoh:

```text
created_project
updated_project
created_task
assigned_task
completed_task
commented_task
uploaded_attachment
added_member
```

Gunakan JSON/JSONB untuk metadata jika sesuai.

---

# 22. DATABASE RELATIONSHIP

Target relationship:

```text
auth.users
     │
     ▼
profiles
     │
     ├──────────────┐
     ▼              ▼
workspaces     notifications
     │
     ▼
workspace_members
     │
     ├──────────────┐
     ▼              ▼
projects       activity_logs
     │
     ▼
tasks
     │
     ├──────────────┐
     ▼              ▼
task_comments  task_attachments
```

---

# 23. ROW LEVEL SECURITY

RLS adalah bagian wajib dari project.

Aktifkan RLS pada seluruh table aplikasi yang membutuhkan authorization.

Minimal:

```text
profiles
workspaces
workspace_members
projects
tasks
task_assignees
task_comments
task_attachments
notifications
activity_logs
```

Jangan membuat policy:

```sql
using (true)
```

untuk data private kecuali memang benar-benar dibutuhkan.

---

# 24. RLS DESIGN PRINCIPLE

Gunakan prinsip:

```text
User
 ↓
Authenticated
 ↓
Workspace membership
 ↓
Role
 ↓
Permission
 ↓
Data access
```

Contoh:

User hanya dapat melihat project apabila:

```text
user adalah member workspace project
```

Admin dapat:

```text
create
read
update
delete
```

Member dapat:

```text
read
create task
update task yang diperbolehkan
comment
upload attachment
```

Viewer hanya:

```text
read
```

Owner memiliki akses penuh terhadap workspace.

---

# 25. IMPORTANT SECURITY RULE

Jangan pernah mengandalkan:

```text
v-if="user.isAdmin"
```

sebagai security.

Itu hanya UI control.

Security sebenarnya harus berada di:

```text
PostgreSQL
RLS
Storage Policies
Edge Functions
```

---

# 26. STORAGE

Implementasikan:

```text
Avatar upload
Task attachment
File preview
File download
File delete
```

Gunakan Supabase Storage.

Buat Storage Policies berdasarkan:

```text
authenticated user
workspace membership
resource ownership
```

---

# 27. REALTIME

Gunakan Supabase Realtime untuk:

```text
Task update
Comment
Notification
Activity
```

Contoh:

User A mengubah task:

```text
Task updated
      ↓
Supabase Realtime
      ↓
User B receives update
      ↓
UI automatically updates
```

Jangan menggunakan polling jika Realtime lebih sesuai.

---

# 28. DATABASE FUNCTIONS

Gunakan PostgreSQL functions jika logic lebih tepat dijalankan di database.

Contoh:

```text
get_workspace_statistics()
get_project_statistics()
get_task_statistics()
```

Jangan memindahkan seluruh logic ke frontend jika database dapat mengerjakannya dengan lebih aman dan efisien.

---

# 29. DATABASE TRIGGERS

Gunakan trigger jika relevan.

Contoh:

```text
New auth user
     ↓
Create profile
```

atau:

```text
Task updated
     ↓
Create activity log
```

Trigger harus dibuat dengan hati-hati dan didokumentasikan.

---

# 30. EDGE FUNCTIONS

Gunakan Edge Functions untuk server-side logic yang membutuhkan secret/API key atau logic yang tidak cocok dijalankan di browser.

Contoh:

```text
send-workspace-invitation
send-notification
generate-report
cleanup-storage
```

Jangan menyimpan secret API di frontend.

---

# 31. DASHBOARD

Dashboard utama menggunakan TailAdmin.

Tampilkan:

```text
Total Workspaces
Total Projects
Total Tasks
Completed Tasks
Pending Tasks
Overdue Tasks
Team Members
Recent Activity
```

Tambahkan chart:

```text
Tasks by Status
Tasks by Priority
Project Progress
Activity Timeline
```

Semua statistik harus mengambil data nyata dari Supabase.

Jangan menggunakan mock data pada production implementation.

---

# 32. UI/UX REQUIREMENTS

Gunakan TailAdmin sebagai referensi utama.

UI harus memiliki:

```text
Loading state
Empty state
Error state
Success feedback
Confirmation dialog
Form validation
Responsive layout
Mobile navigation
Desktop sidebar
Dark mode jika TailAdmin mendukung
```

Gunakan reusable components.

Contoh:

```text
BaseButton
BaseInput
BaseSelect
BaseModal
BaseDropdown
BaseTable
BaseBadge
BaseCard
LoadingState
EmptyState
ErrorState
ConfirmDialog
```

Jangan membuat component yang terlalu besar.

---

# 33. ROUTING

Gunakan Vue Router.

Contoh:

```text
/login
/register
/forgot-password

/dashboard

/workspaces
/workspaces/:workspaceId

/projects
/projects/:projectId

/tasks
/tasks/:taskId

/members

/notifications

/settings/profile
/settings/workspace
/settings/security
```

Protected route harus membutuhkan authentication.

---

# 34. STATE MANAGEMENT

Gunakan Pinia untuk global state.

Minimal:

```text
authStore
workspaceStore
notificationStore
```

Jangan memasukkan seluruh state aplikasi ke Pinia.

Gunakan local component state jika state hanya digunakan oleh satu halaman/component.

---

# 35. SERVICE LAYER

Jangan membuat query Supabase yang kompleks langsung di template/component.

Gunakan service:

```text
src/services/
```

Contoh:

```text
auth.service.js
workspace.service.js
project.service.js
task.service.js
member.service.js
notification.service.js
storage.service.js
```

Contoh pola:

```text
Vue Component
      ↓
Composable / Store
      ↓
Service
      ↓
Supabase
```

---

# 36. COMPOSABLES

Gunakan composables untuk logic reusable.

Contoh:

```text
useAuth()
useWorkspace()
useProjects()
useTasks()
useNotifications()
useRealtime()
useStorage()
```

---

# 37. ERROR HANDLING

Semua request Supabase harus menangani:

```text
loading
success
error
empty
```

Jangan menggunakan:

```js
console.log(error)
```

saja.

User harus mendapatkan feedback yang jelas.

Contoh:

```text
Failed to load projects.
Please try again.
```

Tetapi jangan menampilkan informasi sensitif seperti:

```text
database credentials
SQL internals
service role key
stack trace
```

---

# 38. FORM VALIDATION

Semua form wajib memiliki validasi.

Contoh:

```text
Required field
Minimum length
Maximum length
Valid email
Date validation
File type
File size
```

Validasi frontend digunakan untuk UX.

Validasi database/RLS tetap menjadi security boundary.

---

# 39. DATABASE MIGRATION

Semua perubahan database harus dibuat dalam migration SQL.

Jangan hanya melakukan perubahan manual di Supabase Dashboard tanpa mencatat SQL-nya.

Gunakan struktur:

```text
supabase/
├── migrations/
├── functions/
└── seed.sql
```

Jika Supabase CLI digunakan, ikuti migration workflow resmi.

---

# 40. SEED DATA

Buat seed data untuk development/testing.

Contoh:

```text
Demo workspace
Demo project
Demo tasks
Demo members
Demo comments
```

Tetapi pastikan seed data tidak digunakan sebagai pengganti database production.

---

# 41. DOCUMENTATION

Ini adalah bagian penting dari project.

Setiap fitur Supabase wajib memiliki dokumentasi.

Gunakan:

```text
docs/
```

Struktur:

```text
docs/
├── 00-project-analysis.md
├── 01-project-setup.md
├── 02-supabase-project.md
├── 03-authentication.md
├── 04-database.md
├── 05-database-relationships.md
├── 06-row-level-security.md
├── 07-storage.md
├── 08-realtime.md
├── 09-database-functions.md
├── 10-database-triggers.md
├── 11-edge-functions.md
├── 12-rest-api.md
├── 13-error-handling.md
├── 14-testing.md
├── 15-security.md
└── 16-production-deployment.md
```

---

# 42. DOCUMENTATION FORMAT

Setiap dokumentasi harus menggunakan format:

```markdown
# Feature Name

## 1. Objective

## 2. Concept

## 3. Supabase Configuration

## 4. Database

## 5. Security

## 6. RLS Policy

## 7. Frontend Implementation

## 8. Testing

## 9. Common Errors

## 10. Production Checklist
```

Dokumentasi harus menjelaskan:

```text
Apa?
Mengapa?
Bagaimana?
Implementasinya bagaimana?
Apa security concern-nya?
Bagaimana testing-nya?
```

---

# 43. SUPABASE LAB

Tambahkan section khusus:

```text
Supabase Lab
```

Tujuannya untuk membantu memahami masing-masing fitur Supabase.

Menu:

```text
Supabase Lab
├── Authentication
├── Database
├── RLS
├── Storage
├── Realtime
├── Database Functions
├── Triggers
├── Edge Functions
├── API
└── Logs
```

Halaman ini dapat berupa dokumentasi/interactive demo.

Jangan membuat halaman hanya untuk dekorasi.

Jika fitur tidak cocok untuk UI langsung, berikan:

```text
Concept
Example
Implementation
Result
```

---

# 44. TESTING

Setiap milestone wajib diuji.

Minimal testing:

## Authentication

```text
Register
Login
Logout
Session persistence
Forgot password
Invalid credentials
```

## Authorization

```text
Owner
Admin
Member
Viewer
Unauthorized user
Cross-workspace access
```

## CRUD

```text
Create
Read
Update
Delete
```

## RLS

Pastikan user tidak dapat:

```text
read workspace lain
update project workspace lain
delete task workspace lain
read private notification user lain
access attachment workspace lain
```

## Storage

Test:

```text
Upload
Preview
Download
Delete
Unauthorized access
Invalid file
Large file
```

## Realtime

Test:

```text
User A changes task
User B sees update
```

---

# 45. PRODUCTION SECURITY CHECKLIST

Sebelum menyatakan project selesai, periksa:

```text
[ ] RLS enabled
[ ] RLS policies tested
[ ] Storage policies tested
[ ] No service role key in frontend
[ ] No secret API keys committed
[ ] .env ignored
[ ] Input validation
[ ] File validation
[ ] Authorization enforced server-side
[ ] Error messages sanitized
[ ] Database indexes reviewed
[ ] Foreign keys reviewed
[ ] Cascading deletes reviewed
[ ] Realtime subscriptions cleaned up
[ ] Authentication flow tested
[ ] Password reset tested
[ ] Cross-workspace access tested
```

---

# 46. PERFORMANCE

Perhatikan:

```text
Database indexes
Pagination
Lazy loading
Query optimization
Avoid N+1 queries
Selective columns
Realtime subscription cleanup
Image/file optimization
```

Jangan melakukan:

```text
select *
```

secara berlebihan jika hanya membutuhkan beberapa kolom.

Untuk list besar gunakan pagination.

---

# 47. RESPONSIVE DESIGN

Aplikasi harus nyaman digunakan pada:

```text
Desktop
Laptop
Tablet
Mobile
```

Prioritaskan TailAdmin responsive utilities.

Jangan membuat desktop-only UI.

---

# 48. ACCESSIBILITY

Gunakan:

```text
semantic HTML
proper labels
keyboard navigation
focus states
ARIA jika diperlukan
sufficient contrast
```

Button harus memiliki label yang jelas.

Icon-only button harus memiliki tooltip/accessible label.

---

# 49. CODE QUALITY

Ikuti prinsip:

```text
DRY
SOLID where applicable
Single Responsibility
Reusable Components
Clear Naming
Small Components
Small Functions
Consistent Formatting
```

Hindari:

```text
God components
Huge functions
Duplicated Supabase queries
Hardcoded IDs
Hardcoded credentials
Business logic inside templates
```

---

# 50. NAMING CONVENTION

Vue components:

```text
PascalCase.vue
```

Contoh:

```text
ProjectTable.vue
TaskModal.vue
MemberList.vue
```

Services:

```text
camelCase.service.js
```

Contoh:

```text
task.service.js
project.service.js
```

Database:

```text
snake_case
```

Contoh:

```text
workspace_members
task_comments
activity_logs
```

---

# 51. GIT

Gunakan Git.

Commit harus jelas.

Contoh:

```text
feat: add authentication
feat: add workspace management
feat: add project management
feat: add task management
feat: implement task rls
feat: add storage attachments
feat: add realtime notifications
docs: add supabase authentication guide
fix: handle task loading error
refactor: extract task service
```

Jangan commit:

```text
.env
secrets
credentials
service role keys
```

---

# 52. DEVELOPMENT WORKFLOW

Gunakan workflow:

```text
ANALYZE
   ↓
PLAN
   ↓
IMPLEMENT
   ↓
TEST
   ↓
FIX
   ↓
DOCUMENT
   ↓
REVIEW
   ↓
NEXT MILESTONE
```

Jangan langsung mengerjakan banyak milestone sekaligus.

---

# 53. MILESTONE ORDER

Kerjakan dalam urutan berikut.

## Milestone 0

Project analysis.

Output:

```text
docs/00-project-analysis.md
```

---

## Milestone 1

Project foundation.

Implement:

```text
Vue
Vite
Tailwind
TailAdmin
Router
Pinia
Supabase client
Environment
```

---

## Milestone 2

Authentication.

Implement:

```text
Register
Login
Logout
Session
Forgot password
Profile
Protected route
```

Dokumentasi:

```text
docs/03-authentication.md
```

---

## Milestone 3

Database foundation.

Implement:

```text
profiles
workspaces
workspace_members
```

Dokumentasi:

```text
docs/04-database.md
docs/05-database-relationships.md
```

---

## Milestone 4

RLS.

Implement dan test:

```text
profiles policies
workspace policies
workspace_members policies
```

Dokumentasi:

```text
docs/06-row-level-security.md
```

---

## Milestone 5

Projects.

Implement:

```text
Project CRUD
Project list
Project detail
Project status
Project dashboard
```

---

## Milestone 6

Tasks.

Implement:

```text
Task CRUD
Assignment
Priority
Status
Due date
Kanban
Task detail
```

---

## Milestone 7

Comments.

Implement:

```text
Comment
Edit comment
Delete comment
Realtime comment
```

---

## Milestone 8

Storage.

Implement:

```text
Avatar
Task attachment
Upload
Preview
Delete
Storage policies
```

Documentation:

```text
docs/07-storage.md
```

---

## Milestone 9

Realtime.

Implement:

```text
Realtime task updates
Realtime comments
Realtime notifications
Activity updates
```

Documentation:

```text
docs/08-realtime.md
```

---

## Milestone 10

Notifications.

Implement:

```text
Notification center
Unread counter
Mark as read
Realtime notification
```

---

## Milestone 11

Activity log.

Implement:

```text
Activity timeline
Automatic activity creation where appropriate
```

---

## Milestone 12

Database functions and triggers.

Implement only where useful.

Document:

```text
docs/09-database-functions.md
docs/10-database-triggers.md
```

---

## Milestone 13

Edge Functions.

Implement at least one meaningful Edge Function.

Example:

```text
send-workspace-invitation
```

Documentation:

```text
docs/11-edge-functions.md
```

---

## Milestone 14

Dashboard analytics.

Implement real database-driven statistics.

---

## Milestone 15

Supabase Lab.

Implement educational pages explaining:

```text
Auth
Database
RLS
Storage
Realtime
Functions
Triggers
Edge Functions
API
Logs
```

---

## Milestone 16

Testing.

Perform complete application testing.

Documentation:

```text
docs/14-testing.md
```

---

## Milestone 17

Security review.

Review:

```text
Auth
RLS
Storage
Edge Functions
Secrets
API
Database
```

Documentation:

```text
docs/15-security.md
```

---

## Milestone 18

Production readiness.

Check:

```text
Build
Environment
Database
Security
Performance
Error handling
Responsive UI
```

Documentation:

```text
docs/16-production-deployment.md
```

---

# 54. IMPORTANT RULE ABOUT PRODUCTION

Jangan melakukan deployment secara otomatis.

Saya ingin sampai pada kondisi:

```text
PRODUCTION READY
```

tetapi **saya sendiri yang akan melakukan deployment**.

Agent hanya perlu:

```text
build
test
validate
document
```

dan memberikan instruksi deployment.

---

# 55. WHEN SOMETHING IS UNCLEAR

Jangan langsung membuat asumsi besar.

Jika terdapat keputusan arsitektur yang dapat berdampak besar:

1. Jelaskan masalahnya.
2. Berikan opsi.
3. Pilih opsi yang paling sederhana dan aman.
4. Jika keputusan tidak blocking, gunakan default yang reasonable.
5. Dokumentasikan keputusan tersebut.

---

# 56. DO NOT

Jangan:

```text
❌ Menggunakan mock database untuk fitur production
❌ Menggunakan service role key di frontend
❌ Menonaktifkan RLS hanya agar fitur bekerja
❌ Membuat policy terlalu permisif
❌ Hardcode credentials
❌ Membuat semua logic di Vue component
❌ Mengabaikan error handling
❌ Membuat UI baru jika TailAdmin sudah menyediakan komponen
❌ Mengubah TailAdmin tanpa alasan
❌ Melakukan deployment otomatis
❌ Melompat milestone
❌ Menganggap frontend authorization sebagai security
```

---

# 57. DEFINITION OF DONE

Sebuah milestone dianggap selesai apabila:

```text
[ ] Feature implemented
[ ] UI implemented
[ ] Responsive
[ ] Loading state
[ ] Empty state
[ ] Error state
[ ] Validation
[ ] Supabase integration
[ ] RLS/security reviewed
[ ] Testing completed
[ ] No obvious console errors
[ ] Documentation created
[ ] Code cleaned up
```

---

# 58. FINAL DELIVERABLE

Pada akhir project saya ingin mendapatkan:

```text
app_mariflow_vue/
│
├── src/
├── public/
├── supabase/
│   ├── migrations/
│   ├── functions/
│   └── seed.sql
│
├── docs/
│   ├── 00-project-analysis.md
│   ├── 01-project-setup.md
│   ├── 02-supabase-project.md
│   ├── 03-authentication.md
│   ├── 04-database.md
│   ├── 05-database-relationships.md
│   ├── 06-row-level-security.md
│   ├── 07-storage.md
│   ├── 08-realtime.md
│   ├── 09-database-functions.md
│   ├── 10-database-triggers.md
│   ├── 11-edge-functions.md
│   ├── 12-rest-api.md
│   ├── 13-error-handling.md
│   ├── 14-testing.md
│   ├── 15-security.md
│   └── 16-production-deployment.md
│
├── .env.example
├── .gitignore
├── package.json
└── README.md
```

---

# 59. START NOW

Mulai dari:

```text
MILESTONE 0 — PROJECT ANALYSIS
```

Jangan membuat seluruh aplikasi terlebih dahulu.

Pertama:

1. Analisis project.
2. Analisis TailAdmin.
3. Analisis dependency.
4. Analisis struktur folder.
5. Buat `docs/00-project-analysis.md`.
6. Buat rencana implementasi.
7. Tampilkan hasil analisis.
8. Setelah itu lanjut ke Milestone 1.

Prioritas utama:

```text
Correctness
Security
Maintainability
Documentation
User Experience
Performance
```

Bangun MariFlow sebagai project yang benar-benar dapat digunakan, bukan sekadar demo CRUD.