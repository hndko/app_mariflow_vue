-- ==============================================================================
-- MariFlow SaaS Seeder 01: Auth Users & Profiles
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

-- 1. Siapkan ekstensi pgcrypto untuk enkripsi kata sandi
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2. Buat Pengguna Awal di auth.users (Kata sandi default: 'password')
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

-- 2.5 Pastikan ENUM user_role dan kolom role ada di profiles
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

-- 3. Sinkronisasikan Data Profil ke public.profiles
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
    (CASE 
        WHEN email = 'superadmin@example.com' THEN 'superadmin'
        WHEN email = 'owner@example.com' THEN 'owner'
        WHEN email = 'admin@example.com' THEN 'admin'
        WHEN email = 'member@example.com' THEN 'member'
        ELSE 'viewer'
    END)::public.user_role,
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
