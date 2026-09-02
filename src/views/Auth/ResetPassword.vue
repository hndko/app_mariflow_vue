<template>
  <div class="flex flex-col flex-1 lg:w-1/2 w-full">
    <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto py-10">
      <div class="mb-6 text-center sm:text-left">
        <div class="flex items-center gap-2 mb-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-theme-xs">
            M
          </div>
          <span class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
        </div>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
          Atur Ulang Kata Sandi
        </h1>
        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
          Masukkan kata sandi baru Anda untuk akun ini.
        </p>
      </div>

      <form v-if="!success" @submit.prevent="handleUpdatePassword" class="space-y-4">
        <!-- New Password Input -->
        <BaseInput
          v-model="newPassword"
          label="Kata Sandi Baru"
          type="password"
          placeholder="Minimal 6 karakter"
          autocomplete="new-password"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
          </template>
        </BaseInput>

        <!-- Confirm Password Input -->
        <BaseInput
          v-model="confirmPassword"
          label="Konfirmasi Kata Sandi"
          type="password"
          placeholder="Ulangi kata sandi baru"
          autocomplete="new-password"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
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
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
            </template>
            Simpan Kata Sandi Baru
          </BaseButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '@/services/auth/auth.service'
import { getCustomErrorMessage } from '@/utils/errorHandler'
import { showToast } from '@/composables/useAlert'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseButton from '@/components/common/BaseButton.vue'

const router = useRouter()
const newPassword = ref('')
const confirmPassword = ref('')
const loading = ref(false)
const errorMessage = ref('')
const success = ref(false)

const handleUpdatePassword = async () => {
  if (newPassword.value.length < 6) {
    errorMessage.value = 'Kata sandi minimal 6 karakter demi keamanan akun Anda.'
    showToast.warning(errorMessage.value)
    return
  }
  if (newPassword.value !== confirmPassword.value) {
    errorMessage.value = 'Konfirmasi kata sandi tidak cocok dengan kata sandi baru.'
    showToast.warning(errorMessage.value)
    return
  }

  loading.value = true
  errorMessage.value = ''
  try {
    await authService.updatePassword(newPassword.value)
    success.value = true
    showToast.success('Kata sandi Anda berhasil diperbarui!')
    setTimeout(() => {
      router.push('/login')
    }, 2000)
  } catch (err: any) {
    errorMessage.value = getCustomErrorMessage(err, 'Gagal memperbarui kata sandi. Silakan coba kembali.')
    showToast.error(errorMessage.value)
  } finally {
    loading.value = false
  }
}
</script>
