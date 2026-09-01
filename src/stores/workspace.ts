import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { workspaceService } from '@/services/modules/workspace.service'
import { useAuthStore } from './auth'
import type { Workspace, WorkspaceMember, UserRole } from '@/types/database.types'

export const useWorkspaceStore = defineStore('workspace', () => {
  const workspaces = ref<Workspace[]>([])
  const currentWorkspace = ref<Workspace | null>(null)
  const members = ref<WorkspaceMember[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const currentWorkspaceId = computed(() => currentWorkspace.value?.id || '')
  const currentWorkspaceName = computed(() => currentWorkspace.value?.name || 'Pilih Workspace')

  const userRole = computed<UserRole>(() => {
    return currentWorkspace.value?.role || 'viewer'
  })

  const isOwner = computed(() => userRole.value === 'owner')
  const isAdmin = computed(() => userRole.value === 'owner' || userRole.value === 'admin')
  const canWrite = computed(() => userRole.value !== 'viewer')

  /**
   * Load user's workspaces
   */
  async function loadWorkspaces() {
    const authStore = useAuthStore()
    if (!authStore.user) {
      // Provide demo placeholder workspaces if not logged in
      if (workspaces.value.length === 0) {
        workspaces.value = [
          {
            id: 'ws-demo-01',
            name: 'Mari Partner Main Hub',
            slug: 'mari-partner-hub',
            description: 'Workspace utama tim pengembangan produk Mari Partner',
            owner_id: 'user-demo-1',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            role: 'owner',
          },
          {
            id: 'ws-demo-02',
            name: 'Client Projects & Marketing',
            slug: 'client-projects',
            description: 'Manajemen proyek klien dan kampanye pemasaran digital',
            owner_id: 'user-demo-2',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            role: 'admin',
          },
        ]
        if (!currentWorkspace.value) {
          currentWorkspace.value = workspaces.value[0]
        }
      }
      return
    }

    loading.value = true
    error.value = null
    try {
      const data = await workspaceService.getMyWorkspaces(authStore.user.id)
      workspaces.value = data
      if (data.length > 0) {
        // Restore previously selected workspace or pick first
        const savedId = localStorage.getItem('mariflow_active_ws_id')
        const found = data.find((w) => w.id === savedId)
        currentWorkspace.value = found || data[0]
        if (currentWorkspace.value) {
          localStorage.setItem('mariflow_active_ws_id', currentWorkspace.value.id)
        }
      } else {
        currentWorkspace.value = null
      }
    } catch (err: any) {
      console.error('[WorkspaceStore] Failed to load workspaces:', err)
      error.value = err.message || 'Gagal memuat daftar workspace'
    } finally {
      loading.value = false
    }
  }

  /**
   * Switch active workspace
   */
  function switchWorkspace(ws: Workspace) {
    currentWorkspace.value = ws
    localStorage.setItem('mariflow_active_ws_id', ws.id)
    loadMembers(ws.id)
  }

  /**
   * Create workspace
   */
  async function createWorkspace(name: string, description: string | null) {
    const authStore = useAuthStore()
    const ownerId = authStore.user?.id || 'demo-user'

    loading.value = true
    error.value = null
    try {
      let created: Workspace
      if (authStore.user) {
        created = await workspaceService.createWorkspace(name, description, ownerId)
      } else {
        // Local mockup creation
        created = {
          id: `ws-${Date.now()}`,
          name,
          slug: name.toLowerCase().replace(/[^a-z0-9]/g, '-'),
          description,
          owner_id: ownerId,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
          role: 'owner',
        }
      }

      workspaces.value.unshift(created)
      switchWorkspace(created)
      return created
    } catch (err: any) {
      error.value = err.message || 'Gagal membuat workspace baru'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Load members for active workspace
   */
  async function loadMembers(wsId?: string) {
    const targetWsId = wsId || currentWorkspace.value?.id
    if (!targetWsId) return

    const authStore = useAuthStore()
    if (!authStore.user) {
      // Demo members data
      members.value = [
        {
          id: 'mem-1',
          workspace_id: targetWsId,
          user_id: 'u-1',
          role: 'owner',
          created_at: new Date().toISOString(),
          profile: {
            id: 'u-1',
            full_name: 'Budi Santoso (Anda)',
            avatar_url: '/images/user/user-01.jpg',
            email: 'budi@maripartner.com',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          },
        },
        {
          id: 'mem-2',
          workspace_id: targetWsId,
          user_id: 'u-2',
          role: 'admin',
          created_at: new Date().toISOString(),
          profile: {
            id: 'u-2',
            full_name: 'Siti Rahma',
            avatar_url: '/images/user/user-02.jpg',
            email: 'siti@maripartner.com',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          },
        },
        {
          id: 'mem-3',
          workspace_id: targetWsId,
          user_id: 'u-3',
          role: 'member',
          created_at: new Date().toISOString(),
          profile: {
            id: 'u-3',
            full_name: 'Rian Pratama',
            avatar_url: '/images/user/user-03.jpg',
            email: 'rian@maripartner.com',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          },
        },
      ]
      return
    }

    try {
      members.value = await workspaceService.getWorkspaceMembers(targetWsId)
    } catch (err: any) {
      console.warn('[WorkspaceStore] Failed to load members:', err)
    }
  }

  /**
   * Invite member by email
   */
  async function inviteMember(email: string, role: UserRole) {
    if (!currentWorkspace.value) return
    const authStore = useAuthStore()

    if (!authStore.user) {
      // Local mockup invite
      const newMember: WorkspaceMember = {
        id: `mem-${Date.now()}`,
        workspace_id: currentWorkspace.value.id,
        user_id: `u-${Date.now()}`,
        role,
        created_at: new Date().toISOString(),
        profile: {
          id: `u-${Date.now()}`,
          full_name: email.split('@')[0],
          avatar_url: '/images/user/user-04.jpg',
          email,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      }
      members.value.push(newMember)
      return newMember
    }

    const member = await workspaceService.addMemberByEmail(currentWorkspace.value.id, email, role)
    members.value.push(member)
    return member
  }

  /**
   * Update role
   */
  async function updateMemberRole(memberId: string, role: UserRole) {
    const authStore = useAuthStore()
    if (authStore.user) {
      await workspaceService.updateMemberRole(memberId, role)
    }
    const idx = members.value.findIndex((m) => m.id === memberId)
    if (idx !== -1) {
      members.value[idx].role = role
    }
  }

  /**
   * Remove member
   */
  async function removeMember(memberId: string) {
    const authStore = useAuthStore()
    if (authStore.user) {
      await workspaceService.removeMember(memberId)
    }
    members.value = members.value.filter((m) => m.id !== memberId)
  }

  return {
    workspaces,
    currentWorkspace,
    currentWorkspaceId,
    currentWorkspaceName,
    members,
    loading,
    error,
    userRole,
    isOwner,
    isAdmin,
    canWrite,
    loadWorkspaces,
    switchWorkspace,
    createWorkspace,
    loadMembers,
    inviteMember,
    updateMemberRole,
    removeMember,
  }
})
