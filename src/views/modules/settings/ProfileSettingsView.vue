<template>
  <div class="space-y-6">
    <!-- Header Page Breadcrumb / Title -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Pengaturan Profil</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Perbarui informasi akun, foto profil, dan kredensial keamanan Anda.
        </p>
      </div>
      <div class="flex items-center gap-3">
        <BaseButton
          variant="primary"
          :loading="saving"
          @click="saveProfile"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </template>
          Simpan Perubahan
        </BaseButton>
      </div>
    </div>

    <!-- Alert Notifications -->
    <div
      v-if="successMessage"
      class="p-4 rounded-xl bg-success-50 dark:bg-success-500/10 border border-success-200 dark:border-success-800 text-sm text-success-700 dark:text-success-400 flex items-center justify-between"
    >
      <span>{{ successMessage }}</span>
      <button type="button" @click="successMessage = ''" class="font-bold">×</button>
    </div>

    <div
      v-if="errorMessage"
      class="p-4 rounded-xl bg-error-50 dark:bg-error-500/10 border border-error-200 dark:border-error-800 text-sm text-error-700 dark:text-error-400 flex items-center justify-between"
    >
      <span>{{ errorMessage }}</span>
      <button type="button" @click="errorMessage = ''" class="font-bold">×</button>
    </div>

    <!-- Profile Grid Layout -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
      <!-- Left Column: Avatar & Summary -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 dark:border-gray-800 dark:bg-gray-900 shadow-theme-xs space-y-6">
        <div class="flex flex-col items-center text-center">
          <div class="relative h-28 w-28 overflow-hidden rounded-full border-4 border-white shadow-md dark:border-gray-800 bg-gray-100 dark:bg-gray-800 mb-4">
            <img
              :src="previewAvatar || authStore.userAvatar"
              alt="Avatar"
              class="h-full w-full object-cover"
            />
          </div>
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">
            {{ authStore.userName }}
          </h2>
          <p class="text-xs text-gray-500 dark:text-gray-400">
            {{ authStore.userEmail }}
          </p>
          <div class="mt-3">
            <BaseBadge variant="primary" text="Aktif" dot />
          </div>
        </div>

        <!-- Avatar Upload Section using Drag & Drop -->
        <div class="border-t border-gray-100 pt-5 dark:border-gray-800">
          <label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Unggah Foto Profil Baru
          </label>
          <BaseDropzone
            v-model="avatarFileList"
            :multiple="false"
            :max-size-mb="2"
            accepted-mime-types="image/png,image/jpeg,image/webp"
            accepted-types-label="PNG, JPG, WebP"
            hint-text="Maks. 2MB (Drag & Drop foto)"
            @file-added="onAvatarAdded"
            @file-removed="onAvatarRemoved"
          />
        </div>
      </div>

      <!-- Right Column: Personal Information & Password -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Personal Information Card -->
        <div class="rounded-xl border border-gray-200 bg-white p-6 dark:border-gray-800 dark:bg-gray-900 shadow-theme-xs space-y-5">
          <h3 class="text-base font-semibold text-gray-900 dark:text-white">
            Informasi Pribadi
          </h3>

          <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <!-- Full Name Input -->
            <div class="sm:col-span-2">
              <BaseInput
                v-model="fullName"
                label="Nama Lengkap"
                placeholder="Masukkan nama lengkap Anda"
                required
              >
                <template #prefix>
                  <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </template>
              </BaseInput>
            </div>

            <!-- Email (Readonly) -->
            <div class="sm:col-span-2">
              <BaseInput
                :model-value="authStore.userEmail"
                label="Alamat Email (Akun Utama)"
                type="email"
                placeholder="email@domain.com"
                readonly
                disabled
                hint="Alamat email terikat dengan akun Supabase Auth Anda."
              >
                <template #prefix>
                  <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
                  </svg>
                </template>
              </BaseInput>
            </div>
          </div>
        </div>

        <!-- Security & Password Card -->
        <div class="rounded-xl border border-gray-200 bg-white p-6 dark:border-gray-800 dark:bg-gray-900 shadow-theme-xs space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-base font-semibold text-gray-900 dark:text-white">
                Keamanan & Kata Sandi
              </h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                Pastikan akun Anda menggunakan kata sandi yang kuat dan unik.
              </p>
            </div>
            <BaseButton
              variant="outline"
              size="sm"
              @click="isChangePasswordModalOpen = true"
            >
              <template #startIcon>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                </svg>
              </template>
              Ubah Kata Sandi
            </BaseButton>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Ubah Kata Sandi -->
    <BaseModal
      :is-open="isChangePasswordModalOpen"
      title="Ubah Kata Sandi Akun"
      @close="isChangePasswordModalOpen = false"
    >
      <form @submit.prevent="handleChangePassword" class="space-y-4">
        <BaseInput
          v-model="newPassword"
          label="Kata Sandi Baru"
          type="password"
          placeholder="Minimal 6 karakter"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="confirmNewPassword"
          label="Konfirmasi Kata Sandi Baru"
          type="password"
          placeholder="Ulangi kata sandi baru"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </template>
        </BaseInput>

        <div v-if="passwordError" class="text-xs text-error-500">
          {{ passwordError }}
        </div>
      </form>

      <template #footer>
        <BaseButton
          variant="outline"
          @click="isChangePasswordModalOpen = false"
        >
          Batal
        </BaseButton>
        <BaseButton
          variant="primary"
          :loading="updatingPassword"
          @click="handleChangePassword"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </template>
          Simpan Kata Sandi
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { authService } from '@/services/auth/auth.service'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseDropzone, { type UploadFileItem } from '@/components/common/BaseDropzone.vue'
import BaseModal from '@/components/common/BaseModal.vue'

