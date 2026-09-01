<template>
  <div class="w-full">
    <label v-if="label" class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-300">
      {{ label }}
      <span v-if="required" class="text-error-500">*</span>
    </label>
    <div class="relative">
      <textarea
        :id="id"
        :value="modelValue"
        :placeholder="placeholder"
        :rows="rows"
        :disabled="disabled"
        :readonly="readonly"
        :required="required"
        :class="[
          'w-full rounded-lg border bg-transparent p-3.5 text-sm text-gray-800 shadow-theme-xs transition placeholder:text-gray-400 focus:outline-hidden focus:ring-3 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30',
          errorMessage
            ? 'border-error-300 focus:border-error-500 focus:ring-error-500/10 dark:border-error-700'
            : 'border-gray-300 focus:border-brand-300 focus:ring-brand-500/10 dark:border-gray-700 dark:focus:border-brand-800',
          disabled ? 'opacity-50 cursor-not-allowed bg-gray-50 dark:bg-gray-800' : '',
        ]"
        @input="$emit('update:modelValue', ($event.target as HTMLTextAreaElement).value)"
        @blur="$emit('blur', $event)"
        @focus="$emit('focus', $event)"
      ></textarea>
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
interface BaseTextareaProps {
  modelValue?: string
  label?: string
  placeholder?: string
  rows?: number
  id?: string
  required?: boolean
  disabled?: boolean
  readonly?: boolean
  errorMessage?: string
  hint?: string
}

withDefaults(defineProps<BaseTextareaProps>(), {
  modelValue: '',
  label: '',
  placeholder: '',
  rows: 3,
  id: undefined,
  required: false,
  disabled: false,
  readonly: false,
  errorMessage: '',
  hint: '',
})

defineEmits(['update:modelValue', 'blur', 'focus'])
</script>
