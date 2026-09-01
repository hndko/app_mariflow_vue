<template>
  <div class="w-full space-y-4">
    <!-- Drag & Drop Upload Zone -->
    <div
      :class="[
        'relative flex flex-col items-center justify-center rounded-xl border-2 border-dashed p-6 transition-colors duration-200 cursor-pointer',
        isDragging
          ? 'border-brand-500 bg-brand-50/50 dark:border-brand-400 dark:bg-brand-500/10'
          : 'border-gray-300 bg-gray-50/75 hover:border-brand-400 hover:bg-gray-50 dark:border-gray-700 dark:bg-gray-900/50 dark:hover:border-brand-500',
        disabled ? 'opacity-50 cursor-not-allowed pointer-events-none' : '',
      ]"
      @dragover.prevent="onDragOver"
      @dragleave.prevent="onDragLeave"
      @drop.prevent="onDrop"
      @click="triggerFileInput"
    >
      <input
        ref="fileInputRef"
        type="file"
        class="hidden"
        :multiple="multiple"
        :accept="acceptedMimeTypes"
        :disabled="disabled"
        @change="onFileInputChange"
      />

      <div class="flex h-14 w-14 items-center justify-center rounded-full bg-brand-50 text-brand-500 dark:bg-brand-500/15 dark:text-brand-400 mb-3">
        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="1.5"
            d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
          ></path>
        </svg>
      </div>

      <div class="text-center">
        <p class="text-sm font-semibold text-gray-800 dark:text-white/90">
          <span class="text-brand-500 hover:underline">Klik untuk upload</span> atau seret file ke sini
        </p>
        <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
          {{ hintText || `Format yang didukung: ${acceptedTypesLabel} (Maks. ${maxSizeMb}MB)` }}
        </p>
      </div>
    </div>

    <!-- Error Alert -->
    <div v-if="localError" class="p-3 text-xs text-error-700 bg-error-50 dark:bg-error-500/10 dark:text-error-400 rounded-lg flex items-center justify-between">
      <span>{{ localError }}</span>
      <button type="button" @click="localError = ''" class="text-error-500 hover:text-error-700 font-bold ml-2">×</button>
    </div>

    <!-- Uploaded Files List (Wajib Muncul di Bawah Form) -->
    <div v-if="filesList && filesList.length > 0" class="space-y-2">
      <h4 class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
        Daftar File ({{ filesList.length }})
      </h4>

      <div class="divide-y divide-gray-100 dark:divide-gray-800 rounded-lg border border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900/60 overflow-hidden">
        <div
          v-for="(fileItem, index) in filesList"
          :key="fileItem.id || index"
          class="flex items-center justify-between p-3 transition hover:bg-gray-50/50 dark:hover:bg-white/[0.02]"
        >
          <!-- Left: Thumbnail / File Icon + Details -->
          <div class="flex items-center gap-3 min-w-0">
            <!-- Image Preview Thumbnail or Generic Icon -->
            <div class="h-10 w-10 shrink-0 overflow-hidden rounded-md border border-gray-200 bg-gray-100 dark:border-gray-700 dark:bg-gray-800 flex items-center justify-center">
              <img
                v-if="isImageFile(fileItem)"
                :src="fileItem.previewUrl || fileItem.publicUrl"
                :alt="fileItem.name"
                class="h-full w-full object-cover"
              />
              <svg v-else class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                ></path>
              </svg>
            </div>

            <!-- Name and Size / Upload Progress -->
            <div class="min-w-0 flex-1">
              <p class="truncate text-xs font-medium text-gray-800 dark:text-white/90">
                {{ fileItem.name }}
              </p>
              <div class="flex items-center gap-2 text-[11px] text-gray-500 dark:text-gray-400">
                <span>{{ formatFileSize(fileItem.size) }}</span>
                <span v-if="fileItem.status === 'uploading'" class="text-brand-500 font-medium">
                  • Mengunggah {{ fileItem.progress || 0 }}%
                </span>
                <span v-else-if="fileItem.status === 'success'" class="text-success-600 font-medium">
                  • Selesai
                </span>
                <span v-else-if="fileItem.status === 'error'" class="text-error-600 font-medium">
                  • Gagal
                </span>
              </div>

              <!-- Upload Progress Bar -->
              <div
                v-if="fileItem.status === 'uploading'"
                class="mt-1.5 h-1 w-full overflow-hidden rounded-full bg-gray-200 dark:bg-gray-700"
              >
                <div
                  class="h-full bg-brand-500 transition-all duration-300"
                  :style="{ width: `${fileItem.progress || 0}%` }"
                ></div>
              </div>
            </div>
          </div>

          <!-- Right: Actions (Preview & Delete) -->
          <div class="flex items-center gap-1 shrink-0 ml-2">
            <!-- View / Download Link -->
            <a
              v-if="fileItem.publicUrl"
              :href="fileItem.publicUrl"
              target="_blank"
              class="p-1.5 text-gray-400 hover:text-brand-500 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800"
              title="Lihat / Download File"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
              </svg>
            </a>

            <!-- Delete Button -->
            <button
              type="button"
              class="p-1.5 text-gray-400 hover:text-error-500 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800"
              title="Hapus File"
              @click="removeFile(index, fileItem)"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

