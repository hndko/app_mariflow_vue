<template>
  <div class="space-y-6">
    <!-- Header Section with Workspace & Role Context -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <div class="flex items-center gap-2 mb-1">
          <span class="text-xs font-semibold text-gray-500 dark:text-gray-400">
            Workspace:
          </span>
          <span class="font-bold text-sm text-gray-900 dark:text-white">
            {{ workspaceStore.currentWorkspaceName }}
          </span>
          <BaseBadge
            :variant="getRoleBadgeVariant(effectiveRole)"
            :text="getRoleBadgeText(effectiveRole)"
            size="sm"
          />
        </div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
          Dashboard Analytics
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          {{ getRoleDescription(effectiveRole) }}
        </p>
      </div>

      <!-- Quick Action / Role Preview Switcher -->
      <div class="flex flex-wrap items-center gap-3">
        <!-- Role Preview Toggler for Demo / Testing -->
        <div class="flex items-center rounded-lg border border-gray-200 bg-white p-1 text-xs dark:border-gray-800 dark:bg-gray-900 shadow-theme-xs">
          <span class="px-2 py-1 text-gray-400 font-medium">Tampilan Role:</span>
          <button
            v-for="r in roleOptions"
            :key="r.value"
            type="button"
            :class="[
              'px-2.5 py-1 rounded-md font-semibold transition capitalize',
              previewRole === r.value
                ? 'bg-brand-500 text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white',
            ]"
            @click="previewRole = r.value"
          >
            {{ r.label }}
          </button>
        </div>

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

    <!-- Global Date Range & Time Filter Bar with Presets -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800 shadow-theme-xs">
      <div class="flex flex-wrap items-center gap-2">
        <span class="text-xs font-semibold uppercase tracking-wider text-gray-400 mr-1">
          Rentang Waktu:
        </span>
        <button
          v-for="preset in timePresets"
          :key="preset.id"
          type="button"
          :class="[
            'px-3 py-1.5 text-xs font-semibold rounded-lg transition',
            selectedTimeRange === preset.id
              ? 'bg-brand-50 text-brand-600 dark:bg-brand-500/15 dark:text-brand-400 border border-brand-200 dark:border-brand-800'
              : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800',
          ]"
          @click="changeTimeFilter(preset.id)"
        >
          {{ preset.label }}
        </button>
      </div>

      <div class="flex items-center gap-2 text-xs text-gray-500">
        <span class="inline-block h-2 w-2 rounded-full bg-success-500 animate-pulse"></span>
        <span>Data Tersinkronisasi Otomatis</span>
      </div>
    </div>

    <!-- ============================================================================== -->
    <!-- 👑 ROLE 1: OWNER DASHBOARD (Executive Oversight) -->
    <!-- ============================================================================== -->
    <template v-if="effectiveRole === 'owner'">
      <!-- Executive KPI Cards -->
      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <!-- Total Projects -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Total Proyek</p>
            <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ projectStore.projects.length }}</h3>
            <p class="mt-1 text-xs text-brand-500 font-medium">{{ projectStore.activeProjectsCount }} Proyek Aktif</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-50 text-brand-500 dark:bg-brand-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" /></svg>
          </div>
        </div>

        <!-- Task Completion Rate -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Tingkat Penyelesaian</p>
            <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ completionRate }}%</h3>
            <p class="mt-1 text-xs text-success-600 font-medium">{{ taskStore.completedTasks.length }} dari {{ taskStore.tasks.length }} Selesai</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-success-50 text-success-500 dark:bg-success-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          </div>
        </div>

        <!-- Team Members -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Anggota Kolaborator</p>
            <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ workspaceStore.members.length }}</h3>
            <p class="mt-1 text-xs text-blue-500 font-medium">Tim Aktif</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-500 dark:bg-blue-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" /></svg>
          </div>
        </div>

        <!-- Storage & Attachments -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Lampiran Storage</p>
            <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ taskStore.activeAttachments.length || 12 }} File</h3>
            <p class="mt-1 text-xs text-purple-500 font-medium">Bucket Terproteksi RLS</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-50 text-purple-500 dark:bg-purple-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" /></svg>
          </div>
        </div>
      </div>

      <!-- Executive Velocity Trend Chart -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2 rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <h3 class="font-bold text-base text-gray-900 dark:text-white mb-1">
            Tren Kecepatan Kerja Tim (Task Velocity)
          </h3>
          <p class="text-xs text-gray-500 mb-4">Grafik tugas dibuat vs tugas diselesaikan dalam 7 hari terakhir.</p>
          <div class="h-64">
            <VueApexCharts
              type="area"
              height="250"
              width="100%"
              :options="velocityChartOptions"
              :series="velocityChartSeries"
            />
          </div>
        </div>

        <!-- Projects Status Distribution -->
        <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <h3 class="font-bold text-base text-gray-900 dark:text-white mb-1">
            Status Proyek
          </h3>
          <p class="text-xs text-gray-500 mb-4">Komposisi status seluruh portofolio proyek.</p>
          <div class="h-64 flex items-center justify-center">
            <VueApexCharts
              type="donut"
              height="240"
              width="100%"
              :options="projectStatusChartOptions"
              :series="projectStatusChartSeries"
            />
          </div>
        </div>
      </div>
    </template>

    <!-- ============================================================================== -->
    <!-- ⚡ ROLE 2: ADMIN DASHBOARD (Operational & Bottlenecks) -->
    <!-- ============================================================================== -->
    <template v-else-if="effectiveRole === 'admin'">
      <!-- Operational KPI Cards -->
      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <!-- Backlog Todo -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Backlog (Todo)</p>
            <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ taskStore.todoTasks.length }}</h3>
            <p class="mt-1 text-xs text-gray-500 font-medium">Siap Dikerjakan</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-300">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>
          </div>
        </div>

        <!-- In Progress & Review -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Dalam Pengerjaan</p>
            <h3 class="mt-2 text-2xl font-bold text-brand-600 dark:text-brand-400">{{ taskStore.inProgressTasks.length + taskStore.reviewTasks.length }}</h3>
            <p class="mt-1 text-xs text-brand-500 font-medium">{{ taskStore.reviewTasks.length }} Perlu Direview</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-50 text-brand-500 dark:bg-brand-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          </div>
        </div>

        <!-- Overdue Tasks (Bottleneck) -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Lewat Tenggat Waktu</p>
            <h3 class="mt-2 text-2xl font-bold text-error-600">{{ overdueTasksCount }}</h3>
            <p class="mt-1 text-xs text-error-500 font-medium">Perlu Eskalasi Segera</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-error-50 text-error-500 dark:bg-error-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
          </div>
        </div>

        <!-- Unassigned Tasks -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Belum Ditugaskan</p>
            <h3 class="mt-2 text-2xl font-bold text-warning-600">{{ unassignedTasksCount }}</h3>
            <p class="mt-1 text-xs text-warning-500 font-medium">Perlu Penetapan Anggota</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-warning-50 text-warning-500 dark:bg-warning-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" /></svg>
          </div>
        </div>
      </div>

      <!-- Operational Charts (Workload Allocation & Task Priority) -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <h3 class="font-bold text-base text-gray-900 dark:text-white mb-1">
            Distribusi Beban Kerja Tim
          </h3>
          <p class="text-xs text-gray-500 mb-4">Jumlah tugas aktif per anggota tim.</p>
          <div class="h-64">
            <VueApexCharts
              type="bar"
              height="250"
              width="100%"
              :options="workloadChartOptions"
              :series="workloadChartSeries"
            />
          </div>
        </div>

        <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <h3 class="font-bold text-base text-gray-900 dark:text-white mb-1">
            Tingkat Urgensi Tugas
          </h3>
          <p class="text-xs text-gray-500 mb-4">Distribusi prioritas tugas di backlog.</p>
          <div class="h-64">
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
    </template>

    <!-- ============================================================================== -->
    <!-- 🛠️ ROLE 3: MEMBER DASHBOARD (Personal Productivity Focus) -->
    <!-- ============================================================================== -->
    <template v-else-if="effectiveRole === 'member'">
      <!-- Personal KPI Cards -->
      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <!-- My In Progress -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Tugasku Aktif</p>
            <h3 class="mt-2 text-2xl font-bold text-brand-600 dark:text-brand-400">{{ myActiveTasks.length }}</h3>
            <p class="mt-1 text-xs text-gray-500 font-medium">Sedang Dikerjakan</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-50 text-brand-500 dark:bg-brand-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          </div>
        </div>

        <!-- My Completed -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Tugas Diselesaikan</p>
            <h3 class="mt-2 text-2xl font-bold text-success-600">{{ myCompletedTasks.length }}</h3>
            <p class="mt-1 text-xs text-success-500 font-medium">Bulan Ini</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-success-50 text-success-500 dark:bg-success-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 13l4 4L19 7" /></svg>
          </div>
        </div>

        <!-- My Upcoming Deadline -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Deadline Terdekat</p>
            <h3 class="mt-2 text-2xl font-bold text-warning-600">{{ myUpcomingTasks.length }}</h3>
            <p class="mt-1 text-xs text-warning-500 font-medium">Dalam 7 Hari ke Depan</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-warning-50 text-warning-500 dark:bg-warning-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
          </div>
        </div>

        <!-- My Productivity Score -->
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900 flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-gray-500">Skor Produktivitas</p>
            <h3 class="mt-2 text-2xl font-bold text-purple-600">{{ myProductivityRate }}%</h3>
            <p class="mt-1 text-xs text-purple-500 font-medium">Tingkat Ketepatan</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-50 text-purple-500 dark:bg-purple-500/15">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
          </div>
        </div>
      </div>

      <!-- Member Focus (My Tasks Breakdown) -->
      <div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
        <h3 class="font-bold text-base text-gray-900 dark:text-white mb-1">
          Distribusi Status Tugasku
        </h3>
        <p class="text-xs text-gray-500 mb-4">Ringkasan status tugas yang sedang menjadi tanggung jawab Anda.</p>
        <div class="h-64 flex items-center justify-center">
          <VueApexCharts
            type="donut"
            height="250"
            width="100%"
            :options="myStatusChartOptions"
            :series="myStatusChartSeries"
          />
        </div>
      </div>
    </template>

    <!-- ============================================================================== -->
    <!-- 👁️ ROLE 4: VIEWER DASHBOARD (Read-Only Observability) -->
    <!-- ============================================================================== -->
    <template v-else>
      <div class="rounded-xl border border-blue-200 bg-blue-50/60 p-4 text-xs text-blue-800 dark:border-blue-900/50 dark:bg-blue-950/20 dark:text-blue-300 flex items-center gap-3">
        <svg class="w-5 h-5 text-blue-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        <span>
          <strong>Mode Tinjauan (Viewer)</strong>: Anda memiliki hak akses untuk memantau kemajuan proyek dan kinerja tugas tanpa izin modifikasi data.
        </span>
      </div>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <p class="text-xs font-semibold uppercase text-gray-500">Progres Workspace</p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ completionRate }}% Selesai</h3>
        </div>
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <p class="text-xs font-semibold uppercase text-gray-500">Total Proyek</p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ projectStore.projects.length }} Proyek</h3>
        </div>
        <div class="rounded-2xl border border-gray-200 bg-white p-5 shadow-theme-xs dark:border-gray-800 dark:bg-gray-900">
          <p class="text-xs font-semibold uppercase text-gray-500">Tugas Terbuka</p>
          <h3 class="mt-2 text-2xl font-bold text-gray-900 dark:text-white">{{ taskStore.todoTasks.length + taskStore.inProgressTasks.length }} Tugas</h3>
        </div>
      </div>
    </template>

    <!-- Recent Tasks Table with Auto-Numbering (#) - Common for All Roles -->
    <div class="space-y-3 pt-2">
      <div class="flex items-center justify-between">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">
          {{ effectiveRole === 'member' ? 'Tugas Terbaruku' : 'Aktivitas Tugas Terbaru' }}
        </h3>
        <router-link to="/tasks" class="text-xs font-semibold text-brand-500 hover:text-brand-600">
          Lihat Semua di Papan Kanban →
        </router-link>
      </div>

      <BaseTable
        :columns="taskColumns"
        :data="displayedRecentTasks"
        :show-numbering="true"
        numbering-header="#"
        empty-text="Belum ada tugas di rentang waktu ini"
      >
        <template #cell-title="{ item }">
          <div>
            <span class="font-semibold text-gray-900 dark:text-white">{{ item.title }}</span>
            <span class="block text-[11px] text-brand-600 dark:text-brand-400 mt-0.5">
              {{ item.project?.name || 'Umum' }}
            </span>
          </div>
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
            <div class="h-6 w-6 rounded-full overflow-hidden bg-gray-100 shrink-0">
              <img :src="item.assignee?.avatar_url || '/images/user/user-01.jpg'" alt="Assignee" class="h-full w-full object-cover" />
            </div>
            <span class="text-xs text-gray-700 dark:text-gray-300 truncate max-w-[120px]">
              {{ item.assignee?.full_name || 'Belum ditugaskan' }}
            </span>
          </div>
        </template>
      </BaseTable>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useWorkspaceStore } from '@/stores/workspace'
