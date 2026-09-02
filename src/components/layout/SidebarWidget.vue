<template>
  <div
    class="mx-auto mb-6 w-full max-w-60 rounded-2xl bg-gray-50/90 dark:bg-white/[0.03] border border-gray-100 dark:border-gray-800/80 p-4 text-center transition-colors"
  >
    <div class="flex items-center justify-center gap-2 mb-1.5">
      <span class="w-2 h-2 rounded-full bg-success-500 animate-pulse"></span>
      <h4 class="text-xs font-semibold text-gray-900 dark:text-white">{{ APP_CONFIG.name }} SaaS</h4>
    </div>
    <p class="text-[11px] text-gray-500 dark:text-gray-400 mb-3">
      {{ APP_CONFIG.tagline }}
    </p>
    <div class="inline-flex items-center justify-center px-2.5 py-1 rounded-full text-[11px] font-semibold bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400 border border-brand-200/50 dark:border-brand-500/20">
      v{{ APP_CONFIG.version }} ({{ APP_CONFIG.releaseName }})
    </div>
  </div>
</template>

<script setup lang="ts">
import { APP_CONFIG } from '@/config/app'
</script>
