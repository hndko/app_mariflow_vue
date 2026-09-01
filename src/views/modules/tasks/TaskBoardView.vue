<template>
  <div class="space-y-6">
    <!-- Header Page -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Papan Tugas (Kanban)</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Visualisasikan progres kerja tim di workspace <strong>{{ workspaceStore.currentWorkspaceName }}</strong>.
        </p>
      </div>
      <div class="flex items-center gap-3">
        <BaseButton
          v-if="workspaceStore.canWrite"
          variant="primary"
          @click="openCreateTaskModal"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          Buat Tugas Baru
        </BaseButton>
      </div>
    </div>

    <!-- Filter & Search Bar with Debounce -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-theme-xs">
      <div class="flex flex-col sm:flex-row items-center gap-3 w-full sm:w-auto">
        <!-- Search Input -->
        <div class="w-full sm:w-64">
          <BaseInput
            v-model="searchQuery"
            placeholder="Cari judul tugas..."
          >
            <template #prefix>
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>
        </div>

        <!-- Project Filter -->
        <div class="w-full sm:w-56">
          <BaseSelect
            v-model="selectedProjectId"
            placeholder="Semua Proyek"
            :options="projectFilterOptions"
          />
        </div>
      </div>

      <div class="text-xs text-gray-500 dark:text-gray-400">
        Total Tugas: <span class="font-bold text-gray-800 dark:text-white">{{ filteredTasks.length }}</span>
      </div>
    </div>

    <!-- Kanban Board Grid (4 Columns) -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5 items-start">
      <!-- 1. TODO COLUMN -->
      <div
        class="bg-gray-100/75 dark:bg-gray-900/60 rounded-2xl p-4 border border-gray-200/80 dark:border-gray-800 flex flex-col min-h-[500px]"
        @dragover.prevent
        @drop="onDropTask($event, 'todo')"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-2">
            <span class="h-3 w-3 rounded-full bg-gray-400"></span>
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">To Do</h3>
            <span class="rounded-full bg-gray-200 dark:bg-gray-800 px-2 py-0.5 text-xs font-bold text-gray-600 dark:text-gray-400">
              {{ getColumnTasks('todo').length }}
            </span>
          </div>
        </div>

        <div class="space-y-3 flex-1">
          <div
            v-for="task in getColumnTasks('todo')"
            :key="task.id"
            draggable="true"
            @dragstart="onDragStart(task)"
            @click="openTaskDetailModal(task)"
            class="group cursor-pointer rounded-xl border border-gray-200 bg-white p-4 shadow-theme-xs transition-all hover:border-brand-400 hover:shadow-md dark:border-gray-800 dark:bg-gray-900"
          >
            <div class="flex items-center justify-between gap-2 mb-2">
              <span class="text-[11px] font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[140px]">
                {{ task.project?.name || 'Umum' }}
              </span>
              <BaseBadge :variant="getPriorityBadgeVariant(task.priority)" :text="task.priority" size="sm" />
            </div>

            <h4 class="font-semibold text-sm text-gray-900 dark:text-white line-clamp-2 mb-2">
              {{ task.title }}
            </h4>

            <p v-if="task.description" class="text-xs text-gray-500 dark:text-gray-400 line-clamp-2 mb-3">
              {{ task.description }}
            </p>

            <div class="flex items-center justify-between pt-2 border-t border-gray-100 dark:border-gray-800/80 text-xs text-gray-500">
              <div class="flex items-center gap-1.5 text-[11px]">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <span>{{ formatDate(task.due_date) }}</span>
              </div>
              <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700" :title="task.assignee?.full_name || 'Unassigned'">
                <img :src="task.assignee?.avatar_url || '/images/user/user-01.jpg'" alt="Assignee" class="h-full w-full object-cover" />
              </div>
            </div>
          </div>

          <div v-if="getColumnTasks('todo').length === 0" class="py-8 text-center text-xs text-gray-400 border border-dashed border-gray-300 dark:border-gray-800 rounded-xl">
            Tarik tugas ke sini
          </div>
        </div>
      </div>

      <!-- 2. IN PROGRESS COLUMN -->
      <div
        class="bg-gray-100/75 dark:bg-gray-900/60 rounded-2xl p-4 border border-gray-200/80 dark:border-gray-800 flex flex-col min-h-[500px]"
        @dragover.prevent
        @drop="onDropTask($event, 'in_progress')"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-2">
            <span class="h-3 w-3 rounded-full bg-brand-500"></span>
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">In Progress</h3>
            <span class="rounded-full bg-brand-100 dark:bg-brand-500/20 px-2 py-0.5 text-xs font-bold text-brand-600 dark:text-brand-400">
              {{ getColumnTasks('in_progress').length }}
            </span>
          </div>
        </div>

        <div class="space-y-3 flex-1">
          <div
            v-for="task in getColumnTasks('in_progress')"
            :key="task.id"
            draggable="true"
            @dragstart="onDragStart(task)"
            @click="openTaskDetailModal(task)"
            class="group cursor-pointer rounded-xl border border-gray-200 bg-white p-4 shadow-theme-xs transition-all hover:border-brand-400 hover:shadow-md dark:border-gray-800 dark:bg-gray-900"
          >
            <div class="flex items-center justify-between gap-2 mb-2">
              <span class="text-[11px] font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[140px]">
                {{ task.project?.name || 'Umum' }}
              </span>
              <BaseBadge :variant="getPriorityBadgeVariant(task.priority)" :text="task.priority" size="sm" />
            </div>

            <h4 class="font-semibold text-sm text-gray-900 dark:text-white line-clamp-2 mb-2">
              {{ task.title }}
            </h4>

            <p v-if="task.description" class="text-xs text-gray-500 dark:text-gray-400 line-clamp-2 mb-3">
              {{ task.description }}
            </p>

            <div class="flex items-center justify-between pt-2 border-t border-gray-100 dark:border-gray-800/80 text-xs text-gray-500">
              <div class="flex items-center gap-1.5 text-[11px]">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <span>{{ formatDate(task.due_date) }}</span>
              </div>
              <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700" :title="task.assignee?.full_name || 'Unassigned'">
                <img :src="task.assignee?.avatar_url || '/images/user/user-02.jpg'" alt="Assignee" class="h-full w-full object-cover" />
              </div>
            </div>
          </div>

          <div v-if="getColumnTasks('in_progress').length === 0" class="py-8 text-center text-xs text-gray-400 border border-dashed border-gray-300 dark:border-gray-800 rounded-xl">
            Tarik tugas ke sini
          </div>
        </div>
      </div>

      <!-- 3. REVIEW COLUMN -->
      <div
        class="bg-gray-100/75 dark:bg-gray-900/60 rounded-2xl p-4 border border-gray-200/80 dark:border-gray-800 flex flex-col min-h-[500px]"
        @dragover.prevent
        @drop="onDropTask($event, 'review')"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-2">
            <span class="h-3 w-3 rounded-full bg-warning-500"></span>
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">In Review</h3>
            <span class="rounded-full bg-warning-100 dark:bg-warning-500/20 px-2 py-0.5 text-xs font-bold text-warning-600 dark:text-warning-400">
              {{ getColumnTasks('review').length }}
            </span>
          </div>
        </div>

        <div class="space-y-3 flex-1">
          <div
            v-for="task in getColumnTasks('review')"
            :key="task.id"
            draggable="true"
            @dragstart="onDragStart(task)"
            @click="openTaskDetailModal(task)"
            class="group cursor-pointer rounded-xl border border-gray-200 bg-white p-4 shadow-theme-xs transition-all hover:border-brand-400 hover:shadow-md dark:border-gray-800 dark:bg-gray-900"
          >
            <div class="flex items-center justify-between gap-2 mb-2">
              <span class="text-[11px] font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[140px]">
                {{ task.project?.name || 'Umum' }}
              </span>
              <BaseBadge :variant="getPriorityBadgeVariant(task.priority)" :text="task.priority" size="sm" />
            </div>

            <h4 class="font-semibold text-sm text-gray-900 dark:text-white line-clamp-2 mb-2">
              {{ task.title }}
            </h4>

            <p v-if="task.description" class="text-xs text-gray-500 dark:text-gray-400 line-clamp-2 mb-3">
              {{ task.description }}
            </p>

            <div class="flex items-center justify-between pt-2 border-t border-gray-100 dark:border-gray-800/80 text-xs text-gray-500">
              <div class="flex items-center gap-1.5 text-[11px]">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <span>{{ formatDate(task.due_date) }}</span>
              </div>
              <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700" :title="task.assignee?.full_name || 'Unassigned'">
                <img :src="task.assignee?.avatar_url || '/images/user/user-03.jpg'" alt="Assignee" class="h-full w-full object-cover" />
              </div>
            </div>
          </div>

          <div v-if="getColumnTasks('review').length === 0" class="py-8 text-center text-xs text-gray-400 border border-dashed border-gray-300 dark:border-gray-800 rounded-xl">
            Tarik tugas ke sini
          </div>
        </div>
      </div>

      <!-- 4. COMPLETED COLUMN -->
      <div
        class="bg-gray-100/75 dark:bg-gray-900/60 rounded-2xl p-4 border border-gray-200/80 dark:border-gray-800 flex flex-col min-h-[500px]"
        @dragover.prevent
        @drop="onDropTask($event, 'completed')"
      >
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-2">
            <span class="h-3 w-3 rounded-full bg-success-500"></span>
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Completed</h3>
            <span class="rounded-full bg-success-100 dark:bg-success-500/20 px-2 py-0.5 text-xs font-bold text-success-600 dark:text-success-400">
              {{ getColumnTasks('completed').length }}
            </span>
          </div>
        </div>

        <div class="space-y-3 flex-1">
          <div
            v-for="task in getColumnTasks('completed')"
            :key="task.id"
            draggable="true"
            @dragstart="onDragStart(task)"
            @click="openTaskDetailModal(task)"
            class="group cursor-pointer rounded-xl border border-gray-200 bg-white p-4 shadow-theme-xs transition-all hover:border-brand-400 hover:shadow-md dark:border-gray-800 dark:bg-gray-900 opacity-90"
          >
            <div class="flex items-center justify-between gap-2 mb-2">
              <span class="text-[11px] font-semibold text-brand-600 dark:text-brand-400 truncate max-w-[140px]">
                {{ task.project?.name || 'Umum' }}
              </span>
              <BaseBadge variant="success" text="Selesai" size="sm" />
            </div>

            <h4 class="font-semibold text-sm text-gray-900 dark:text-white line-clamp-2 line-through text-gray-500 mb-2">
              {{ task.title }}
            </h4>

            <div class="flex items-center justify-between pt-2 border-t border-gray-100 dark:border-gray-800/80 text-xs text-gray-500">
              <div class="flex items-center gap-1.5 text-[11px]">
                <svg class="w-3.5 h-3.5 text-success-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <span>Selesai</span>
              </div>
              <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700" :title="task.assignee?.full_name || 'Unassigned'">
                <img :src="task.assignee?.avatar_url || '/images/user/user-01.jpg'" alt="Assignee" class="h-full w-full object-cover" />
              </div>
            </div>
          </div>

          <div v-if="getColumnTasks('completed').length === 0" class="py-8 text-center text-xs text-gray-400 border border-dashed border-gray-300 dark:border-gray-800 rounded-xl">
            Tarik tugas ke sini
          </div>
        </div>
      </div>
    </div>

    <!-- Create Task Modal -->
    <BaseModal
      :is-open="isCreateModalOpen"
      title="Buat Tugas Baru"
      @close="isCreateModalOpen = false"
    >
      <form @submit.prevent="handleCreateTask" class="space-y-4">
        <BaseInput
          v-model="formTitle"
          label="Judul Tugas"
          placeholder="contoh: Buat skema migrasi database"
          required
        >
          <template #prefix>
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
          </template>
        </BaseInput>

        <BaseTextarea
          v-model="formDescription"
          label="Deskripsi Tugas"
          placeholder="Jelaskan detail instruksi pengerjaan tugas..."
          :rows="3"
        />

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <!-- Project Selection -->
          <BaseSelect
            v-model="formProjectId"
            label="Proyek Terkait"
            placeholder="Pilih proyek..."
            :options="projectSelectOptions"
            required
          />

          <!-- Priority -->
          <BaseSelect
            v-model="formPriority"
            label="Prioritas"
            :options="priorityOptions"
            required
          />
        </div>

        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <!-- Assignee -->
          <BaseSelect
            v-model="formAssignedTo"
            label="Tugaskan Kepada"
            placeholder="Pilih anggota tim..."
            :options="memberSelectOptions"
          />

          <!-- Due Date -->
          <BaseInput
            v-model="formDueDate"
            label="Tenggat Waktu"
            type="date"
            placeholder="YYYY-MM-DD"
          />
        </div>

        <div v-if="createError" class="text-xs text-error-500">
          {{ createError }}
        </div>
      </form>

      <template #footer>
        <BaseButton variant="outline" @click="isCreateModalOpen = false">
          Batal
        </BaseButton>
        <BaseButton
          variant="primary"
          :loading="submitting"
          @click="handleCreateTask"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          Simpan Tugas
        </BaseButton>
      </template>
    </BaseModal>

    <!-- Task Detail, Comments & Attachments Modal -->
    <BaseModal
      :is-open="isDetailModalOpen"
      :title="selectedTask?.title || 'Detail Tugas'"
      max-width="2xl"
      @close="isDetailModalOpen = false"
    >
      <div v-if="selectedTask" class="space-y-6">
        <!-- Status & Meta Row -->
        <div class="flex flex-wrap items-center justify-between gap-3 p-3 bg-gray-50 dark:bg-gray-800/50 rounded-xl">
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-500 dark:text-gray-400">Status:</span>
            <BaseSelect
              v-model="selectedTask.status"
              :options="statusOptions"
              @update:model-value="onDetailStatusChange"
            />
          </div>

          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-500 dark:text-gray-400">Prioritas:</span>
            <BaseBadge :variant="getPriorityBadgeVariant(selectedTask.priority)" :text="selectedTask.priority" />
          </div>
        </div>

        <!-- Description -->
        <div>
          <label class="block text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1">
            Deskripsi
          </label>
          <p class="text-sm text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-900 p-3 rounded-lg border border-gray-100 dark:border-gray-800">
            {{ selectedTask.description || 'Tidak ada deskripsi rinci.' }}
          </p>
        </div>

        <!-- Attachments Section with Drag & Drop & Uploaded Files List Below -->
        <div class="space-y-3 border-t border-gray-100 dark:border-gray-800 pt-5">
          <h4 class="text-sm font-bold text-gray-900 dark:text-white flex items-center gap-2">
            <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
            </svg>
            Lampiran File (Attachments)
          </h4>

          <!-- BaseDropzone component (Drag & Drop + preview list below form) -->
          <BaseDropzone
            :multiple="true"
            :max-size-mb="10"
            @file-added="onAttachmentAdded"
          />

          <!-- Existing Task Attachments List from DB -->
          <div v-if="taskStore.activeAttachments.length > 0" class="space-y-2 mt-3">
            <h5 class="text-xs font-semibold text-gray-500">File Tersimpan di Supabase Storage ({{ taskStore.activeAttachments.length }})</h5>
            <div class="divide-y divide-gray-100 dark:divide-gray-800 border border-gray-200 dark:border-gray-800 rounded-lg overflow-hidden bg-white dark:bg-gray-900">
              <div
                v-for="att in taskStore.activeAttachments"
                :key="att.id"
                class="flex items-center justify-between p-2.5 text-xs"
              >
                <div class="flex items-center gap-2.5 min-w-0">
                  <svg class="w-4 h-4 text-brand-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  <span class="truncate font-medium text-gray-800 dark:text-gray-200">{{ att.file_name }}</span>
                  <span class="text-[10px] text-gray-400">({{ formatFileSize(att.file_size) }})</span>
                </div>
                <div class="flex items-center gap-2">
                  <a
                    v-if="att.public_url"
                    :href="att.public_url"
                    target="_blank"
                    class="text-brand-500 hover:underline text-[11px]"
                  >
                    Unduh
                  </a>
                  <button
                    type="button"
                    class="text-error-500 hover:text-error-700"
                    @click="taskStore.deleteAttachment(att.id, att.file_path)"
                  >
                    Hapus
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Comments Section -->
        <div class="space-y-3 border-t border-gray-100 dark:border-gray-800 pt-5">
          <h4 class="text-sm font-bold text-gray-900 dark:text-white flex items-center gap-2">
            <svg class="w-4 h-4 text-brand-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
            </svg>
            Komentar ({{ taskStore.activeComments.length }})
          </h4>

          <!-- Comment Input Form -->
          <form @submit.prevent="handleAddComment" class="flex gap-2">
            <div class="flex-1">
              <BaseInput
                v-model="newCommentText"
                placeholder="Tulis tanggapan atau komentar..."
              />
            </div>
            <BaseButton
              type="submit"
              variant="primary"
              :disabled="!newCommentText.trim()"
            >
              <template #startIcon>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                </svg>
              </template>
              Kirim
            </BaseButton>
          </form>

          <!-- Comments Timeline -->
          <div class="space-y-3 max-h-56 overflow-y-auto custom-scrollbar pr-1 pt-2">
            <div
              v-for="cmt in taskStore.activeComments"
              :key="cmt.id"
              class="flex gap-3 p-3 bg-gray-50 dark:bg-gray-800/40 rounded-xl text-xs"
            >
              <div class="h-7 w-7 rounded-full overflow-hidden shrink-0 bg-gray-200">
                <img :src="cmt.user?.avatar_url || '/images/user/user-01.jpg'" alt="User" class="h-full w-full object-cover" />
              </div>
              <div class="flex-1">
                <div class="flex items-center justify-between mb-1">
                  <span class="font-bold text-gray-900 dark:text-white">{{ cmt.user?.full_name || 'Anggota' }}</span>
                  <span class="text-[10px] text-gray-400">{{ formatDate(cmt.created_at) }}</span>
                </div>
                <p class="text-gray-700 dark:text-gray-300">{{ cmt.content }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <BaseButton
          variant="danger"
          size="sm"
          @click="handleDeleteTask"
        >
          <template #startIcon>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </template>
          Hapus Tugas
        </BaseButton>
        <BaseButton variant="outline" size="sm" @click="isDetailModalOpen = false">
          Tutup
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useTaskStore } from '@/stores/task'
import { useProjectStore } from '@/stores/project'
import { useWorkspaceStore } from '@/stores/workspace'
import { useDebounce } from '@/composables/useDebounce'
import BaseInput from '@/components/common/BaseInput.vue'
import BaseSelect from '@/components/common/BaseSelect.vue'
import BaseTextarea from '@/components/common/BaseTextarea.vue'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import BaseDropzone, { type UploadFileItem } from '@/components/common/BaseDropzone.vue'
import type { Task, TaskStatus, TaskPriority } from '@/types/database.types'

