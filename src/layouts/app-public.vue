<template>
  <div class="min-h-screen flex flex-col bg-white dark:bg-gray-950 text-gray-900 dark:text-gray-100">
    <header class="border-b border-gray-100 dark:border-gray-800 bg-white/80 dark:bg-gray-900/80 backdrop-blur-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2.5">
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-brand-500 text-white font-bold text-lg">
            M
          </div>
          <span class="text-xl font-bold tracking-tight text-gray-900 dark:text-white">MariFlow</span>
        </router-link>
        <div class="flex items-center gap-3">
          <router-link
            to="/login"
            class="text-sm font-medium text-gray-700 hover:text-brand-500 dark:text-gray-300 px-3 py-2 rounded-lg"
          >
            Masuk
          </router-link>
          <router-link
            to="/register"
            class="text-sm font-medium bg-brand-500 hover:bg-brand-600 text-white px-4 py-2 rounded-lg shadow-theme-xs transition"
          >
            Daftar Gratis
          </router-link>
        </div>
      </div>
    </header>

    <main class="flex-1">
      <slot></slot>
    </main>

    <footer class="border-t border-gray-100 dark:border-gray-800 py-8 bg-gray-50 dark:bg-gray-900">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-sm text-gray-500">
        <p>&copy; {{ new Date().getFullYear() }} MariFlow SaaS (Mari Partner). All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// Public / Landing Page Layout
</script>
