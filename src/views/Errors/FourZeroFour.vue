<template>
  <div
    class="relative flex flex-col items-center justify-center min-h-screen p-6 overflow-hidden z-1 bg-gray-50 dark:bg-gray-900"
  >
    <!-- Centered Content -->
    <div class="mx-auto w-full max-w-[242px] text-center sm:max-w-[472px]">
      <div class="flex items-center justify-center gap-2 mb-4">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-500 text-white font-bold text-xl shadow-theme-xs">
          M
        </div>
        <span class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
      </div>

      <h1
        class="mb-4 font-bold text-gray-800 text-4xl dark:text-white sm:text-6xl"
      >
        404
      </h1>

      <p
        class="mb-6 text-base text-gray-600 dark:text-gray-400 sm:text-lg"
      >
        Halaman yang Anda cari tidak ditemukan atau telah dipindahkan.
      </p>

      <router-link
        to="/dashboard"
        class="inline-flex items-center justify-center gap-2 rounded-lg bg-brand-500 px-6 py-3 text-sm font-semibold text-white shadow-theme-xs hover:bg-brand-600 transition"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
        Kembali ke Dashboard
      </router-link>
    </div>

    <!-- Footer -->
    <p
      class="absolute text-xs text-center text-gray-400 bottom-6 left-1/2 -translate-x-1/2 dark:text-gray-500"
    >
      &copy; {{ currentYear }} MariFlow SaaS — Simple Workspace & Task Management
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const currentYear = ref(new Date().getFullYear())
</script>
