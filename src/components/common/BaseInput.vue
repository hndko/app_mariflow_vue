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
        class="absolute left-0 top-1/2 -translate-y-1/2 flex items-center justify-center pl-3.5 pr-2.5 text-gray-400 dark:text-gray-500 pointer-events-none"
      >
        <slot name="prefix">
          <component :is="prefixIcon" class="w-5 h-5" />
        </slot>
      </span>

      <!-- Input Field -->
      <input
        :id="id"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :required="required"
        :class="[
          'h-11 w-full rounded-lg border bg-transparent py-2.5 text-sm text-gray-800 shadow-theme-xs transition placeholder:text-gray-400 focus:outline-hidden focus:ring-3 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30',
          $slots.prefix || prefixIcon ? 'pl-11' : 'pl-4',
          $slots.suffix || suffixIcon ? 'pr-11' : 'pr-4',
          errorMessage
            ? 'border-error-300 focus:border-error-500 focus:ring-error-500/10 dark:border-error-700'
            : 'border-gray-300 focus:border-brand-300 focus:ring-brand-500/10 dark:border-gray-700 dark:focus:border-brand-800',
          disabled ? 'opacity-50 cursor-not-allowed bg-gray-50 dark:bg-gray-800' : '',
        ]"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        @blur="$emit('blur', $event)"
        @focus="$emit('focus', $event)"
      />

      <!-- Suffix Icon / Icon Group Right -->
      <span
        v-if="$slots.suffix || suffixIcon"
        class="absolute right-0 top-1/2 -translate-y-1/2 flex items-center justify-center pr-3.5 pl-2.5 text-gray-400 dark:text-gray-500"
      >
        <slot name="suffix">
          <component :is="suffixIcon" class="w-5 h-5" />
        </slot>
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
interface BaseInputProps {
  modelValue?: string | number
  label?: string
  placeholder?: string
  type?: string
  id?: string
  required?: boolean
  disabled?: boolean
  readonly?: boolean
  prefixIcon?: object | Function
  suffixIcon?: object | Function
  errorMessage?: string
  hint?: string
}

withDefaults(defineProps<BaseInputProps>(), {
  modelValue: '',
  label: '',
  placeholder: '',
  type: 'text',
  id: undefined,
  required: false,
  disabled: false,
  readonly: false,
  prefixIcon: undefined,
  suffixIcon: undefined,
  errorMessage: '',
  hint: '',
})

defineEmits(['update:modelValue', 'blur', 'focus'])
</script>
