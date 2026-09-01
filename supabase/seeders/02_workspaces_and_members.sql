-- ==============================================================================
-- MariFlow SaaS Seeder 02: Workspaces & Workspace Members
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

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
    -- 1. Gunakan superadmin_uid jika owner_uid null
    IF owner_uid IS NULL THEN owner_uid := superadmin_uid; END IF;
    -- 2. Gunakan profile pertama yang ada di database
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles ORDER BY created_at ASC LIMIT 1; END IF;
    -- 3. Gunakan user pertama di auth.users jika profile belum terbuat
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM auth.users ORDER BY created_at ASC LIMIT 1; END IF;

    -- 4. Jika database masih benar-benar kosong, buat auth user & profile darurat
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
        VALUES (owner_uid, 'Budi Santoso (Owner)', 'owner@example.com', 'owner'::public.user_role, NOW(), NOW())
        ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name;
    END IF;

    -- Pastikan user roles lainnya tidak null
    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;
    IF viewer_uid IS NULL THEN viewer_uid := owner_uid; END IF;

    -- 1. Insert Workspaces
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

    -- 2. Insert Workspace Members
    -- Workspace 1 (Mari Partner Hub)
    IF owner_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, owner_uid, 'owner'::public.workspace_role, NOW() - INTERVAL '30 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF admin_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, admin_uid, 'admin'::public.workspace_role, NOW() - INTERVAL '28 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, member_uid, 'member'::public.workspace_role, NOW() - INTERVAL '25 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF viewer_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_main_id, viewer_uid, 'viewer'::public.workspace_role, NOW() - INTERVAL '20 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    -- Workspace 2 (Client Projects)
    IF owner_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_client_id, owner_uid, 'owner'::public.workspace_role, NOW() - INTERVAL '20 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_client_id, member_uid, 'member'::public.workspace_role, NOW() - INTERVAL '18 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    -- Workspace 3 (Mobile App Team)
    IF admin_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_fintech_id, admin_uid, 'owner'::public.workspace_role, NOW() - INTERVAL '10 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

    IF member_uid IS NOT NULL THEN
        INSERT INTO public.workspace_members (workspace_id, user_id, role, created_at)
        VALUES (ws_fintech_id, member_uid, 'member'::public.workspace_role, NOW() - INTERVAL '9 days')
        ON CONFLICT (workspace_id, user_id) DO NOTHING;
    END IF;

END $$;
