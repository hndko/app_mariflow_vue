-- ==============================================================================
-- Migration: Fix Function Search Path Mutable & Restrict Executable Privileges
-- Linter References: 0011_function_search_path_mutable, 
--                    0028_anon_security_definer_function_executable,
--                    0029_authenticated_security_definer_function_executable
-- ==============================================================================

BEGIN;

-- 1. FIX: set_updated_at (Internal Trigger Function)
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.set_updated_at() FROM PUBLIC, anon, authenticated;

-- 2. FIX: handle_new_user (Internal Trigger Function on auth.users)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    new_workspace_id UUID;
    user_name TEXT;
BEGIN
    user_name := COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1));
    
    -- 1. Insert profile
    INSERT INTO public.profiles (id, full_name, avatar_url, email)
    VALUES (NEW.id, user_name, NULL, NEW.email)
    ON CONFLICT (id) DO UPDATE 
    SET full_name = EXCLUDED.full_name, email = EXCLUDED.email;

    -- 2. Create default personal workspace
    INSERT INTO public.workspaces (name, slug, description, owner_id)
    VALUES (
        user_name || '''s Workspace',
        lower(regexp_replace(user_name, '[^a-zA-Z0-9]', '-', 'g')) || '-' || substring(NEW.id::text, 1, 6),
        'Workspace utama Anda di MariFlow',
        NEW.id
    )
    RETURNING id INTO new_workspace_id;

    -- 3. Add user as workspace Owner
    INSERT INTO public.workspace_members (workspace_id, user_id, role)
    VALUES (new_workspace_id, NEW.id, 'owner')
    ON CONFLICT DO NOTHING;

    -- 4. Create welcome notification
    INSERT INTO public.notifications (user_id, workspace_id, type, title, message)
    VALUES (
        NEW.id,
        new_workspace_id,
        'welcome',
        'Selamat Datang di MariFlow!',
        'Workspace utama Anda telah dibuat. Mulai buat proyek dan kelola tugas tim Anda sekarang.'
    );

    RETURN NEW;
EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'handle_new_user encountered error: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, auth, pg_temp;

GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role, supabase_auth_admin;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role, supabase_auth_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role, supabase_auth_admin;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO postgres, anon, authenticated, service_role, supabase_auth_admin;
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO postgres, supabase_auth_admin;

-- 3. FIX: log_task_activity (Internal Trigger Function on public.tasks)
CREATE OR REPLACE FUNCTION public.log_task_activity()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.activity_logs (workspace_id, user_id, entity_type, entity_id, action, metadata)
        VALUES (
            NEW.workspace_id,
            NEW.created_by,
            'task',
            NEW.id::text,
            'created_task',
            jsonb_build_object('title', NEW.title, 'priority', NEW.priority)
        );
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status != NEW.status THEN
            INSERT INTO public.activity_logs (workspace_id, user_id, entity_type, entity_id, action, metadata)
            VALUES (
                NEW.workspace_id,
                COALESCE(auth.uid(), NEW.created_by),
                'task',
                NEW.id::text,
                'updated_status',
                jsonb_build_object('title', NEW.title, 'old_status', OLD.status, 'new_status', NEW.status)
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.log_task_activity() FROM PUBLIC, anon, authenticated;

-- 4. FIX: is_workspace_member (Helper Function for RLS Policies)
CREATE OR REPLACE FUNCTION public.is_workspace_member(ws_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.workspace_members
        WHERE workspace_id = ws_id AND user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.is_workspace_member(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.is_workspace_member(UUID) TO authenticated;

-- 5. FIX: get_workspace_role (Helper Function for RLS Policies)
CREATE OR REPLACE FUNCTION public.get_workspace_role(ws_id UUID)
RETURNS workspace_role AS $$
DECLARE
    user_role workspace_role;
BEGIN
    SELECT role INTO user_role FROM public.workspace_members
    WHERE workspace_id = ws_id AND user_id = auth.uid();
    RETURN user_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.get_workspace_role(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_workspace_role(UUID) TO authenticated;

-- 6. FIX: get_workspace_statistics (Analytics RPC -> SECURITY INVOKER)
CREATE OR REPLACE FUNCTION public.get_workspace_statistics(target_ws_id UUID)
RETURNS JSONB AS $$
DECLARE
    result JSONB;
    v_total_projects BIGINT;
    v_total_tasks BIGINT;
    v_completed_tasks BIGINT;
    v_pending_tasks BIGINT;
    v_overdue_tasks BIGINT;
    v_team_members BIGINT;
    v_todo_tasks BIGINT;
    v_in_progress_tasks BIGINT;
    v_review_tasks BIGINT;
    v_urgent_tasks BIGINT;
    v_high_tasks BIGINT;
    v_medium_tasks BIGINT;
    v_low_tasks BIGINT;
BEGIN
    IF NOT public.is_workspace_member(target_ws_id) THEN
        RAISE EXCEPTION 'Akses ditolak: Anda bukan anggota workspace ini.';
    END IF;

    SELECT COUNT(*) INTO v_total_projects FROM public.projects WHERE workspace_id = target_ws_id;
    SELECT COUNT(*) INTO v_total_tasks FROM public.tasks WHERE workspace_id = target_ws_id;

    SELECT COUNT(*) INTO v_completed_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'completed';
    SELECT COUNT(*) INTO v_todo_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'todo';
    SELECT COUNT(*) INTO v_in_progress_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'in_progress';
    SELECT COUNT(*) INTO v_review_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'review';
    v_pending_tasks := v_total_tasks - v_completed_tasks;

    SELECT COUNT(*) INTO v_overdue_tasks FROM public.tasks
    WHERE workspace_id = target_ws_id AND due_date < CURRENT_DATE AND status != 'completed';

    SELECT COUNT(*) INTO v_team_members FROM public.workspace_members WHERE workspace_id = target_ws_id;

    SELECT COUNT(*) INTO v_urgent_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'urgent';
    SELECT COUNT(*) INTO v_high_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'high';
    SELECT COUNT(*) INTO v_medium_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'medium';
    SELECT COUNT(*) INTO v_low_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'low';

    result := jsonb_build_object(
        'total_projects', v_total_projects,
        'total_tasks', v_total_tasks,
        'completed_tasks', v_completed_tasks,
        'pending_tasks', v_pending_tasks,
        'overdue_tasks', v_overdue_tasks,
        'team_members', v_team_members,
        'tasks_by_status', jsonb_build_object(
            'todo', v_todo_tasks,
            'in_progress', v_in_progress_tasks,
            'review', v_review_tasks,
            'completed', v_completed_tasks
        ),
        'tasks_by_priority', jsonb_build_object(
            'urgent', v_urgent_tasks,
            'high', v_high_tasks,
            'medium', v_medium_tasks,
            'low', v_low_tasks
        )
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER STABLE
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.get_workspace_statistics(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_workspace_statistics(UUID) TO authenticated;

-- 7. FIX: get_role_dashboard_statistics (Role-based Analytics RPC -> SECURITY INVOKER)
CREATE OR REPLACE FUNCTION public.get_role_dashboard_statistics(
    target_ws_id UUID,
    target_user_id UUID,
    time_filter TEXT DEFAULT 'all'
)
RETURNS JSONB AS $$
DECLARE
    result JSONB;
    v_user_role TEXT;
    v_start_time TIMESTAMPTZ;

    v_total_projects BIGINT := 0;
    v_active_projects BIGINT := 0;
    v_total_tasks BIGINT := 0;
    v_completed_tasks BIGINT := 0;
    v_pending_tasks BIGINT := 0;
    v_overdue_tasks BIGINT := 0;
    v_unassigned_tasks BIGINT := 0;
    v_total_members BIGINT := 0;
    v_total_attachments BIGINT := 0;

    v_todo_tasks BIGINT := 0;
    v_in_progress_tasks BIGINT := 0;
    v_review_tasks BIGINT := 0;

    v_urgent_tasks BIGINT := 0;
    v_high_tasks BIGINT := 0;
    v_medium_tasks BIGINT := 0;
    v_low_tasks BIGINT := 0;

    v_my_total_tasks BIGINT := 0;
    v_my_in_progress BIGINT := 0;
    v_my_completed BIGINT := 0;
    v_my_review BIGINT := 0;
    v_my_overdue BIGINT := 0;

    v_trend_dates JSONB := '[]'::jsonb;
    v_trend_created JSONB := '[]'::jsonb;
    v_trend_completed JSONB := '[]'::jsonb;
BEGIN
    SELECT role INTO v_user_role
    FROM public.workspace_members
    WHERE workspace_id = target_ws_id AND user_id = target_user_id;

    IF v_user_role IS NULL THEN
        SELECT 'owner' INTO v_user_role
        FROM public.workspaces
        WHERE id = target_ws_id AND owner_id = target_user_id;
    END IF;

    IF v_user_role IS NULL THEN
        RAISE EXCEPTION 'Akses ditolak: Anda bukan anggota workspace ini.';
    END IF;

    IF time_filter = 'today' THEN
        v_start_time := date_trunc('day', CURRENT_TIMESTAMP);
    ELSIF time_filter = 'week' THEN
        v_start_time := date_trunc('week', CURRENT_TIMESTAMP);
    ELSIF time_filter = 'month' THEN
        v_start_time := date_trunc('month', CURRENT_TIMESTAMP);
    ELSIF time_filter = 'year' THEN
        v_start_time := date_trunc('year', CURRENT_TIMESTAMP);
    ELSE
        v_start_time := '1970-01-01 00:00:00+00'::timestamptz;
    END IF;

    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'active')
    INTO v_total_projects, v_active_projects
    FROM public.projects
    WHERE workspace_id = target_ws_id;

    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'completed'),
        COUNT(*) FILTER (WHERE status = 'todo'),
        COUNT(*) FILTER (WHERE status = 'in_progress'),
        COUNT(*) FILTER (WHERE status = 'review'),
        COUNT(*) FILTER (WHERE status != 'completed' AND due_date < CURRENT_DATE),
        COUNT(*) FILTER (WHERE assigned_to IS NULL),
        COUNT(*) FILTER (WHERE priority = 'urgent'),
        COUNT(*) FILTER (WHERE priority = 'high'),
        COUNT(*) FILTER (WHERE priority = 'medium'),
        COUNT(*) FILTER (WHERE priority = 'low')
    INTO
        v_total_tasks,
        v_completed_tasks,
        v_todo_tasks,
        v_in_progress_tasks,
        v_review_tasks,
        v_overdue_tasks,
        v_unassigned_tasks,
        v_urgent_tasks,
        v_high_tasks,
        v_medium_tasks,
        v_low_tasks
    FROM public.tasks
    WHERE workspace_id = target_ws_id
      AND created_at >= v_start_time;

    v_pending_tasks := v_total_tasks - v_completed_tasks;

    SELECT COUNT(*) INTO v_total_members
    FROM public.workspace_members
    WHERE workspace_id = target_ws_id;

    SELECT COUNT(*) INTO v_total_attachments
    FROM public.task_attachments ta
    JOIN public.tasks t ON t.id = ta.task_id
    WHERE t.workspace_id = target_ws_id;

    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'in_progress'),
        COUNT(*) FILTER (WHERE status = 'completed'),
        COUNT(*) FILTER (WHERE status = 'review'),
        COUNT(*) FILTER (WHERE status != 'completed' AND due_date < CURRENT_DATE)
    INTO
        v_my_total_tasks,
        v_my_in_progress,
        v_my_completed,
        v_my_review,
        v_my_overdue
    FROM public.tasks
    WHERE workspace_id = target_ws_id
      AND assigned_to = target_user_id
      AND created_at >= v_start_time;

    SELECT
        jsonb_agg(to_char(d.day, 'DD Mon')),
        jsonb_agg(COALESCE(tc.created_count, 0)),
        jsonb_agg(COALESCE(tc.completed_count, 0))
    INTO
        v_trend_dates,
        v_trend_created,
        v_trend_completed
    FROM (
        SELECT generate_series(
            CURRENT_DATE - INTERVAL '6 days',
            CURRENT_DATE,
            INTERVAL '1 day'
        )::date AS day
    ) d
    LEFT JOIN (
        SELECT
            created_at::date AS task_day,
            COUNT(*) AS created_count,
            COUNT(*) FILTER (WHERE status = 'completed') AS completed_count
        FROM public.tasks
        WHERE workspace_id = target_ws_id
          AND created_at >= CURRENT_DATE - INTERVAL '6 days'
        GROUP BY created_at::date
    ) tc ON d.day = tc.task_day;

    result := jsonb_build_object(
        'user_role', v_user_role,
        'time_filter', time_filter,
        'overview', jsonb_build_object(
            'total_projects', v_total_projects,
            'active_projects', v_active_projects,
            'total_tasks', v_total_tasks,
            'completed_tasks', v_completed_tasks,
            'pending_tasks', v_pending_tasks,
            'overdue_tasks', v_overdue_tasks,
            'total_members', v_total_members,
            'total_attachments', v_total_attachments,
            'completion_rate', CASE WHEN v_total_tasks > 0 THEN ROUND((v_completed_tasks::numeric / v_total_tasks::numeric) * 100, 1) ELSE 0 END
        ),
        'workspace_metrics', jsonb_build_object(
            'unassigned_tasks', v_unassigned_tasks,
            'tasks_by_status', jsonb_build_object(
                'todo', v_todo_tasks,
                'in_progress', v_in_progress_tasks,
                'review', v_review_tasks,
                'completed', v_completed_tasks
            ),
            'tasks_by_priority', jsonb_build_object(
                'urgent', v_urgent_tasks,
                'high', v_high_tasks,
                'medium', v_medium_tasks,
                'low', v_low_tasks
            )
        ),
        'member_metrics', jsonb_build_object(
            'my_total_tasks', v_my_total_tasks,
            'my_in_progress', v_my_in_progress,
            'my_completed', v_my_completed,
            'my_review', v_my_review,
            'my_overdue', v_my_overdue,
            'my_completion_rate', CASE WHEN v_my_total_tasks > 0 THEN ROUND((v_my_completed::numeric / v_my_total_tasks::numeric) * 100, 1) ELSE 0 END
        ),
        'trend_series', jsonb_build_object(
            'dates', COALESCE(v_trend_dates, '[]'::jsonb),
            'created', COALESCE(v_trend_created, '[]'::jsonb),
            'completed', COALESCE(v_trend_completed, '[]'::jsonb)
        )
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER STABLE
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.get_role_dashboard_statistics(UUID, UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_role_dashboard_statistics(UUID, UUID, TEXT) TO authenticated;

-- 8. FIX: rls_auto_enable (if present)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_proc p 
        JOIN pg_namespace n ON p.pronamespace = n.oid 
        WHERE n.nspname = 'public' AND p.proname = 'rls_auto_enable'
    ) THEN
        EXECUTE 'REVOKE ALL ON FUNCTION public.rls_auto_enable() FROM PUBLIC, anon, authenticated;';
    END IF;
END $$;

COMMIT;
