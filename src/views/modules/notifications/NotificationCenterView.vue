<template>
  <div class="space-y-6">
    <!-- Header Page -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Pusat Notifikasi</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Pantau penugasan tugas, komentar baru, dan aktivitas penting di workspace Anda.
        </p>
      </div>
      <div class="flex items-center gap-3">
        <BaseButton
          v-if="notificationStore.unreadCount > 0"
          variant="outline"
          size="sm"
          @click="notificationStore.markAllAsRead"
        >
          <template #startIcon>
            <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7m-5-6l4 4L9 19" />
            </svg>
          </template>
          Tandai Semua Dibaca
        </BaseButton>
      </div>
    </div>

    <!-- Filter Tab Bar -->
    <div class="flex items-center gap-2 border-b border-gray-200 dark:border-gray-800 pb-3">
      <button
        type="button"
        :class="[
          'px-4 py-2 text-sm font-medium rounded-lg transition',
          activeTab === 'all'
            ? 'bg-brand-50 text-brand-600 dark:bg-brand-500/15 dark:text-brand-400 font-semibold'
            : 'text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white',
        ]"
        @click="activeTab = 'all'"
      >
        Semua ({{ notificationStore.notifications.length }})
      </button>
      <button
        type="button"
        :class="[
          'px-4 py-2 text-sm font-medium rounded-lg transition',
          activeTab === 'unread'
            ? 'bg-brand-50 text-brand-600 dark:bg-brand-500/15 dark:text-brand-400 font-semibold'
            : 'text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white',
        ]"
        @click="activeTab = 'unread'"
      >
        Belum Dibaca ({{ notificationStore.unreadCount }})
      </button>
    </div>

    <!-- Notification Table with Auto-Numbering (#) -->
    <BaseTable
      :columns="columns"
      :data="filteredNotifications"
      :loading="notificationStore.loading"
      :show-numbering="true"
      numbering-header="#"
      :show-actions="true"
      actions-header="Aksi"
      empty-text="Tidak ada notifikasi"
      empty-description="Seluruh pemberitahuan aktivitas baru akan muncul di sini."
    >
      <!-- Title & Message Cell -->
      <template #cell-title="{ item }">
        <div class="flex items-start gap-3 py-1">
          <div
            :class="[
              'mt-0.5 h-8 w-8 rounded-full flex items-center justify-center shrink-0 text-white',
              item.is_read ? 'bg-gray-300 dark:bg-gray-700' : 'bg-brand-500',
            ]"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
          </div>
          <div>
            <div class="flex items-center gap-2">
              <span :class="['text-sm font-semibold', item.is_read ? 'text-gray-600 dark:text-gray-300' : 'text-gray-900 dark:text-white font-bold']">
                {{ item.title }}
              </span>
              <span v-if="!item.is_read" class="h-2 w-2 rounded-full bg-brand-500"></span>
            </div>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
              {{ item.message }}
            </p>
          </div>
        </div>
      </template>

      <!-- Created At Cell -->
      <template #cell-created_at="{ item }">
        <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap">
          {{ formatDate(item.created_at) }}
        </span>
      </template>

      <!-- Table Action (Icon Only) -->
      <template #actions="{ item }">
        <BaseButton
          v-if="!item.is_read"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Tandai Sudah Dibaca"
          @click="notificationStore.markAsRead(item.id)"
        >
          <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </BaseButton>
      </template>
    </BaseTable>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useNotificationStore } from '@/stores/notification'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'
import BaseButton from '@/components/common/BaseButton.vue'

const notificationStore = useNotificationStore()
const activeTab = ref<'all' | 'unread'>('all')

const columns: TableColumn[] = [
  { key: 'title', label: 'Pemberitahuan' },
  { key: 'created_at', label: 'Waktu', class: 'w-40' },
]

onMounted(async () => {
  await notificationStore.loadNotifications()
})

onBeforeUnmount(() => {
  notificationStore.cleanup()
})

const filteredNotifications = computed(() => {
  if (activeTab.value === 'unread') {
    return notificationStore.notifications.filter((n) => !n.is_read)
  }
  return notificationStore.notifications
})

const formatDate = (isoStr: string) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleString('id-ID', {
    day: 'numeric',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
  })
}
</script>
