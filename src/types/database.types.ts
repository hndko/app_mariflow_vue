export type UserRole = 'owner' | 'admin' | 'member' | 'viewer'

export type ProjectStatus = 'planning' | 'active' | 'completed' | 'archived'

export type TaskStatus = 'todo' | 'in_progress' | 'review' | 'completed' | 'cancelled'

export type TaskPriority = 'low' | 'medium' | 'high' | 'urgent'

export interface Profile {
  id: string
  full_name: string | null
  avatar_url: string | null
  email: string
  created_at: string
  updated_at: string
}

export interface Workspace {
  id: string
  name: string
  slug: string
  description: string | null
  owner_id: string
  created_at: string
  updated_at: string
  role?: UserRole
}

export interface WorkspaceMember {
  id: string
  workspace_id: string
  user_id: string
  role: UserRole
  created_at: string
  profile?: Profile
}

export interface Project {
  id: string
  workspace_id: string
  name: string
  description: string | null
  status: ProjectStatus
  start_date: string | null
  due_date: string | null
  created_by: string
  created_at: string
  updated_at: string
  creator?: Profile
  tasks_count?: number
  completed_tasks_count?: number
}

export interface Task {
  id: string
  project_id: string
  workspace_id: string
  title: string
  description: string | null
  status: TaskStatus
  priority: TaskPriority
  assigned_to: string | null
  created_by: string
  due_date: string | null
  created_at: string
  updated_at: string
  assignee?: Profile | null
  creator?: Profile | null
  project?: Partial<Project> | null
  comments_count?: number
  attachments_count?: number
}

export interface TaskAssignee {
  id: string
  task_id: string
  user_id: string
  created_at: string
  profile?: Profile
}

export interface TaskComment {
  id: string
  task_id: string
  user_id: string
  content: string
  created_at: string
  updated_at: string
  user?: Profile
}

export interface TaskAttachment {
  id: string
  task_id: string
  uploaded_by: string
  file_name: string
  file_path: string
  file_size: number
  mime_type: string
  created_at: string
  uploader?: Profile
  public_url?: string
}

export interface AppNotification {
  id: string
  user_id: string
  workspace_id: string
  type: string
  title: string
  message: string
  reference_type: string | null
  reference_id: string | null
  is_read: boolean
  created_at: string
}

export interface ActivityLog {
  id: string
  workspace_id: string
  user_id: string
  entity_type: string
  entity_id: string
  action: string
  metadata: Record<string, any> | null
  created_at: string
  user?: Profile
}

export interface DashboardStats {
  total_workspaces: number
  total_projects: number
  total_tasks: number
  completed_tasks: number
  pending_tasks: number
  overdue_tasks: number
  team_members: number
  tasks_by_status: Record<TaskStatus, number>
  tasks_by_priority: Record<TaskPriority, number>
}
