<template>
  <div class="relative" ref="dropdownRef">
    <button
      class="relative flex items-center justify-center text-gray-500 transition-colors bg-white border border-gray-200 rounded-full hover:text-dark-900 h-10 w-10 hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white cursor-pointer"
      @click="toggleDropdown"
      title="Notifikasi"
    >
      <span
        v-if="notificationStore.unreadCount > 0"
        class="absolute -top-1 -right-1 z-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-brand-500 px-1 text-[10px] font-bold text-white shadow-sm"
      >
        {{ notificationStore.unreadCount }}
      </span>

      <svg
        class="fill-current"
        width="18"
        height="18"
        viewBox="0 0 20 20"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M10.75 2.29248C10.75 1.87827 10.4143 1.54248 10 1.54248C9.58583 1.54248 9.25004 1.87827 9.25004 2.29248V2.83613C6.08266 3.20733 3.62504 5.9004 3.62504 9.16748V14.4591H3.33337C2.91916 14.4591 2.58337 14.7949 2.58337 15.2091C2.58337 15.6234 2.91916 15.9591 3.33337 15.9591H4.37504H15.625H16.6667C17.0809 15.9591 17.4167 15.6234 17.4167 15.2091C17.4167 14.7949 17.0809 14.4591 16.6667 14.4591H16.375V9.16748C16.375 5.9004 13.9174 3.20733 10.75 2.83613V2.29248ZM14.875 14.4591V9.16748C14.875 6.47509 12.6924 4.29248 10 4.29248C7.30765 4.29248 5.12504 6.47509 5.12504 9.16748V14.4591H14.875ZM8.00004 17.7085C8.00004 18.1228 8.33583 18.4585 8.75004 18.4585H11.25C11.6643 18.4585 12 18.1228 12 17.7085C12 17.2943 11.6643 16.9585 11.25 16.9585H8.75004C8.33583 16.9585 8.00004 17.2943 8.00004 17.7085Z"
        />
      </svg>
    </button>

    <!-- Dropdown Start -->
    <div
      v-if="dropdownOpen"
      class="absolute right-0 mt-[17px] flex h-[400px] w-[340px] flex-col rounded-2xl border border-gray-200 bg-white p-3 shadow-theme-lg dark:border-gray-800 dark:bg-gray-900 z-99999"
    >
      <div class="flex items-center justify-between pb-2 mb-2 border-b border-gray-100 dark:border-gray-800">
        <h5 class="text-sm font-bold text-gray-800 dark:text-white">
          Notifikasi ({{ notificationStore.unreadCount }} baru)
        </h5>

        <button
          v-if="notificationStore.unreadCount > 0"
          type="button"
          class="text-[11px] font-semibold text-brand-500 hover:underline"
          @click="notificationStore.markAllAsRead"
        >
          Tandai dibaca
        </button>
      </div>

      <ul class="flex flex-col h-auto overflow-y-auto custom-scrollbar divide-y divide-gray-100 dark:divide-gray-800">
        <li
          v-for="notif in notificationStore.notifications.slice(0, 5)"
          :key="notif.id"
          class="p-2.5 hover:bg-gray-50 dark:hover:bg-white/5 rounded-lg cursor-pointer transition"
          @click="handleNotificationClick(notif)"
        >
          <div class="flex items-start gap-2.5">
            <span
              :class="[
                'mt-1 h-2 w-2 rounded-full shrink-0',
                notif.is_read ? 'bg-transparent' : 'bg-brand-500',
              ]"
            ></span>
            <div class="min-w-0 flex-1">
              <p class="text-xs font-semibold text-gray-900 dark:text-white truncate">
                {{ notif.title }}
              </p>
              <p class="text-[11px] text-gray-500 dark:text-gray-400 line-clamp-2 mt-0.5">
                {{ notif.message }}
              </p>
            </div>
          </div>
        </li>

        <li v-if="notificationStore.notifications.length === 0" class="py-12 text-center text-xs text-gray-400">
          Tidak ada notifikasi
        </li>
      </ul>

      <router-link
        to="/notifications"
        class="mt-auto block text-center rounded-lg border border-gray-200 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-300 dark:hover:bg-gray-800"
        @click="closeDropdown"
      >
        Lihat Semua Notifikasi
      </router-link>
    </div>
    <!-- Dropdown End -->
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useNotificationStore } from '@/stores/notification'
import type { AppNotification } from '@/types/database.types'

const notificationStore = useNotificationStore()

const dropdownOpen = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)

const toggleDropdown = () => {
  dropdownOpen.value = !dropdownOpen.value
}

const closeDropdown = () => {
  dropdownOpen.value = false
}

const handleNotificationClick = async (notif: AppNotification) => {
  if (!notif.is_read) {
    await notificationStore.markAsRead(notif.id)
  }
}

const handleClickOutside = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    closeDropdown()
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
  notificationStore.loadNotifications()
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