import { useProjectStore } from '@/stores/project'
import { useTaskStore } from '@/stores/task'
import { useAuthStore } from '@/stores/auth'
import BaseButton from '@/components/common/BaseButton.vue'
import BaseBadge from '@/components/common/BaseBadge.vue'
import BaseTable, { type TableColumn } from '@/components/common/BaseTable.vue'
import type { UserRole } from '@/types/database.types'

const workspaceStore = useWorkspaceStore()
const projectStore = useProjectStore()
const taskStore = useTaskStore()
const authStore = useAuthStore()

// Time Filter Preset State
const selectedTimeRange = ref<string>('all')
const previewRole = ref<UserRole | null>(null)

const timePresets = [
  { id: 'all', label: 'Semua Waktu' },
  { id: 'today', label: 'Hari Ini' },
  { id: 'week', label: 'Minggu Ini' },
  { id: 'month', label: 'Bulan Ini' },
  { id: 'year', label: 'Tahun Ini' },
]

const roleOptions = [
  { value: 'owner' as UserRole, label: 'Owner (Eksekutif)' },
  { value: 'admin' as UserRole, label: 'Admin (Operasional)' },
  { value: 'member' as UserRole, label: 'Member (Pribadi)' },
  { value: 'viewer' as UserRole, label: 'Viewer (Read-Only)' },
]

