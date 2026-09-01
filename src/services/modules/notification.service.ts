import { supabase } from '../supabase'
import type { AppNotification } from '@/types/database.types'
import type { RealtimeChannel } from '@supabase/supabase-js'

export const notificationService = {
  /**
   * Fetch all notifications for a user
   */
  async getNotifications(userId: string): Promise<AppNotification[]> {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(30)

    if (error) throw error
    return (data || []) as AppNotification[]
  },

  /**
   * Mark single notification as read
   */
  async markAsRead(notificationId: string): Promise<void> {
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', notificationId)

    if (error) throw error
  },

  /**
   * Mark all notifications as read for a user
   */
  async markAllAsRead(userId: string): Promise<void> {
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('user_id', userId)
      .eq('is_read', false)

    if (error) throw error
  },

  /**
   * Subscribe to Realtime notifications for current user
   */
  subscribeToNotifications(
    userId: string,
    onInsert: (notification: AppNotification) => void
  ): RealtimeChannel {
    const channel = supabase
      .channel(`user-notifications-${userId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
          filter: `user_id=eq.${userId}`,
        },
        (payload) => {
          onInsert(payload.new as AppNotification)
        }
      )
      .subscribe()

    return channel
  },

  /**
   * Subscribe to Realtime tasks updates for a workspace
   */
  subscribeToWorkspaceTasks(
    workspaceId: string,
    onUpdate: (payload: any) => void
  ): RealtimeChannel {
    const channel = supabase
      .channel(`workspace-tasks-${workspaceId}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'tasks',
          filter: `workspace_id=eq.${workspaceId}`,
        },
        (payload) => {
          onUpdate(payload)
        }
      )
      .subscribe()

    return channel
  },

  /**
   * Cleanup Realtime channel
   */
  unsubscribe(channel: RealtimeChannel | null) {
    if (channel) {
      supabase.removeChannel(channel)
    }
  },
}
