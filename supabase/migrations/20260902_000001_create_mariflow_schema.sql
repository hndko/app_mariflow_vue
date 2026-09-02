-- ==============================================================================
-- MariFlow SaaS Database Schema & Row Level Security (RLS) Migration
-- Target Engine: Supabase PostgreSQL
-- ==============================================================================

-- 1. ENUMS
CREATE TYPE user_role AS ENUM ('superadmin', 'owner', 'admin', 'member', 'viewer');
CREATE TYPE workspace_role AS ENUM ('owner', 'admin', 'member', 'viewer');
CREATE TYPE project_status AS ENUM ('planning', 'active', 'completed', 'archived');
CREATE TYPE task_status AS ENUM ('todo', 'in_progress', 'review', 'completed', 'cancelled');
CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high', 'urgent');

-- 2. EXTENSIONS & UTILITIES
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Function to automatically update `updated_at` timestamps
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql
SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.set_updated_at() FROM PUBLIC, anon, authenticated;

-- 3. TABLES DEFINITION

-- 3.1 Profiles Table (Linked to auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    avatar_url TEXT,
    email TEXT NOT NULL,
    role user_role DEFAULT 'member'::user_role NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.2 Workspaces Table
CREATE TABLE IF NOT EXISTS public.workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.3 Workspace Members Table
CREATE TABLE IF NOT EXISTS public.workspace_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role workspace_role DEFAULT 'member'::workspace_role NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(workspace_id, user_id)
);

-- 3.4 Projects Table
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    status project_status DEFAULT 'active'::project_status NOT NULL,
    start_date DATE,
    due_date DATE,
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.5 Tasks Table
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    status task_status DEFAULT 'todo'::task_status NOT NULL,
    priority task_priority DEFAULT 'medium'::task_priority NOT NULL,
    assigned_to UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    due_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.6 Task Assignees (Optional multiple assignees support)
CREATE TABLE IF NOT EXISTS public.task_assignees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES public.tasks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(task_id, user_id)
);

