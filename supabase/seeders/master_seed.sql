-- ==============================================================================
-- MariFlow SaaS — MASTER SEEDER SCRIPT
-- Target: Supabase Cloud SQL Editor & Supabase Local CLI
-- Deskripsi: Menjalankan seluruh seeder (Users, Profiles, Workspaces, Members,
--            Projects, Tasks Kanban, Comments, Attachments) secara atomik.
-- Akun Demo: email @example.com & password default 'password'
-- ==============================================================================

BEGIN;

-- ------------------------------------------------------------------------------
-- 1. EKSTENSI & PENGGUNA AWAL (auth.users & public.profiles)
-- ------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    superadmin_uid UUID := '00000000-0000-0000-0000-000000000001'::UUID;
    owner_uid      UUID := '00000000-0000-0000-0000-000000000002'::UUID;
    admin_uid      UUID := '00000000-0000-0000-0000-000000000003'::UUID;
    member_uid     UUID := '00000000-0000-0000-0000-000000000004'::UUID;
    viewer_uid     UUID := '00000000-0000-0000-0000-000000000005'::UUID;
BEGIN
    -- Superadmin User (Password: password)
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'superadmin@example.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            superadmin_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'superadmin@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Super Administrator"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Owner User (Password: password)
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'owner@example.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'owner@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso (Owner)"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Admin User (Password: password)
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'admin@example.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            admin_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'admin@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Siti Rahma (Admin)"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Member User (Password: password)
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'member@example.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            member_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'member@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Rian Pratama (Member)"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Viewer User (Password: password)
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'viewer@example.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            viewer_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'viewer@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Maya Indah (Viewer)"}',
            NOW(),
            NOW()
        );
    END IF;
END $$;

-- ------------------------------------------------------------------------------
-- 1.5 PASTIKAN ENUM user_role & KOLOM role ADA DI PROFILES
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE public.user_role AS ENUM ('superadmin', 'owner', 'admin', 'member', 'viewer');
    ELSE
        BEGIN
            ALTER TYPE public.user_role ADD VALUE IF NOT EXISTS 'superadmin' BEFORE 'owner';
        EXCEPTION
            WHEN duplicate_object THEN NULL;
        END;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'role'
    ) THEN
        EXECUTE 'ALTER TABLE public.profiles ADD COLUMN role public.user_role DEFAULT ''member''';
    END IF;
END $$;

-- ------------------------------------------------------------------------------
-- 2. SINKRONISASI PROFILES
-- ------------------------------------------------------------------------------
INSERT INTO public.profiles (id, full_name, avatar_url, email, role, created_at, updated_at)
SELECT 
    id,
    COALESCE(raw_user_meta_data->>'full_name', email),
    CASE 
        WHEN email = 'superadmin@example.com' THEN 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'
        WHEN email = 'owner@example.com' THEN 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'
        WHEN email = 'admin@example.com' THEN 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'
        WHEN email = 'member@example.com' THEN 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150'
        ELSE 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150'
    END,
    email,
    CASE 
        WHEN email = 'superadmin@example.com' THEN 'superadmin'
        WHEN email = 'owner@example.com' THEN 'owner'
        WHEN email = 'admin@example.com' THEN 'admin'
        WHEN email = 'member@example.com' THEN 'member'
        ELSE 'viewer'
    END,
    NOW(),
    NOW()
FROM auth.users
WHERE email IN (
    'superadmin@example.com',
    'owner@example.com',
    'admin@example.com',
    'member@example.com',
    'viewer@example.com'
)
ON CONFLICT (id) DO UPDATE 
SET 
    full_name = EXCLUDED.full_name,
    avatar_url = EXCLUDED.avatar_url,
    role = EXCLUDED.role,
    updated_at = NOW();

-- ------------------------------------------------------------------------------
-- 3. WORKSPACES & WORKSPACE MEMBERS
-- ------------------------------------------------------------------------------
DO $$
DECLARE
    superadmin_uid UUID;
    owner_uid      UUID;
    admin_uid      UUID;
    member_uid     UUID;
    viewer_uid     UUID;

    ws_main_id     UUID := '10000000-0000-0000-0000-000000000001'::UUID;
    ws_client_id   UUID := '10000000-0000-0000-0000-000000000002'::UUID;
    ws_fintech_id  UUID := '10000000-0000-0000-0000-000000000003'::UUID;