const taskStore = useTaskStore()
const projectStore = useProjectStore()
const workspaceStore = useWorkspaceStore()

const searchQuery = ref('')
const debouncedSearch = useDebounce(searchQuery, 300)
const selectedProjectId = ref('')

// Drag & drop transfer state
const draggedTask = ref<Task | null>(null)

// Create Task Modal State
const isCreateModalOpen = ref(false)
const formTitle = ref('')
const formDescription = ref('')
const formProjectId = ref('')
const formPriority = ref<TaskPriority>('medium')
const formAssignedTo = ref('')
const formDueDate = ref('')
const submitting = ref(false)
const createError = ref('')

// Detail Modal State
const isDetailModalOpen = ref(false)
const selectedTask = ref<Task | null>(null)
const newCommentText = ref('')

const priorityOptions = [
  { value: 'low', label: 'Rendah (Low)' },
  { value: 'medium', label: 'Sedang (Medium)' },
  { value: 'high', label: 'Tinggi (High)' },
  { value: 'urgent', label: 'Mendesak (Urgent)' },
]

const statusOptions = [
  { value: 'todo', label: 'To Do' },
  { value: 'in_progress', label: 'In Progress' },
  { value: 'review', label: 'In Review' },
  { value: 'completed', label: 'Completed' },
]

