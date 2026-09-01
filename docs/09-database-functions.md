# Database Functions & RPC — MariFlow SaaS (Milestone 12)

## 1. Objective
Menjelaskan implementasi Remote Procedure Calls (RPC) berbasis PL/pgSQL di PostgreSQL untuk mengoptimalkan agregasi data statistik analitik dashboard secara atomik dan efisien.

---

## 2. Concept: Database RPC vs Client Aggregation
- **Pendekatan Lama (Client Processing)**: Frontend memuat ribuan row tugas dan proyek lalu menghitung totalnya menggunakan filter JavaScript (berat dan boros memori).
- **Pendekatan MariFlow (PostgreSQL RPC)**: Kalkulasi agregasi dilakukan langsung di kernel PostgreSQL dalam satu query mikrodetik, mengembalikan payload JSON ringkas ke browser.

---

## 3. Implementasi Function `get_workspace_statistics`
```sql
CREATE OR REPLACE FUNCTION public.get_workspace_statistics(target_ws_id UUID)
RETURNS JSONB AS $$
...
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
```

---

## 4. Pemanggilan di Frontend
```typescript
const { data, error } = await supabase.rpc('get_workspace_statistics', {
  target_ws_id: activeWorkspaceId
});
```
