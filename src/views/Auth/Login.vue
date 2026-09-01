<template>
  <div class="flex flex-col flex-1 lg:w-1/2 w-full justify-center">
    <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
      <div class="mb-6 text-center sm:text-left">
        <div class="flex items-center gap-2 mb-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-theme-xs">
            M
          </div>
          <span class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
        </div>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
          Masuk ke Akun Anda
        </h1>
        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
          Kelola workspace dan produktivitas tim Anda dengan mudah.
        </p>
      </div>

      <!-- Error Message Alert -->
      <div
        v-if="errorMessage"
        class="mb-5 p-4 rounded-xl bg-error-50 dark:bg-error-500/10 border border-error-200 dark:border-error-800 text-sm text-error-700 dark:text-error-400 flex items-center justify-between"
      >
        <div class="flex items-center gap-2">
          <svg class="w-5 h-5 shrink-0 text-error-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span>{{ errorMessage }}</span>
        </div>
        <button type="button" @click="errorMessage = ''" class="text-error-500 hover:text-error-700 font-bold ml-2">×</button>
      </div>

      <!-- Form Login -->
      <form @submit.prevent="handleLogin" class="space-y-4">
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

        <!-- Password Input with Icon Group & Placeholder -->
        <div>
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
                class="cursor-pointer text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
                @click="showPassword = !showPassword"
              >
                <svg v-if="!showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
                <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l18 18" />
                </svg>
              </button>
            </template>
          </BaseInput>
        </div>

        <!-- Remember Me & Forgot Password -->
        <div class="flex items-center justify-between text-sm">
          <label class="flex items-center gap-2 cursor-pointer select-none text-gray-600 dark:text-gray-400">
            <input
              type="checkbox"
              v-model="rememberMe"
              class="h-4 w-4 rounded border-gray-300 text-brand-500 focus:ring-brand-400 dark:border-gray-700 dark:bg-gray-800"
            />
            Ingat saya
          </label>
          <router-link
            to="/forgot-password"
            class="font-medium text-brand-500 hover:text-brand-600 dark:text-brand-400 transition"
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
            custom-class="w-full"
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
          class="font-semibold text-brand-500 hover:text-brand-600 dark:text-brand-400 ml-1"
        >
          Daftar Sekarang
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseButton from '@/components/common/BaseButton.vue'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  if (!email.value || !password.value) {
    errorMessage.value = 'Mohon lengkapi email dan kata sandi.'
    return
  }

  loading.value = true
  errorMessage.value = ''
  try {
    await authStore.login(email.value, password.value)
    router.push('/dashboard')
  } catch (err: any) {
    errorMessage.value = err.message || 'Email atau kata sandi tidak sesuai. Silakan coba lagi.'
  } finally {
    loading.value = false
  }
}
</script>