// Determine role: Preview role overrides active membership role for testing/switching
const effectiveRole = computed<UserRole>(() => {
  return previewRole.value || workspaceStore.userRole || 'owner'
})

onMounted(async () => {
  await Promise.all([
    workspaceStore.loadWorkspaces(),
    projectStore.loadProjects(),
    taskStore.loadTasks(),
    workspaceStore.loadMembers(),
  ])
  if (!previewRole.value) {
    previewRole.value = workspaceStore.userRole
  }
})

watch(
  () => workspaceStore.currentWorkspaceId,
  async () => {
    await Promise.all([
      projectStore.loadProjects(),
      taskStore.loadTasks(),
      workspaceStore.loadMembers(),
    ])
  }
)

const changeTimeFilter = (presetId: string) => {
  selectedTimeRange.value = presetId
}

// -----------------------------------------------------------------------------
// Computeds for Role KPIs
// -----------------------------------------------------------------------------
const completionRate = computed(() => {
  if (taskStore.tasks.length === 0) return 0
  return Math.round((taskStore.completedTasks.length / taskStore.tasks.length) * 100)
})

const overdueTasksCount = computed(() => {
  const now = new Date().toISOString().split('T')[0]
  return taskStore.tasks.filter(
    (t) => t.status !== 'completed' && t.due_date && t.due_date < now
  ).length
})

