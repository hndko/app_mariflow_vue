<template>
  <div class="space-y-6">
    <!-- Header Page -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Daftar Proyek</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Kelola inisiatif dan milestone proyek di workspace <strong>{{ workspaceStore.currentWorkspaceName }}</strong>.
        </p>
      </div>
      <BaseButton
        v-if="workspaceStore.canWrite"
        variant="primary"
        @click="openCreateModal"
      >
        <template #startIcon>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
        </template>
        Tambah Proyek Baru
      </BaseButton>
    </div>

    <!-- Filter & Search Bar with Debounce -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-theme-xs">
      <div class="flex flex-col sm:flex-row items-center gap-3 w-full sm:w-auto">
        <!-- Search Input -->
        <div class="w-full sm:w-64">
          <BaseInput
            v-model="searchQuery"
            placeholder="Cari nama proyek..."
          >
            <template #prefix>
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>
        </div>

        <!-- Status Filter -->
        <div class="w-full sm:w-44">
          <BaseSelect
            v-model="statusFilter"
            placeholder="Semua Status"
            :options="statusFilterOptions"
          />
        </div>
      </div>

      <div class="text-xs text-gray-500 dark:text-gray-400">
        Menampilkan: <span class="font-bold text-gray-800 dark:text-white">{{ filteredProjects.length }}</span> Proyek
      </div>
    </div>

    <!-- Projects Table with Auto-Numbering (#) -->
    <BaseTable
      :columns="columns"
      :data="filteredProjects"
      :loading="projectStore.loading"
      :show-numbering="true"
      numbering-header="#"
      :show-actions="workspaceStore.canWrite"
      actions-header="Aksi"
      empty-text="Belum ada proyek"
      empty-description="Buat proyek pertama Anda untuk mulai mengatur tugas dan kolaborasi tim."
    >
      <!-- Name & Description Cell -->
      <template #cell-name="{ item }">
        <div>
          <span class="font-semibold text-gray-900 dark:text-white block">{{ item.name }}</span>
          <span class="text-xs text-gray-500 dark:text-gray-400 line-clamp-1">
            {{ item.description || 'Tidak ada deskripsi' }}
          </span>
        </div>
      </template>

      <!-- Status Cell -->
      <template #cell-status="{ item }">
        <BaseBadge
          :variant="getStatusBadgeVariant(item.status)"
          :text="formatStatus(item.status)"
          dot
        />
      </template>

      <!-- Due Date Cell -->
      <template #cell-due_date="{ item }">
        <span class="text-xs text-gray-600 dark:text-gray-300">
          {{ formatDate(item.due_date) }}
        </span>
      </template>

      <!-- Creator Cell -->
      <template #cell-creator="{ item }">
        <div class="flex items-center gap-2">
          <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-800">
            <img :src="item.creator?.avatar_url || '/images/user/user-01.jpg'" alt="Creator" class="h-full w-full object-cover" />
          </div>
          <span class="text-xs text-gray-700 dark:text-gray-300">
            {{ item.creator?.full_name || 'User' }}
          </span>
        </div>
      </template>

      <!-- Table Actions (Icon Only) -->
      <template #actions="{ item }">
        <!-- Edit Project -->
        <BaseButton
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Edit Proyek"
          @click="openEditModal(item)"
        >
          <svg class="w-4 h-4 text-gray-600 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
          </svg>
        </BaseButton>

        <!-- Delete Project (Admin/Owner only) -->
        <BaseButton
          v-if="workspaceStore.isAdmin"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Hapus Proyek"
          @click="confirmDelete(item)"
        >
          <svg class="w-4 h-4 text-error-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
        </BaseButton>
      </template>

      <template #emptyAction>
        <BaseButton v-if="workspaceStore.canWrite" variant="primary" size="sm" @click="openCreateModal">
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          Buat Proyek Pertama
        </BaseButton>
      </template>
    </BaseTable>

    <!-- Create / Edit Modal -->
    <BaseModal
      :is-open="isModalOpen"
      :title="editingId ? 'Edit Proyek' : 'Tambah Proyek Baru'"
      @close="isModalOpen = false"
    >
      <form @submit.prevent="handleSaveProject" class="space-y-4">
        <BaseInput
          v-model="formName"
          label="Nama Proyek"
          placeholder="contoh: Redesain Aplikasi Mobile"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
            </svg>
          </template>
        </BaseInput>

        <BaseTextarea
          v-model="formDescription"
          label="Deskripsi Proyek"
          placeholder="Tuliskan gambaran umum dan target proyek ini..."
          :rows="3"
        />

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <BaseSelect
            v-model="formStatus"
            label="Status Proyek"
            :options="statusOptions"
            required
          />

          <BaseInput
            v-model="formDueDate"
            label="Tenggat Waktu (Due Date)"
            type="date"
            placeholder="YYYY-MM-DD"
          />
        </div>

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
          @click="handleSaveProject"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </template>
          {{ editingId ? 'Simpan Perubahan' : 'Buat Proyek' }}
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useProjectStore } from '@/stores/project'
import { useWorkspaceStore } from '@/stores/workspace'
import { useDebounce } from '@/composables/useDebounce'
import { showToast, showConfirm } from '@/composables/useAlert'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseSelect from '@/components/common/BaseSelect.vue'
import BaseTextarea from '@/components/common/BaseTextarea.vue'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import type { Project, ProjectStatus } from '@/types/database.types'

