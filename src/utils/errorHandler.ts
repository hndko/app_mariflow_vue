/**
 * ==============================================================================
 * MariFlow SaaS — Centralized Custom Error Handler & Sanitizer
 * ==============================================================================
 * Mengonversi seluruh raw database stack trace, Supabase Auth errors, PostgreSQL RLS,
 * dan Network exceptions menjadi pesan Bahasa Indonesia yang ramah, sopan, dan informatif.
 */

export interface AppErrorOptions {
  fallbackMessage?: string
  context?: string
}

/**
 * Menerjemahkan dan membersihkan segala jenis error menjadi pesan pengguna yang ramah
 */
export function getCustomErrorMessage(
  error: unknown,
  fallbackMessage: string = 'Terjadi kendala pada sistem. Silakan coba beberapa saat lagi.'
): string {
  if (!error) return fallbackMessage

  const rawMessage = typeof error === 'string' 
    ? error 
    : (error as any)?.message || (error as any)?.error_description || (error as any)?.msg || ''

  const errorCode = (error as any)?.code || (error as any)?.statusCode || (error as any)?.status || ''
  const errorDetails = (error as any)?.details || ''
  const errorHint = (error as any)?.hint || ''

  const fullErrorStr = `${rawMessage} ${errorCode} ${errorDetails} ${errorHint}`.toLowerCase()

  // 1. Supabase Authentication Errors
  if (
    fullErrorStr.includes('invalid login credentials') ||
    fullErrorStr.includes('invalid_credentials') ||
    fullErrorStr.includes('invalid email or password')
  ) {
    return 'Email atau kata sandi yang Anda masukkan salah. Silakan periksa kembali.'
  }

  if (
    fullErrorStr.includes('email not confirmed') ||
    fullErrorStr.includes('email_not_confirmed')
  ) {
    return 'Alamat email Anda belum dikonfirmasi. Silakan periksa kotak masuk atau folder spam email Anda untuk verifikasi.'
  }

  if (
    fullErrorStr.includes('user already registered') ||
    fullErrorStr.includes('email_exists') ||
    fullErrorStr.includes('already exists')
  ) {
    return 'Alamat email ini sudah terdaftar di MariFlow. Silakan masuk menggunakan akun tersebut atau gunakan email lain.'
  }

  if (
    fullErrorStr.includes('password should be at least') ||
    fullErrorStr.includes('weak_password') ||
    fullErrorStr.includes('password is too short')
  ) {
    return 'Kata sandi harus terdiri dari minimal 6 karakter demi keamanan akun Anda.'
  }

  if (
    fullErrorStr.includes('user not found') ||
    fullErrorStr.includes('user_not_found')
  ) {
    return 'Akun pengguna dengan data tersebut tidak ditemukan dalam sistem.'
  }

  if (
    fullErrorStr.includes('rate limit') ||
    fullErrorStr.includes('over_email_send_rate_limit') ||
    fullErrorStr.includes('too many requests')
  ) {
    return 'Terlalu banyak permintaan dalam waktu singkat. Mohon tunggu beberapa menit sebelum mencoba kembali.'
  }

  if (
    fullErrorStr.includes('session missing') ||
    fullErrorStr.includes('jwt expired') ||
    fullErrorStr.includes('token is expired') ||
    fullErrorStr.includes('auth session missing')
  ) {
    return 'Sesi login Anda telah berakhir. Silakan masuk kembali ke akun Anda.'
  }

  if (fullErrorStr.includes('same password') || fullErrorStr.includes('new password should be different')) {
    return 'Kata sandi baru tidak boleh sama dengan kata sandi Anda saat ini.'
  }

  // 2. PostgreSQL & PostgREST Database Errors
  if (errorCode === '23505' || fullErrorStr.includes('duplicate key value') || fullErrorStr.includes('unique constraint')) {
    if (fullErrorStr.includes('workspace_members')) {
      return 'Pengguna ini sudah terdaftar sebagai anggota di workspace ini.'
    }
    if (fullErrorStr.includes('slug')) {
      return 'Nama atau pengenal ini sudah digunakan. Silakan gunakan nama lain yang unik.'
    }
    return 'Data dengan informasi ini sudah ada dalam sistem (duplikat). Silakan periksa kembali data Anda.'
  }

  if (errorCode === '23503' || fullErrorStr.includes('foreign key constraint')) {
    return 'Operasi tidak dapat diproses karena data referensi terkait (proyek, tugas, atau workspace) tidak ditemukan atau telah dihapus.'
  }

  if (errorCode === '23502' || fullErrorStr.includes('null value in column')) {
    return 'Mohon lengkapi seluruh kolom formulir yang wajib diisi.'
  }

  if (
    errorCode === '42501' ||
    fullErrorStr.includes('row-level security') ||
    fullErrorStr.includes('permission denied') ||
    fullErrorStr.includes('violates row-level security policy')
  ) {
    return 'Akses Ditolak: Anda tidak memiliki izin atau wewenang untuk melakukan tindakan ini pada workspace ini.'
  }

  if (errorCode === 'PGRST116' || fullErrorStr.includes('contains 0 rows')) {
    return 'Data yang Anda cari tidak ditemukan atau telah dihapus dari sistem.'
  }

  if (errorCode === '22P02' || fullErrorStr.includes('invalid input syntax for type uuid')) {
    return 'Format pengenal data tidak valid. Silakan muat ulang halaman formulir.'
  }

  // 3. Storage & File Upload Errors
  if (fullErrorStr.includes('bucket not found') || fullErrorStr.includes('bucket_not_found')) {
    return 'Tempat penyimpanan berkas (storage bucket) belum disiapkan pada database. Hubungi administrator.'
  }

  if (
    fullErrorStr.includes('entity too large') ||
    fullErrorStr.includes('payload too large') ||
    fullErrorStr.includes('file size') ||
    errorCode === 413
  ) {
    return 'Ukuran berkas terlalu besar. Batas maksimal ukuran file adalah 10 MB.'
  }

  if (fullErrorStr.includes('mime type') || fullErrorStr.includes('unsupported media type') || errorCode === 415) {
    return 'Format berkas tidak didukung. Silakan unggah format gambar (PNG, JPG, WEBP) atau dokumen yang valid.'
  }

  // 4. Network & Connection Errors
  if (
    fullErrorStr.includes('failed to fetch') ||
    fullErrorStr.includes('networkerror') ||
    fullErrorStr.includes('network request failed') ||
    fullErrorStr.includes('err_connection_refused') ||
    fullErrorStr.includes('err_internet_disconnected')
  ) {
    return 'Koneksi internet terputus atau server sedang tidak dapat dijangkau. Mohon periksa sambungan internet Anda.'
  }

  if (fullErrorStr.includes('timeout') || fullErrorStr.includes('aborterror')) {
    return 'Waktu permintaan habis (timeout). Silakan periksa jaringan internet Anda dan coba lagi.'
  }

  // 5. If message is already clean Indonesian text, preserve it
  if (rawMessage && !rawMessage.includes('{') && !rawMessage.includes('at ') && !rawMessage.includes('PostgresError')) {
    return rawMessage
  }

  return fallbackMessage
}
