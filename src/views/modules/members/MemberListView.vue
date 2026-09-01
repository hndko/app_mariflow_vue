<template>
  <div class="space-y-6">
    <!-- Header Page -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Anggota Tim</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Kelola kolaborator dan hak akses di workspace <strong>{{ workspaceStore.currentWorkspaceName }}</strong>.
        </p>
      </div>
      <BaseButton
        v-if="workspaceStore.isAdmin"
        variant="primary"
        @click="openInviteModal"
      >
        <template #startIcon>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
          </svg>
        </template>
        Undang Anggota Baru
      </BaseButton>
    </div>

    <!-- Alert Notifications -->
    <div
      v-if="feedbackMessage"
      class="p-4 rounded-xl bg-success-50 dark:bg-success-500/10 border border-success-200 dark:border-success-800 text-sm text-success-700 dark:text-success-400 flex items-center justify-between"
    >
      <span>{{ feedbackMessage }}</span>
      <button type="button" @click="feedbackMessage = ''" class="font-bold">×</button>
    </div>

    <!-- Filter & Search Bar with Debounce -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-theme-xs">
      <div class="w-full sm:max-w-xs">
        <BaseInput
          v-model="searchQuery"
          placeholder="Cari nama atau email anggota..."
        >
          <template #prefix>
            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </template>
        </BaseInput>
      </div>
      <div class="text-xs text-gray-500 dark:text-gray-400">
        Total Anggota: <span class="font-bold text-gray-800 dark:text-white">{{ filteredMembers.length }}</span> Orang
      </div>
    </div>

    <!-- Members Table with Auto-Numbering (#) -->
    <BaseTable
      :columns="columns"
      :data="filteredMembers"
      :loading="loading"
      :show-numbering="true"
      numbering-header="#"
      :show-actions="workspaceStore.isAdmin"
      actions-header="Aksi"
      empty-text="Belum ada anggota"
      empty-description="Undang anggota tim pertama Anda untuk mulai berkolaborasi."
    >
      <!-- User Profile & Name Cell -->
      <template #cell-user="{ item }">
        <div class="flex items-center gap-3">
          <div class="h-10 w-10 shrink-0 overflow-hidden rounded-full border border-gray-200 bg-gray-100 dark:border-gray-700 dark:bg-gray-800">
            <img
              :src="item.profile?.avatar_url || '/images/user/user-01.jpg'"
              :alt="item.profile?.full_name || 'User'"
              class="h-full w-full object-cover"
            />
          </div>
          <div>
            <span class="block font-semibold text-gray-900 dark:text-white">
              {{ item.profile?.full_name || 'Anggota Tim' }}
            </span>
            <span class="block text-xs text-gray-500 dark:text-gray-400">
              {{ item.profile?.email || '-' }}
            </span>
          </div>
        </div>
      </template>

      <!-- Role Cell -->
      <template #cell-role="{ item }">
        <BaseBadge
          :variant="getRoleBadgeVariant(item.role)"
          :text="formatRole(item.role)"
        />
      </template>

      <!-- Joined At Cell -->
      <template #cell-created_at="{ item }">
        <span class="text-xs text-gray-500 dark:text-gray-400">
          {{ formatDate(item.created_at) }}
        </span>
      </template>

      <!-- Actions Column (Icon Only) -->
      <template #actions="{ item }">
        <!-- Edit Role (cannot edit owner) -->
        <BaseButton
          v-if="item.role !== 'owner'"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Ubah Peran / Hak Akses"
          @click="openChangeRoleModal(item)"
        >
          <svg class="w-4 h-4 text-gray-600 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
          </svg>
        </BaseButton>

        <!-- Remove Member -->
        <BaseButton
          v-if="item.role !== 'owner'"
          variant="outline"
          size="icon-sm"
          :is-icon-only="true"
          title="Keluarkan dari Workspace"
          @click="confirmRemove(item)"
        >
          <svg class="w-4 h-4 text-error-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
        </BaseButton>
      </template>
    </BaseTable>

    <!-- Invite Member Modal -->
    <BaseModal
      :is-open="isInviteModalOpen"
      title="Undang Anggota ke Workspace"
      @close="isInviteModalOpen = false"
    >
      <form @submit.prevent="handleInviteMember" class="space-y-4">
        <!-- Email Input with Icon Group & Placeholder -->
        <BaseInput
          v-model="inviteEmail"
          label="Alamat Email Pengguna"
          type="email"
          placeholder="contoh: kolega@perusahaan.com"
          hint="Pengguna harus sudah terdaftar di aplikasi MariFlow."
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
            </svg>
          </template>
        </BaseInput>

        <!-- Role Select with Icon Group & Placeholder -->
        <BaseSelect
          v-model="inviteRole"
          label="Peran / Tingkat Akses"
          placeholder="Pilih tingkat akses..."
          :options="roleOptions"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </template>
        </BaseSelect>

        <div v-if="inviteError" class="text-xs text-error-500">
          {{ inviteError }}
        </div>
      </form>

      <template #footer>
        <BaseButton variant="outline" @click="isInviteModalOpen = false">
          Batal
        </BaseButton>
        <BaseButton
          variant="primary"
          :loading="inviting"
          @click="handleInviteMember"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
            </svg>
          </template>
          Kirim Undangan
        </BaseButton>
      </template>
    </BaseModal>

    <!-- Change Role Modal -->
    <BaseModal
      :is-open="isChangeRoleModalOpen"
      title="Ubah Peran Anggota"
      @close="isChangeRoleModalOpen = false"
    >
      <div class="space-y-4">
        <p class="text-sm text-gray-600 dark:text-gray-400">
          Ubah hak akses untuk <strong>{{ selectedMember?.profile?.full_name || selectedMember?.profile?.email }}</strong>:
        </p>

        <BaseSelect
          v-model="updatedRole"
          label="Pilih Peran Baru"
          :options="roleOptions"
          required
        />
      </div>

      <template #footer>
        <BaseButton variant="outline" @click="isChangeRoleModalOpen = false">
          Batal
        </BaseButton>
        <BaseButton
          variant="primary"
          @click="handleUpdateRole"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </template>
          Simpan Peran
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useWorkspaceStore } from '@/stores/workspace'
import { useDebounce } from '@/composables/useDebounce'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseSelect from '@/components/common/BaseSelect.vue'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import type { WorkspaceMember, UserRole } from '@/types/database.types'

