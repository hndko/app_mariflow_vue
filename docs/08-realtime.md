# Supabase Realtime Engine — MariFlow SaaS (Milestone 9)

## 1. Objective
Mendokumentasikan implementasi Supabase Realtime (Websockets & PostgreSQL Change Data Capture) untuk sinkronisasi data instan antar anggota tim (tugas, komentar, notifikasi) tanpa memerlukan polling berkala.

---

## 2. Concept & Realtime Architecture
Supabase Realtime mempublikasikan perubahan database PostgreSQL secara langsung ke client melalui koneksi WebSocket:
```text
[ User A Updates Task Status ]
              │
              ▼
    [ PostgreSQL UPDATE ]
              │ (CDC Replication)
              ▼
    [ Supabase Realtime Server ]
              │ (Websocket Broadcast)
              ▼
[ User B Browser: State Instantly Refreshes in UI ]
```

---

## 3. Subscription Hygiene & Memory Management
Setiap subscription pada component Vue **wajib** dibersihkan pada lifecycle `onBeforeUnmount`:
```typescript
import { onMounted, onBeforeUnmount } from 'vue'
import { notificationService } from '@/services/modules/notification.service'

let channel: any = null

onMounted(() => {
  channel = notificationService.subscribeToWorkspaceTasks(workspaceId, (payload) => {
    // Reaktif update local state
  })
})

onBeforeUnmount(() => {
  notificationService.unsubscribe(channel)
})
```

---

## 4. Testing & Verification
- Buka dua browser berbeda dengan akun member di workspace yang sama.
- Pindahkan kartu tugas di papan Kanban pada Browser 1.
- Pastikan kartu di Browser 2 berpindah secara otomatis secara realtime (<200ms).
