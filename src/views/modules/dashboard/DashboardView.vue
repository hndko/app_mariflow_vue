<template>
  <div class="space-y-6">
    <!-- Header Section with Workspace Context -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
          Dashboard Analytics
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Ikhtisar performa & produktivitas di workspace <strong class="text-brand-600 dark:text-brand-400">{{ workspaceStore.currentWorkspaceName }}</strong>
        </p>
      </div>

      <!-- Quick Switcher / Add Task Button -->
      <div class="flex items-center gap-3">
        <router-link to="/tasks">
          <BaseButton variant="primary">
            <template #startIcon>
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
            </template>
            Buka Papan Kanban
          </BaseButton>
        </router-link>
      </div>
    </div>

    <!-- KPI Metric Cards Grid -->
    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
      <!-- 1. Total Projects -->
      <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Total Proyek
          </p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">
            {{ projectStore.projects.length }}
          </h3>
          <p class="mt-1 text-xs text-brand-500 font-medium">
            {{ projectStore.activeProjectsCount }} Proyek Aktif
          </p>
        </div>
        <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-50 text-brand-500 dark:bg-brand-500/15 dark:text-brand-400">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
          </svg>
        </div>
      </div>

      <!-- 2. Total Tasks -->
      <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Total Tugas
          </p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">
            {{ taskStore.tasks.length }}
          </h3>
          <p class="mt-1 text-xs text-success-600 font-medium">
            {{ taskStore.completedTasks.length }} Selesai
          </p>
        </div>
        <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-success-50 text-success-500 dark:bg-success-500/15 dark:text-success-400">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
          </svg>
        </div>
      </div>

      <!-- 3. In Progress Tasks -->
      <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Sedang Dikerjakan
          </p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">
            {{ taskStore.inProgressTasks.length + taskStore.reviewTasks.length }}
          </h3>
          <p class="mt-1 text-xs text-warning-600 font-medium">
            {{ taskStore.todoTasks.length }} Menunggu (Todo)
          </p>
        </div>
        <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-warning-50 text-warning-500 dark:bg-warning-500/15 dark:text-warning-400">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
      </div>

      <!-- 4. Team Members -->
      <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Anggota Tim
          </p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">
            {{ workspaceStore.members.length }}
          </h3>
          <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
            Di workspace ini
          </p>
        </div>
        <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-500 dark:bg-blue-500/15 dark:text-blue-400">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
        </div>
      </div>
    </div>

    <!-- Charts Section (Donut & Bar Charts via ApexCharts) -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
      <!-- Chart 1: Tasks by Status -->
      <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-bold text-base text-gray-900 dark:text-white">
            Distribusi Tugas berdasarkan Status
          </h3>
        </div>
        <div class="h-64 flex items-center justify-center">
          <VueApexCharts
            type="donut"
            height="250"
            width="100%"
            :options="statusChartOptions"
            :series="statusChartSeries"
          />
        </div>
      </div>

      <!-- Chart 2: Tasks by Priority -->
      <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-bold text-base text-gray-900 dark:text-white">
            Distribusi Prioritas Tugas
          </h3>
        </div>
        <div class="h-64 flex items-center justify-center">
          <VueApexCharts
            type="bar"
            height="250"
            width="100%"
            :options="priorityChartOptions"
            :series="priorityChartSeries"
          />
        </div>
      </div>
    </div>

    <!-- Recent Tasks Table with Auto-Numbering (#) -->
    <div class="space-y-3">
      <div class="flex items-center justify-between">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">
          Tugas Terbaru
        </h3>
        <router-link to="/tasks" class="text-xs font-semibold text-brand-500 hover:text-brand-600">
          Lihat Semua Tugas →
        </router-link>
      </div>

      <BaseTable
        :columns="taskColumns"
        :data="recentTasks"
        :show-numbering="true"
        numbering-header="#"
        empty-text="Belum ada tugas di workspace ini"
      >
        <template #cell-title="{ item }">
          <span class="font-semibold text-gray-900 dark:text-white">{{ item.title }}</span>
        </template>

        <template #cell-status="{ item }">
          <BaseBadge
            :variant="getStatusBadge(item.status)"
            :text="item.status"
            dot
          />
        </template>

        <template #cell-priority="{ item }">
          <BaseBadge
            :variant="getPriorityBadge(item.priority)"
            :text="item.priority"
          />
        </template>

        <template #cell-assignee="{ item }">
          <div class="flex items-center gap-2">
            <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-100">
              <img :src="item.assignee?.avatar_url || '/images/user/user-01.jpg'" alt="Assignee" class="h-full w-full object-cover" />
            </div>
            <span class="text-xs text-gray-700 dark:text-gray-300">
              {{ item.assignee?.full_name || 'Belum ditugaskan' }}
            </span>
          </div>
        </template>
      </BaseTable>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useWorkspaceStore } from '@/stores/workspace'