onMounted(async () => {
  await Promise.all([
    taskStore.loadTasks(),
    projectStore.loadProjects(),
    workspaceStore.loadMembers(),
  ])
})

watch(
  () => workspaceStore.currentWorkspaceId,
  async () => {
    await Promise.all([
      taskStore.loadTasks(),
      projectStore.loadProjects(),
      workspaceStore.loadMembers(),
    ])
  }
)

const projectFilterOptions = computed(() => [
  { value: '', label: 'Semua Proyek' },
  ...projectStore.projects.map((p) => ({ value: p.id, label: p.name })),
])

const projectSelectOptions = computed(() =>
  projectStore.projects.map((p) => ({ value: p.id, label: p.name }))
)

const memberSelectOptions = computed(() => [
  { value: '', label: 'Belum Ditugaskan' },
  ...workspaceStore.members.map((m) => ({
    value: m.user_id,
    label: m.profile?.full_name || m.profile?.email || 'User',
  })),
])

const filteredTasks = computed(() => {
  return taskStore.tasks.filter((t) => {
    const matchSearch =
      !debouncedSearch.value ||
      t.title.toLowerCase().includes(debouncedSearch.value.toLowerCase()) ||
      (t.description && t.description.toLowerCase().includes(debouncedSearch.value.toLowerCase()))

    const matchProject = !selectedProjectId.value || t.project_id === selectedProjectId.value
    return matchSearch && matchProject
  })
})