-- 3.7 Task Comments Table
CREATE TABLE IF NOT EXISTS public.task_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES public.tasks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.8 Task Attachments Table
CREATE TABLE IF NOT EXISTS public.task_attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES public.tasks(id) ON DELETE CASCADE,
    uploaded_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.9 Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    reference_type TEXT,
    reference_id TEXT,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3.10 Activity Logs Table
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    action TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 4. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_workspaces_owner ON public.workspaces(owner_id);
CREATE INDEX IF NOT EXISTS idx_workspace_members_user ON public.workspace_members(user_id);
CREATE INDEX IF NOT EXISTS idx_workspace_members_workspace ON public.workspace_members(workspace_id);
CREATE INDEX IF NOT EXISTS idx_projects_workspace ON public.projects(workspace_id);
CREATE INDEX IF NOT EXISTS idx_projects_status ON public.projects(status);
CREATE INDEX IF NOT EXISTS idx_tasks_project ON public.tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_workspace ON public.tasks(workspace_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON public.tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON public.tasks(assigned_to);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON public.tasks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_task_comments_task ON public.task_comments(task_id);
CREATE INDEX IF NOT EXISTS idx_task_attachments_task ON public.task_attachments(task_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON public.notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_activity_logs_workspace ON public.activity_logs(workspace_id, created_at DESC);

-- 5. UPDATED_AT TRIGGERS
CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trg_workspaces_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trg_projects_updated_at BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trg_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trg_task_comments_updated_at BEFORE UPDATE ON public.task_comments FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

-- 6. AUTOMATIC USER REGISTRATION TRIGGER
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
    VALUES (new_workspace_id, NEW.id, 'owner'::workspace_role)
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

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ==============================================================================
-- 7. ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_assignees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Helper function: Is user member of workspace?
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

-- Helper function: Get user role in workspace
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

-- 7.1 PROFILES POLICIES
CREATE POLICY "Public profiles are viewable by authenticated users"
    ON public.profiles FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    TO authenticated
    USING (auth.uid() = id);

-- 7.2 WORKSPACES POLICIES
CREATE POLICY "Users can view workspaces they are member of"
    ON public.workspaces FOR SELECT
    TO authenticated
    USING (public.is_workspace_member(id) OR owner_id = auth.uid());

CREATE POLICY "Authenticated users can create workspaces"
    ON public.workspaces FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Workspace owners and admins can update workspace"
    ON public.workspaces FOR UPDATE
    TO authenticated
    USING (owner_id = auth.uid() OR public.get_workspace_role(id) IN ('owner', 'admin'));

CREATE POLICY "Only workspace owners can delete workspace"
    ON public.workspaces FOR DELETE
    TO authenticated
    USING (owner_id = auth.uid());

-- 7.3 WORKSPACE MEMBERS POLICIES
CREATE POLICY "Members can view other members in same workspace"
    ON public.workspace_members FOR SELECT
    TO authenticated
    USING (public.is_workspace_member(workspace_id));

CREATE POLICY "Owners and admins can add members"
    ON public.workspace_members FOR INSERT
    TO authenticated
    WITH CHECK (public.get_workspace_role(workspace_id) IN ('owner', 'admin'));

CREATE POLICY "Owners and admins can update member roles"
    ON public.workspace_members FOR UPDATE
    TO authenticated
    USING (public.get_workspace_role(workspace_id) IN ('owner', 'admin'));

CREATE POLICY "Owners and admins can remove members or user can leave"
    ON public.workspace_members FOR DELETE
    TO authenticated
    USING (
        user_id = auth.uid() OR
        public.get_workspace_role(workspace_id) IN ('owner', 'admin')
    );

-- 7.4 PROJECTS POLICIES
CREATE POLICY "Members can view projects in their workspace"
    ON public.projects FOR SELECT
    TO authenticated
    USING (public.is_workspace_member(workspace_id));

CREATE POLICY "Non-viewers can create projects"
    ON public.projects FOR INSERT
    TO authenticated
    WITH CHECK (
        public.is_workspace_member(workspace_id) AND
        public.get_workspace_role(workspace_id) IN ('owner', 'admin', 'member')
    );

CREATE POLICY "Non-viewers can update projects"
    ON public.projects FOR UPDATE
    TO authenticated
    USING (
        public.is_workspace_member(workspace_id) AND
        public.get_workspace_role(workspace_id) IN ('owner', 'admin', 'member')
    );

CREATE POLICY "Owners and admins can delete projects"
    ON public.projects FOR DELETE
    TO authenticated
    USING (public.get_workspace_role(workspace_id) IN ('owner', 'admin'));

-- 7.5 TASKS POLICIES
CREATE POLICY "Members can view tasks in their workspace"
    ON public.tasks FOR SELECT
    TO authenticated
    USING (public.is_workspace_member(workspace_id));

CREATE POLICY "Non-viewers can create tasks"
    ON public.tasks FOR INSERT
    TO authenticated
    WITH CHECK (
        public.is_workspace_member(workspace_id) AND
        public.get_workspace_role(workspace_id) IN ('owner', 'admin', 'member')
    );

CREATE POLICY "Non-viewers can update tasks"
    ON public.tasks FOR UPDATE
    TO authenticated
    USING (
        public.is_workspace_member(workspace_id) AND
        public.get_workspace_role(workspace_id) IN ('owner', 'admin', 'member')
    );

CREATE POLICY "Owners, admins or task creators can delete tasks"
    ON public.tasks FOR DELETE
    TO authenticated
    USING (
        created_by = auth.uid() OR
        public.get_workspace_role(workspace_id) IN ('owner', 'admin')
    );

-- 7.6 TASK COMMENTS POLICIES
CREATE POLICY "Members can view comments"
    ON public.task_comments FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.tasks t
            WHERE t.id = task_id AND public.is_workspace_member(t.workspace_id)
        )
    );

CREATE POLICY "Members can add comments"
    ON public.task_comments FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.tasks t
            WHERE t.id = task_id AND public.is_workspace_member(t.workspace_id)
        )
    );

CREATE POLICY "Users can edit or delete their own comments"
    ON public.task_comments FOR ALL
    TO authenticated
    USING (auth.uid() = user_id);

-- 7.7 TASK ATTACHMENTS POLICIES
CREATE POLICY "Members can view attachments"
    ON public.task_attachments FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.tasks t
            WHERE t.id = task_id AND public.is_workspace_member(t.workspace_id)
        )
    );

CREATE POLICY "Members can upload attachments"
    ON public.task_attachments FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.uid() = uploaded_by AND
        EXISTS (
            SELECT 1 FROM public.tasks t
            WHERE t.id = task_id AND public.is_workspace_member(t.workspace_id)
        )
    );

CREATE POLICY "Uploaders or admins can delete attachments"
    ON public.task_attachments FOR DELETE
    TO authenticated
    USING (
        uploaded_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.tasks t
            WHERE t.id = task_id AND public.get_workspace_role(t.workspace_id) IN ('owner', 'admin')
        )
    );

-- 7.8 NOTIFICATIONS POLICIES
CREATE POLICY "Users can view and manage their own notifications"
    ON public.notifications FOR ALL
    TO authenticated
    USING (auth.uid() = user_id);

-- 7.9 ACTIVITY LOGS POLICIES
CREATE POLICY "Members can view activity logs in their workspace"
    ON public.activity_logs FOR SELECT
    TO authenticated
    USING (public.is_workspace_member(workspace_id));

CREATE POLICY "System and members can insert activity logs"
    ON public.activity_logs FOR INSERT
    TO authenticated
    WITH CHECK (public.is_workspace_member(workspace_id));