import { useProjectStore } from '@/stores/project'
import { useTaskStore } from '@/stores/task'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'

const workspaceStore = useWorkspaceStore()
const projectStore = useProjectStore()
const taskStore = useTaskStore()

onMounted(async () => {
  await Promise.all([
    workspaceStore.loadWorkspaces(),
    projectStore.loadProjects(),
    taskStore.loadTasks(),
    workspaceStore.loadMembers(),
  ])
})

const recentTasks = computed(() => taskStore.tasks.slice(0, 5))

const taskColumns: TableColumn[] = [
  { key: 'title', label: 'Judul Tugas' },
  { key: 'status', label: 'Status', align: 'center', class: 'w-32' },
  { key: 'priority', label: 'Prioritas', align: 'center', class: 'w-28' },
  { key: 'assignee', label: 'Ditugaskan', class: 'w-44' },
]

// Status Donut Chart Configuration
const statusChartSeries = computed(() => [
  taskStore.todoTasks.length,
  taskStore.inProgressTasks.length,
  taskStore.reviewTasks.length,
  taskStore.completedTasks.length,
])

const statusChartOptions = computed(() => ({
  chart: {
    type: 'donut',
    fontFamily: 'inherit',
  },
  labels: ['To Do', 'In Progress', 'Review', 'Completed'],
  colors: ['#9ca3af', '#465fff', '#f59e0b', '#10b981'],
  legend: {
    position: 'bottom',
  },
  dataLabels: {
    enabled: false,
  },
}))

// Priority Bar Chart Configuration
const priorityChartSeries = computed(() => [
  {
    name: 'Jumlah Tugas',
    data: [
      taskStore.tasks.filter((t) => t.priority === 'urgent').length,
      taskStore.tasks.filter((t) => t.priority === 'high').length,
      taskStore.tasks.filter((t) => t.priority === 'medium').length,
      taskStore.tasks.filter((t) => t.priority === 'low').length,
    ],
  },
])

const priorityChartOptions = computed(() => ({
  chart: {
    type: 'bar',
    toolbar: { show: false },
    fontFamily: 'inherit',
  },
  xaxis: {
    categories: ['Mendesak (Urgent)', 'Tinggi (High)', 'Sedang (Medium)', 'Rendah (Low)'],
  },
  colors: ['#ef4444', '#f59e0b', '#465fff', '#6b7280'],
  plotOptions: {
    bar: {
      borderRadius: 6,
      distributed: true,
    },
  },
  dataLabels: {
    enabled: false,
  },
  legend: {
    show: false,
  },
}))

const getStatusBadge = (status: string) => {
  if (status === 'completed') return 'success'
  if (status === 'in_progress') return 'primary'
  if (status === 'review') return 'warning'
  return 'gray'
}

const getPriorityBadge = (priority: string) => {
  if (priority === 'urgent') return 'error'
  if (priority === 'high') return 'warning'
  if (priority === 'medium') return 'primary'
  return 'gray'
}
</script>
