-- ==============================================================================
-- MariFlow SaaS Database Functions & Triggers for Analytics & Automation
-- Target Engine: Supabase PostgreSQL
-- ==============================================================================

-- 1. Function: Aggregated Workspace Statistics for Dashboard
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
    -- Check permissions
    IF NOT public.is_workspace_member(target_ws_id) THEN
        RAISE EXCEPTION 'Akses ditolak: Anda bukan anggota workspace ini.';
    END IF;

    -- Count projects
    SELECT COUNT(*) INTO v_total_projects FROM public.projects WHERE workspace_id = target_ws_id;

    -- Count total tasks
    SELECT COUNT(*) INTO v_total_tasks FROM public.tasks WHERE workspace_id = target_ws_id;

    -- Count tasks by status
    SELECT COUNT(*) INTO v_completed_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'completed';
    SELECT COUNT(*) INTO v_todo_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'todo';
    SELECT COUNT(*) INTO v_in_progress_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'in_progress';
    SELECT COUNT(*) INTO v_review_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND status = 'review';
    v_pending_tasks := v_total_tasks - v_completed_tasks;

    -- Count overdue tasks (due_date < current date and not completed)
    SELECT COUNT(*) INTO v_overdue_tasks FROM public.tasks
    WHERE workspace_id = target_ws_id AND due_date < CURRENT_DATE AND status != 'completed';

    -- Count team members
    SELECT COUNT(*) INTO v_team_members FROM public.workspace_members WHERE workspace_id = target_ws_id;

    -- Count tasks by priority
    SELECT COUNT(*) INTO v_urgent_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'urgent';
    SELECT COUNT(*) INTO v_high_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'high';
    SELECT COUNT(*) INTO v_medium_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'medium';
    SELECT COUNT(*) INTO v_low_tasks FROM public.tasks WHERE workspace_id = target_ws_id AND priority = 'low';

    -- Build JSON result
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
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- 2. Trigger: Automatic Activity Log for Task Changes
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_log_task_activity ON public.tasks;
CREATE TRIGGER trg_log_task_activity
    AFTER INSERT OR UPDATE ON public.tasks
    FOR EACH ROW EXECUTE PROCEDURE public.log_task_activity();