const workspaceStore = useWorkspaceStore()

const searchQuery = ref('')
const debouncedSearch = useDebounce(searchQuery, 300)
const loading = ref(false)
const feedbackMessage = ref('')

const isInviteModalOpen = ref(false)
const inviteEmail = ref('')
const inviteRole = ref<UserRole>('member')
const inviting = ref(false)
const inviteError = ref('')

const isChangeRoleModalOpen = ref(false)
const selectedMember = ref<WorkspaceMember | null>(null)
const updatedRole = ref<UserRole>('member')

const roleOptions = [
  { value: 'admin', label: 'Admin (Mengelola Anggota & Proyek)' },
  { value: 'member', label: 'Member (Membuat & Menyelesaikan Tugas)' },
  { value: 'viewer', label: 'Viewer (Hanya Melihat Data)' },
]

const columns: TableColumn[] = [
  { key: 'user', label: 'Pengguna' },
  { key: 'role', label: 'Peran / Hak Akses', align: 'center', class: 'w-36' },
  { key: 'created_at', label: 'Bergabung Pada', class: 'w-36' },
]

onMounted(async () => {
  loading.value = true
  await workspaceStore.loadMembers()
  loading.value = false
})

const filteredMembers = computed(() => {
  if (!debouncedSearch.value) return workspaceStore.members
  const q = debouncedSearch.value.toLowerCase()
  return workspaceStore.members.filter((m) => {
    const name = m.profile?.full_name?.toLowerCase() || ''
    const email = m.profile?.email?.toLowerCase() || ''
    return name.includes(q) || email.includes(q)
  })
})

const getRoleBadgeVariant = (role: string) => {
  if (role === 'owner') return 'primary'
  if (role === 'admin') return 'info'
  if (role === 'member') return 'success'
  return 'gray'
}

const formatRole = (role?: string) => {
  if (role === 'owner') return 'Owner'
  if (role === 'admin') return 'Admin'
  if (role === 'member') return 'Member'
  return 'Viewer'
}

const formatDate = (isoStr: string) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}

const openInviteModal = () => {
  inviteEmail.value = ''
  inviteRole.value = 'member'
  inviteError.value = ''
  isInviteModalOpen.value = true
}

const handleInviteMember = async () => {
  if (!inviteEmail.value) {
    inviteError.value = 'Email pengguna wajib diisi.'
    return
  }

  inviting.value = true
  inviteError.value = ''
  try {
    await workspaceStore.inviteMember(inviteEmail.value, inviteRole.value)
    isInviteModalOpen.value = false
    feedbackMessage.value = `Anggota baru (${inviteEmail.value}) berhasil ditambahkan ke workspace!`
  } catch (err: any) {
    inviteError.value = err.message || 'Gagal menambahkan anggota.'
  } finally {
    inviting.value = false
  }
}

const openChangeRoleModal = (member: WorkspaceMember) => {
  selectedMember.value = member
  updatedRole.value = member.role
  isChangeRoleModalOpen.value = true
}

const handleUpdateRole = async () => {
  if (!selectedMember.value) return
  await workspaceStore.updateMemberRole(selectedMember.value.id, updatedRole.value)
  isChangeRoleModalOpen.value = false
  feedbackMessage.value = 'Peran anggota berhasil diperbarui.'
}

const confirmRemove = async (member: WorkspaceMember) => {
  if (confirm(`Apakah Anda yakin ingin mengeluarkan ${member.profile?.full_name || member.profile?.email} dari workspace ini?`)) {
    await workspaceStore.removeMember(member.id)
    feedbackMessage.value = 'Anggota berhasil dikeluarkan dari workspace.'
  }
}
</script>
