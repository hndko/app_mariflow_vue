import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { projectService } from '@/services/modules/project.service'
import { useWorkspaceStore } from './workspace'
import { useAuthStore } from './auth'
import type { Project, ProjectStatus } from '@/types/database.types'

export const useProjectStore = defineStore('project', () => {
  const projects = ref<Project[]>([])
  const currentProject = ref<Project | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const activeProjectsCount = computed(() => projects.value.filter((p) => p.status === 'active').length)
  const planningProjectsCount = computed(() => projects.value.filter((p) => p.status === 'planning').length)
  const completedProjectsCount = computed(() => projects.value.filter((p) => p.status === 'completed').length)

  /**
   * Load projects for active workspace
   */
  async function loadProjects(status?: ProjectStatus) {
    const workspaceStore = useWorkspaceStore()
    const authStore = useAuthStore()

    if (!workspaceStore.currentWorkspaceId) return

    if (!authStore.user) {
      // Demo projects fallback
      if (projects.value.length === 0) {
        projects.value = [
          {
            id: 'proj-01',
            workspace_id: workspaceStore.currentWorkspaceId,
            name: 'Pembangunan Platform MariFlow v1.0',
            description: 'Pengembangan modul core workspace, task kanban, dan integrasi Supabase',
            status: 'active',
            start_date: '2026-09-01',
            due_date: '2026-10-15',
            created_by: 'user-1',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            creator: {
              id: 'user-1',
              full_name: 'Budi Santoso',
              avatar_url: '/images/user/user-01.jpg',
              email: 'budi@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
          },
          {
            id: 'proj-02',
            workspace_id: workspaceStore.currentWorkspaceId,
            name: 'Redesain Landing Page & Branding',
            description: 'Pembaruan visual identitas brand Mari Partner dan UI website marketing',
            status: 'planning',
            start_date: '2026-09-10',
            due_date: '2026-10-01',
            created_by: 'user-2',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            creator: {
              id: 'user-2',
              full_name: 'Siti Rahma',
              avatar_url: '/images/user/user-02.jpg',
              email: 'siti@maripartner.com',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
          },
        ]
      }
      return
    }

    loading.value = true
    error.value = null
    try {
      projects.value = await projectService.getProjects(workspaceStore.currentWorkspaceId, status)
    } catch (err: any) {
      console.error('[ProjectStore] Failed to load projects:', err)
      error.value = err.message || 'Gagal memuat daftar proyek'
    } finally {
      loading.value = false
    }
  }

  /**
   * Create new project
   */
  async function createProject(data: {
    name: string
    description?: string | null
    status?: ProjectStatus
    start_date?: string | null
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
      let created: Project
      if (authStore.user) {
        created = await projectService.createProject({
          workspace_id: workspaceStore.currentWorkspaceId,
          created_by: authStore.user.id,
          ...data,
        })
      } else {
        created = {
          id: `proj-${Date.now()}`,
          workspace_id: workspaceStore.currentWorkspaceId,
          created_by: 'demo-user',
          name: data.name,
          description: data.description || null,
          status: data.status || 'active',
          start_date: data.start_date || null,
          due_date: data.due_date || null,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
          creator: {
            id: 'demo-user',
            full_name: authStore.userName,
            avatar_url: authStore.userAvatar,
            email: authStore.userEmail,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          },
        }
      }

      projects.value.unshift(created)
      return created
    } catch (err: any) {
      error.value = err.message || 'Gagal membuat proyek baru'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Update project
   */
  async function updateProject(projectId: string, updates: Partial<Project>) {
    const authStore = useAuthStore()
    loading.value = true
    try {
      if (authStore.user) {
        const updated = await projectService.updateProject(projectId, updates)
        const idx = projects.value.findIndex((p) => p.id === projectId)
        if (idx !== -1) projects.value[idx] = updated
        return updated
      } else {
        const idx = projects.value.findIndex((p) => p.id === projectId)
        if (idx !== -1) {
          projects.value[idx] = { ...projects.value[idx], ...updates, updated_at: new Date().toISOString() }
        }
      }
    } catch (err: any) {
      error.value = err.message || 'Gagal memperbarui proyek'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Delete project
   */
  async function deleteProject(projectId: string) {
    const authStore = useAuthStore()
    if (authStore.user) {
      await projectService.deleteProject(projectId)
    }
    projects.value = projects.value.filter((p) => p.id !== projectId)
  }

  return {
    projects,
    currentProject,
    loading,
    error,
    activeProjectsCount,
    planningProjectsCount,
    completedProjectsCount,
    loadProjects,
    createProject,
    updateProject,
    deleteProject,
  }
})
