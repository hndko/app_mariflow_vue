-- ==============================================================================
-- MariFlow SaaS — DATABASE RESET / CLEAN SLATE SCRIPT
-- Target: Supabase Cloud SQL Editor & Supabase Local CLI
-- PERINGATAN: Script ini akan MENGHAPUS SELURUH tabel, relasi, trigger, fungsi,
--             dan tipe data kustom di skema public, serta membersihkan akun demo.
-- ==============================================================================

BEGIN;

-- 1. HAPUS TRIGGER AUTH PADA auth.users (Mencegah trigger berjalan saat reset)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 2. HAPUS SELURUH TABEL DI SKEMA public (DENGAN CASCADE)
DROP TABLE IF EXISTS public.task_attachments CASCADE;
DROP TABLE IF EXISTS public.task_comments CASCADE;
DROP TABLE IF EXISTS public.task_assignees CASCADE;
DROP TABLE IF EXISTS public.tasks CASCADE;
DROP TABLE IF EXISTS public.projects CASCADE;
DROP TABLE IF EXISTS public.workspace_members CASCADE;
DROP TABLE IF EXISTS public.workspaces CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.activity_logs CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- 3. HAPUS SELURUH FUNGSI KUSTOM DI SKEMA public
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.set_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.log_task_activity() CASCADE;
DROP FUNCTION IF EXISTS public.is_workspace_member(UUID) CASCADE;
DROP FUNCTION IF EXISTS public.get_workspace_role(UUID) CASCADE;
DROP FUNCTION IF EXISTS public.get_workspace_statistics(UUID) CASCADE;
DROP FUNCTION IF EXISTS public.get_role_dashboard_statistics(UUID, UUID, TEXT) CASCADE;
DROP FUNCTION IF EXISTS public.rls_auto_enable() CASCADE;

-- 4. HAPUS ENUM TIPE DATA KUSTOM
DROP TYPE IF EXISTS public.task_priority CASCADE;
DROP TYPE IF EXISTS public.task_status CASCADE;
DROP TYPE IF EXISTS public.project_status CASCADE;
DROP TYPE IF EXISTS public.workspace_role CASCADE;
DROP TYPE IF EXISTS public.user_role CASCADE;

-- 5. BERSIHKAN DATA AUTH USERS DEMO (Hanya akun contoh @example.com)
DELETE FROM auth.users 
WHERE email IN (
    'superadmin@example.com',
    'owner@example.com',
    'admin@example.com',
    'member@example.com',
    'viewer@example.com'
);

COMMIT;
