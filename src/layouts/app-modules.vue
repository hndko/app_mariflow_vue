<template>
  <div class="min-h-screen xl:flex bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100">
    <app-sidebar />
    <Backdrop />
    <div
      class="flex-1 transition-all duration-300 ease-in-out flex flex-col min-w-0"
      :class="[isExpanded || isHovered ? 'lg:ml-[290px]' : 'lg:ml-[90px]']"
    >
      <app-header />
      <main class="flex-1 p-4 mx-auto max-w-(--breakpoint-2xl) w-full md:p-6 lg:p-8">
        <slot></slot>
      </main>
      <footer class="border-t border-gray-200 dark:border-gray-800 py-4 px-6 text-center text-xs text-gray-500 dark:text-gray-400">
        <p>&copy; {{ new Date().getFullYear() }} MariFlow SaaS — Simple Workspace & Task Management (Mari Partner)</p>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import AppSidebar from '@/components/layout/AppSidebar.vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import Backdrop from '@/components/layout/Backdrop.vue'
import { useSidebar } from '@/composables/useSidebar'

const { isExpanded, isHovered } = useSidebar()
</script>
