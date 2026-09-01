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

      <!-- Native Input -->
      <input
        :id="id"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :required="required"
        :class="[
          'w-full rounded-lg border text-sm transition-colors duration-150 focus:outline-hidden',
          'bg-white dark:bg-gray-900 text-gray-900 dark:text-white',
          'placeholder:text-gray-400 dark:placeholder:text-gray-500',
          $slots.prefix || prefixIcon ? 'pl-10' : 'pl-3.5',
          $slots.suffix || suffixIcon ? 'pr-10' : 'pr-3.5',
          error
            ? 'border-error-500 focus:border-error-500 focus:ring-2 focus:ring-error-500/20'
            : 'border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/10 dark:focus:border-brand-400',
          disabled ? 'opacity-60 cursor-not-allowed bg-gray-50 dark:bg-gray-800' : '',
          sizeClasses[size],
        ]"
        @input="onInput"
        @blur="emit('blur', $event)"
        @focus="emit('focus', $event)"
      />

      <!-- Suffix Icon Slot / Prop -->
      <div
        v-if="$slots.suffix || suffixIcon"
        class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-gray-400"
      >
        <slot name="suffix">
          <component :is="suffixIcon" class="w-5 h-5" />
        </slot>
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

interface BaseInputProps {
  modelValue?: string | number | null
  id?: string
  label?: string
  type?: string
  placeholder?: string
  disabled?: boolean
  required?: boolean
  error?: string
  hint?: string
  size?: 'sm' | 'md' | 'lg'
  prefixIcon?: Component | object
  suffixIcon?: Component | object
}

withDefaults(defineProps<BaseInputProps>(), {
  modelValue: '',
  id: () => `input-${Math.random().toString(36).substring(2, 9)}`,
  label: '',
  type: 'text',
  placeholder: '',
  disabled: false,
  required: false,
  error: '',
  hint: '',
  size: 'md',
  prefixIcon: undefined,
  suffixIcon: undefined,
})

const emit = defineEmits(['update:modelValue', 'blur', 'focus'])

const sizeClasses = {
  sm: 'py-1.5 text-xs',
  md: 'py-2.5 text-sm',
  lg: 'py-3.5 text-base',
}

const onInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value)
}
</script>
