import { supabase } from '../supabase'
import type { Project, ProjectStatus } from '@/types/database.types'

export const projectService = {
  /**
   * Fetch all projects in a workspace
   */
  async getProjects(workspaceId: string, status?: ProjectStatus): Promise<Project[]> {
    let query = supabase
      .from('projects')
      .select(`
        *,
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .eq('workspace_id', workspaceId)
      .order('created_at', { ascending: false })

    if (status) {
      query = query.eq('status', status)
    }

    const { data, error } = await query
    if (error) throw error
    return (data || []) as Project[]
  },

  /**
   * Fetch single project by ID
   */
  async getProjectById(projectId: string): Promise<Project | null> {
    const { data, error } = await supabase
      .from('projects')
      .select(`
        *,
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .eq('id', projectId)
      .single()

    if (error) {
      if (error.code === 'PGRST116') return null
      throw error
    }
    return data as Project
  },

  /**
   * Create new project
   */
  async createProject(data: {
    workspace_id: string
    name: string
    description?: string | null
    status?: ProjectStatus
    start_date?: string | null
    due_date?: string | null
    created_by: string
  }): Promise<Project> {
    const { data: project, error } = await supabase
      .from('projects')
      .insert({
        ...data,
        status: data.status || 'active',
      })
      .select(`
        *,
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .single()

    if (error) throw error
    return project as Project
  },

  /**
   * Update existing project
   */
  async updateProject(projectId: string, updates: Partial<Project>): Promise<Project> {
    const { data, error } = await supabase
      .from('projects')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', projectId)
      .select(`
        *,
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .single()

    if (error) throw error
    return data as Project
  },

  /**
   * Delete project
   */
  async deleteProject(projectId: string): Promise<void> {
    const { error } = await supabase
      .from('projects')
      .delete()
      .eq('id', projectId)

    if (error) throw error
  },
}
