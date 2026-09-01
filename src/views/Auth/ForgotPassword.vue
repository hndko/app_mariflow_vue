<template>
  <div class="flex flex-col flex-1 lg:w-1/2 w-full">
    <div class="w-full max-w-md pt-10 mx-auto">
      <router-link
        to="/login"
        class="inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300 mb-6"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Kembali ke Halaman Masuk
      </router-link>
    </div>

    <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
      <div class="mb-6 text-center sm:text-left">
        <div class="flex items-center gap-2 mb-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-theme-xs">
            M
          </div>
          <span class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
        </div>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
          Lupa Kata Sandi?
        </h1>
        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
          Masukkan alamat email Anda untuk menerima tautan pemulihan kata sandi.
        </p>
      </div>

      <!-- Success Alert -->
      <div
        v-if="successMessage"
        class="mb-5 p-4 rounded-xl bg-success-50 dark:bg-success-500/10 border border-success-200 dark:border-success-800 text-sm text-success-700 dark:text-success-400"
      >
        {{ successMessage }}
      </div>

      <!-- Error Alert -->
      <div
        v-if="errorMessage"
        class="mb-5 p-4 rounded-xl bg-error-50 dark:bg-error-500/10 border border-error-200 dark:border-error-800 text-sm text-error-700 dark:text-error-400 flex items-center justify-between"
      >
        <span>{{ errorMessage }}</span>
        <button type="button" @click="errorMessage = ''" class="text-error-500 font-bold">×</button>
      </div>

      <form @submit.prevent="handleResetRequest" class="space-y-4">
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

        <!-- Submit Button -->
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
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </template>
            Kirim Tautan Reset
          </BaseButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { authService } from '@/services/auth/auth.service'
import { getCustomErrorMessage } from '@/utils/errorHandler'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseButton from '@/components/common/BaseButton.vue'

const email = ref('')
const loading = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

const handleResetRequest = async () => {
  if (!email.value) return
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  try {
    await authService.resetPasswordForEmail(email.value)
    successMessage.value = 'Instruksi pemulihan telah dikirim ke email Anda. Silakan periksa kotak masuk atau spam.'
  } catch (err: any) {
    errorMessage.value = getCustomErrorMessage(err, 'Gagal mengirim email reset kata sandi. Silakan periksa kembali email Anda.')
  } finally {
    loading.value = false
  }
}
</script>
