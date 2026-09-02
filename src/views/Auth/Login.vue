<template>
  <div class="w-full max-w-5xl mx-auto my-auto bg-white dark:bg-gray-900 rounded-2xl sm:rounded-3xl shadow-xl dark:shadow-2xl border border-gray-100 dark:border-gray-800/80 overflow-hidden grid grid-cols-1 lg:grid-cols-12 transition-colors duration-200">
    <!-- Left Card: Brand & Workflow Preview (2-Card Desktop / Stacks on Mobile) -->
    <div class="lg:col-span-5 bg-gradient-to-br from-brand-50/70 via-brand-50/30 to-white dark:from-brand-950/30 dark:via-gray-900 dark:to-gray-900 p-6 sm:p-8 lg:p-10 flex flex-col justify-between border-b lg:border-b-0 lg:border-r border-gray-100 dark:border-gray-800">
      <div>
        <!-- Brand Logo & Badge -->
        <div class="flex items-center justify-between mb-6 lg:mb-8">
          <div class="flex items-center gap-3">
            <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-md shadow-brand-500/20">
              M
            </div>
            <div>
              <span class="text-xl font-bold tracking-tight text-gray-900 dark:text-white block leading-tight">MariFlow</span>
              <span class="text-xs font-medium text-gray-500 dark:text-gray-400">Workspace & Task SaaS</span>
            </div>
          </div>
          <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-brand-100/80 text-brand-700 dark:bg-brand-500/10 dark:text-brand-400">
            <span class="w-1.5 h-1.5 rounded-full bg-brand-500 animate-pulse"></span>
            v1.0 Ready
          </span>
        </div>

        <!-- Headline & Value Pitch -->
        <div class="space-y-2 mb-6">
          <h2 class="text-xl sm:text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            Kelola Proyek & Tugas Tim dengan Efisien
          </h2>
          <p class="text-sm text-gray-600 dark:text-gray-400 leading-relaxed">
            Platform kolaborasi modern dengan Kanban realtime, multi-workspace, analitik produktivitas, dan keamanan PostgreSQL RLS.
          </p>
        </div>

        <!-- Mini Interactive Preview Widget (Desktop Only) -->
        <div class="hidden sm:block p-4 rounded-xl bg-white dark:bg-gray-800/80 border border-gray-200/80 dark:border-gray-700/60 shadow-xs mb-6">
          <div class="flex items-center justify-between pb-3 border-b border-gray-100 dark:border-gray-700/50">
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-success-500"></span>
              <span class="text-xs font-semibold text-gray-700 dark:text-gray-200">MariFlow Kanban Hub</span>
            </div>
            <span class="text-[11px] font-medium px-2 py-0.5 rounded-md bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400">
              Sprint 01
            </span>
          </div>

          <div class="mt-3 space-y-2">
            <div class="p-2.5 rounded-lg bg-gray-50 dark:bg-gray-900/60 border border-gray-100 dark:border-gray-800 flex items-center justify-between">
              <div class="min-w-0 flex-1">
                <p class="text-xs font-medium text-gray-900 dark:text-gray-100 truncate">Implementasi Realtime Supabase</p>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-[10px] px-1.5 py-0.5 rounded bg-blue-100 dark:bg-blue-500/20 text-blue-700 dark:text-blue-300 font-medium">In Progress</span>
                  <span class="text-[10px] text-gray-400">85% Selesai</span>
                </div>
              </div>
              <div class="flex -space-x-1.5 ml-2">
                <span class="inline-flex h-6 w-6 items-center justify-center rounded-full bg-brand-500 text-[10px] font-bold text-white ring-2 ring-white dark:ring-gray-800">BS</span>
                <span class="inline-flex h-6 w-6 items-center justify-center rounded-full bg-emerald-500 text-[10px] font-bold text-white ring-2 ring-white dark:ring-gray-800">SR</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Demo Account Fillers -->
      <div class="pt-4 border-t border-gray-200/60 dark:border-gray-800/80">
        <p class="text-xs font-semibold text-gray-700 dark:text-gray-300 mb-2.5 flex items-center gap-1.5">
          <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
          Isi Cepat Akun Demo (1-Klik):
        </p>
        <div class="flex flex-wrap gap-1.5">
          <button
            v-for="acc in demoAccounts"
            :key="acc.role"
            type="button"
            @click="fillDemoAccount(acc)"
            class="px-2.5 py-1 text-xs rounded-lg font-medium border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 hover:border-brand-400 hover:text-brand-600 dark:hover:border-brand-500 dark:hover:text-brand-400 hover:bg-brand-50/50 dark:hover:bg-brand-500/10 transition-colors shadow-2xs cursor-pointer"
            :title="`Isi data ${acc.label}`"
          >
            {{ acc.label }}
          </button>
        </div>
      </div>
    </div>

    <!-- Right Card: Form Login (Reflows cleanly on mobile) -->
    <div class="lg:col-span-7 p-6 sm:p-8 lg:p-12 flex flex-col justify-center">
      <div class="w-full max-w-md mx-auto">
        <!-- Form Header -->
        <div class="mb-6 sm:mb-8 text-center sm:text-left">
          <h1 class="text-2xl sm:text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
            Masuk ke Akun
          </h1>
          <p class="mt-1.5 text-sm text-gray-500 dark:text-gray-400">
            Silakan masukkan kredensial Anda untuk melanjutkan ke dashboard.
          </p>
        </div>

        <!-- Form Login -->
        <form @submit.prevent="handleLogin" class="space-y-4 sm:space-y-5">
          <!-- Email Input with Icon Group & Placeholder -->
          <BaseInput
            v-model="email"
            label="Alamat Email"
            type="email"
            placeholder="nama@perusahaan.com"
            autocomplete="email"
            required
          >
            <template #prefix>
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
              </svg>
            </template>
          </BaseInput>

          <!-- Password Input with Lock Icon & Interactive Eye Toggle -->
          <BaseInput
            v-model="password"
            label="Kata Sandi"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Masukkan kata sandi akun Anda"
            autocomplete="current-password"
            required
          >
            <template #prefix>
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
            </template>
            <template #suffix>
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="p-1 rounded-md text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer"
                :title="showPassword ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi'"
                :aria-label="showPassword ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi'"
              >
                <!-- Eye Open (Show password) -->
                <svg v-if="!showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
                <!-- Eye Slash (Hide password) -->
                <svg v-else class="w-5 h-5 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l18 18" />
                </svg>
              </button>
            </template>
          </BaseInput>

          <!-- Remember Me & Forgot Password -->
          <div class="flex items-center justify-between text-sm pt-0.5">
            <label class="flex items-center gap-2 cursor-pointer select-none text-gray-600 dark:text-gray-400">
              <input
                type="checkbox"
                v-model="rememberMe"
                class="h-4 w-4 rounded border-gray-300 text-brand-500 focus:ring-brand-400 dark:border-gray-700 dark:bg-gray-800 cursor-pointer"
              />
              <span>Ingat saya</span>
            </label>
            <router-link
              to="/forgot-password"
              class="font-medium text-brand-500 hover:text-brand-600 dark:text-brand-400 transition-colors"
            >
              Lupa kata sandi?
            </router-link>
          </div>

          <!-- Submit Button (Icon + Text) -->
          <div class="pt-2">
            <BaseButton
              type="submit"
              variant="primary"
              size="lg"
              :loading="loading"
              custom-class="w-full justify-center shadow-md shadow-brand-500/20"
            >
              <template #startIcon>
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                </svg>
              </template>
              Masuk ke Aplikasi
            </BaseButton>
          </div>
        </form>

        <!-- Register Link -->
        <div class="mt-8 text-center text-sm text-gray-500 dark:text-gray-400">
          Belum memiliki akun?
          <router-link
            to="/register"
            class="font-semibold text-brand-500 hover:text-brand-600 dark:text-brand-400 ml-1 transition-colors"
          >
            Daftar Sekarang
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { showToast } from '@/composables/useAlert'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseButton from '@/components/common/BaseButton.vue'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)
const loading = ref(false)

