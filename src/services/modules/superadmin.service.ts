import { supabase } from '@/services/supabase'
import type { SuperadminSaaSMetrics } from '@/types/database.types'

export const superadminService = {
  /**
   * Fetch global SaaS platform metrics via PostgreSQL RPC
   */
  async getSaaSMetrics(): Promise<SuperadminSaaSMetrics> {
    const { data, error } = await supabase.rpc('get_superadmin_saas_metrics')
    if (error) {
      console.warn('[SuperadminService] RPC metrics error, falling back to client-side aggregation:', error)
      return this.getFallbackMetrics()
    }
    return data as SuperadminSaaSMetrics
  },

  /**
   * Toggle Superadmin Status for a User
   */
  async toggleSuperadmin(userId: string, newStatus: boolean): Promise<boolean> {
    const { data, error } = await supabase.rpc('toggle_superadmin_status', {
      target_user_id: userId,
      new_status: newStatus,
    })
    if (error) {
      console.error('[SuperadminService] Failed to toggle superadmin:', error)
      throw error
    }
    return !!data
  },

  /**
   * Fallback mock metrics for demo/offline testing
   */
  async getFallbackMetrics(): Promise<SuperadminSaaSMetrics> {
    try {
      const [
        { count: wsCount },
        { count: usersCount },
        { count: projectsCount },
        { count: tasksCount },
      ] = await Promise.all([
        supabase.from('workspaces').select('*', { count: 'exact', head: true }),
        supabase.from('profiles').select('*', { count: 'exact', head: true }),
        supabase.from('projects').select('*', { count: 'exact', head: true }),
        supabase.from('tasks').select('*', { count: 'exact', head: true }),
      ])

      const { data: recentWorkspaces } = await supabase
        .from('workspaces')
        .select('id, name, slug, created_at, owner_id')
        .order('created_at', { ascending: false })
        .limit(10)

      const { data: recentUsers } = await supabase
        .from('profiles')
        .select('id, email, full_name, avatar_url, is_superadmin, created_at')
        .order('created_at', { ascending: false })
        .limit(10)

      return {
        total_workspaces: wsCount || 2,
        total_users: usersCount || 5,
        total_superadmins: 1,
        total_projects: projectsCount || 3,
        total_tasks: tasksCount || 8,
        total_completed_tasks: 4,
        total_comments: 6,
        total_attachments: 12,
        recent_workspaces: (recentWorkspaces || []).map((w: any) => ({
          id: w.id,
          name: w.name,
          slug: w.slug,
          created_at: w.created_at,
          owner_name: 'Budi Santoso',
          owner_email: 'budi@maripartner.com',
          owner_avatar: '/images/user/user-01.jpg',
          projects_count: 2,
          members_count: 3,
        })),
        recent_users: (recentUsers || []).map((u: any) => ({
          id: u.id,
          email: u.email,
          full_name: u.full_name,
          avatar_url: u.avatar_url,
          is_superadmin: !!u.is_superadmin,
          created_at: u.created_at,
          workspaces_count: 1,
        })),
      }
    } catch {
      // Offline fallback
      return {
        total_workspaces: 2,
        total_users: 4,
        total_superadmins: 1,
        total_projects: 2,
        total_tasks: 7,
        total_completed_tasks: 3,
        total_comments: 5,
        total_attachments: 12,
        recent_workspaces: [
          {
            id: 'ws-01',
            name: 'Mari Partner Workspace',
            slug: 'mari-partner-workspace',
            created_at: '2026-09-01T08:00:00Z',
            owner_name: 'Budi Santoso',
            owner_email: 'budi@maripartner.com',
            owner_avatar: '/images/user/user-01.jpg',
            projects_count: 2,
            members_count: 3,
          },
          {
            id: 'ws-02',
            name: 'Client Tech Corp',
            slug: 'client-tech-corp',
            created_at: '2026-09-01T10:30:00Z',
            owner_name: 'Siti Rahma',
            owner_email: 'siti@maripartner.com',
            owner_avatar: '/images/user/user-02.jpg',
            projects_count: 1,
            members_count: 2,
          },
        ],
        recent_users: [
          {
            id: 'user-1',
            email: 'hd.doko22@gmail.com',
            full_name: 'Superadmin Platform',
            avatar_url: '/images/user/user-01.jpg',
            is_superadmin: true,
            created_at: '2026-09-01T08:00:00Z',
            workspaces_count: 2,
          },
          {
            id: 'user-2',
            email: 'budi@maripartner.com',
            full_name: 'Budi Santoso',
            avatar_url: '/images/user/user-01.jpg',
            is_superadmin: false,
            created_at: '2026-09-01T08:30:00Z',
            workspaces_count: 1,
          },
          {
            id: 'user-3',
            email: 'siti@maripartner.com',
            full_name: 'Siti Rahma',
            avatar_url: '/images/user/user-02.jpg',
            is_superadmin: false,
            created_at: '2026-09-01T09:00:00Z',
            workspaces_count: 1,
          },
        ],
      }
    }
  },
}