const projectStore = useProjectStore()
const workspaceStore = useWorkspaceStore()

const searchQuery = ref('')
const debouncedSearch = useDebounce(searchQuery, 300)
const statusFilter = ref('')

const isModalOpen = ref(false)
const editingId = ref<string | null>(null)
const formName = ref('')
const formDescription = ref('')
const formStatus = ref<ProjectStatus>('active')
const formDueDate = ref('')
const submitting = ref(false)
const modalError = ref('')

const statusOptions = [
  { value: 'planning', label: 'Perencanaan (Planning)' },
  { value: 'active', label: 'Aktif (Active)' },
  { value: 'completed', label: 'Selesai (Completed)' },
  { value: 'archived', label: 'Diarsipkan (Archived)' },
]

const statusFilterOptions = [
  { value: '', label: 'Semua Status' },
  { value: 'planning', label: 'Perencanaan' },
  { value: 'active', label: 'Aktif' },
  { value: 'completed', label: 'Selesai' },
  { value: 'archived', label: 'Diarsipkan' },
]

const columns: TableColumn[] = [
  { key: 'name', label: 'Nama Proyek' },
  { key: 'status', label: 'Status', align: 'center', class: 'w-32' },
  { key: 'due_date', label: 'Tenggat', class: 'w-32' },
  { key: 'creator', label: 'Dibuat Oleh', class: 'w-36' },
]

onMounted(async () => {
  await projectStore.loadProjects()
})

watch(
  () => workspaceStore.currentWorkspaceId,
  async () => {
    await projectStore.loadProjects()
  }
)

const filteredProjects = computed(() => {
  return projectStore.projects.filter((p) => {
    const matchSearch =
      !debouncedSearch.value ||
      p.name.toLowerCase().includes(debouncedSearch.value.toLowerCase()) ||
      (p.description && p.description.toLowerCase().includes(debouncedSearch.value.toLowerCase()))

    const matchStatus = !statusFilter.value || p.status === statusFilter.value
    return matchSearch && matchStatus
  })
})

const getStatusBadgeVariant = (status: ProjectStatus) => {
  if (status === 'active') return 'primary'
  if (status === 'completed') return 'success'
  if (status === 'planning') return 'warning'
  return 'gray'
}

const formatStatus = (status: ProjectStatus) => {
  if (status === 'planning') return 'Planning'
  if (status === 'active') return 'Active'
  if (status === 'completed') return 'Completed'
  return 'Archived'
}

const formatDate = (isoStr: string | null) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}

const openCreateModal = () => {
  editingId.value = null
  formName.value = ''
  formDescription.value = ''
  formStatus.value = 'active'
  formDueDate.value = ''
  modalError.value = ''
  isModalOpen.value = true
}

const openEditModal = (project: Project) => {
  editingId.value = project.id
  formName.value = project.name
  formDescription.value = project.description || ''
  formStatus.value = project.status
  formDueDate.value = project.due_date || ''
  modalError.value = ''
  isModalOpen.value = true
}

const handleSaveProject = async () => {
  if (!formName.value) {
    modalError.value = 'Nama proyek wajib diisi.'
    return
  }

  submitting.value = true
  modalError.value = ''
  try {
    if (editingId.value) {
      await projectStore.updateProject(editingId.value, {
        name: formName.value,
        description: formDescription.value,
        status: formStatus.value,
        due_date: formDueDate.value || null,
      })
      showToast.success('Proyek berhasil diperbarui!')
    } else {
      await projectStore.createProject({
        name: formName.value,
        description: formDescription.value,
        status: formStatus.value,
        due_date: formDueDate.value || null,
      })
      showToast.success('Proyek baru berhasil dibuat!')
    }
    isModalOpen.value = false
  } catch (err: any) {
    modalError.value = err.message || 'Gagal menyimpan proyek.'
    showToast.error(modalError.value)
  } finally {
    submitting.value = false
  }
}

const confirmDelete = async (project: Project) => {
  const confirmed = await showConfirm({
    title: 'Hapus Proyek?',
    text: `Apakah Anda yakin ingin menghapus proyek "${project.name}"? Seluruh tugas kanban di dalam proyek ini akan ikut terhapus.`,
    confirmText: 'Ya, Hapus Proyek',
    cancelText: 'Batal',
    isDanger: true,
  })

  if (confirmed) {
    try {
      await projectStore.deleteProject(project.id)
      showToast.success(`Proyek "${project.name}" berhasil dihapus.`)
    } catch (err: any) {
      console.error('Delete project failed:', err)
      showToast.error('Gagal menghapus proyek.')
    }
  }
}
</script>
