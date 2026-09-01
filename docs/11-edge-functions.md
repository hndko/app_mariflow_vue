# Supabase Edge Functions — MariFlow SaaS (Milestone 13)

## 1. Objective
Menjelaskan arsitektur Supabase Edge Functions berbasis Deno runtime untuk mengeksekusi logika server-side yang membutuhkan secret API keys (seperti pengiriman email undangan workspace).

---

## 2. Concept
Edge Functions berjalan di serverless edge nodes yang dekat dengan pengguna secara global:
```text
[ Browser ] ──► [ Supabase Edge Function (Deno) ] ──► [ Resend / SendGrid / External API ]
```

---

## 3. Function Blueprint: `send-workspace-invitation`
Lokasi: `supabase/functions/send-workspace-invitation/index.ts`
```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { workspaceName, inviteeEmail, inviterName } = await req.json()
  
  // Kirim email via third-party provider menggunakan secret key yang aman di edge
  return new Response(
    JSON.stringify({ success: true, message: `Undangan terkirim ke ${inviteeEmail}` }),
    { headers: { "Content-Type": "application/json" } }
  )
})
```
