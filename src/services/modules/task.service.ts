import { supabase } from '../supabase'
import type { Task, TaskStatus, TaskPriority, TaskComment, TaskAttachment } from '@/types/database.types'

export const taskService = {
  /**
   * Fetch all tasks for a workspace with optional project/status filters
   */
  async getTasks(workspaceId: string, projectId?: string, status?: TaskStatus): Promise<Task[]> {
    let query = supabase
      .from('tasks')
      .select(`
        *,
        assignee:assigned_to (
          id,
          full_name,
          avatar_url,
          email
        ),
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        ),
        project:project_id (
          id,
          name,
          status
        )
      `)
      .eq('workspace_id', workspaceId)
      .order('created_at', { ascending: false })

    if (projectId) {
      query = query.eq('project_id', projectId)
    }
    if (status) {
      query = query.eq('status', status)
    }

    const { data, error } = await query
    if (error) throw error
    return (data || []) as Task[]
  },

  /**
   * Create new task
   */
  async createTask(data: {
    project_id: string
    workspace_id: string
    title: string
    description?: string | null
    status?: TaskStatus
    priority?: TaskPriority
    assigned_to?: string | null
    created_by: string
    due_date?: string | null
  }): Promise<Task> {
    const { data: task, error } = await supabase
      .from('tasks')
      .insert({
        ...data,
        status: data.status || 'todo',
        priority: data.priority || 'medium',
      })
      .select(`
        *,
        assignee:assigned_to (
          id,
          full_name,
          avatar_url,
          email
        ),
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        ),
        project:project_id (
          id,
          name
        )
      `)
      .single()

    if (error) throw error
    return task as Task
  },

  /**
   * Update task fields
   */
  async updateTask(taskId: string, updates: Partial<Task>): Promise<Task> {
    const { data, error } = await supabase
      .from('tasks')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', taskId)
      .select(`
        *,
        assignee:assigned_to (
          id,
          full_name,
          avatar_url,
          email
        ),
        creator:created_by (
          id,
          full_name,
          avatar_url,
          email
        ),
        project:project_id (
          id,
          name
        )
      `)
      .single()

    if (error) throw error
    return data as Task
  },

  /**
   * Update task status (Optimized for drag & drop Kanban)
   */
  async updateTaskStatus(taskId: string, newStatus: TaskStatus): Promise<void> {
    const { error } = await supabase
      .from('tasks')
      .update({
        status: newStatus,
        updated_at: new Date().toISOString(),
      })
      .eq('id', taskId)

    if (error) throw error
  },

  /**
   * Delete task
   */
  async deleteTask(taskId: string): Promise<void> {
    const { error } = await supabase
      .from('tasks')
      .delete()
      .eq('id', taskId)

    if (error) throw error
  },

  // ==========================================
  // COMMENTS SECTION
  // ==========================================

  /**
   * Get comments for a task
   */
  async getTaskComments(taskId: string): Promise<TaskComment[]> {
    const { data, error } = await supabase
      .from('task_comments')
      .select(`
        *,
        user:user_id (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .eq('task_id', taskId)
      .order('created_at', { ascending: true })

    if (error) throw error
    return (data || []) as TaskComment[]
  },

  /**
   * Add comment to task
   */
  async addComment(taskId: string, userId: string, content: string): Promise<TaskComment> {
    const { data, error } = await supabase
      .from('task_comments')
      .insert({
        task_id: taskId,
        user_id: userId,
        content: content.trim(),
      })
      .select(`
        *,
        user:user_id (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .single()

    if (error) throw error
    return data as TaskComment
  },

  /**
   * Delete comment
   */
  async deleteComment(commentId: string): Promise<void> {
    const { error } = await supabase
      .from('task_comments')
      .delete()
      .eq('id', commentId)

    if (error) throw error
  },

  // ==========================================
  // ATTACHMENTS & STORAGE SECTION
  // ==========================================

  /**
   * Get attachments for a task
   */
  async getTaskAttachments(taskId: string): Promise<TaskAttachment[]> {
    const { data, error } = await supabase
      .from('task_attachments')
      .select(`
        *,
        uploader:uploaded_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .eq('task_id', taskId)
      .order('created_at', { ascending: false })

    if (error) throw error

    // Attach public URLs
    return (data || []).map((att: any) => {
      const { data: urlData } = supabase.storage
        .from('task-attachments')
        .getPublicUrl(att.file_path)

      return {
        ...att,
        public_url: urlData?.publicUrl || '',
      }
    })
  },

  /**
   * Upload file to Supabase Storage and register in task_attachments table
   */
  async uploadAttachment(
    taskId: string,
    file: File,
    uploadedBy: string,
    workspaceId: string
  ): Promise<TaskAttachment> {
    const fileExt = file.name.split('.').pop()
    const filePath = `${workspaceId}/${taskId}/${Date.now()}-${Math.random().toString(36).substring(2, 7)}.${fileExt}`

    // 1. Upload to Supabase Storage bucket 'task-attachments'
    const { error: uploadError } = await supabase.storage
      .from('task-attachments')
      .upload(filePath, file, {
        cacheControl: '3600',
        upsert: false,
      })

    if (uploadError) {
      console.warn('[Storage Upload] Storage bucket write failed (will register metadata):', uploadError)
    }

    // 2. Insert metadata record in PostgreSQL
    const { data, error } = await supabase
      .from('task_attachments')
      .insert({
        task_id: taskId,
        uploaded_by: uploadedBy,
        file_name: file.name,
        file_path: filePath,
        file_size: file.size,
        mime_type: file.type || 'application/octet-stream',
      })
      .select(`
        *,
        uploader:uploaded_by (
          id,
          full_name,
          avatar_url,
          email
        )
      `)
      .single()

    if (error) throw error

    const { data: urlData } = supabase.storage
      .from('task-attachments')
      .getPublicUrl(filePath)

    return {
      ...data,
      public_url: urlData?.publicUrl || '',
    }
  },

  /**
   * Delete attachment from Storage and DB
   */
  async deleteAttachment(attachmentId: string, filePath: string): Promise<void> {
    // Delete from Supabase Storage
    await supabase.storage.from('task-attachments').remove([filePath])

    // Delete record
    const { error } = await supabase
      .from('task_attachments')
      .delete()
      .eq('id', attachmentId)

    if (error) throw error
  },
}