const unassignedTasksCount = computed(() => {
  return taskStore.tasks.filter((t) => !t.assigned_to).length
})

// Member Personal Tasks Computeds
const myTasks = computed(() => {
  const currentUid = authStore.user?.id || 'user-1'
  return taskStore.tasks.filter((t) => t.assigned_to === currentUid || t.assigned_to === 'user-1')
})

const myActiveTasks = computed(() => myTasks.value.filter((t) => t.status === 'in_progress'))
const myCompletedTasks = computed(() => myTasks.value.filter((t) => t.status === 'completed'))

const myUpcomingTasks = computed(() => {
  const now = new Date()
  const sevenDaysLater = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
  return myTasks.value.filter(
    (t) => t.status !== 'completed' && t.due_date && t.due_date <= sevenDaysLater
  )
})

const myProductivityRate = computed(() => {
  if (myTasks.value.length === 0) return 100
  return Math.round((myCompletedTasks.value.length / myTasks.value.length) * 100)
})

const displayedRecentTasks = computed(() => {
  if (effectiveRole.value === 'member') {
    return myTasks.value.slice(0, 5)
  }
  return taskStore.tasks.slice(0, 5)
})

// -----------------------------------------------------------------------------
// Role Helper Labels
// -----------------------------------------------------------------------------
const getRoleBadgeVariant = (role: UserRole) => {
  if (role === 'owner') return 'primary'
  if (role === 'admin') return 'warning'
  if (role === 'member') return 'success'
  return 'gray'
}

const getRoleBadgeText = (role: UserRole) => {
  if (role === 'owner') return 'Role: Owner'
  if (role === 'admin') return 'Role: Admin'
  if (role === 'member') return 'Role: Member'
  return 'Role: Viewer'
}

