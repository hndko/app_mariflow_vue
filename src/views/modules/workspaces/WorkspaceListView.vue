<template>
  <div class="space-y-6">
    <!-- Header Page -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Workspace Anda</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Kelola seluruh workspace tim, proyek, dan hak akses kolaborasi Anda.
        </p>
      </div>
      <BaseButton
        variant="primary"
        @click="openCreateModal"
      >
        <template #startIcon>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
        </template>
        Buat Workspace Baru
      </BaseButton>
    </div>

    <!-- Search and Filter Bar with Debounce -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-theme-xs">
      <div class="w-full sm:max-w-xs">
        <BaseInput
          v-model="searchQuery"
          placeholder="Cari nama workspace..."
        >
          <template #prefix>
            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </template>
        </BaseInput>
      </div>
      <div class="text-xs text-gray-500 dark:text-gray-400">
        Total: <span class="font-bold text-gray-800 dark:text-white">{{ filteredWorkspaces.length }}</span> Workspace
      </div>
    </div>

    <!-- Workspace Table with Auto-Numbering (#) -->
    <BaseTable
      :columns="columns"
      :data="filteredWorkspaces"
      :loading="workspaceStore.loading"
      :show-numbering="true"
      numbering-header="#"
      :show-actions="true"
      actions-header="Aksi"
      empty-text="Belum ada workspace"
      empty-description="Buat workspace pertama Anda untuk mulai mengelola proyek dan tim."
    >
      <!-- Custom Name & Slug Cell -->
      <template #cell-name="{ item }">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-brand-50 text-brand-600 font-bold text-base dark:bg-brand-500/15 dark:text-brand-400">
            {{ item.name.charAt(0).toUpperCase() }}
          </div>
          <div>
            <div class="flex items-center gap-2">
              <span class="font-semibold text-gray-900 dark:text-white">{{ item.name }}</span>
              <span
                v-if="item.id === workspaceStore.currentWorkspaceId"
                class="rounded-md bg-success-50 text-success-700 dark:bg-success-500/15 dark:text-success-400 px-1.5 py-0.5 text-[10px] font-bold"
              >
                Aktif
              </span>
            </div>
            <p class="text-xs text-gray-500 dark:text-gray-400 line-clamp-1">
              {{ item.description || 'Tidak ada deskripsi' }}
            </p>
          </div>
        </div>
      </template>

      <!-- Role Badge Cell -->
      <template #cell-role="{ item }">
        <BaseBadge
          :variant="item.role === 'owner' ? 'primary' : item.role === 'admin' ? 'info' : 'gray'"
          :text="formatRole(item.role)"
        />
      </template>

      <!-- Created At Cell -->
      <template #cell-created_at="{ item }">
        <span class="text-xs text-gray-500 dark:text-gray-400">
          {{ formatDate(item.created_at) }}
        </span>
      </template>

      <!-- Table Action Buttons (Icon Only with accessible Title) -->
      <template #actions="{ item }">
        <!-- Switch to Workspace -->
        <BaseButton
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Beralih ke Workspace ini"
          @click="selectWorkspace(item)"
        >
          <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
          </svg>
        </BaseButton>

        <!-- Edit Workspace -->
        <BaseButton
          v-if="item.role === 'owner' || item.role === 'admin'"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Edit Workspace"
          @click="openEditModal(item)"
        >
          <svg class="w-4 h-4 text-gray-600 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
          </svg>
        </BaseButton>

        <!-- Delete Workspace (Owner Only) -->
        <BaseButton
          v-if="item.role === 'owner'"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Hapus Workspace"
          @click="confirmDelete(item)"
        >
          <svg class="w-4 h-4 text-error-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
        </BaseButton>
      </template>

      <template #emptyAction>
        <BaseButton variant="primary" size="sm" @click="openCreateModal">
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          Buat Workspace Sekarang
        </BaseButton>
      </template>
    </BaseTable>

    <!-- Create / Edit Modal -->
    <BaseModal
      :is-open="isModalOpen"
      :title="editingId ? 'Edit Workspace' : 'Buat Workspace Baru'"
      @close="isModalOpen = false"
    >
      <form @submit.prevent="handleSaveWorkspace" class="space-y-4">
        <BaseInput
          v-model="formName"
          label="Nama Workspace"
          placeholder="contoh: PT Maju Bersama / Tim Desain"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </template>
        </BaseInput>

        <BaseTextarea
          v-model="formDescription"
          label="Deskripsi Workspace"
          placeholder="Tuliskan tujuan atau keterangan workspace ini..."
          :rows="3"
        />

        <div v-if="modalError" class="text-xs text-error-500">
          {{ modalError }}
        </div>
      </form>

      <template #footer>
        <BaseButton variant="outline" @click="isModalOpen = false">
          Batal
        </BaseButton>
        <BaseButton
          variant="primary"
          :loading="submitting"
          @click="handleSaveWorkspace"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </template>
          {{ editingId ? 'Simpan Perubahan' : 'Buat Workspace' }}
        </BaseButton>
      </template>
    </BaseModal>

    <!-- Delete Confirmation Modal -->
    <BaseModal
      :is-open="isDeleteModalOpen"
      title="Hapus Workspace"
      max-width="sm"
      @close="isDeleteModalOpen = false"
    >
      <div class="space-y-3">
        <p class="text-sm text-gray-600 dark:text-gray-300">
          Apakah Anda yakin ingin menghapus workspace <strong>{{ targetDeleteWs?.name }}</strong>? Seluruh data proyek, tugas, dan lampiran di dalamnya akan dihapus secara permanen.
        </p>
      </div>

      <template #footer>
        <BaseButton variant="outline" size="sm" @click="isDeleteModalOpen = false">
          Batal
        </BaseButton>
        <BaseButton
          variant="danger"
          size="sm"
          :loading="deleting"
          @click="handleDeleteWorkspace"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </template>
          Hapus Permanen
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useWorkspaceStore } from '@/stores/workspace'
import { useDebounce } from '@/composables/useDebounce'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseTextarea from '@/components/common/BaseTextarea.vue'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import type { Workspace } from '@/types/database.types'

