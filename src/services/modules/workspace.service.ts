import { supabase } from '../supabase'
import type { Workspace, WorkspaceMember, UserRole } from '@/types/database.types'

export const workspaceService = {
  /**
   * Fetch all workspaces that current user is a member of
   */
  async getMyWorkspaces(userId: string): Promise<Workspace[]> {
    const { data, error } = await supabase
      .from('workspace_members')
      .select(`
        role,
        workspaces (
          id,
          name,
          slug,
          description,
          owner_id,
          created_at,
          updated_at
        )
      `)
      .eq('user_id', userId)

    if (error) throw error

    if (!data || data.length === 0) {
      // Fallback: Also check if user is owner of any workspaces directly
      const { data: ownedData, error: ownedError } = await supabase
        .from('workspaces')
        .select('*')
        .eq('owner_id', userId)

      if (ownedError) throw ownedError
      return (ownedData || []).map((w) => ({ ...w, role: 'owner' as UserRole }))
    }

    return data
      .filter((item: any) => item.workspaces !== null)
      .map((item: any) => ({
        ...item.workspaces,
        role: item.role as UserRole,
      }))
  },

  /**
   * Fetch single workspace by ID
   */
  async getWorkspaceById(workspaceId: string): Promise<Workspace | null> {
    const { data, error } = await supabase
      .from('workspaces')
      .select('*')
      .eq('id', workspaceId)
      .single()

    if (error) {
      if (error.code === 'PGRST116') return null
      throw error
    }
    return data as Workspace
  },

  /**
   * Create a new workspace
   */
  async createWorkspace(name: string, description: string | null, ownerId: string): Promise<Workspace> {
    const slug = `${name.toLowerCase().replace(/[^a-z0-9]/g, '-')}-${Math.random().toString(36).substring(2, 7)}`

    const { data: ws, error: wsError } = await supabase
      .from('workspaces')
      .insert({
        name,
        slug,
        description,
        owner_id: ownerId,
      })
      .select()
      .single()

    if (wsError) throw wsError

    // Automatically register owner in workspace_members
    await supabase.from('workspace_members').insert({
      workspace_id: ws.id,
      user_id: ownerId,
      role: 'owner',
    })

    return { ...ws, role: 'owner' as UserRole }
  },

  /**
   * Update workspace details
   */
  async updateWorkspace(workspaceId: string, updates: Partial<Workspace>): Promise<Workspace> {
    const { data, error } = await supabase
      .from('workspaces')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', workspaceId)
      .select()
      .single()

    if (error) throw error
    return data as Workspace
  },

  /**
   * Delete workspace
   */
  async deleteWorkspace(workspaceId: string): Promise<void> {
    const { error } = await supabase
      .from('workspaces')
      .delete()
      .eq('id', workspaceId)

    if (error) throw error
  },

  /**
   * Get all members belonging to a workspace
   */
  async getWorkspaceMembers(workspaceId: string): Promise<WorkspaceMember[]> {
    const { data, error } = await supabase
      .from('workspace_members')
      .select(`
        id,
        workspace_id,
        user_id,
        role,
        created_at,
        profiles (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .eq('workspace_id', workspaceId)

    if (error) throw error

    return (data || []).map((item: any) => ({
      id: item.id,
      workspace_id: item.workspace_id,
      user_id: item.user_id,
      role: item.role,
      created_at: item.created_at,
      profile: item.profiles,
    }))
  },

  /**
   * Invite or add member by email
   */
  async addMemberByEmail(workspaceId: string, email: string, role: UserRole): Promise<WorkspaceMember> {
    // 1. Lookup user in profiles by email
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('id, full_name, avatar_url, email')
      .eq('email', email.trim().toLowerCase())
      .single()

    if (profileError || !profile) {
      throw new Error(`Pengguna dengan email "${email}" tidak ditemukan di MariFlow. Pastikan pengguna telah mendaftar.`)
    }

    // 2. Insert into workspace_members
    const { data, error } = await supabase
      .from('workspace_members')
      .insert({
        workspace_id: workspaceId,
        user_id: profile.id,
        role,
      })
      .select()
      .single()

    if (error) {
      if (error.code === '23505') {
        throw new Error('Pengguna ini sudah menjadi anggota di workspace ini.')
      }
      throw error
    }

    return {
      ...data,
      profile,
    }
  },

  /**
   * Update member role
   */
  async updateMemberRole(memberId: string, newRole: UserRole): Promise<void> {
    const { error } = await supabase
      .from('workspace_members')
      .update({ role: newRole })
      .eq('id', memberId)

    if (error) throw error
  },

  /**
   * Remove member from workspace
   */
  async removeMember(memberId: string): Promise<void> {
    const { error } = await supabase
      .from('workspace_members')
      .delete()
      .eq('id', memberId)

    if (error) throw error
  },
}
