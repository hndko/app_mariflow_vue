import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { notificationService } from '@/services/modules/notification.service'
import { useAuthStore } from './auth'
import type { AppNotification } from '@/types/database.types'
import type { RealtimeChannel } from '@supabase/supabase-js'

export const useNotificationStore = defineStore('notification', () => {
  const notifications = ref<AppNotification[]>([])
  const loading = ref(false)
  let realtimeChannel: RealtimeChannel | null = null

  const unreadCount = computed(() => notifications.value.filter((n) => !n.is_read).length)

  /**
   * Load notifications for current user
   */
  async function loadNotifications() {
    const authStore = useAuthStore()
    if (!authStore.user) {
      if (notifications.value.length === 0) {
        notifications.value = [
          {
            id: 'notif-01',
            user_id: 'demo-user',
            workspace_id: 'ws-demo-01',
            type: 'task_assigned',
            title: 'Tugas Baru Ditugaskan',
            message: 'Anda ditugaskan pada tugas "Implementasi Papan Kanban & Drag-and-Drop".',
            reference_type: 'task',
            reference_id: 'task-02',
            is_read: false,
            created_at: new Date(Date.now() - 3600000).toISOString(),
          },
          {
            id: 'notif-02',
            user_id: 'demo-user',
            workspace_id: 'ws-demo-01',
            type: 'comment',
            title: 'Komentar Baru',
            message: 'Siti Rahma menambahkan komentar pada tugas "Setup Database Supabase".',
            reference_type: 'task',
            reference_id: 'task-01',
            is_read: true,
            created_at: new Date(Date.now() - 86400000).toISOString(),
          },
        ]
      }
      return
    }

    loading.value = true
    try {
      notifications.value = await notificationService.getNotifications(authStore.user.id)
      setupRealtime(authStore.user.id)
    } catch (err) {
      console.warn('[NotificationStore] Failed to load notifications:', err)
    } finally {
      loading.value = false
    }
  }

  /**
   * Setup Realtime listener
   */
  function setupRealtime(userId: string) {
    if (realtimeChannel) {
      notificationService.unsubscribe(realtimeChannel)
    }

    realtimeChannel = notificationService.subscribeToNotifications(userId, (newNotif) => {
      notifications.value.unshift(newNotif)
    })
  }

  /**
   * Mark notification as read
   */
  async function markAsRead(notificationId: string) {
    const authStore = useAuthStore()
    const target = notifications.value.find((n) => n.id === notificationId)
    if (target) {
      target.is_read = true
    }

    if (authStore.user) {
      await notificationService.markAsRead(notificationId)
    }
  }

  /**
   * Mark all as read
   */
  async function markAllAsRead() {
    const authStore = useAuthStore()
    notifications.value.forEach((n) => (n.is_read = true))

    if (authStore.user) {
      await notificationService.markAllAsRead(authStore.user.id)
    }
  }

  /**
   * Cleanup channel
   */
  function cleanup() {
    if (realtimeChannel) {
      notificationService.unsubscribe(realtimeChannel)
      realtimeChannel = null
    }
  }

  return {
    notifications,
    loading,
    unreadCount,
    loadNotifications,
    markAsRead,
    markAllAsRead,
    cleanup,
  }
})
