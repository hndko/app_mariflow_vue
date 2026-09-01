import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes: RouteRecordRaw[] = [
  // Public Landing (Optional)
  {
    path: '/',
    name: 'Home',
    redirect: '/dashboard',
  },

  // Auth Routes (Guest Only)
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Auth/Login.vue'),
    meta: {
      title: 'Masuk Akun',
      layout: 'app-auth',
      guestOnly: true,
    },
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Auth/Register.vue'),
    meta: {
      title: 'Daftar Akun Baru',
      layout: 'app-auth',
      guestOnly: true,
    },
  },
  {
    path: '/forgot-password',
    name: 'ForgotPassword',
    component: () => import('@/views/Auth/ForgotPassword.vue'),
    meta: {
      title: 'Lupa Kata Sandi',
      layout: 'app-auth',
      guestOnly: true,
    },
  },
  {
    path: '/reset-password',
    name: 'ResetPassword',
    component: () => import('@/views/Auth/ResetPassword.vue'),
    meta: {
      title: 'Atur Ulang Kata Sandi',
      layout: 'app-auth',
    },
  },

  // Protected Module Routes
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/views/modules/dashboard/DashboardView.vue'),
    meta: {
      title: 'Dashboard Analytics',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/workspaces',
    name: 'Workspaces',
    component: () => import('@/views/modules/workspaces/WorkspaceListView.vue'),
    meta: {
      title: 'Daftar Workspace',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/projects',
    name: 'Projects',
    component: () => import('@/views/modules/projects/ProjectListView.vue'),
    meta: {
      title: 'Manajemen Proyek',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/tasks',
    name: 'Tasks',
    component: () => import('@/views/modules/tasks/TaskBoardView.vue'),
    meta: {
      title: 'Papan Tugas (Kanban)',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/members',
    name: 'Members',
    component: () => import('@/views/modules/members/MemberListView.vue'),
    meta: {
      title: 'Anggota Tim & Hak Akses',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/notifications',
    name: 'Notifications',
    component: () => import('@/views/modules/notifications/NotificationCenterView.vue'),
    meta: {
      title: 'Pusat Notifikasi',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/settings/profile',
    name: 'ProfileSettings',
    component: () => import('@/views/modules/settings/ProfileSettingsView.vue'),
    meta: {
      title: 'Pengaturan Profil',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },
  {
    path: '/supabase-lab',
    name: 'SupabaseLab',
    component: () => import('@/views/modules/supabase-lab/SupabaseLabView.vue'),
    meta: {
      title: 'Supabase Lab & Learning Center',
      layout: 'app-modules',
      requiresAuth: true,
    },
  },

  // 404 Catch-All
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/Errors/FourZeroFour.vue'),
    meta: {
      title: '404 Tidak Ditemukan',
      layout: 'app-auth',
    },
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  scrollBehavior(_to, _from, savedPosition) {
    return savedPosition || { left: 0, top: 0 }
  },
  routes,
})

// Navigation Guards for Authentication & Titles
router.beforeEach(async (to, _from, next) => {
  document.title = `${to.meta.title ? `${to.meta.title} | ` : ''}MariFlow SaaS — Simple Workspace & Task Management`

  const authStore = useAuthStore()

  // If initial auth check is not completed, initialize
  if (authStore.loading) {
    try {
      await authStore.initializeAuth()
    } catch (e) {
      console.warn('[Router] Auth check failed on navigation:', e)
    }
  }

  // Handle protected routes
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    // If not authenticated and trying to access protected route, allow guest / demo or redirect to login
    // In production with active Supabase credentials, redirect to /login
    // During local dev without active server session, let user navigate or prompt login
    if (!authStore.session && !localStorage.getItem('mariflow_guest_bypass')) {
      return next({ name: 'Login' })
    }
  }

  // Handle guest-only routes (redirect away if already logged in)
  if (to.meta.guestOnly && authStore.isAuthenticated) {
    return next({ name: 'Dashboard' })
  }

  next()
})

export default router
