-- ==============================================================================
-- MariFlow SaaS Seeder 05: Task Comments & Task Attachments
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

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

    IF owner_uid IS NULL THEN SELECT id INTO owner_uid FROM public.profiles LIMIT 1; END IF;
    IF admin_uid IS NULL THEN admin_uid := owner_uid; END IF;
    IF member_uid IS NULL THEN member_uid := owner_uid; END IF;

    -- 1. Insert Task Comments
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

    -- 2. Insert Task Attachments (Metadata)
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
