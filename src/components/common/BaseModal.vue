<template>
  <Teleport to="body">
    <transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="isOpen"
        class="fixed inset-0 z-99999 flex items-center justify-center p-4 overflow-y-auto"
      >
        <!-- Backdrop with Blur -->
        <div
          class="fixed inset-0 bg-gray-900/60 backdrop-blur-xs transition-opacity"
          aria-hidden="true"
          @click="onBackdropClick"
        ></div>

        <!-- Modal Dialog Box -->
        <div
          :class="[
            'relative w-full overflow-hidden rounded-2xl bg-white text-left shadow-2xl transition-all dark:bg-gray-900 border border-gray-100 dark:border-gray-800',
            maxWidthClasses[maxWidth],
          ]"
        >
          <!-- Header -->
          <div class="flex items-center justify-between border-b border-gray-100 px-6 py-4 dark:border-gray-800">
            <h3 class="text-base font-semibold text-gray-900 dark:text-white">
              <slot name="title">{{ title }}</slot>
            </h3>
            <button
              type="button"
              class="rounded-lg p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-600 dark:hover:bg-gray-800 dark:hover:text-gray-300 transition"
              @click="$emit('close')"
            >
              <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>
          </div>

          <!-- Body Content -->
          <div class="px-6 py-5">
            <slot></slot>
          </div>

          <!-- Footer Actions -->
          <div
            v-if="$slots.footer"
            class="flex items-center justify-end gap-3 border-t border-gray-100 bg-gray-50/50 px-6 py-4 dark:border-gray-800 dark:bg-gray-800/30"
          >
            <slot name="footer"></slot>
          </div>
        </div>
      </div>
    </transition>
  </Teleport>
</template>

<script setup lang="ts">
interface BaseModalProps {
  isOpen: boolean
  title?: string
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl'
  closeOnBackdrop?: boolean
}

const props = withDefaults(defineProps<BaseModalProps>(), {
  isOpen: false,
  title: '',
  maxWidth: 'lg',
  closeOnBackdrop: true,
})

const emit = defineEmits(['close'])

const maxWidthClasses = {
  sm: 'max-w-sm',
  md: 'max-w-md',
  lg: 'max-w-lg',
  xl: 'max-w-xl',
  '2xl': 'max-w-2xl',
}

const onBackdropClick = () => {
  if (props.closeOnBackdrop) {
    emit('close')
  }
}
</script>
