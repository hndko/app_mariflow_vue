<template>
  <div class="w-full">
    <label v-if="label" class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-300">
      {{ label }}
      <span v-if="required" class="text-error-500">*</span>
    </label>
    <div class="relative flex items-center">
      <!-- Prefix Icon / Icon Group Left -->
      <span
        v-if="$slots.prefix || prefixIcon"
        class="absolute left-0 top-1/2 -translate-y-1/2 flex items-center justify-center pl-3.5 pr-2.5 text-gray-400 dark:text-gray-500 pointer-events-none z-10"
      >
        <slot name="prefix">
          <component :is="prefixIcon" class="w-5 h-5" />
        </slot>
      </span>

      <!-- Select Dropdown -->
      <select
        :id="id"
        :value="modelValue"
        :disabled="disabled"
        :required="required"
        :class="[
          'h-11 w-full appearance-none rounded-lg border bg-transparent py-2.5 pr-10 text-sm text-gray-800 shadow-theme-xs transition focus:outline-hidden focus:ring-3 dark:bg-gray-900 dark:text-white/90',
          $slots.prefix || prefixIcon ? 'pl-11' : 'pl-4',
          errorMessage
            ? 'border-error-300 focus:border-error-500 focus:ring-error-500/10 dark:border-error-700'
            : 'border-gray-300 focus:border-brand-300 focus:ring-brand-500/10 dark:border-gray-700 dark:focus:border-brand-800',
          disabled ? 'opacity-50 cursor-not-allowed bg-gray-50 dark:bg-gray-800' : '',
        ]"
        @change="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
      >
        <option v-if="placeholder" value="" disabled :selected="!modelValue">
          {{ placeholder }}
        </option>
        <slot>
          <option
            v-for="opt in options"
            :key="opt.value"
            :value="opt.value"
          >
            {{ opt.label }}
          </option>
        </slot>
      </select>

      <!-- Chevron Icon -->
      <span class="absolute right-0 top-1/2 -translate-y-1/2 flex items-center justify-center pr-3.5 pointer-events-none text-gray-400 dark:text-gray-500">
        <svg class="w-4 h-4 stroke-current" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M5 7.5L10 12.5L15 7.5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </span>
    </div>

    <!-- Error / Helper Message -->
    <p v-if="errorMessage" class="mt-1.5 text-xs text-error-500">
      {{ errorMessage }}
    </p>
    <p v-else-if="hint" class="mt-1.5 text-xs text-gray-500 dark:text-gray-400">
      {{ hint }}
    </p>
  </div>
</template>

<script setup lang="ts">
interface SelectOption {
  value: string | number
  label: string
}

interface BaseSelectProps {
  modelValue?: string | number
  label?: string
  placeholder?: string
  id?: string
  required?: boolean
  disabled?: boolean
  prefixIcon?: object | Function
  options?: SelectOption[]
  errorMessage?: string
  hint?: string
}

withDefaults(defineProps<BaseSelectProps>(), {
  modelValue: '',
  label: '',
  placeholder: 'Pilih salah satu...',
  id: undefined,
  required: false,
  disabled: false,
  prefixIcon: undefined,
  options: () => [],
  errorMessage: '',
  hint: '',
})

defineEmits(['update:modelValue'])
</script>
