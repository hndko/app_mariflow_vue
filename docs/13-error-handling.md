# Error Handling & Resilience — MariFlow SaaS (Milestone 13)

## 1. Objective
Mendokumentasikan penanganan error komprehensif, validasi form, sanitasi pesan kesalahan, dan ketahanan terhadap kegagalan jaringan atau timeout.

---

## 2. 4-State Data Handling Pattern
Setiap interaksi data di MariFlow menangani 4 kondisi state secara eksplisit:
1. **Loading State**: Menampilkan skeleton loading atau spinner pada tombol.
2. **Success State**: Menampilkan feedback visual atau update instan ke Pinia store.
3. **Error State**: Menampilkan alert yang ramah pengguna tanpa membocorkan kredensial atau stack trace SQL internal.
4. **Empty State**: Menampilkan ilustrasi dan deskripsi komunikatif jika data bernilai kosong (`[]`).

---

## 3. Sanitasi Pesan Error
```typescript
try {
  await taskService.createTask(payload);
} catch (err: any) {
  // Jangan tampilkan err.stack atau raw SQL string ke user
  const userMessage = err.message?.includes('violates foreign key')
    ? 'Proyek atau anggota yang dipilih tidak valid.'
    : err.message || 'Terjadi kendala saat menyimpan data. Silakan coba lagi.';
  errorMessage.value = userMessage;
}
```
