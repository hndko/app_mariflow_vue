# 🔔 Standar Alert & Konfirmasi MariFlow SaaS: Toast Alert & SweetAlert2 (`docs/21`)

Dokumen ini menjelaskan implementasi dan panduan penggunaan sistem **Toast Alert** dan **SweetAlert Confirmation Modal** yang telah distandarisasi di seluruh modul aplikasi **MariFlow SaaS** (`app_mariflow_vue`).

---

## 🎯 1. Prinsip Utama

1. **Alert Biasa (Notifikasi Responsif)**:
   - Menggunakan **Toast Alert** mengambang di pojok kanan atas (*Top-End*).
   - Auto-dismiss (3500ms) dilengkapi *progress bar* dan jeda saat kursor mouse diarahkan (*pause on hover*).
   - Menghilangkan banner error/sukses statis yang merusak tata letak form.
2. **Alert Konfirmasi (Aksi Penting & Destruktif)**:
   - Menggunakan **SweetAlert2 Modal** interaktif (`showConfirm()`).
   - Dilengkapi ikon visual animasi (*warning / question / danger*), tombol pembatalan eksplisit, dan styling TailAdmin Dark/Light mode otomatis.
3. **Larangan Baku**:
   - Dilarang keras menggunakan dialog bawaan browser `window.alert()`, `window.confirm()`, atau `window.prompt()`.

---

## 🛠️ 2. Arsitektur & Composable `useAlert` (`src/composables/useAlert.ts`)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                      🔔 MARIFLOW UNIFIED ALERT SYSTEM                       │
├─────────────────────────────────────────────────────────────────────────────┤
│ 🍞 1. TOAST ALERT (Alert Biasa):                                            │
│    - showToast.success(message, title?) ──► Sukses aksi / CRUD / Login      │
│    - showToast.error(message, title?)   ──► Kegagalan API / Validasi        │
│    - showToast.warning(message, title?) ──► Peringatan input / Validasi     │
│    - showToast.info(message, title?)    ──► Informasi status / Navigasi     │
├─────────────────────────────────────────────────────────────────────────────┤
│ 🛡️ 2. SWEETALERT CONFIRM (Konfirmasi Tindakan):                             │
│    - showConfirm({ title, text, confirmText, cancelText, isDanger: true })  │
│      └──► Mengembalikan Promise<boolean> (true jika user klik 'Ya')         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 💻 3. Contoh Penggunaan dalam Kode

### 3.1 Menampilkan Toast Alert
```typescript
import { showToast } from '@/composables/useAlert'

// Notifikasi sukses
showToast.success('Workspace baru berhasil dibuat!')

// Notifikasi error
showToast.error('Gagal menghubungkan ke Supabase. Periksa koneksi Anda.')

// Notifikasi peringatan
showToast.warning('Kata sandi minimal harus 6 karakter.')

// Notifikasi informasi
showToast.info('Beralih ke workspace: Tim Desain')
```

### 3.2 Menampilkan SweetAlert Konfirmasi (Hapus / Tindakan Kritis)
```typescript
import { showConfirm, showToast } from '@/composables/useAlert'

const handleDeleteTask = async (task: Task) => {
  const confirmed = await showConfirm({
    title: 'Hapus Tugas?',
    text: `Apakah Anda yakin ingin menghapus tugas "${task.title}"?`,
    confirmText: 'Ya, Hapus Tugas',
    cancelText: 'Batal',
    isDanger: true, // Warna tombol otomatis merah (danger)
  })

  if (confirmed) {
    try {
      await taskStore.deleteTask(task.id)
      showToast.success(`Tugas "${task.title}" berhasil dihapus.`)
    } catch (err: any) {
      showToast.error('Gagal menghapus tugas.')
    }
  }
}
```

---

## 📋 4. Matriks Implementasi di Seluruh Modul Aplikasi

| Modul & Komponen | Tipe Alert | Trigger Aksi |
| :--- | :--- | :--- |
| **Workspaces (`WorkspaceListView.vue`)** | **SweetAlert Confirm** | Konfirmasi hapus workspace |
| | **Toast Alert** | Sukses buat/edit workspace, beralih workspace, error |
| **Projects (`ProjectListView.vue`)** | **SweetAlert Confirm** | Konfirmasi hapus proyek |
| | **Toast Alert** | Sukses tambah/edit proyek, hapus proyek, error |
| **Tasks (`TaskBoardView.vue`)** | **SweetAlert Confirm** | Konfirmasi hapus tugas & hapus lampiran berkas |
| | **Toast Alert** | Sukses tambah tugas, drag-and-drop status, komentar, upload file |
| **Members (`MemberListView.vue`)** | **SweetAlert Confirm** | Konfirmasi keluarkan anggota dari workspace |
| | **Toast Alert** | Sukses undang anggota, ubah role anggota, error |
| **Profile & Settings (`ProfileSettingsView.vue`)** | **Toast Alert** | Sukses update profil, ganti foto avatar, ubah kata sandi |
| **Notifications (`NotificationCenterView.vue`)** | **Toast Alert** | Sukses tandai semua dibaca, tandai per item |
| **Auth (`Login.vue`, `Register.vue`, dll)** | **Toast Alert** | Sukses login, daftar akun, kirim tautan reset password |
| **User Menu Header (`UserMenu.vue`)** | **SweetAlert Confirm** | Konfirmasi keluar akun (Sign out) |

---

*MariFlow SaaS — Panduan Arsitektur UI/UX & Standar Alerting.*
