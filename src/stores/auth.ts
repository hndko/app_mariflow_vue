import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/services/supabase'
import { authService } from '@/services/auth/auth.service'
import type { Profile, UserRole } from '@/types/database.types'
import type { User, Session } from '@supabase/supabase-js'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const session = ref<Session | null>(null)
  const profile = ref<Profile | null>(null)
  const loading = ref<boolean>(true)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => !!user.value)
  const isSuperadmin = computed(() => profile.value?.role === 'superadmin')
  const userRole = computed<UserRole>(() => profile.value?.role || 'owner')
  const userName = computed(() => profile.value?.full_name || user.value?.user_metadata?.full_name || user.value?.email?.split('@')[0] || 'User')
  const userAvatar = computed(() => profile.value?.avatar_url || '/images/user/user-01.jpg')
  const userEmail = computed(() => user.value?.email || '')

  /**
   * Initialize authentication status on application boot
   */
  async function initializeAuth() {
    loading.value = true
    error.value = null
    try {
      const activeSession = await authService.getSession()
      session.value = activeSession
      user.value = activeSession?.user ?? null

      if (user.value) {
        await loadProfile(user.value.id)
      }
    } catch (err: any) {
      console.error('[AuthStore] Initialization failed:', err)
      error.value = err.message || 'Gagal memuat sesi pengguna'
    } finally {
      loading.value = false
    }

    // Listen to Supabase Auth state changes
    supabase.auth.onAuthStateChange(async (_event, newSession) => {
      session.value = newSession
      user.value = newSession?.user ?? null
      if (user.value) {
        await loadProfile(user.value.id)
      } else {
        profile.value = null
      }
    })
  }

  /**
   * Load user profile details
   */
  async function loadProfile(userId: string) {
    try {
      const data = await authService.getProfile(userId)
      if (data) {
        profile.value = data
      } else if (user.value) {
        // Create initial fallback profile object
        profile.value = {
          id: userId,
          email: user.value.email || '',
          full_name: user.value.user_metadata?.full_name || '',
          avatar_url: null,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        }
      }
    } catch (err: any) {
      console.warn('[AuthStore] Failed to load profile:', err)
    }
  }

  /**
   * Register new user
   */
  async function register(email: string, password: string, fullName: string) {
    loading.value = true
    error.value = null
    try {
      const data = await authService.signUp(email, password, fullName)
      user.value = data.user
      session.value = data.session
      if (data.user) {
        await loadProfile(data.user.id)
      }
      return data
    } catch (err: any) {
      error.value = err.message || 'Gagal melakukan pendaftaran'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Sign in existing user
   */
  async function login(email: string, password: string) {
    loading.value = true
    error.value = null
    try {
      const data = await authService.signIn(email, password)
      user.value = data.user
      session.value = data.session
      if (data.user) {
        await loadProfile(data.user.id)
      }
      return data
    } catch (err: any) {
      error.value = err.message || 'Gagal masuk akun'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Sign out user
   */
  async function logout() {
    loading.value = true
    try {
      await authService.signOut()
      user.value = null
      session.value = null
      profile.value = null
    } catch (err: any) {
      console.error('[AuthStore] Logout failed:', err)
    } finally {
      loading.value = false
    }
  }

  /**
   * Update Profile
   */
  async function updateProfile(updates: Partial<Profile>) {
    if (!user.value) return
    loading.value = true
    error.value = null
    try {
      const updated = await authService.updateProfile(user.value.id, updates)
      profile.value = updated
      return updated
    } catch (err: any) {
      error.value = err.message || 'Gagal memperbarui profil'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    user,
    session,
    profile,
    loading,
    error,
    isAuthenticated,
    isSuperadmin,
    userRole,
    userName,
    userAvatar,
    userEmail,
    initializeAuth,
    register,
    login,
    logout,
    updateProfile,
    loadProfile,
  }
})
