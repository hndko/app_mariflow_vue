import type { NavigationGuardNext, RouteLocationNormalized } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useWorkspaceStore } from '@/stores/workspace'
import type { UserRole } from '@/types/database.types'

/**
 * ==============================================================================
 * CheckRoleMiddleware — Single Unified Role Authorization Guard
 * ==============================================================================
 * Memeriksa apakah role pengguna (Superadmin, Owner, Admin, Member, Viewer)
 * memiliki hak akses ke rute tujuan berdasarkan route.meta.allowedRoles.
 */
export async function CheckRoleMiddleware(
  to: RouteLocationNormalized,
  _from: RouteLocationNormalized,
  next: NavigationGuardNext
) {
  const allowedRoles = to.meta.allowedRoles as UserRole[] | undefined

  // Jika rute tidak membatasi role tertentu, izinkan navigasi
  if (!allowedRoles || allowedRoles.length === 0) {
    return next()
  }

  const authStore = useAuthStore()
  const workspaceStore = useWorkspaceStore()

  // 1. Superadmin selalu memiliki bypass akses global ke seluruh rute
  if (authStore.userRole === 'superadmin' || authStore.isSuperadmin) {
    return next()
  }

  // 2. Ambil role aktif pengguna pada workspace saat ini
  const currentRole: UserRole = workspaceStore.userRole || authStore.userRole || 'viewer'

  // 3. Verifikasi apakah currentRole termasuk dalam daftar allowedRoles
  if (!allowedRoles.includes(currentRole)) {
    console.warn(
      `[CheckRoleMiddleware] Akses ditolak ke "${to.path}" untuk role "${currentRole}". Diperlukan salah satu dari: [${allowedRoles.join(', ')}]`
    )
    // Alihkan ke Dashboard jika role tidak mencukupi
    return next({ name: 'Dashboard' })
  }

  next()
}
