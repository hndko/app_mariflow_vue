<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <div class="flex items-center gap-2">
          <span class="rounded-md bg-emerald-500/10 px-2 py-0.5 text-xs font-bold text-emerald-600 dark:text-emerald-400">
            End-to-End Learning Lab
          </span>
        </div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white mt-1">
          Supabase Lab & Learning Center
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Modul edukasi dan dokumentasi interaktif untuk mempelajari arsitektur Supabase secara mendalam.
        </p>
      </div>
    </div>

    <!-- Lab Navigation Tabs -->
    <div class="flex items-center gap-2 overflow-x-auto custom-scrollbar border-b border-gray-200 dark:border-gray-800 pb-3">
      <button
        v-for="tab in labTabs"
        :key="tab.id"
        type="button"
        :class="[
          'px-3.5 py-2 text-xs font-semibold rounded-lg transition whitespace-nowrap',
          activeTab === tab.id
            ? 'bg-brand-500 text-white shadow-theme-xs'
            : 'bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-300 hover:bg-gray-50 border border-gray-200 dark:border-gray-800',
        ]"
        @click="activeTab = tab.id"
      >
        {{ tab.label }}
      </button>
    </div>

    <!-- Active Tab Content Card -->
    <div class="rounded-2xl border border-gray-200 bg-white p-6 dark:border-gray-800 dark:bg-gray-900 shadow-theme-xs space-y-6">
      <!-- 1. AUTHENTICATION TAB -->
      <div v-if="activeTab === 'auth'" class="space-y-4">
        <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">1. Supabase Authentication</h2>
          <p class="text-sm text-gray-500">Mekanisme pendaftaran, login, refresh token, dan session persistence.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/50 space-y-2">
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Konsep Kunci</h3>
            <ul class="list-disc list-inside space-y-1 text-gray-600 dark:text-gray-400">
              <li>Token JWT terenkripsi dengan payload <code>sub (user_id)</code> dan <code>role (authenticated)</code>.</li>
              <li>Sesi otomatis disimpan di <code>localStorage</code> dan direfresh via auto token refresh.</li>
              <li>Trigger PostgreSQL <code>on_auth_user_created</code> otomatis menyinkronkan data ke tabel <code>profiles</code>.</li>
            </ul>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 text-emerald-400 font-mono text-[11px] overflow-x-auto">
            <p class="text-gray-400">// Contoh Registrasi:</p>
            <p>const { data, error } = await supabase.auth.signUp({</p>
            <p class="pl-4">email: 'user@mariflow.com',</p>
            <p class="pl-4">password: 'Secret123!',</p>
            <p>})</p>
          </div>
        </div>
      </div>

      <!-- 2. ROW LEVEL SECURITY (RLS) TAB -->
      <div v-else-if="activeTab === 'rls'" class="space-y-4">
        <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">2. PostgreSQL Row Level Security (RLS)</h2>
          <p class="text-sm text-gray-500">Keamanan multi-tenant di level database engine tanpa mengandalkan frontend.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/50 space-y-2">
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Prinsip Multi-Tenancy</h3>
            <p class="text-gray-600 dark:text-gray-400">
              Setiap query yang dijalankan client diverifikasi oleh PostgreSQL menggunakan fungsi <code>auth.uid()</code> dan policy <code>is_workspace_member(workspace_id)</code>.
            </p>
            <div class="mt-2">
              <BaseBadge variant="error" text="Dilarang keras: USING (true)" />
            </div>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 text-emerald-400 font-mono text-[11px] overflow-x-auto">
            <p class="text-gray-400">-- Contoh Policy RLS Projects:</p>
            <p>CREATE POLICY "Workspace Isolation"</p>
            <p>ON public.projects FOR SELECT TO authenticated</p>
            <p>USING (public.is_workspace_member(workspace_id));</p>
          </div>
        </div>
      </div>

      <!-- 3. STORAGE TAB -->
      <div v-else-if="activeTab === 'storage'" class="space-y-4">
        <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">3. Supabase Object Storage</h2>
          <p class="text-sm text-gray-500">Pengelolaan bucket file, drag & drop uploader, dan Storage Policies.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/50 space-y-2">
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Struktur Bucket</h3>
            <ul class="list-disc list-inside space-y-1 text-gray-600 dark:text-gray-400">
              <li><code>avatars</code>: Public read, owner update.</li>
              <li><code>task-attachments</code>: Private multi-tenant, akses dibatasi per folder <code>{workspace_id}/</code>.</li>
            </ul>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 text-emerald-400 font-mono text-[11px] overflow-x-auto">
            <p class="text-gray-400">// Upload File:</p>
            <p>await supabase.storage</p>
            <p class="pl-4">.from('task-attachments')</p>
            <p class="pl-4">.upload(filePath, file);</p>
          </div>
        </div>
      </div>

      <!-- 4. REALTIME TAB -->
      <div v-else-if="activeTab === 'realtime'" class="space-y-4">
        <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">4. Supabase Realtime Engine</h2>
          <p class="text-sm text-gray-500">PostgreSQL Change Data Capture (CDC) dan sinkronisasi websocket.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/50 space-y-2">
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Subscription Hygiene</h3>
            <p class="text-gray-600 dark:text-gray-400">
              Setiap channel yang dibuka wajib memiliki handler <code>supabase.removeChannel()</code> pada hook <code>onBeforeUnmount</code> di Vue untuk menghindari memory leak.
            </p>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 text-emerald-400 font-mono text-[11px] overflow-x-auto">
            <p class="text-gray-400">// Realtime Channel:</p>
            <p>supabase.channel('tasks-channel')</p>
            <p class="pl-4">.on('postgres_changes', { event: '*', table: 'tasks' }, handler)</p>
            <p class="pl-4">.subscribe();</p>
          </div>
        </div>
      </div>

      <!-- 5. DATABASE FUNCTIONS & TRIGGERS TAB -->
      <div v-else-if="activeTab === 'functions'" class="space-y-4">
        <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
          <h2 class="text-lg font-bold text-gray-900 dark:text-white">5. Database Functions & Triggers</h2>
          <p class="text-sm text-gray-500">Kompilasi logika agregasi performa tinggi di engine PostgreSQL (RPC).</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/50 space-y-2">
            <h3 class="font-bold text-sm text-gray-800 dark:text-gray-200">Manfaat RPC Function</h3>
            <p class="text-gray-600 dark:text-gray-400">
              Menghitung ringkasan KPI dashboard (total proyek, tugas per status, prioritas, overdue) secara atomik di database tanpa mentransfer ribuan raw record ke browser.
            </p>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 text-emerald-400 font-mono text-[11px] overflow-x-auto">
            <p class="text-gray-400">// Memanggil RPC di Frontend:</p>
            <p>const { data } = await supabase</p>
            <p class="pl-4">.rpc('get_workspace_statistics', { target_ws_id: wsId });</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import BaseBadge from '@/components/common/BaseBadge.vue'

const activeTab = ref('auth')

const labTabs = [
  { id: 'auth', label: '1. Authentication' },
  { id: 'rls', label: '2. Row Level Security (RLS)' },
  { id: 'storage', label: '3. Object Storage' },
  { id: 'realtime', label: '4. Realtime CDC' },
  { id: 'functions', label: '5. RPC Functions & Triggers' },
]
</script>
