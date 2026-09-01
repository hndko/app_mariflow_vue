<template>
  <ThemeProvider>
    <SidebarProvider>
      <component :is="currentLayout">
        <RouterView />
      </component>
    </SidebarProvider>
  </ThemeProvider>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import ThemeProvider from './components/layout/ThemeProvider.vue'
import SidebarProvider from './components/layout/SidebarProvider.vue'
import AppAuthLayout from '@/layouts/app-auth.vue'
import AppModulesLayout from '@/layouts/app-modules.vue'
import AppPublicLayout from '@/layouts/app-public.vue'

const route = useRoute()

const layouts: Record<string, any> = {
  'app-auth': AppAuthLayout,
  'app-modules': AppModulesLayout,
  'app-public': AppPublicLayout,
}

const currentLayout = computed(() => {
  const layoutName = (route.meta?.layout as string) || 'app-modules'
  return layouts[layoutName] || AppModulesLayout
})
</script>
