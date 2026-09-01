import Swal, { type SweetAlertIcon, type SweetAlertResult } from 'sweetalert2'

/**
 * Check if the application is currently in dark mode
 */
const isDarkMode = (): boolean => {
  return (
    document.documentElement.classList.contains('dark') ||
    localStorage.getItem('theme') === 'dark'
  )
}

/**
 * Common color palette matching TailAdmin / MariFlow theme
 */
const getThemeColors = () => {
  const dark = isDarkMode()
  return {
    background: dark ? '#101828' : '#ffffff',
    color: dark ? '#f9fafb' : '#1d2939',
    confirmButtonColor: '#465fff', // brand-500
    cancelButtonColor: dark ? '#344054' : '#98a2b3', // gray-700 / gray-400
    dangerColor: '#f04438', // error-500
  }
}

/**
 * Base Toast Config (Top-Right Floating Notification)
 */
const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3500,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.onmouseenter = Swal.stopTimer
    toast.onmouseleave = Swal.resumeTimer
  },
})

/**
 * Toast Notification Helper (Alert Biasa)
 */
export const showToast = {
  success(message: string, title?: string) {
    const colors = getThemeColors()
    return Toast.fire({
      icon: 'success',
      title: title || message,
      text: title ? message : undefined,
      background: colors.background,
      color: colors.color,
      customClass: {
        popup: 'mariflow-toast shadow-theme-lg rounded-xl border border-gray-200 dark:border-gray-800',
      },
    })
  },

  error(message: string, title?: string) {
    const colors = getThemeColors()
    return Toast.fire({
      icon: 'error',
      title: title || message,
      text: title ? message : undefined,
      background: colors.background,
      color: colors.color,
      customClass: {
        popup: 'mariflow-toast shadow-theme-lg rounded-xl border border-gray-200 dark:border-gray-800',
      },
    })
  },

  warning(message: string, title?: string) {
    const colors = getThemeColors()
    return Toast.fire({
      icon: 'warning',
      title: title || message,
      text: title ? message : undefined,
      background: colors.background,
      color: colors.color,
      customClass: {
        popup: 'mariflow-toast shadow-theme-lg rounded-xl border border-gray-200 dark:border-gray-800',
      },
    })
  },

  info(message: string, title?: string) {
    const colors = getThemeColors()
    return Toast.fire({
      icon: 'info',
      title: title || message,
      text: title ? message : undefined,
      background: colors.background,
      color: colors.color,
      customClass: {
        popup: 'mariflow-toast shadow-theme-lg rounded-xl border border-gray-200 dark:border-gray-800',
      },
    })
  },
}

export interface ConfirmOptions {
  title: string
  text: string
  confirmText?: string
  cancelText?: string
  icon?: SweetAlertIcon
  isDanger?: boolean
}

/**
 * SweetAlert Confirmation Dialog (Alert Confirm)
 * Returns Promise<boolean> -> true if confirmed, false if cancelled
 */
export const showConfirm = async (options: ConfirmOptions): Promise<boolean> => {
  const colors = getThemeColors()
  const {
    title,
    text,
    confirmText = options.isDanger ? 'Ya, Hapus' : 'Ya, Lanjutkan',
    cancelText = 'Batal',
    icon = options.isDanger ? 'warning' : 'question',
    isDanger = false,
  } = options

  const result: SweetAlertResult = await Swal.fire({
    title,
    text,
    icon,
    showCancelButton: true,
    confirmButtonText: confirmText,
    cancelButtonText: cancelText,
    confirmButtonColor: isDanger ? colors.dangerColor : colors.confirmButtonColor,
    cancelButtonColor: colors.cancelButtonColor,
    background: colors.background,
    color: colors.color,
    reverseButtons: true,
    focusCancel: true,
    customClass: {
      popup: 'mariflow-swal-popup rounded-2xl p-6 shadow-theme-xl border border-gray-200 dark:border-gray-800',
      title: 'text-lg font-bold text-gray-900 dark:text-white',
      htmlContainer: 'text-sm text-gray-600 dark:text-gray-300',
      confirmButton:
        'px-4 py-2.5 rounded-lg text-sm font-semibold text-white shadow-theme-xs transition focus:outline-none',
      cancelButton:
        'px-4 py-2.5 rounded-lg text-sm font-semibold text-gray-700 bg-gray-100 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700 transition focus:outline-none mr-3',
    },
  })

  return result.isConfirmed
}

/**
 * SweetAlert Success Modal Helper
 */
export const showSuccessModal = (title: string, text?: string) => {
  const colors = getThemeColors()
  return Swal.fire({
    title,
    text,
    icon: 'success',
    confirmButtonText: 'Tutup',
    confirmButtonColor: colors.confirmButtonColor,
    background: colors.background,
    color: colors.color,
    customClass: {
      popup: 'mariflow-swal-popup rounded-2xl p-6 shadow-theme-xl border border-gray-200 dark:border-gray-800',
    },
  })
}

/**
 * SweetAlert Error Modal Helper
 */
export const showErrorModal = (title: string, text?: string) => {
  const colors = getThemeColors()
  return Swal.fire({
    title,
    text,
    icon: 'error',
    confirmButtonText: 'Tutup',
    confirmButtonColor: colors.dangerColor,
    background: colors.background,
    color: colors.color,
    customClass: {
      popup: 'mariflow-swal-popup rounded-2xl p-6 shadow-theme-xl border border-gray-200 dark:border-gray-800',
    },
  })
}

export function useAlert() {
  return {
    toast: showToast,
    confirm: showConfirm,
    successModal: showSuccessModal,
    errorModal: showErrorModal,
  }
}
