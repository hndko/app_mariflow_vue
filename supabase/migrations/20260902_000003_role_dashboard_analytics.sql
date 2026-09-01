-- ==============================================================================
-- MariFlow SaaS Role-Based Dashboard Analytics Optimization
-- Target Engine: Supabase PostgreSQL (Single-Pass Performance RPC)
-- ==============================================================================

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

    -- Workspace Global Metrics
    v_total_projects BIGINT := 0;
    v_active_projects BIGINT := 0;
    v_total_tasks BIGINT := 0;
    v_completed_tasks BIGINT := 0;
    v_pending_tasks BIGINT := 0;
    v_overdue_tasks BIGINT := 0;
    v_unassigned_tasks BIGINT := 0;
    v_total_members BIGINT := 0;
    v_total_attachments BIGINT := 0;

    -- Status Breakdown
    v_todo_tasks BIGINT := 0;
    v_in_progress_tasks BIGINT := 0;
    v_review_tasks BIGINT := 0;

    -- Priority Breakdown
    v_urgent_tasks BIGINT := 0;
    v_high_tasks BIGINT := 0;
    v_medium_tasks BIGINT := 0;
    v_low_tasks BIGINT := 0;

    -- Member Specific Metrics (For Member Role)
    v_my_total_tasks BIGINT := 0;
    v_my_in_progress BIGINT := 0;
    v_my_completed BIGINT := 0;
    v_my_review BIGINT := 0;
    v_my_overdue BIGINT := 0;

    -- Time Series Series Arrays
    v_trend_dates JSONB := '[]'::jsonb;
    v_trend_created JSONB := '[]'::jsonb;
    v_trend_completed JSONB := '[]'::jsonb;
BEGIN
    -- 1. Verify workspace membership & resolve role
    SELECT role INTO v_user_role
    FROM public.workspace_members
    WHERE workspace_id = target_ws_id AND user_id = target_user_id;

    IF v_user_role IS NULL THEN
        -- Check if user is the owner directly
        SELECT 'owner' INTO v_user_role
        FROM public.workspaces
        WHERE id = target_ws_id AND owner_id = target_user_id;
    END IF;

    IF v_user_role IS NULL THEN
        RAISE EXCEPTION 'Akses ditolak: Anda bukan anggota workspace ini.';
    END IF;

    -- 2. Determine time filter timestamp boundary
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

    -- 3. Projects Count
    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'active')
    INTO v_total_projects, v_active_projects
    FROM public.projects
    WHERE workspace_id = target_ws_id;

    -- 4. Single-Pass Workspace Tasks Aggregation
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

    -- 5. Team Members & Attachments Count
    SELECT COUNT(*) INTO v_total_members
    FROM public.workspace_members
    WHERE workspace_id = target_ws_id;

    SELECT COUNT(*) INTO v_total_attachments
    FROM public.task_attachments ta
    JOIN public.tasks t ON t.id = ta.task_id
    WHERE t.workspace_id = target_ws_id;

    -- 6. Member-Specific Personal Task Aggregation (For Member View)
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

    -- 7. Build Time-Series Trend Aggregates (Last 7 Days)
    SELECT
        jsonb_agg(to_char(d.day, 'DD Mon')),
        jsonb_agg(COALESCE(tc.created_count, 0)),
        jsonb_agg(COALESCE(tcomp.completed_count, 0))
    INTO
        v_trend_dates,
        v_trend_created,
        v_trend_completed
    FROM generate_series(
        CURRENT_DATE - INTERVAL '6 days',
        CURRENT_DATE,
        '1 day'::interval
    ) d(day)
    LEFT JOIN (
        SELECT date_trunc('day', created_at) AS day, COUNT(*) AS created_count
        FROM public.tasks
        WHERE workspace_id = target_ws_id
        GROUP BY date_trunc('day', created_at)
    ) tc ON tc.day = d.day
    LEFT JOIN (
        SELECT date_trunc('day', updated_at) AS day, COUNT(*) AS completed_count
        FROM public.tasks
        WHERE workspace_id = target_ws_id AND status = 'completed'
        GROUP BY date_trunc('day', updated_at)
    ) tcomp ON tcomp.day = d.day;

    -- 8. Construct Unified Structured Response
    result := jsonb_build_object(
        'user_role', v_user_role,
        'time_filter', time_filter,
        'executive_metrics', jsonb_build_object(
            'total_projects', v_total_projects,
            'active_projects', v_active_projects,
            'total_tasks', v_total_tasks,
            'completed_tasks', v_completed_tasks,
            'completion_rate', CASE WHEN v_total_tasks > 0 THEN ROUND((v_completed_tasks::numeric / v_total_tasks::numeric) * 100, 1) ELSE 0 END,
            'total_members', v_total_members,
            'total_attachments', v_total_attachments
        ),
        'operational_metrics', jsonb_build_object(
            'pending_tasks', v_pending_tasks,
            'overdue_tasks', v_overdue_tasks,
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
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