const authStore = useAuthStore()

const fullName = ref('')
const previewAvatar = ref('')
const avatarFileList = ref<UploadFileItem[]>([])
const saving = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

// Change Password State
const isChangePasswordModalOpen = ref(false)
const newPassword = ref('')
const confirmNewPassword = ref('')
const updatingPassword = ref(false)
const passwordError = ref('')

onMounted(() => {
  if (authStore.profile) {
    fullName.value = authStore.profile.full_name || ''
    previewAvatar.value = authStore.profile.avatar_url || ''
  }
})

const onAvatarAdded = (item: UploadFileItem) => {
  if (item.previewUrl) {
    previewAvatar.value = item.previewUrl
  }
}

const onAvatarRemoved = () => {
  previewAvatar.value = authStore.profile?.avatar_url || ''
}

const saveProfile = async () => {
  saving.value = true
  successMessage.value = ''
  errorMessage.value = ''
  try {
    let uploadedAvatarUrl = previewAvatar.value

    // If a new avatar file was picked, in a full Supabase storage scenario we upload to bucket 'avatars'
    if (avatarFileList.value.length > 0 && avatarFileList.value[0].rawFile) {
      // If mock/local, keep object preview or public URL
      uploadedAvatarUrl = previewAvatar.value
    }

    await authStore.updateProfile({
      full_name: fullName.value,
      avatar_url: uploadedAvatarUrl || null,
    })

    successMessage.value = 'Profil Anda berhasil diperbarui!'
  } catch (err: any) {
    errorMessage.value = err.message || 'Gagal menyimpan pembaruan profil.'
  } finally {
    saving.value = false
  }
}

const handleChangePassword = async () => {
  if (newPassword.value.length < 6) {
    passwordError.value = 'Kata sandi minimal 6 karakter.'
    return
  }
  if (newPassword.value !== confirmNewPassword.value) {
    passwordError.value = 'Konfirmasi kata sandi baru tidak cocok.'
    return
  }

  updatingPassword.value = true
  passwordError.value = ''
  try {
    await authService.updatePassword(newPassword.value)
    isChangePasswordModalOpen.value = false
    newPassword.value = ''
    confirmNewPassword.value = ''
    successMessage.value = 'Kata sandi berhasil diperbarui.'
  } catch (err: any) {
    passwordError.value = err.message || 'Gagal memperbarui kata sandi.'
  } finally {
    updatingPassword.value = false
  }
}
</script>
