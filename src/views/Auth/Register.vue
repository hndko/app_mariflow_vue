<template>
  <div class="flex flex-col flex-1 lg:w-1/2 w-full justify-center">
    <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto py-6">
      <div class="mb-5 text-center sm:text-left">
        <div class="flex items-center gap-2 mb-2">
          <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-theme-xs">
            M
          </div>
          <span class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
        </div>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
          Buat Akun Baru
        </h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Mulai kolaborasi tim Anda dalam hitungan detik.
        </p>
      </div>

      <!-- Registration Form -->
      <form @submit.prevent="handleRegister" class="space-y-3.5">
        <!-- Full Name Input -->
        <BaseInput
          v-model="fullName"
          label="Nama Lengkap"
          placeholder="contoh: Budi Santoso"
          autocomplete="name"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </template>
        </BaseInput>

        <!-- Email Input -->
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

        <!-- Password Input -->
        <BaseInput
          v-model="password"
          label="Kata Sandi (min. 6 karakter)"
          :type="showPassword ? 'text' : 'password'"
          placeholder="Buat kata sandi yang aman"
          autocomplete="new-password"
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
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
            </button>
          </template>
        </BaseInput>

        <!-- Terms and Conditions Checkbox -->
        <div class="flex items-start gap-2 pt-1 text-xs text-gray-600 dark:text-gray-400">
          <input
            id="terms"
            type="checkbox"
            v-model="agreeTerms"
            class="h-4 w-4 mt-0.5 rounded border-gray-300 text-brand-500 focus:ring-brand-400 dark:border-gray-700 dark:bg-gray-800"
            required
          />
          <label for="terms" class="cursor-pointer">
            Saya menyetujui <span class="text-brand-500 font-medium hover:underline">Syarat & Ketentuan</span> serta <span class="text-brand-500 font-medium hover:underline">Kebijakan Privasi</span> MariFlow.
          </label>
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
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
              </svg>
            </template>
            Daftar Akun Sekarang
          </BaseButton>
        </div>
      </form>

      <!-- Sign In Link -->
      <div class="mt-6 text-center text-sm text-gray-500 dark:text-gray-400">
        Sudah memiliki akun?
        <router-link
          to="/login"
          class="font-semibold text-brand-500 hover:text-brand-600 dark:text-brand-400 ml-1"
        >
          Masuk di Sini
        </router-link>
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

const fullName = ref('')
const email = ref('')
const password = ref('')
const agreeTerms = ref(false)
const showPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')

const handleRegister = async () => {
  if (!agreeTerms.value) {
    errorMessage.value = 'Anda harus menyetujui Syarat & Ketentuan terlebih dahulu.'
    showToast.warning(errorMessage.value)
    return
  }
  if (password.value.length < 6) {
    errorMessage.value = 'Kata sandi minimal 6 karakter.'
    showToast.warning(errorMessage.value)
    return
  }

  loading.value = true
  errorMessage.value = ''
  try {
    await authStore.register(email.value, password.value, fullName.value)
    showToast.success('Pendaftaran akun berhasil! Selamat datang di MariFlow.')
    router.push('/dashboard')
  } catch (err: any) {
    errorMessage.value = err.message || 'Gagal mendaftar. Silakan coba kembali.'
    showToast.error(errorMessage.value)
  } finally {
    loading.value = false
  }
}
</script>
