-- ==============================================================================
-- MariFlow SaaS — Migration 000004: Add 'superadmin' to user_role ENUM
-- ==============================================================================

-- 1. Add 'superadmin' value to existing user_role ENUM
ALTER TYPE public.user_role ADD VALUE IF NOT EXISTS 'superadmin' BEFORE 'owner';

-- 2. Optional: Add direct role column to profiles
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS role public.user_role DEFAULT 'member'::public.user_role;

-- 3. Update master account to superadmin role
UPDATE public.profiles
SET role = 'superadmin'::public.user_role
WHERE email IN ('superadmin@example.com', 'hd.doko22@gmail.com');
