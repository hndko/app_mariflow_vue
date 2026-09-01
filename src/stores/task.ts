import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { taskService } from '@/services/modules/task.service'
import { useWorkspaceStore } from './workspace'
import { useAuthStore } from './auth'
import type { Task, TaskStatus, TaskPriority, TaskComment, TaskAttachment } from '@/types/database.types'

export const useTaskStore = defineStore('task', () => {
  const tasks = ref<Task[]>([])
  const activeTask = ref<Task | null>(null)
  const activeComments = ref<TaskComment[]>([])
  const activeAttachments = ref<TaskAttachment[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Kanban grouped columns
  const todoTasks = computed(() => tasks.value.filter((t) => t.status === 'todo'))
  const inProgressTasks = computed(() => tasks.value.filter((t) => t.status === 'in_progress'))
  const reviewTasks = computed(() => tasks.value.filter((t) => t.status === 'review'))
  const completedTasks = computed(() => tasks.value.filter((t) => t.status === 'completed'))

  /**
   * Load tasks for active workspace
   */
  async function loadTasks(projectId?: string) {
    const workspaceStore = useWorkspaceStore()
    const authStore = useAuthStore()

    if (!workspaceStore.currentWorkspaceId) return

    if (!authStore.user) {
      // Demo tasks fallback
      if (tasks.value.length === 0) {
        tasks.value = [
          {
            id: 'task-01',
            project_id: 'proj-01',
            workspace_id: workspaceStore.currentWorkspaceId,
            title: 'Setup Database Supabase & Row Level Security',
            description: 'Konfigurasi skema tabel PostgreSQL dan policy otorisasi multi-tenant.',
            status: 'completed',
            priority: 'urgent',
            assigned_to: 'user-1',
            created_by: 'user-1',
            due_date: '2026-09-05',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            assignee: {
              id: 'user-1',
              full_name: 'Budi Santoso',
              avatar_url: '/images/user/user-01.jpg',
              email: 'budi@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            project: { id: 'proj-01', name: 'Pembangunan Platform MariFlow', status: 'active' },
          },
          {
            id: 'task-02',
            project_id: 'proj-01',
            workspace_id: workspaceStore.currentWorkspaceId,
            title: 'Implementasi Papan Kanban & Drag-and-Drop',
            description: 'Membuat antarmuka Kanban board dengan kartu tugas interaktif dan status reaktif.',
            status: 'in_progress',
            priority: 'high',
            assigned_to: 'user-2',
            created_by: 'user-1',
            due_date: '2026-09-12',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            assignee: {
              id: 'user-2',
              full_name: 'Siti Rahma',
              avatar_url: '/images/user/user-02.jpg',
              email: 'siti@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            project: { id: 'proj-01', name: 'Pembangunan Platform MariFlow', status: 'active' },
          },
          {
            id: 'task-03',
            project_id: 'proj-01',
            workspace_id: workspaceStore.currentWorkspaceId,
            title: 'Audit Keamanan & Penanganan Debounce',
            description: 'Pemeriksaan sanitasi input form, validasi file upload, dan debouncing query search.',
            status: 'todo',
            priority: 'medium',
            assigned_to: 'user-3',
            created_by: 'user-1',
            due_date: '2026-09-20',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            assignee: {
              id: 'user-3',
              full_name: 'Rian Pratama',
              avatar_url: '/images/user/user-03.jpg',
              email: 'rian@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            project: { id: 'proj-01', name: 'Pembangunan Platform MariFlow', status: 'active' },
          },
          {
            id: 'task-04',
            project_id: 'proj-02',
            workspace_id: workspaceStore.currentWorkspaceId,
            title: 'Review Mockup Desain Dashboard Analytics',
            description: 'Evaluasi visual komponen ApexCharts dan KPI ringkasan tugas.',
            status: 'review',
            priority: 'low',
            assigned_to: 'user-1',
            created_by: 'user-2',
            due_date: '2026-09-15',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            assignee: {
              id: 'user-1',
              full_name: 'Budi Santoso',
              avatar_url: '/images/user/user-01.jpg',
              email: 'budi@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            project: { id: 'proj-02', name: 'Redesain Landing Page & Branding', status: 'planning' },
          },
        ]
      }
      return
    }

    loading.value = true
    error.value = null
    try {
      tasks.value = await taskService.getTasks(workspaceStore.currentWorkspaceId, projectId)
    } catch (err: any) {
      console.error('[TaskStore] Failed to load tasks:', err)
      error.value = err.message || 'Gagal memuat daftar tugas'
    } finally {
      loading.value = false
    }
  }

  /**
   * Create task
   */
  async function createTask(data: {
    project_id: string
    title: string
    description?: string | null
    priority?: TaskPriority
    assigned_to?: string | null
    due_date?: string | null
  }) {
    const workspaceStore = useWorkspaceStore()
    const authStore = useAuthStore()

    if (!workspaceStore.currentWorkspaceId) {
      throw new Error('Pilih workspace terlebih dahulu.')
    }

    loading.value = true
    error.value = null
    try {
      let created: Task
      if (authStore.user) {
        created = await taskService.createTask({
          workspace_id: workspaceStore.currentWorkspaceId,
          created_by: authStore.user.id,
          ...data,
        })
      } else {
        const assignedProfile = workspaceStore.members.find((m) => m.user_id === data.assigned_to)?.profile
        created = {
          id: `task-${Date.now()}`,
          workspace_id: workspaceStore.currentWorkspaceId,
          project_id: data.project_id,
          title: data.title,
          description: data.description || null,
          status: 'todo',
          priority: data.priority || 'medium',
          assigned_to: data.assigned_to || null,
          created_by: 'demo-user',
          due_date: data.due_date || null,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
          assignee: assignedProfile,
        }
      }

      tasks.value.unshift(created)
      return created
    } catch (err: any) {
      error.value = err.message || 'Gagal membuat tugas baru'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Update task status (Kanban drop handler)
   */
  async function updateStatus(taskId: string, newStatus: TaskStatus) {
    const taskIndex = tasks.value.findIndex((t) => t.id === taskId)
    if (taskIndex !== -1) {
      // Optimistic update
      tasks.value[taskIndex].status = newStatus
      tasks.value[taskIndex].updated_at = new Date().toISOString()
    }

    const authStore = useAuthStore()
    if (authStore.user) {
      try {
        await taskService.updateTaskStatus(taskId, newStatus)
      } catch (err) {
        console.error('[TaskStore] Failed to update task status in DB:', err)
      }
    }
  }

  /**
   * Update task details
   */
  async function updateTask(taskId: string, updates: Partial<Task>) {
    const authStore = useAuthStore()
    try {
      if (authStore.user) {
        const updated = await taskService.updateTask(taskId, updates)
        const idx = tasks.value.findIndex((t) => t.id === taskId)
        if (idx !== -1) tasks.value[idx] = updated
        if (activeTask.value && activeTask.value.id === taskId) {
          activeTask.value = updated
        }
        return updated
      } else {
        const idx = tasks.value.findIndex((t) => t.id === taskId)
        if (idx !== -1) {
          tasks.value[idx] = { ...tasks.value[idx], ...updates, updated_at: new Date().toISOString() }
          if (activeTask.value && activeTask.value.id === taskId) {
            activeTask.value = tasks.value[idx]
          }
        }
      }
    } catch (err: any) {
      error.value = err.message || 'Gagal memperbarui tugas'
      throw err
    }
  }

  /**
   * Delete task
   */
  async function deleteTask(taskId: string) {
    const authStore = useAuthStore()
    if (authStore.user) {
      await taskService.deleteTask(taskId)
    }
    tasks.value = tasks.value.filter((t) => t.id !== taskId)
    if (activeTask.value && activeTask.value.id === taskId) {
      activeTask.value = null
    }
  }

  /**
   * Load task detail with comments & attachments
   */
  async function openTaskDetails(task: Task) {
    activeTask.value = task
    activeComments.value = []
    activeAttachments.value = []

    const authStore = useAuthStore()
    if (authStore.user) {
      try {
        const [cmts, atts] = await Promise.all([
          taskService.getTaskComments(task.id),
          taskService.getTaskAttachments(task.id),
        ])
        activeComments.value = cmts
        activeAttachments.value = atts
      } catch (err) {
        console.warn('[TaskStore] Failed to load comments/attachments:', err)
      }
    }
  }

  /**
   * Add comment to active task
   */
  async function addComment(content: string) {
    if (!activeTask.value || !content.trim()) return
    const authStore = useAuthStore()

    if (authStore.user) {
      const newComment = await taskService.addComment(activeTask.value.id, authStore.user.id, content)
      activeComments.value.push(newComment)
    } else {
      activeComments.value.push({
        id: `cmt-${Date.now()}`,
        task_id: activeTask.value.id,
        user_id: 'demo-user',
        content,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
        user: {
          id: 'demo-user',
          full_name: authStore.userName,
          avatar_url: authStore.userAvatar,
          email: authStore.userEmail,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      })
    }
  }

  /**
   * Upload attachment to active task
   */
  async function uploadAttachment(file: File) {
    if (!activeTask.value) return
    const authStore = useAuthStore()
    const workspaceStore = useWorkspaceStore()

    if (authStore.user) {
      const att = await taskService.uploadAttachment(
        activeTask.value.id,
        file,
        authStore.user.id,
        workspaceStore.currentWorkspaceId
      )
      activeAttachments.value.unshift(att)
    } else {
      const previewUrl = file.type.startsWith('image/') ? URL.createObjectURL(file) : undefined
      activeAttachments.value.unshift({
        id: `att-${Date.now()}`,
        task_id: activeTask.value.id,
        uploaded_by: 'demo-user',
        file_name: file.name,
        file_path: `local/${file.name}`,
        file_size: file.size,
        mime_type: file.type,
        created_at: new Date().toISOString(),
        public_url: previewUrl,
      })
    }
  }

  /**
   * Delete attachment
   */
  async function deleteAttachment(attachmentId: string, filePath: string) {
    const authStore = useAuthStore()
    if (authStore.user) {
      await taskService.deleteAttachment(attachmentId, filePath)
    }
    activeAttachments.value = activeAttachments.value.filter((a) => a.id !== attachmentId)
  }

  return {
    tasks,
    activeTask,
    activeComments,
    activeAttachments,
    loading,
    error,
    todoTasks,
    inProgressTasks,
    reviewTasks,
    completedTasks,
    loadTasks,
    createTask,
    updateStatus,
    updateTask,
    deleteTask,
    openTaskDetails,
    addComment,
    uploadAttachment,
    deleteAttachment,
  }
})