const getRoleDescription = (role: UserRole) => {
  if (role === 'owner') {
    return 'Ikhtisar eksekutif kecepatan kerja tim, portofolio proyek, dan alokasi kapasitas.'
  }
  if (role === 'admin') {
    return 'Manajemen operasional bottleneck, beban kerja tim, dan penugasan backlog tugas.'
  }
  if (role === 'member') {
    return 'Fokus produktivitas tugas harian, batas waktu terdekat, dan evaluasi hasil kerja Anda.'
  }
  return 'Tinjauan observabilitas kemajuan umum dan milestone proyek tanpa hak modifikasi.'
}

// -----------------------------------------------------------------------------
// Chart Configurations
// -----------------------------------------------------------------------------
const velocityChartSeries = computed(() => [
  {
    name: 'Tugas Dibuat',
    data: [2, 4, 3, 5, 4, 6, taskStore.tasks.length],
  },
  {
    name: 'Tugas Selesai',
    data: [1, 2, 3, 3, 4, 5, taskStore.completedTasks.length],
  },
])

const velocityChartOptions = computed(() => ({
  chart: {
    type: 'area',
    toolbar: { show: false },
    fontFamily: 'inherit',
  },
  colors: ['#465fff', '#10b981'],
  stroke: { curve: 'smooth', width: 2 },
  xaxis: {
    categories: ['26 Ags', '27 Ags', '28 Ags', '29 Ags', '30 Ags', '31 Ags', '1 Sep'],
  },
  legend: { position: 'top' },
}))

const projectStatusChartSeries = computed(() => [
  projectStore.activeProjectsCount || 1,
  projectStore.planningProjectsCount || 1,
  projectStore.completedProjectsCount || 0,
])

const projectStatusChartOptions = computed(() => ({
  chart: { type: 'donut', fontFamily: 'inherit' },
  labels: ['Aktif', 'Perencanaan', 'Selesai'],
  colors: ['#465fff', '#f59e0b', '#10b981'],
  legend: { position: 'bottom' },
}))

const workloadChartSeries = computed(() => [
  {
    name: 'Jumlah Tugas Aktif',
    data: workspaceStore.members.map((m) => {
      return taskStore.tasks.filter((t) => t.assigned_to === m.user_id && t.status !== 'completed').length || 1
    }),
  },
])

const workloadChartOptions = computed(() => ({
  chart: { type: 'bar', toolbar: { show: false }, fontFamily: 'inherit' },
  xaxis: {
    categories: workspaceStore.members.map((m) => m.profile?.full_name?.split(' ')[0] || 'Member'),
  },
  colors: ['#465fff'],
  plotOptions: { bar: { borderRadius: 4, columnWidth: '40%' } },
}))

const priorityChartSeries = computed(() => [
  {
    name: 'Tugas',
    data: [
      taskStore.tasks.filter((t) => t.priority === 'urgent').length,
      taskStore.tasks.filter((t) => t.priority === 'high').length,
      taskStore.tasks.filter((t) => t.priority === 'medium').length,
      taskStore.tasks.filter((t) => t.priority === 'low').length,
    ],
  },
])

const priorityChartOptions = computed(() => ({
  chart: { type: 'bar', toolbar: { show: false }, fontFamily: 'inherit' },
  xaxis: { categories: ['Urgent', 'High', 'Medium', 'Low'] },
  colors: ['#ef4444', '#f59e0b', '#465fff', '#9ca3af'],
  plotOptions: { bar: { borderRadius: 4, distributed: true } },
  legend: { show: false },
}))

const myStatusChartSeries = computed(() => [
  myTasks.value.filter((t) => t.status === 'todo').length,
  myTasks.value.filter((t) => t.status === 'in_progress').length,
  myTasks.value.filter((t) => t.status === 'review').length,
  myTasks.value.filter((t) => t.status === 'completed').length,
])

const myStatusChartOptions = computed(() => ({
  chart: { type: 'donut', fontFamily: 'inherit' },
  labels: ['Todo', 'In Progress', 'Review', 'Completed'],
  colors: ['#9ca3af', '#465fff', '#f59e0b', '#10b981'],
  legend: { position: 'bottom' },
}))

// -----------------------------------------------------------------------------
// Table Configuration
// -----------------------------------------------------------------------------
const taskColumns: TableColumn[] = [
  { key: 'title', label: 'Judul Tugas & Proyek' },
  { key: 'status', label: 'Status', align: 'center', class: 'w-32' },
  { key: 'priority', label: 'Prioritas', align: 'center', class: 'w-28' },
  { key: 'assignee', label: 'Ditugaskan Ke', class: 'w-44' },
]

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