const demoAccounts = [
  { role: 'superadmin', label: '👑 Superadmin', email: 'superadmin@example.com', pass: 'password' },
  { role: 'owner', label: '🏢 Owner', email: 'owner@example.com', pass: 'password' },
  { role: 'admin', label: '🛡️ Admin', email: 'admin@example.com', pass: 'password' },
  { role: 'member', label: '👤 Member', email: 'member@example.com', pass: 'password' },
  { role: 'viewer', label: '👁️ Viewer', email: 'viewer@example.com', pass: 'password' },
]

const fillDemoAccount = (acc: (typeof demoAccounts)[0]) => {
  email.value = acc.email
  password.value = acc.pass
  showToast.info(`Akun demo ${acc.label} terpasang pada formulir.`)
}

const handleLogin = async () => {
  if (!email.value.trim() || !password.value) {
    showToast.warning('Mohon masukkan alamat email dan kata sandi Anda.')
    return
  }

  loading.value = true
  try {
    await authStore.login(email.value.trim(), password.value)
    showToast.success('Selamat datang kembali di MariFlow!')
    router.push('/dashboard')
  } catch (err: any) {
    const msg = err.message || 'Email atau kata sandi tidak sesuai. Silakan coba lagi.'
    showToast.error(msg)
  } finally {
    loading.value = false
  }
}
</script>