export interface UploadFileItem {
  id?: string
  name: string
  size: number
  type?: string
  rawFile?: File
  previewUrl?: string
  publicUrl?: string
  filePath?: string
  status?: 'pending' | 'uploading' | 'success' | 'error'
  progress?: number
}

interface BaseDropzoneProps {
  modelValue?: UploadFileItem[]
  multiple?: boolean
  maxSizeMb?: number
  acceptedMimeTypes?: string
  acceptedTypesLabel?: string
  hintText?: string
  disabled?: boolean
}

const props = withDefaults(defineProps<BaseDropzoneProps>(), {
  modelValue: () => [],
  multiple: true,
  maxSizeMb: 10,
  acceptedMimeTypes: 'image/png,image/jpeg,image/gif,image/webp,application/pdf,application/zip,text/plain',
  acceptedTypesLabel: 'PNG, JPG, PDF, ZIP',
  hintText: '',
  disabled: false,
})

const emit = defineEmits(['update:modelValue', 'file-added', 'file-removed'])

const fileInputRef = ref<HTMLInputElement | null>(null)
const isDragging = ref(false)
const localError = ref('')

const filesList = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const triggerFileInput = () => {
  if (!props.disabled && fileInputRef.value) {
    fileInputRef.value.click()
  }
}

const onDragOver = () => {
  if (!props.disabled) {
    isDragging.value = true
  }
}

const onDragLeave = () => {
  isDragging.value = false
}

const onDrop = (e: DragEvent) => {
  isDragging.value = false
  if (props.disabled) return
  if (e.dataTransfer && e.dataTransfer.files) {
    processFiles(Array.from(e.dataTransfer.files))
  }
}

const onFileInputChange = (e: Event) => {
  const target = e.target as HTMLInputElement
  if (target.files) {
    processFiles(Array.from(target.files))
    target.value = ''
  }
}

const processFiles = (rawFiles: File[]) => {
  localError.value = ''
  const validItems: UploadFileItem[] = []

  for (const file of rawFiles) {
    // Check file size
    if (file.size > props.maxSizeMb * 1024 * 1024) {
      localError.value = `File "${file.name}" melebihi batas maksimal ${props.maxSizeMb}MB.`
      continue
    }

    const previewUrl = file.type.startsWith('image/') ? URL.createObjectURL(file) : undefined

    const item: UploadFileItem = {
      id: Math.random().toString(36).substring(2, 9),
      name: file.name,
      size: file.size,
      type: file.type,
      rawFile: file,
      previewUrl,
      status: 'pending',
      progress: 0,
    }

    validItems.push(item)
    emit('file-added', item)
  }

  if (validItems.length > 0) {
    if (props.multiple) {
      filesList.value = [...filesList.value, ...validItems]
    } else {
      filesList.value = [validItems[0]]
    }
  }
}

const removeFile = (index: number, item: UploadFileItem) => {
  const updated = [...filesList.value]
  updated.splice(index, 1)
  filesList.value = updated
  emit('file-removed', item)
}

const isImageFile = (item: UploadFileItem) => {
  return item.previewUrl || (item.type && item.type.startsWith('image/')) || (item.publicUrl && /\.(jpg|jpeg|png|webp|gif|svg)$/i.test(item.publicUrl))
}

const formatFileSize = (bytes: number) => {
  if (!bytes || bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${sizes[i]}`
}
</script>