const getColumnTasks = (status: TaskStatus) => {
  return filteredTasks.value.filter((t) => t.status === status)
}

const getPriorityBadgeVariant = (priority: TaskPriority) => {
  if (priority === 'urgent') return 'error'
  if (priority === 'high') return 'warning'
  if (priority === 'medium') return 'primary'
  return 'gray'
}

const formatDate = (isoStr: string | null) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
  })
}

const formatFileSize = (bytes: number) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${sizes[i]}`
}

// Drag and Drop Handlers
const onDragStart = (task: Task) => {
  draggedTask.value = task
}

const onDropTask = (_event: DragEvent, targetStatus: TaskStatus) => {
  if (draggedTask.value && draggedTask.value.status !== targetStatus) {
    taskStore.updateStatus(draggedTask.value.id, targetStatus)
  }
  draggedTask.value = null
}

const openCreateTaskModal = () => {
  formTitle.value = ''
  formDescription.value = ''
  formProjectId.value = projectStore.projects[0]?.id || ''
  formPriority.value = 'medium'
  formAssignedTo.value = ''
  formDueDate.value = ''
  createError.value = ''
  isCreateModalOpen.value = true
}

const handleCreateTask = async () => {
  if (!formTitle.value) {
    createError.value = 'Judul tugas wajib diisi.'
    return
  }
  if (!formProjectId.value) {
    createError.value = 'Pilih proyek terkait terlebih dahulu.'
    return
  }

  submitting.value = true
  createError.value = ''
  try {
    await taskStore.createTask({
      project_id: formProjectId.value,
      title: formTitle.value,
      description: formDescription.value,
      priority: formPriority.value,
      assigned_to: formAssignedTo.value || null,
      due_date: formDueDate.value || null,
    })
    isCreateModalOpen.value = false
  } catch (err: any) {
    createError.value = err.message || 'Gagal membuat tugas baru.'
  } finally {
    submitting.value = false
  }
}

const openTaskDetailModal = async (task: Task) => {
  selectedTask.value = task
  await taskStore.openTaskDetails(task)
  isDetailModalOpen.value = true
}

const onDetailStatusChange = (val: string | number) => {
  if (selectedTask.value) {
    taskStore.updateStatus(selectedTask.value.id, val as TaskStatus)
  }
}

const handleAddComment = async () => {
  if (!newCommentText.value.trim()) return
  await taskStore.addComment(newCommentText.value)
  newCommentText.value = ''
}

const onAttachmentAdded = async (fileItem: UploadFileItem) => {
  if (fileItem.rawFile) {
    await taskStore.uploadAttachment(fileItem.rawFile)
  }
}

const handleDeleteTask = async () => {
  if (selectedTask.value && confirm(`Hapus tugas "${selectedTask.value.title}"?`)) {
    await taskStore.deleteTask(selectedTask.value.id)
    isDetailModalOpen.value = false
  }
}
</script>
