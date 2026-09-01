<template>
  <div class="w-full space-y-1.5">
    <label
      v-if="label"
      :for="id"
      class="block text-xs font-semibold text-gray-700 dark:text-gray-300"
    >
      {{ label }}
      <span v-if="required" class="text-error-500">*</span>
    </label>

    <div class="relative flex items-center rounded-lg">
      <!-- Prefix Icon Slot / Prop -->
      <div
        v-if="$slots.prefix || prefixIcon"
        class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-400"
      >
        <slot name="prefix">
          <component :is="prefixIcon" class="w-5 h-5" />
        </slot>
      </div>

      <!-- Native Select -->
      <select
        :id="id"
        :value="modelValue"
        :disabled="disabled"
        :required="required"
        :class="[
          'w-full rounded-lg border text-sm transition-colors duration-150 appearance-none focus:outline-hidden',
          'bg-white dark:bg-gray-900 text-gray-900 dark:text-white',
          $slots.prefix || prefixIcon ? 'pl-10' : 'pl-3.5',
          'pr-10',
          error
            ? 'border-error-500 focus:border-error-500 focus:ring-2 focus:ring-error-500/20'
            : 'border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/10 dark:focus:border-brand-400',
          disabled ? 'opacity-60 cursor-not-allowed bg-gray-50 dark:bg-gray-800' : 'cursor-pointer',
          sizeClasses[size],
        ]"
        @change="onChange"
      >
        <option v-if="placeholder" value="" disabled :selected="!modelValue">
          {{ placeholder }}
        </option>
        <option
          v-for="opt in options"
          :key="String(opt.value)"
          :value="opt.value"
        >
          {{ opt.label }}
        </option>
      </select>

      <!-- Dropdown Chevron Suffix -->
      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-gray-400">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </div>
    </div>

    <!-- Error / Hint Message -->
    <p v-if="error" class="text-xs text-error-500 mt-1">
      {{ error }}
    </p>
    <p v-else-if="hint" class="text-xs text-gray-400 dark:text-gray-500 mt-1">
      {{ hint }}
    </p>
  </div>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

export interface SelectOption {
  value: string | number
  label: string
}

interface BaseSelectProps {
  modelValue?: string | number | null
  options: SelectOption[]
  id?: string
  label?: string
  placeholder?: string
  disabled?: boolean
  required?: boolean
  error?: string
  hint?: string
  size?: 'sm' | 'md' | 'lg'
  prefixIcon?: Component | object
}

withDefaults(defineProps<BaseSelectProps>(), {
  modelValue: '',
  id: () => `select-${Math.random().toString(36).substring(2, 9)}`,
  label: '',
  placeholder: '',
  disabled: false,
  required: false,
  error: '',
  hint: '',
  size: 'md',
  prefixIcon: undefined,
})

const emit = defineEmits(['update:modelValue', 'change'])

const sizeClasses = {
  sm: 'py-1.5 text-xs',
  md: 'py-2.5 text-sm',
  lg: 'py-3.5 text-base',
}

const onChange = (event: Event) => {
  const target = event.target as HTMLSelectElement
  emit('update:modelValue', target.value)
  emit('change', target.value)
}
</script>
