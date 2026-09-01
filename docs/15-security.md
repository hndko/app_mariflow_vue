# Production Security Review — MariFlow SaaS (Milestone 17)

## 1. Objective
Melakukan audit keamanan komprehensif terhadap arsitektur aplikasi MariFlow SaaS mencakup Row Level Security, secret exposure, otorisasi multi-role, dan storage policy boundaries.

---

## 2. OWASP & Security Verification

1. **Secret Exposure Zero-Tolerance**:
   - `SUPABASE_SERVICE_ROLE_KEY` sama sekali tidak terdapat pada source code frontend.
   - Variabel diakses melalui `import.meta.env.VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY`.
2. **Strict Row Level Security (RLS)**:
   - 10 tabel publik seluruhnya berstatus `ENABLE ROW LEVEL SECURITY`.
   - Tidak ada policy `USING (true)` pada data privat / relasional.
   - Evaluasi hak akses menggunakan helper function berperingkat `SECURITY DEFINER` dengan parameter `$1`.
3. **Storage Security & Path Traversal Prevention**:
   - File attachment dibatasi hanya untuk member workspace yang sesuai (`storage.objects` RLS policy).
   - Nama file di-hash dengan unique timestamp ID.
4. **Input Sanitization & Injection Defense**:
   - Seluruh query PostgREST diparameterisasi otomatis (bebas dari SQL Injection).
   - XSS dicegah melalui interpolasi otomatis Vue 3 (`{{ }}`).
