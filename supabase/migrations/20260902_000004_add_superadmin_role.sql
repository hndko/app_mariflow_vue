-- ==============================================================================
-- MariFlow SaaS — Migration 000004: Platform Superadmin Role & Global Metrics
-- ==============================================================================

-- 1. Add is_superadmin boolean column to profiles
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_superadmin BOOLEAN DEFAULT FALSE NOT NULL;

-- 2. Create index on is_superadmin for quick lookup
CREATE INDEX IF NOT EXISTS idx_profiles_is_superadmin 
ON public.profiles (is_superadmin) 
WHERE is_superadmin = TRUE;

-- 3. Update RLS on profiles to allow superadmins to view and manage all profiles
DROP POLICY IF EXISTS "Superadmins can view all profiles" ON public.profiles;
CREATE POLICY "Superadmins can view all profiles"
    ON public.profiles FOR SELECT
    USING (
        auth.uid() = id 
        OR (SELECT is_superadmin FROM public.profiles WHERE id = auth.uid()) = TRUE
    );

-- 4. Superadmin policy on workspaces
DROP POLICY IF EXISTS "Superadmins can view all workspaces" ON public.workspaces;
CREATE POLICY "Superadmins can view all workspaces"
    ON public.workspaces FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.workspace_members wm
            WHERE wm.workspace_id = workspaces.id AND wm.user_id = auth.uid()
        )
        OR (SELECT is_superadmin FROM public.profiles WHERE id = auth.uid()) = TRUE
    );

-- 5. RPC Function: Get Global SaaS Platform Metrics for Superadmin
CREATE OR REPLACE FUNCTION public.get_superadmin_saas_metrics()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    current_caller_id UUID;
    caller_is_superadmin BOOLEAN;
    result JSON;
BEGIN
    current_caller_id := auth.uid();
    
    -- Check if caller is superadmin
    SELECT is_superadmin INTO caller_is_superadmin
    FROM public.profiles
    WHERE id = current_caller_id;

    IF caller_is_superadmin IS NOT TRUE AND current_caller_id IS NOT NULL THEN
        RAISE EXCEPTION 'Akses Ditolak: Hanya Superadmin Platform yang diizinkan mengakses metrik global SaaS.';
    END IF;

    SELECT json_build_object(
        'total_workspaces', (SELECT COUNT(*) FROM public.workspaces),
        'total_users', (SELECT COUNT(*) FROM public.profiles),
        'total_superadmins', (SELECT COUNT(*) FROM public.profiles WHERE is_superadmin = TRUE),
        'total_projects', (SELECT COUNT(*) FROM public.projects),
        'total_tasks', (SELECT COUNT(*) FROM public.tasks),
        'total_completed_tasks', (SELECT COUNT(*) FROM public.tasks WHERE status = 'completed'),
        'total_comments', (SELECT COUNT(*) FROM public.task_comments),
        'total_attachments', (SELECT COUNT(*) FROM public.task_attachments),
        'recent_workspaces', (
            SELECT COALESCE(json_agg(w_data), '[]'::json)
            FROM (
                SELECT 
                    w.id,
                    w.name,
                    w.slug,
                    w.created_at,
                    p.full_name AS owner_name,
                    p.email AS owner_email,
                    p.avatar_url AS owner_avatar,
                    (SELECT COUNT(*) FROM public.projects pr WHERE pr.workspace_id = w.id) AS projects_count,
                    (SELECT COUNT(*) FROM public.workspace_members wm WHERE wm.workspace_id = w.id) AS members_count
                FROM public.workspaces w
                LEFT JOIN public.profiles p ON p.id = w.owner_id
                ORDER BY w.created_at DESC
                LIMIT 10
            ) w_data
        ),
        'recent_users', (
            SELECT COALESCE(json_agg(u_data), '[]'::json)
            FROM (
                SELECT 
                    id,
                    email,
                    full_name,
                    avatar_url,
                    is_superadmin,
                    created_at,
                    (SELECT COUNT(*) FROM public.workspace_members wm WHERE wm.user_id = profiles.id) AS workspaces_count
                FROM public.profiles
                ORDER BY created_at DESC
                LIMIT 10
            ) u_data
        )
    ) INTO result;

    RETURN result;
END;
$$;

-- 6. RPC Function: Toggle Superadmin Role (Only callable by existing superadmin)
CREATE OR REPLACE FUNCTION public.toggle_superadmin_status(target_user_id UUID, new_status BOOLEAN)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    caller_is_superadmin BOOLEAN;
BEGIN
    SELECT is_superadmin INTO caller_is_superadmin
    FROM public.profiles
    WHERE id = auth.uid();

    IF caller_is_superadmin IS NOT TRUE THEN
        RAISE EXCEPTION 'Akses Ditolak: Hanya Superadmin Platform yang dapat mengubah peran Superadmin.';
    END IF;

    UPDATE public.profiles
    SET is_superadmin = new_status,
        updated_at = NOW()
    WHERE id = target_user_id;

    RETURN TRUE;
END;
$$;

-- 7. Elevate default owner to Superadmin if profile exists
UPDATE public.profiles
SET is_superadmin = TRUE
WHERE email IN ('hd.doko22@gmail.com', 'budi@maripartner.com');