const router = useRouter()
const workspaceStore = useWorkspaceStore()

const searchQuery = ref('')
const debouncedSearch = useDebounce(searchQuery, 300)

const isModalOpen = ref(false)
const editingId = ref<string | null>(null)
const formName = ref('')
const formDescription = ref('')
const submitting = ref(false)
const modalError = ref('')

const isDeleteModalOpen = ref(false)
const targetDeleteWs = ref<Workspace | null>(null)
const deleting = ref(false)

const columns: TableColumn[] = [
  { key: 'name', label: 'Nama Workspace' },
  { key: 'role', label: 'Peran Anda', align: 'center', class: 'w-32' },
  { key: 'created_at', label: 'Dibuat Pada', class: 'w-36' },
]

onMounted(async () => {
  await workspaceStore.loadWorkspaces()
})

const filteredWorkspaces = computed(() => {
  if (!debouncedSearch.value) return workspaceStore.workspaces
  const q = debouncedSearch.value.toLowerCase()
  return workspaceStore.workspaces.filter(
    (w) => w.name.toLowerCase().includes(q) || (w.description && w.description.toLowerCase().includes(q))
  )
})

const formatRole = (role?: string) => {
  if (role === 'owner') return 'Pemilik (Owner)'
  if (role === 'admin') return 'Admin'
  if (role === 'member') return 'Anggota'
  return 'Pengamat (Viewer)'
}

const formatDate = (isoStr: string) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}

const selectWorkspace = (ws: Workspace) => {
  workspaceStore.switchWorkspace(ws)
  router.push('/dashboard')
}

const openCreateModal = () => {
  editingId.value = null
  formName.value = ''
  formDescription.value = ''
  modalError.value = ''
  isModalOpen.value = true
}

const openEditModal = (ws: Workspace) => {
  editingId.value = ws.id
  formName.value = ws.name
  formDescription.value = ws.description || ''
  modalError.value = ''
  isModalOpen.value = true
}

const handleSaveWorkspace = async () => {
  if (!formName.value) {
    modalError.value = 'Nama workspace wajib diisi.'
    return
  }

  submitting.value = true
  modalError.value = ''
  try {
    if (editingId.value) {
      // Edit
      const idx = workspaceStore.workspaces.findIndex((w) => w.id === editingId.value)
      if (idx !== -1) {
        workspaceStore.workspaces[idx].name = formName.value
        workspaceStore.workspaces[idx].description = formDescription.value
      }
    } else {
      // Create
      await workspaceStore.createWorkspace(formName.value, formDescription.value)
    }
    isModalOpen.value = false
  } catch (err: any) {
    modalError.value = err.message || 'Gagal menyimpan workspace.'
  } finally {
    submitting.value = false
  }
}

const confirmDelete = (ws: Workspace) => {
  targetDeleteWs.value = ws
  isDeleteModalOpen.value = true
}

const handleDeleteWorkspace = async () => {
  if (!targetDeleteWs.value) return
  deleting.value = true
  try {
    workspaceStore.workspaces = workspaceStore.workspaces.filter((w) => w.id !== targetDeleteWs.value?.id)
    isDeleteModalOpen.value = false
  } catch (err: any) {
    console.error('Delete error:', err)
  } finally {
    deleting.value = false
  }
}
</script>
