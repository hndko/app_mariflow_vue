<template>
  <div class="overflow-hidden rounded-xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
    <div class="max-w-full overflow-x-auto custom-scrollbar">
      <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-800 text-left text-sm">
        <thead class="bg-gray-50/75 dark:bg-gray-800/50">
          <tr>
            <!-- Automatic Numbering Column (#) -->
            <th
              v-if="showNumbering"
              scope="col"
              class="w-16 px-4 py-3.5 text-center font-semibold text-gray-700 dark:text-gray-300"
            >
              {{ numberingHeader }}
            </th>

            <!-- Custom Headers -->
            <th
              v-for="column in columns"
              :key="column.key"
              scope="col"
              :class="[
                'px-4 py-3.5 font-semibold text-gray-700 dark:text-gray-300',
                column.align === 'center' ? 'text-center' : column.align === 'right' ? 'text-right' : 'text-left',
                column.class || '',
              ]"
            >
              {{ column.label }}
            </th>

            <!-- Actions Header -->
            <th
              v-if="$slots.actions || showActions"
              scope="col"
              class="w-28 px-4 py-3.5 text-center font-semibold text-gray-700 dark:text-gray-300"
            >
              {{ actionsHeader }}
            </th>
          </tr>
        </thead>

        <tbody class="divide-y divide-gray-100 dark:divide-gray-800/60 bg-white dark:bg-transparent">
          <!-- Loading Skeleton State -->
          <template v-if="loading">
            <tr v-for="n in skeletonRows" :key="n" class="animate-pulse">
              <td v-if="showNumbering" class="px-4 py-4 text-center">
                <div class="h-4 w-6 mx-auto bg-gray-200 dark:bg-gray-700 rounded"></div>
              </td>
              <td v-for="col in columns" :key="col.key" class="px-4 py-4">
                <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded" :style="{ width: `${Math.floor(Math.random() * 40 + 50)}%` }"></div>
              </td>
              <td v-if="$slots.actions || showActions" class="px-4 py-4 text-center">
                <div class="h-4 w-12 mx-auto bg-gray-200 dark:bg-gray-700 rounded"></div>
              </td>
            </tr>
          </template>

          <!-- Empty State -->
          <template v-else-if="!data || data.length === 0">
            <tr>
              <td
                :colspan="totalColumns"
                class="px-6 py-12 text-center text-gray-500 dark:text-gray-400"
              >
                <div class="flex flex-col items-center justify-center space-y-2">
                  <svg
                    class="w-12 h-12 text-gray-300 dark:text-gray-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
                    ></path>
                  </svg>
                  <p class="text-base font-medium text-gray-700 dark:text-gray-300">
                    {{ emptyText }}
                  </p>
                  <p class="text-xs text-gray-400">
                    {{ emptyDescription }}
                  </p>
                  <div v-if="$slots.emptyAction" class="pt-2">
                    <slot name="emptyAction"></slot>
                  </div>
                </div>
              </td>
            </tr>
          </template>

          <!-- Real Data Rows -->
          <template v-else>
            <tr
              v-for="(item, index) in data"
              :key="itemKey ? item[itemKey] : index"
              class="transition-colors hover:bg-gray-50/50 dark:hover:bg-white/[0.02]"
            >
              <!-- Auto-calculated Numbering (#) -->
              <td
                v-if="showNumbering"
                class="px-4 py-3.5 text-center text-xs font-medium text-gray-500 dark:text-gray-400"
              >
                {{ calculateRowNumber(index) }}
              </td>

              <!-- Dynamic Data Cells or Custom Column Slot -->
              <td
                v-for="column in columns"
                :key="column.key"
                :class="[
                  'px-4 py-3.5 text-gray-700 dark:text-gray-300',
                  column.align === 'center' ? 'text-center' : column.align === 'right' ? 'text-right' : 'text-left',
                  column.cellClass || '',
                ]"
              >
                <slot :name="`cell-${column.key}`" :item="item" :index="index" :value="item[column.key]">
                  {{ item[column.key] ?? '-' }}
                </slot>
              </td>

              <!-- Action Column Slot -->
              <td
                v-if="$slots.actions || showActions"
                class="px-4 py-3.5 text-center text-sm"
              >
                <div class="flex items-center justify-center gap-1.5">
                  <slot name="actions" :item="item" :index="index"></slot>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>

    <!-- Pagination Footer -->
    <div
      v-if="$slots.pagination"
      class="border-t border-gray-200 dark:border-gray-800 px-4 py-3 bg-gray-50/50 dark:bg-gray-900/30"
    >
      <slot name="pagination"></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

export interface TableColumn {
  key: string
  label: string
  align?: 'left' | 'center' | 'right'
  class?: string
  cellClass?: string
}

interface BaseTableProps {
  columns: TableColumn[]
  data: any[]
  showNumbering?: boolean
  numberingHeader?: string
  page?: number
  perPage?: number
  loading?: boolean
  skeletonRows?: number
  itemKey?: string
  showActions?: boolean
  actionsHeader?: string
  emptyText?: string
  emptyDescription?: string
}

const props = withDefaults(defineProps<BaseTableProps>(), {
  showNumbering: true,
  numberingHeader: '#',
  page: 1,
  perPage: 10,
  loading: false,
  skeletonRows: 5,
  itemKey: 'id',
  showActions: false,
  actionsHeader: 'Aksi',
  emptyText: 'Tidak ada data',
  emptyDescription: 'Belum ada catatan yang tersimpan pada tabel ini.',
})

const totalColumns = computed(() => {
  let count = props.columns.length
  if (props.showNumbering) count += 1
  if (props.showActions) count += 1
  return count
})

const calculateRowNumber = (index: number) => {
  return (props.page - 1) * props.perPage + index + 1
}
</script>
