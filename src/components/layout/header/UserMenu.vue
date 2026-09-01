<template>
  <div class="relative" ref="dropdownRef">
    <button
      class="flex items-center text-gray-700 dark:text-gray-400 cursor-pointer"
      @click.prevent="toggleDropdown"
    >
      <span class="mr-3 overflow-hidden rounded-full h-10 w-10 border border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-800">
        <img :src="authStore.userAvatar" alt="User" class="h-full w-full object-cover" />
      </span>

      <span class="block mr-1 font-semibold text-sm text-gray-800 dark:text-gray-200">
        {{ authStore.userName }}
      </span>

      <ChevronDownIcon :class="{ 'rotate-180': dropdownOpen }" />
    </button>

    <!-- Dropdown Start -->
    <div
      v-if="dropdownOpen"
      class="absolute right-0 mt-[17px] flex w-[260px] flex-col rounded-2xl border border-gray-200 bg-white p-3 shadow-theme-lg dark:border-gray-800 dark:bg-gray-900 z-99999"
    >
      <div class="px-3 py-2 border-b border-gray-100 dark:border-gray-800">
        <span class="block font-semibold text-gray-800 text-sm dark:text-white">
          {{ authStore.userName }}
        </span>
        <span class="mt-0.5 block text-xs text-gray-500 dark:text-gray-400 truncate">
          {{ authStore.userEmail }}
        </span>
      </div>

      <ul class="flex flex-col gap-1 pt-3 pb-2 border-b border-gray-100 dark:border-gray-800">
        <li>
          <router-link
            to="/settings/profile"
            @click="closeDropdown"
            class="flex items-center gap-3 px-3 py-2 text-xs font-medium text-gray-700 rounded-lg group hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-white/5"
          >
            <UserCircleIcon class="w-4 h-4 text-gray-500" />
            Pengaturan Profil
          </router-link>
        </li>
        <li>
          <router-link
            to="/workspaces"
            @click="closeDropdown"
            class="flex items-center gap-3 px-3 py-2 text-xs font-medium text-gray-700 rounded-lg group hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-white/5"
          >
            <SettingsIcon class="w-4 h-4 text-gray-500" />
            Kelola Workspace
          </router-link>
        </li>
        <li>
          <router-link
            to="/supabase-lab"
            @click="closeDropdown"
            class="flex items-center gap-3 px-3 py-2 text-xs font-medium text-gray-700 rounded-lg group hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-white/5"
          >
            <InfoCircleIcon class="w-4 h-4 text-gray-500" />
            Supabase Lab
          </router-link>
        </li>
      </ul>

      <button
        type="button"
        @click="handleLogout"
        class="flex items-center gap-3 px-3 py-2 mt-2 text-xs font-medium text-error-600 rounded-lg hover:bg-error-50 dark:hover:bg-error-500/10 transition cursor-pointer text-left w-full"
      >
        <LogoutIcon class="w-4 h-4 text-error-500" />
        Keluar (Sign out)
      </button>
    </div>
    <!-- Dropdown End -->
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { showToast, showConfirm } from '@/composables/useAlert'
import { UserCircleIcon, ChevronDownIcon, LogoutIcon, SettingsIcon, InfoCircleIcon } from '@/icons'

const router = useRouter()
const authStore = useAuthStore()

const dropdownOpen = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)

const toggleDropdown = () => {
  dropdownOpen.value = !dropdownOpen.value
}

const closeDropdown = () => {
  dropdownOpen.value = false
}

const handleLogout = async () => {
  closeDropdown()
  const confirmed = await showConfirm({
    title: 'Konfirmasi Keluar',
    text: 'Apakah Anda yakin ingin keluar dari akun MariFlow?',
    confirmText: 'Ya, Keluar',
    cancelText: 'Batal',
    isDanger: false,
  })

  if (confirmed) {
    await authStore.logout()
    showToast.info('Anda telah berhasil keluar dari akun.')
    router.push('/login')
  }
}

const handleClickOutside = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    closeDropdown()
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
