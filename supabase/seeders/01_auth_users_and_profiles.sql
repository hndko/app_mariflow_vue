-- ==============================================================================
-- MariFlow SaaS Seeder 01: Auth Users & Profiles
-- Target: Supabase PostgreSQL (Local CLI & Supabase Cloud)
-- ==============================================================================

-- 1. Siapkan ekstensi pgcrypto untuk enkripsi kata sandi
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2. Buat Pengguna Awal di auth.users (Kata sandi default: 'password123')
DO $$
DECLARE
    superadmin_uid UUID := '00000000-0000-0000-0000-000000000001'::UUID;
    owner_uid      UUID := '00000000-0000-0000-0000-000000000002'::UUID;
    admin_uid      UUID := '00000000-0000-0000-0000-000000000003'::UUID;
    member_uid     UUID := '00000000-0000-0000-0000-000000000004'::UUID;
    viewer_uid     UUID := '00000000-0000-0000-0000-000000000005'::UUID;
BEGIN
    -- Superadmin User
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hd.doko22@gmail.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            superadmin_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'hd.doko22@gmail.com',
            crypt('password123', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Hendi Doko (Superadmin)"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Owner User
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'budi@maripartner.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            owner_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'budi@maripartner.com',
            crypt('password123', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Budi Santoso"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Admin User
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'siti@maripartner.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            admin_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'siti@maripartner.com',
            crypt('password123', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Siti Rahma"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Member User
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rian@maripartner.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            member_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'rian@maripartner.com',
            crypt('password123', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Rian Pratama"}',
            NOW(),
            NOW()
        );
    END IF;

    -- Viewer User
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'maya@maripartner.com') THEN
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            raw_app_meta_data, raw_user_meta_data, created_at, updated_at
        ) VALUES (
            viewer_uid,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'maya@maripartner.com',
            crypt('password123', gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}',
            '{"full_name":"Maya Indah"}',
            NOW(),
            NOW()
        );
    END IF;
END $$;

-- 3. Sinkronisasikan Data Profil ke public.profiles
INSERT INTO public.profiles (id, full_name, avatar_url, email, role, created_at, updated_at)
SELECT 
    id,
    COALESCE(raw_user_meta_data->>'full_name', email),
    CASE 
        WHEN email = 'hd.doko22@gmail.com' THEN 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'
        WHEN email = 'budi@maripartner.com' THEN 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'
        WHEN email = 'siti@maripartner.com' THEN 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'
        WHEN email = 'rian@maripartner.com' THEN 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150'
        ELSE 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150'
    END,
    email,
    CASE 
        WHEN email = 'hd.doko22@gmail.com' THEN 'superadmin'::public.user_role
        WHEN email = 'budi@maripartner.com' THEN 'owner'::public.user_role
        WHEN email = 'siti@maripartner.com' THEN 'admin'::public.user_role
        WHEN email = 'rian@maripartner.com' THEN 'member'::public.user_role
        ELSE 'viewer'::public.user_role
    END,
    NOW(),
    NOW()
FROM auth.users
WHERE email IN (
    'hd.doko22@gmail.com',
    'budi@maripartner.com',
    'siti@maripartner.com',
    'rian@maripartner.com',
    'maya@maripartner.com'
)
ON CONFLICT (id) DO UPDATE 
SET 
    full_name = EXCLUDED.full_name,
    avatar_url = EXCLUDED.avatar_url,
    role = EXCLUDED.role,
    updated_at = NOW();