BEGIN
    -- Ambil User IDs dari profiles berdasarkan email @example.com
    SELECT id INTO superadmin_uid FROM public.profiles WHERE email = 'superadmin@example.com' LIMIT 1;
    SELECT id INTO owner_uid FROM public.profiles WHERE email = 'owner@example.com' LIMIT 1;
    SELECT id INTO admin_uid FROM public.profiles WHERE email = 'admin@example.com' LIMIT 1;
    SELECT id INTO member_uid FROM public.profiles WHERE email = 'member@example.com' LIMIT 1;
    SELECT id INTO viewer_uid FROM public.profiles WHERE email = 'viewer@example.com' LIMIT 1;

    -- Fallback berjenjang agar owner_id TIDAK AKAN PERNAH NULL:
    IF owner_uid IS NULL THEN owner_uid := superadmin_uid; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles ORDER BY created_at ASC LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM auth.users ORDER BY created_at ASC LIMIT 1; END IF;

    -- Jika database masih benar-benar kosong, buat auth user & profile darurat
    IF owner_uid IS NULL THEN
        owner_uid := '00000000-0000-0000-0000-000000000002'::UUID;

        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'owner@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso (Owner)"}',
            NOW(),
            NOW()
        ) ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.profiles (id, full_name, email, role, created_at, updated_at)
        VALUES (owner_uid, 'Budi Santoso (Owner)', 'owner@example.com', 'owner', NOW(), NOW())
        ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name;
    END IF;

    -- Pastikan user roles lainnya tidak null
    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;
    IF viewer_uid IS NULL THEN viewer_uid := owner_uid; END IF;

    -- Insert Workspaces
    INSERT INTO public.workspaces (id, name, slug, description, owner_id, created_at, updated_at)
    VALUES 
    (
        ws_main_id,
        'Mari Partner Main Hub',
        'mari-partner-hub',
        'Workspace utama tim pengembangan produk Mari Partner & MariFlow SaaS.',
        owner_uid,
        NOW() - INTERVAL '30 days',
        NOW()
    ),
    (
        ws_client_id,
        'Client Projects & Marketing',
        'client-projects-marketing',
        'Manajemen proyek kampanye klien agensi dan pemasaran digital.',
        owner_uid,
        NOW() - INTERVAL '20 days',
        NOW()
    ),
    (
        ws_fintech_id,
        'MariFlow Mobile App Team',
        'mariflow-mobile-app',
        'Pengembangan aplikasi mobile iOS & Android pendamping MariFlow.',
        admin_uid,
        NOW() - INTERVAL '10 days',
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        name = EXCLUDED.name,
        slug = EXCLUDED.slug,
        description = EXCLUDED.description,
        owner_id = EXCLUDED.owner_id,
        updated_at = NOW();

    -- Insert Members
    IF owner_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, owner_uid, 'owner', NOW() - INTERVAL '30 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF admin_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, admin_uid, 'admin', NOW() - INTERVAL '28 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, member_uid, 'member', NOW() - INTERVAL '25 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF viewer_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, viewer_uid, 'viewer', NOW() - INTERVAL '20 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    -- Workspace 2 Members
    IF owner_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_client_id, owner_uid, 'owner', NOW() - INTERVAL '20 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_client_id, member_uid, 'member', NOW() - INTERVAL '18 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    -- Workspace 3 Members
    IF admin_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_fintech_id, admin_uid, 'owner', NOW() - INTERVAL '10 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_fintech_id, member_uid, 'member', NOW() - INTERVAL '9 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;
END $$;

-- ------------------------------------------------------------------------------
-- 4. PROJECTS
-- ------------------------------------------------------------------------------
DO $$
DECLARE
    owner_uid      UUID;
    admin_uid      UUID;

    ws_main_id     UUID := '10000000-0000-0000-0000-000000000001'::UUID;
    ws_client_id   UUID := '10000000-0000-0000-0000-000000000002'::UUID;

    p_mariflow_v1  UUID := '20000000-0000-0000-0000-000000000001'::UUID;
    p_landing_page UUID := '20000000-0000-0000-0000-000000000002'::UUID;
    p_payment_sys  UUID := '20000000-0000-0000-0000-000000000003'::UUID;
    p_security_v1  UUID := '20000000-0000-0000-0000-000000000004'::UUID;
BEGIN
    SELECT id INTO owner_uid FROM public.profiles WHERE email = 'owner@example.com' LIMIT 1;
    SELECT id INTO admin_uid FROM public.profiles WHERE email = 'admin@example.com' LIMIT 1;
    
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles WHERE email = 'superadmin@example.com' LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles ORDER BY created_at ASC LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM auth.users ORDER BY created_at ASC LIMIT 1; END IF;

    -- Jika database masih benar-benar kosong, buat auth user & profile darurat
    IF owner_uid IS NULL THEN
        owner_uid := '00000000-0000-0000-0000-000000000002'::UUID;

        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'owner@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso (Owner)"}',
            NOW(),
            NOW()
        ) ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.profiles (id, full_name, email, created_at, updated_at)
        VALUES (owner_uid, 'Budi Santoso (Owner)', 'owner@example.com', NOW(), NOW())
        ON CONFLICT (id) DO NOTHING;
    END IF;

    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;

    INSERT INTO public.projects (id, workspace_id, name, description, status, start_date, due_date, created_by, created_at, updated_at)
    VALUES 
    (
        p_mariflow_v1,
        ws_main_id,
        'Pembangunan Platform MariFlow v1.0',
        'Pengembangan inti fitur multi-workspace, task kanban board, dan integrasi Supabase end-to-end.',
        'active',
        CURRENT_DATE - INTERVAL '15 days',
        CURRENT_DATE + INTERVAL '45 days',
        owner_uid,
        NOW() - INTERVAL '15 days',
        NOW()
    ),
    (
        p_landing_page,
        ws_main_id,
        'Redesain Landing Page & Branding',
        'Pembaruan visual identitas brand Mari Partner dan landing page marketing SaaS yang responsif.',
        'planning',
        CURRENT_DATE + INTERVAL '5 days',
        CURRENT_DATE + INTERVAL '30 days',
        admin_uid,
        NOW() - INTERVAL '10 days',
        NOW()
    ),
    (
        p_payment_sys,
        ws_main_id,
        'Integrasi Sistem Pembayaran & Invoicing',
        'Implementasi gateway subscription SaaS, kupon diskon, dan faktur otomatis.',
        'active',
        CURRENT_DATE - INTERVAL '5 days',
        CURRENT_DATE + INTERVAL '60 days',
        owner_uid,
        NOW() - INTERVAL '5 days',
        NOW()
    ),
    (
        p_security_v1,
        ws_client_id,
        'Audit Keamanan & Penetrasi RLS Database',
        'Audit kepatuhan PostgreSQL Row Level Security, proteksi token anon, dan sanitasi input form.',
        'completed',
        CURRENT_DATE - INTERVAL '25 days',
        CURRENT_DATE - INTERVAL '2 days',
        admin_uid,
        NOW() - INTERVAL '25 days',
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        status = EXCLUDED.status,
        start_date = EXCLUDED.start_date,
        due_date = EXCLUDED.due_date,
        updated_at = NOW();
END $$;

-- ------------------------------------------------------------------------------
-- 5. TASKS KANBAN BOARD
-- ------------------------------------------------------------------------------
DO $$
DECLARE
    owner_uid      UUID;
    admin_uid      UUID;
    member_uid     UUID;

    ws_main_id     UUID := '10000000-0000-0000-0000-000000000001'::UUID;
    p_mariflow_v1  UUID := '20000000-0000-0000-0000-000000000001'::UUID;
    p_landing_page UUID := '20000000-0000-0000-0000-000000000002'::UUID;
    p_payment_sys  UUID := '20000000-0000-0000-0000-000000000003'::UUID;
BEGIN
    SELECT id INTO owner_uid FROM public.profiles WHERE email = 'owner@example.com' LIMIT 1;
    SELECT id INTO admin_uid FROM public.profiles WHERE email = 'admin@example.com' LIMIT 1;
    SELECT id INTO member_uid FROM public.profiles WHERE email = 'member@example.com' LIMIT 1;

    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles WHERE email = 'superadmin@example.com' LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles ORDER BY created_at ASC LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM auth.users ORDER BY created_at ASC LIMIT 1; END IF;

    -- Jika database masih benar-benar kosong, buat auth user & profile darurat
    IF owner_uid IS NULL THEN
        owner_uid := '00000000-0000-0000-0000-000000000002'::UUID;

        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'owner@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso (Owner)"}',
            NOW(),
            NOW()
        ) ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.profiles (id, full_name, email, created_at, updated_at)
        VALUES (owner_uid, 'Budi Santoso (Owner)', 'owner@example.com', NOW(), NOW())
        ON CONFLICT (id) DO NOTHING;
    END IF;

    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;

    INSERT INTO public.tasks (id, workspace_id, project_id, title, description, status, priority, assigned_to, created_by, due_date, created_at, updated_at)
    VALUES
    -- COMPLETED
    (
        '30000000-0000-0000-0000-000000000001'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Setup Database Migrations & PostgreSQL RLS',
        'Membuat skema tabel profiles, workspaces, members, projects, tasks, comments, dan storage policies.',
        'completed',
        'urgent',
        owner_uid,
        owner_uid,
        CURRENT_DATE - INTERVAL '5 days',
        NOW() - INTERVAL '14 days',
        NOW() - INTERVAL '5 days'
    ),
    (
        '30000000-0000-0000-0000-000000000002'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Konfigurasi Supabase Auth & Session Handling',
        'Integrasi login, registrasi, lupa password, reset password, dan listener onAuthStateChange di Pinia Store.',
        'completed',
        'high',
        admin_uid,
        owner_uid,
        CURRENT_DATE - INTERVAL '3 days',
        NOW() - INTERVAL '12 days',
        NOW() - INTERVAL '3 days'
    ),
    (
        '30000000-0000-0000-0000-000000000003'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Kustomisasi Pesan Error Sistem & Database',
        'Penerjemahan raw error database dan Supabase Auth ke Bahasa Indonesia yang ramah via errorHandler.ts.',
        'completed',
        'medium',
        member_uid,
        admin_uid,
        CURRENT_DATE - INTERVAL '1 days',
        NOW() - INTERVAL '5 days',
        NOW() - INTERVAL '1 days'
    ),
    -- IN PROGRESS
    (
        '30000000-0000-0000-0000-000000000004'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Implementasi Drag & Drop Papan Kanban',
        'Mengintegrasikan HTML5 Drag & Drop API pada kolom To Do, In Progress, Review, dan Completed.',
        'in_progress',
        'urgent',
        member_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '3 days',
        NOW() - INTERVAL '7 days',
        NOW()
    ),
    (
        '30000000-0000-0000-0000-000000000005'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Supabase Storage Multi-file Dropzone',
        'Fitur upload lampiran berkas multi-file dengan drag & drop, thumbnail preview, dan size limiter.',
        'in_progress',
        'high',
        admin_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '5 days',
        NOW() - INTERVAL '4 days',
        NOW()
    ),
    (
        '30000000-0000-0000-0000-000000000006'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Navigasi Route Guard CheckRoleMiddleware',
        'Pengamanan rute router berbasis single CheckRoleMiddleware dan bypass otomatis untuk Superadmin.',
        'in_progress',
        'medium',
        owner_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '4 days',
        NOW() - INTERVAL '2 days',
        NOW()
    ),
    -- REVIEW
    (
        '30000000-0000-0000-0000-000000000007'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Review Mockup Dashboard Analytics & KPI',
        'Evaluasi grafik kecepatan penyelesaian tugas, distribusi beban kerja tim, dan pie chart status proyek.',
        'review',
        'high',
        owner_uid,
        admin_uid,
        CURRENT_DATE + INTERVAL '2 days',
        NOW() - INTERVAL '3 days',
        NOW()
    ),
    (
        '30000000-0000-0000-0000-000000000008'::UUID,
        ws_main_id,
        p_payment_sys,
        'Review Integrasi Webhook Gateway Pembayaran',
        'Pengujian sandbox pembayaran subscription dan pengiriman invoice email otomatis.',
        'review',
        'medium',
        admin_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '6 days',
        NOW() - INTERVAL '3 days',
        NOW()
    ),
    -- TO DO
    (
        '30000000-0000-0000-0000-000000000009'::UUID,
        ws_main_id,
        p_landing_page,
        'Desain Header Hero & Ilustrasi Mari Partner',
        'Membuat visual ilustrasi bertema modern SaaS dengan badge preview interaktif untuk landing page.',
        'todo',
        'medium',
        member_uid,
        admin_uid,
        CURRENT_DATE + INTERVAL '10 days',
        NOW() - INTERVAL '1 days',
        NOW()
    ),
    (
        '30000000-0000-0000-0000-000000000010'::UUID,
        ws_main_id,
        p_landing_page,
        'Optimasi Mobile Viewport & Dark Mode Theme',
        'Memastikan seluruh halaman publik dan modul SaaS tampil sempurna pada layar smartphone.',
        'todo',
        'low',
        member_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '12 days',
        NOW() - INTERVAL '1 days',
        NOW()
    ),
    (
        '30000000-0000-0000-0000-000000000011'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Pemberitahuan Realtime & Bell Notification Center',
        'Sinkronisasi notifikasi live saat pengguna ditugaskan ke task baru atau dimention di komentar.',
        'todo',
        'high',
        admin_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '8 days',
        NOW(),
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        title = EXCLUDED.title,
        description = EXCLUDED.description,
        status = EXCLUDED.status,
        priority = EXCLUDED.priority,
        due_date = EXCLUDED.due_date,
        updated_at = NOW();
END $$;

-- ------------------------------------------------------------------------------
-- 6. TASK COMMENTS & TASK ATTACHMENTS
-- ------------------------------------------------------------------------------
DO $$
DECLARE
    owner_uid      UUID;
    admin_uid      UUID;
    member_uid     UUID;

    t_kanban_id    UUID := '30000000-0000-0000-0000-000000000004'::UUID;
    t_storage_id   UUID := '30000000-0000-0000-0000-000000000005'::UUID;
    t_auth_id      UUID := '30000000-0000-0000-0000-000000000002'::UUID;
BEGIN
    SELECT id INTO owner_uid FROM public.profiles WHERE email = 'owner@example.com' LIMIT 1;
    SELECT id INTO admin_uid FROM public.profiles WHERE email = 'admin@example.com' LIMIT 1;
    SELECT id INTO member_uid FROM public.profiles WHERE email = 'member@example.com' LIMIT 1;

    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles WHERE email = 'superadmin@example.com' LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles ORDER BY created_at ASC LIMIT 1; END IF;
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM auth.users ORDER BY created_at ASC LIMIT 1; END IF;

    -- Jika database masih benar-benar kosong, buat auth user & profile darurat
    IF owner_uid IS NULL THEN
        owner_uid := '00000000-0000-0000-0000-000000000002'::UUID;

        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'owner@example.com',
            crypt('password', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso (Owner)"}',
            NOW(),
            NOW()
        ) ON CONFLICT (id) DO NOTHING;

        INSERT INTO public.profiles (id, full_name, email, created_at, updated_at)
        VALUES (owner_uid, 'Budi Santoso (Owner)', 'owner@example.com', NOW(), NOW())
        ON CONFLICT (id) DO NOTHING;
    END IF;

    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;

    -- Task Comments
    INSERT INTO public.task_comments (id, task_id, user_id, content, created_at, updated_at)
    VALUES
    (
        '40000000-0000-0000-0000-000000000001'::UUID,
        t_kanban_id,
        owner_uid,
        'Pastikan event onDragOver menggunakan preventDefault() agar transisi drag halus di Firefox & Chrome.',
        NOW() - INTERVAL '2 days',
        NOW() - INTERVAL '2 days'
    ),
    (
        '40000000-0000-0000-0000-000000000002'::UUID,
        t_kanban_id,
        member_uid,
        'Siap Mas Budi! Optimistic UI update sudah berjalan cepat dan tersinkronisasi ke status tugas di database.',
        NOW() - INTERVAL '1 days',
        NOW() - INTERVAL '1 days'
    ),
    (
        '40000000-0000-0000-0000-000000000003'::UUID,
        t_storage_id,
        admin_uid,
        'Storage bucket task-attachments sudah disiapkan dengan public URL dan batasan maksimal 10 MB per berkas.',
        NOW() - INTERVAL '12 hours',
        NOW() - INTERVAL '12 hours'
    ),
    (
        '40000000-0000-0000-0000-000000000004'::UUID,
        t_auth_id,
        owner_uid,
        'Session storage & token refresh listener onAuthStateChange sudah teruji aman saat tab browser dibuka kembali.',
        NOW() - INTERVAL '3 days',
        NOW() - INTERVAL '3 days'
    )
    ON CONFLICT (id) DO NOTHING;

    -- Task Attachments Metadata
    INSERT INTO public.task_attachments (id, task_id, uploaded_by, file_name, file_path, file_size, mime_type, created_at)
    VALUES
    (
        '50000000-0000-0000-0000-000000000001'::UUID,
        t_kanban_id,
        member_uid,
        'kanban-ui-flow-v1.png',
        'demo/kanban-ui-flow-v1.png',
        245760,
        'image/png',
        NOW() - INTERVAL '2 days'
    ),
    (
        '50000000-0000-0000-0000-000000000002'::UUID,
        t_storage_id,
        admin_uid,
        'storage-policy-spec.pdf',
        'demo/storage-policy-spec.pdf',
        524288,
        'application/pdf',
        NOW() - INTERVAL '12 hours'
    )
    ON CONFLICT (id) DO NOTHING;
END $$;

COMMIT;
