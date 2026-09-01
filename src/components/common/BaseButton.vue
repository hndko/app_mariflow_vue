<template>
  <button
    :type="type"
    :disabled="disabled || loading"
    :title="title || ariaLabel || text"
    :aria-label="ariaLabel || title || text"
    :class="[
      'inline-flex items-center justify-center font-semibold transition-all duration-150 focus:outline-hidden focus:ring-3 select-none',
      isIconOnly ? iconSizeClasses[size] : sizeClasses[size],
      variantClasses[variant],
      rounded ? 'rounded-full' : 'rounded-lg',
      disabled ? 'opacity-50 cursor-not-allowed shadow-none' : 'cursor-pointer',
      customClass,
    ]"
    @click="handleClick"
  >
    <!-- Loading Spinner -->
    <svg
      v-if="loading"
      class="animate-spin -ml-0.5 mr-2 h-4 w-4 text-current"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle
        class="opacity-25"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        stroke-width="4"
      ></circle>
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      ></path>
    </svg>

    <!-- Icon-Only Button Content -->
    <template v-if="isIconOnly">
      <slot name="icon">
        <component :is="icon" v-if="icon" class="w-4 h-4" />
      </slot>
    </template>

    <!-- Standard Button Content (Icon + Text) -->
    <template v-else>
      <span v-if="$slots.startIcon || startIcon" class="shrink-0">
        <slot name="startIcon">
          <component :is="startIcon" class="w-4 h-4" />
        </slot>
      </span>
      <span v-if="text || $slots.default">
        <slot>{{ text }}</slot>
      </span>
      <span v-if="$slots.endIcon || endIcon" class="shrink-0">
        <slot name="endIcon">
          <component :is="endIcon" class="w-4 h-4" />
        </slot>
      </span>
    </template>
  </button>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

interface BaseButtonProps {
  variant?: 'primary' | 'secondary' | 'outline' | 'danger' | 'ghost' | 'success'
  size?: 'sm' | 'md' | 'lg' | 'icon-sm' | 'icon-md'
  type?: 'button' | 'submit' | 'reset'
  text?: string
  startIcon?: Component | object
  endIcon?: Component | object
  icon?: Component | object
  isIconOnly?: boolean
  disabled?: boolean
  loading?: boolean
  rounded?: boolean
  title?: string
  ariaLabel?: string
  customClass?: string
}

const props = withDefaults(defineProps<BaseButtonProps>(), {
  variant: 'primary',
  size: 'md',
  type: 'button',
  text: '',
  startIcon: undefined,
  endIcon: undefined,
  icon: undefined,
  isIconOnly: false,
  disabled: false,
  loading: false,
  rounded: false,
  title: '',
  ariaLabel: '',
  customClass: '',
})

const emit = defineEmits(['click'])

const sizeClasses = {
  sm: 'px-3 py-1.5 text-xs gap-1.5',
  md: 'px-4 py-2.5 text-sm gap-2',
  lg: 'px-5 py-3 text-base gap-2.5',
  'icon-sm': 'p-1.5 text-xs',
  'icon-md': 'p-2.5 text-sm',
}

const iconSizeClasses = {
  sm: 'w-8 h-8 p-1.5',
  md: 'w-9 h-9 p-2',
  lg: 'w-11 h-11 p-2.5',
  'icon-sm': 'w-8 h-8 p-1.5',
  'icon-md': 'w-9 h-9 p-2',
}

const variantClasses = {
  primary:
    'bg-brand-500 text-white shadow-theme-xs hover:bg-brand-600 focus:ring-brand-500/20 active:bg-brand-700 dark:bg-brand-500 dark:hover:bg-brand-600',
  secondary:
    'bg-gray-100 text-gray-800 hover:bg-gray-200 focus:ring-gray-300 dark:bg-gray-800 dark:text-gray-200 dark:hover:bg-gray-700',
  outline:
    'border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 dark:hover:bg-gray-800',
  danger:
    'bg-error-500 text-white shadow-theme-xs hover:bg-error-600 focus:ring-error-500/20 active:bg-error-700 dark:bg-error-500 dark:hover:bg-error-600',
  ghost:
    'bg-transparent text-gray-600 hover:bg-gray-100 hover:text-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white',
  success:
    'bg-success-500 text-white shadow-theme-xs hover:bg-success-600 focus:ring-success-500/20 active:bg-success-700',
}

const handleClick = (e: MouseEvent) => {
  if (!props.disabled && !props.loading) {
    emit('click', e)
  }
}
</script>
