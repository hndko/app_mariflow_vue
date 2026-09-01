<template>
  <span
    :class="[
      'inline-flex items-center gap-1.5 rounded-full font-medium',
      sizeClasses[size],
      variantClasses[variant],
    ]"
  >
    <span
      v-if="dot"
      :class="['h-1.5 w-1.5 rounded-full', dotClasses[variant]]"
    ></span>
    <slot name="icon">
      <component :is="icon" v-if="icon" class="w-3.5 h-3.5" />
    </slot>
    <slot>{{ text }}</slot>
  </span>
</template>

<script setup lang="ts">
interface BaseBadgeProps {
  variant?: 'primary' | 'success' | 'warning' | 'error' | 'info' | 'gray'
  size?: 'sm' | 'md'
  text?: string
  dot?: boolean
  icon?: object | Function
}

withDefaults(defineProps<BaseBadgeProps>(), {
  variant: 'gray',
  size: 'md',
  text: '',
  dot: false,
  icon: undefined,
})

const sizeClasses = {
  sm: 'px-2 py-0.5 text-theme-xs',
  md: 'px-2.5 py-1 text-xs',
}

const variantClasses = {
  primary: 'bg-brand-50 text-brand-700 dark:bg-brand-500/15 dark:text-brand-400',
  success: 'bg-success-50 text-success-700 dark:bg-success-500/15 dark:text-success-400',
  warning: 'bg-warning-50 text-warning-700 dark:bg-warning-500/15 dark:text-warning-400',
  error: 'bg-error-50 text-error-700 dark:bg-error-500/15 dark:text-error-400',
  info: 'bg-blue-50 text-blue-700 dark:bg-blue-500/15 dark:text-blue-400',
  gray: 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
}

const dotClasses = {
  primary: 'bg-brand-500',
  success: 'bg-success-500',
  warning: 'bg-warning-500',
  error: 'bg-error-500',
  info: 'bg-blue-500',
  gray: 'bg-gray-500',
}
</script>
