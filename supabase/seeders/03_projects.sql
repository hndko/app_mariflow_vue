-- ==============================================================================
-- MariFlow SaaS Seeder 03: Projects
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

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
    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles LIMIT 1; END IF;
    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;

    INSERT INTO public.projects (id, workspace_id, name, description, status, start_date, due_date, created_by, created_at, updated_at)
    VALUES 
    (
        p_mariflow_v1,
        ws_main_id,
        'Pembangunan Platform MariFlow v1.0',
        'Pengembangan inti fitur multi-workspace, task kanban board, dan integrasi Supabase end-to-end.',
        'active'::public.project_status,
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
        'planning'::public.project_status,
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
        'active'::public.project_status,
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
        'completed'::public.project_status,
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
