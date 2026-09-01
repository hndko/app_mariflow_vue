-- ==============================================================================
-- MariFlow SaaS Seeder 04: Tasks Kanban Board
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

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

    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles LIMIT 1; END IF;
    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;

    -- ========================================================
    -- 1. TASKS: COMPLETED COLUMN
    -- ========================================================
    INSERT INTO public.tasks (id, workspace_id, project_id, title, description, status, priority, assigned_to, created_by, due_date, created_at, updated_at)
    VALUES
    (
        '30000000-0000-0000-0000-000000000001'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Setup Database Migrations & PostgreSQL RLS',
        'Membuat skema tabel profiles, workspaces, members, projects, tasks, comments, dan storage policies.',
        'completed'::public.task_status,
        'urgent'::public.task_priority,
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
        'completed'::public.task_status,
        'high'::public.task_priority,
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
        'completed'::public.task_status,
        'medium'::public.task_priority,
        member_uid,
        admin_uid,
        CURRENT_DATE - INTERVAL '1 days',
        NOW() - INTERVAL '5 days',
        NOW() - INTERVAL '1 days'
    ),

    -- ========================================================
    -- 2. TASKS: IN PROGRESS COLUMN
    -- ========================================================
    (
        '30000000-0000-0000-0000-000000000004'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Implementasi Drag & Drop Papan Kanban',
        'Mengintegrasikan HTML5 Drag & Drop API pada kolom To Do, In Progress, Review, dan Completed.',
        'in_progress'::public.task_status,
        'urgent'::public.task_priority,
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
        'in_progress'::public.task_status,
        'high'::public.task_priority,
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
        'in_progress'::public.task_status,
        'medium'::public.task_priority,
        owner_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '4 days',
        NOW() - INTERVAL '2 days',
        NOW()
    ),

    -- ========================================================
    -- 3. TASKS: REVIEW COLUMN
    -- ========================================================
    (
        '30000000-0000-0000-0000-000000000007'::UUID,
        ws_main_id,
        p_mariflow_v1,
        'Review Mockup Dashboard Analytics & KPI',
        'Evaluasi grafik kecepatan penyelesaian tugas, distribusi beban kerja tim, dan pie chart status proyek.',
        'review'::public.task_status,
        'high'::public.task_priority,
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
        'review'::public.task_status,
        'medium'::public.task_priority,
        admin_uid,
        owner_uid,
        CURRENT_DATE + INTERVAL '6 days',
        NOW() - INTERVAL '3 days',
        NOW()
    ),

    -- ========================================================
    -- 4. TASKS: TO DO COLUMN
    -- ========================================================
    (
        '30000000-0000-0000-0000-000000000009'::UUID,
        ws_main_id,
        p_landing_page,
        'Desain Header Hero & Ilustrasi Mari Partner',
        'Membuat visual ilustrasi bertema modern SaaS dengan badge preview interaktif untuk landing page.',
        'todo'::public.task_status,
        'medium'::public.task_priority,
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
        'todo'::public.task_status,
        'low'::public.task_priority,
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
        'todo'::public.task_status,
        'high'::public.task_priority,
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
