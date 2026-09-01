-- ==============================================================================
-- MariFlow SaaS Seed Data Entrypoint (Local Supabase CLI / Docker)
-- ==============================================================================
-- File ini dieksekusi secara otomatis saat menjalankan `supabase db reset`.
-- Berisi seluruh data awal: Auth Users, Profiles, Workspaces, Members, Projects, Tasks, Comments, & Attachments.
-- Script terorganisir per file tersedia di folder: supabase/seeders/
-- ==============================================================================

\i supabase/seeders/master_seed.sql
