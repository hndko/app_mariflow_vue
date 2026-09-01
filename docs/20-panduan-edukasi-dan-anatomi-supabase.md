# 📘 Masterclass Supabase: Panduan Edukasi & Anatomi Lengkap Seluruh Menu Platform

Dokumen ini disusun sebagai **materi pembelajaran mendalam (Masterclass Guide)** mengenai ekosistem **Supabase**, anatomi seluruh fiturnya dari tingkat **Organisasi** hingga **Project**, serta keterkaitannya langsung dengan aplikasi **MariFlow SaaS**.

---

## 📑 Daftar Isi
1. [Konsep Inti & Hirarki Supabase (Organization vs Project)](#-1-konsep-inti--hirarki-supabase)
2. [Anatomi Form Pembuatan Project Baru (Create a New Project)](#-2-anatomi-form-pembuatan-project-baru)
   - [2.1 Pemilihan Region Database Terbaik](#21-pemilihan-region-database-terbaik)
   - [2.2 Konfigurasi Opsi Security & Automatic RLS Trigger](#22-konfigurasi-opsi-security--automatic-rls-trigger)
   - [2.3 Integrasi GitHub Repository](#23-integrasi-github-repository)
3. [Anatomi Menu Organisasi — Bagian 1 (Projects, Team, Integrations)](#-3-anatomi-menu-organisasi--bagian-1)
4. [Anatomi Menu Organisasi — Bagian 2 (Configuration, Security & OAuth)](#-4-anatomi-menu-organisasi--bagian-2)
5. [Anatomi Menu Organisasi — Bagian 3 (Compliance, Legal & Usage Metrics)](#-5-anatomi-menu-organisasi--bagian-3)
6. [Panduan Langkah-demi-Langkah Pengisian Form untuk MariFlow SaaS](#-6-panduan-langkah-demi-langkah-pengisian-form-mariflow)
7. [Anatomi Menu Tingkat Project (Backend & Database Engine)](#-7-anatomi-menu-tingkat-project)
8. [Anatomi Lengkap Project Dashboard (Project Overview)](#-8-anatomi-lengkap-project-dashboard-project-overview)
   - [8.1 Kartu Status Utama (Compute & Database Health)](#81-kartu-status-utama-project-header--compute-health)
   - [8.2 Bagian "Get Connected" (Pintu Integrasi)](#82-bagian-get-connected-pintu-masuk-integrasi)
   - [8.3 4 Pilar Metrik Layanan (API, Realtime, Storage, Postgres)](#83-4-pilar-metrik-layanan-service-metrics)
   - [8.4 Security & Performance Advisor](#84-security--performance-advisor)
9. [Anatomi Lengkap 13 Menu Sidebar Kiri Project](#-9-anatomi-lengkap-13-menu-sidebar-kiri-project-level)
10. [Bedah Lengkap Menu Table Editor & Modal "Create a New Table"](#-10-bedah-lengkap-menu-table-editor--modal-create-a-new-table)
    - [10.1 Komponen Halaman Utama Table Editor & Batch Edit](#101-komponen-halaman-utama-table-editor)
    - [10.2 Anatomi Modal Drawer "Create a new table under public"](#102-anatomi-modal-drawer-create-a-new-table-under-public)
    - [10.3 Penjelasan Detail Tiap Opsi Pembuatan Tabel (RLS, Realtime, Columns, FK, API)](#103-penjelasan-detail-tiap-opsi-pembuatan-tabel)
11. [Matriks Komparasi: FREE Tier vs PRO Tier (Panduan Batasan & Skalabilitas)](#-11-matriks-komparasi-free-tier-vs-pro-tier-panduan-batasan--skalabilitas)
    - [11.1 Rincian Fitur Bebas Pakai di FREE Tier](#111-rincian-fitur-bebas-pakai-di-free-tier-cukup-untuk-pengembangan--mvp)
    - [11.2 Daftar Fitur Eksklusif PRO TIER (Terkunci)](#112-daftar-fitur-eksklusif-pro-tier--wajib-diperhatikan)
12. [Bedah Lengkap Menu SQL Editor (Query Builder, AI Assistant & Chart Visualizer)](#-12-bedah-lengkap-menu-sql-editor-query-builder-ai-assistant--chart-visualizer)
    - [12.1 Anatomi Panel Kiri (Snippet Manager & References)](#121-anatomi-panel-kiri-snippet-manager--references)
    - [12.2 Fitur Unggulan Editor & Supabase AI (Ctrl+Shift+K)](#122-fitur-unggulan-editor--supabase-ai-ctrlshiftk)
    - [12.3 Panel Hasil Eksekusi: Tab Results & Chart](#123-panel-hasil-eksekusi-tab-results--chart)
13. [Bedah Komprehensif Menu Database (Schema Visualizer, Functions, Triggers & Access Control)](#-13-bedah-komprehensif-menu-database-schema-visualizer-functions-triggers--access-control)
    - [13.1 Kelompok 1: DATABASE MANAGEMENT (ERD, Functions RPC, Triggers, Enums, Extensions, Indexes, Publications)](#131-kelompok-1-database-management)
    - [13.2 Kelompok 2: ACCESS CONTROL (Policies RLS, Database Roles)](#132-kelompok-2-access-control)
    - [13.3 Kelompok 3: CONFIGURATION & PLATFORM (Settings, Replication, Backups, Migrations)](#133-kelompok-3-configuration--platform)
14. [Panduan Lengkap Ekstensi PostgreSQL (Database Extensions Masterclass)](#-14-panduan-lengkap-ekstensi-postgresql-database-extensions-masterclass)
    - [14.1 Mengapa Supabase Menggunakan Schema extensions?](#141-mengapa-supabase-menggunakan-schema-extensions)
    - [14.2 4 Ekstensi Utama yang Wajib Aktif untuk MariFlow](#142-4-ekstensi-utama-yang-wajib-aktif-enabled-by-default-untuk-mariflow)
    - [14.3 Ekstensi Pilihan SaaS Paling Berguna untuk Fitur Lanjutan](#143-ekstensi-pilihan-saas-paling-berguna-untuk-pengembangan-fitur-lanjutan)
    - [14.4 Cara Mengaktifkan Ekstensi via SQL Script](#144-cara-mengaktifkan-ekstensi-via-sql-script)
15. [Panduan Lengkap Optimasi Query & Database Indexes (Query Optimization Masterclass)](#-15-panduan-lengkap-optimasi-query--database-indexes-query-optimization-masterclass)
    - [15.1 Mengapa Database Index Sangat Penting bagi SaaS Multi-Tenant?](#151-mengapa-database-index-sangat-penting-bagi-saas-multi-tenant)
    - [15.2 Anatomi Tipe-Tipe Index di PostgreSQL & Rekomendasi Penggunaannya](#152-anatomi-tipe-tipe-index-di-postgresql--rekomendasi-penggunaannya)
    - [15.3 Teknik Optimasi Lanjutan (Composite, Partial & Covering Index)](#153-teknik-optimasi-lanjutan-advanced-saas-indexing-strategies)
    - [15.4 Memeriksa Kinerja Query dengan EXPLAIN ANALYZE](#154-memeriksa-kinerja-query-dengan-explain-analyze)
    - [15.5 Fitur Supabase Index Advisor](#155-fitur-supabase-index-advisor-tombol-di-kanan-atas)
16. [Bedah Lengkap Database Publications, Policies (RLS), & Roles Architecture](#-16-bedah-lengkap-database-publications-policies-rls--roles-architecture)
    - [16.1 Database Publications (supabase_realtime & Event Toggles)](#161-database-publications-supabase_realtime)
    - [16.2 Policies (Row Level Security Visual Manager)](#162-policies-row-level-security-visual-manager)
    - [16.3 Database Roles (Hierarki Peran PostgreSQL & Arsitektur Keamanan)](#163-database-roles-hierarki-peran-postgresql--arsitektur-keamanan)
    - [16.4 Anatomi Drawer "Create a new role" & Privilese Database](#164-anatomi-drawer-create-a-new-role--privilese-database)
17. [Bedah Lengkap Database Settings (Password, Connection Pooling, SSL, & Security)](#-17-bedah-lengkap-database-settings-password-connection-pooling-ssl--security)
    - [17.1 Database Password & Dampak Reset Password](#171-database-password--dampak-reset-password)
    - [17.2 Connection Pooling (Supavisor): Solusi 200 Koneksi di Free Tier](#172-connection-pooling-supavisor-solusi-200-koneksi-di-free-tier)
    - [17.3 SSL Configuration (Enkripsi Data In-Transit)](#173-ssl-configuration-enkripsi-data-in-transit)
    - [17.4 Network Restrictions (IP Whitelist) & Network Bans](#174-network-restrictions-ip-whitelist--network-bans)
    - [17.5 Connection Logging (log_connections & log_disconnections)](#175-connection-logging-log_connections--log_disconnections)
18. [Bedah Lengkap Database Replication & Supabase Pipelines (BigQuery Analytics & Read Replicas)](#-18-bedah-lengkap-database-replication--supabase-pipelines-bigquery-analytics--read-replicas)
    - [18.1 Dua Jenis Replikasi: Read Replicas vs Pipelines](#181-dua-jenis-replikasi-di-supabase-read-replicas-vs-pipelines)
    - [18.2 Mengapa SaaS Membutuhkan Replikasi ke Google BigQuery?](#182-mengapa-saas-membutuhkan-replikasi-ke-google-bigquery)
    - [18.3 Status Paket: FREE Tier vs PRO Tier (Solusi Analitik Free Tier)](#183--status-paket-free-tier-vs-pro-tier)
19. [Bedah Lengkap Database Backups & Database Migrations](#-19-bedah-lengkap-database-backups--database-migrations)
    - [19.1 Database Backups: Scheduled, PITR, & Strategi Backup Free Tier](#191--database-backups-scheduled-pitr--strategi-backup-free-tier)
    - [19.2 Panduan Backup Manual 100% Gratis untuk MariFlow di FREE Tier](#192--panduan-backup-manual-100-gratis-untuk-mariflow-di-free-tier)
    - [19.3 Database Migrations: Mengelola Skema via Supabase CLI](#193--database-migrations-mengelola-skema-via-supabase-cli)
20. [Bedah Lengkap Menu Authentication (User Directory, Invitation, & OAuth 2.0 Server)](#-20-bedah-lengkap-menu-authentication-user-directory-invitation--oauth-20-server)
    - [20.1 Direktori Pengguna (Authentication Users)](#201--direktori-pengguna-authentication--users)
    - [20.2 Anatomi Opsi Pembuatan Akun: Create User vs Send Invitation](#202--anatomi-opsi-pembuatan-akun-create-user-vs-send-invitation)
    - [20.3 OAuth Apps & OAuth 2.0 Server](#203--oauth-apps--oauth-20-server-beta)
21. [Bedah Lengkap Email Notifications & Custom SMTP Server (Templates & Security Alerts)](#-21-bedah-lengkap-email-notifications--custom-smtp-server-templates--security-alerts)
    - [21.1 Perbedaan Email Bawaan vs Custom SMTP Provider](#211-perbedaan-email-bawaan-built-in-pool-vs-custom-smtp-provider)
    - [21.2 6 Template Otentikasi Utama & Variabel Dinamis](#212--6-template-otentikasi-utama--variabel-dinamisnya)
    - [21.3 7 Notifikasi Peringatan Keamanan (Security Notifications)](#213--7-notifikasi-peringatan-keamanan-security-notifications)
    - [21.4 Konfigurasi Custom SMTP Provider (Tab SMTP Settings)](#214--konfigurasi-custom-smtp-provider-tab-smtp-settings)
22. [Bedah Lengkap Sign In & Providers (User Signups, Social OAuth, & Custom OIDC)](#-22-bedah-lengkap-sign-in--providers-user-signups-social-oauth--custom-oidc)
    - [22.1 Kontrol Registrasi Pengguna (User Signups)](#221--kontrol-registrasi-pengguna-user-signups)
    - [22.2 Mengaktifkan Social Login di MariFlow (Google & GitHub)](#222--mengaktifkan-social-login-di-mariflow-google--github)
    - [22.3 Custom Auth Providers (Enterprise OIDC SSO)](#223--custom-auth-providers-new-enterprise-oidc-sso)
23. [Bedah Lengkap Third-Party Auth (Integrasi Eksternal JWT: Clerk, Firebase, Auth0, & AWS Cognito)](#-23-bedah-lengkap-third-party-auth-integrasi-eksternal-jwt-clerk-firebase-auth0--aws-cognito)
    - [23.1 Apa itu Third-Party Auth di Supabase?](#231-apa-itu-third-party-auth-di-supabase)
    - [23.2 Bagaimana Cara Kerja Verifikasi JWT Eksternal dengan PostgreSQL RLS?](#232-bagaimana-cara-kerja-verifikasi-jwt-eksternal-dengan-postgresql-rls)
    - [23.3 Rekomendasi untuk MariFlow SaaS](#233--rekomendasi-untuk-mariflow-saas)
24. [Bedah Lengkap Passkeys, User Sessions, Token Lifecycle, & Auth Rate Limits](#-24-bedah-lengkap-passkeys-user-sessions-token-lifecycle--auth-rate-limits)
    - [24.1 Passkeys (WebAuthn / Login Biometrik Modern)](#241--passkeys-beta-webauthn--login-biometrik-modern)
    - [24.2 User Sessions & Siklus Hidup Token JWT (Token Lifecycle)](#242--user-sessions--siklus-hidup-token-jwt-token-lifecycle)
    - [24.3 Status Sesi: FREE Tier vs PRO Tier](#243--status-sesi-free-tier-vs-pro-tier)
    - [24.4 Auth Rate Limits (Perlindungan DDoS & Brute-Force)](#244--auth-rate-limits-perlindungan-ddos--brute-force)
25. [Bedah Lengkap Multi-Factor (MFA), URL Configuration, & Attack Protection](#-25-bedah-lengkap-multi-factor-mfa-url-configuration--attack-protection)
    - [25.1 Multi-Factor Authentication (MFA / 2FA)](#251--multi-factor-authentication-mfa--2fa)
    - [25.2 URL Configuration (Mencegah Serangan Open Redirect)](#252--url-configuration-mencegah-serangan-open-redirect)
    - [25.3 Attack Protection (Bot Captcha & Leaked Passwords)](#253--attack-protection-bot-captcha--leaked-passwords)
26. [Bedah Lengkap Auth Hooks, Audit Logs, & Auth Performance Tuning](#-26-bedah-lengkap-auth-hooks-audit-logs--auth-performance-tuning)
    - [26.1 Auth Hooks (Intersepsi Alur Otentikasi dengan Postgres & Edge Functions)](#261--auth-hooks-beta-intersepsi-alur-otentikasi-dengan-postgres--edge-functions)
    - [26.2 Audit Logs (audit_log_entries)](#262--audit-logs-audit_log_entries)
    - [26.3 Auth Performance Tuning (FREE Tier vs PRO Tier)](#263--auth-performance-tuning-free-tier-vs-pro-tier)
27. [Bedah Lengkap Supabase Storage (Object Storage, Public vs Private Buckets, & Storage RLS)](#-27-bedah-lengkap-supabase-storage-object-storage-public-vs-private-buckets--storage-rls)
    - [27.1 Anatomi Bucket: Public vs Private](#271--anatomi-bucket-public-vs-private)
    - [27.2 Keunggulan Arsitektur: RLS di Tingkat File (storage.objects)](#272--keunggulan-arsitektur-rls-di-tingkat-file-storageobjects)
    - [27.3 Storage Settings: FREE Tier vs PRO Tier](#273--storage-settings-free-tier-vs-pro-tier)
28. [Bedah Lengkap Analytics Buckets (Apache Iceberg) & Vector Buckets (AI Embeddings)](#-28-bedah-lengkap-analytics-buckets-apache-iceberg--vector-buckets-ai-embeddings)
    - [28.1 Analytics Buckets (PostgreSQL Foreign Data Wrapper + Apache Iceberg)](#281--analytics-buckets-postgresql-foreign-data-wrapper--apache-iceberg)
    - [28.2 Vector Buckets (AI Embeddings & Semantic Search Skala Besar)](#282--vector-buckets-ai-embeddings--semantic-search-skala-besar)
    - [28.3 Status Tier & Tahap Rilis](#283--status-tier--tahap-rilis)
29. [Bedah Lengkap S3-Compatible Protocol & S3 Access Keys (AWS SDK, Rclone, & RLS Bypass Warning)](#-29-bedah-lengkap-s3-compatible-protocol--s3-access-keys-aws-sdk-rclone--rls-bypass-warning)
    - [29.1 Apa itu S3-Compatible Protocol di Supabase?](#291--apa-itu-s3-compatible-protocol-di-supabase)
    - [29.2 Parameter Koneksi S3](#292--parameter-koneksi-s3)
    - [29.3 Contoh Penggunaan dengan AWS SDK & Python Boto3](#293--contoh-penggunaan-dengan-aws-sdk--python-boto3)
    - [29.4 Peringatan Keamanan Kritis: S3 Access Keys Bypass RLS!](#294--peringatan-keamanan-kritis-s3-access-keys-bypass-rls)
30. [Bedah Lengkap Supabase Edge Functions (Deno Runtime, Webhooks, & Secrets)](#-30-bedah-lengkap-supabase-edge-functions-deno-runtime-webhooks--secrets)
    - [30.1 Apa itu Supabase Edge Functions & Mengapa Memakai Deno?](#301--apa-itu-supabase-edge-functions--mengapa-memakai-deno)
    - [30.2 3 Cara Pembuatan & Deployment Edge Functions](#302--3-cara-pembuatan--deployment-edge-functions)
    - [30.3 Manajemen Kunci Rahasia (Edge Function Secrets)](#303--manajemen-kunci-rahasia-edge-function-secrets)
    - [30.4 Kuota Paket: FREE Tier vs PRO Tier](#304--kuota-paket-free-tier-vs-pro-tier)
31. [Bedah Lengkap Supabase Realtime (Postgres Changes, Broadcast, Presence, & Realtime RLS)](#-31-bedah-lengkap-supabase-realtime-postgres-changes-broadcast-presence--realtime-rls)
    - [31.1 3 Pilar Utama Fitur Realtime di MariFlow SaaS](#311--3-pilar-utama-fitur-realtime-di-mariflow-saas)
    - [31.2 Realtime Inspector (Alat Debugging Langsung)](#312--realtime-inspector-alat-debugging-langsung)
    - [31.3 Realtime Authorization & RLS Policies (realtime.messages)](#313--realtime-authorization--rls-policies-realtimemessages)
    - [31.4 Realtime Settings: FREE Tier vs PRO Tier](#314--realtime-settings-free-tier-vs-pro-tier)
    - [31.5 Higienitas Subscription di Vue 3 (Anti-Memory Leak)](#315--higienitas-subscription-di-vue-3-anti-memory-leak)
32. [Bedah Lengkap Security Advisor & Postgres Linter (Splinter Engine & RLS Auditing)](#-32-bedah-lengkap-security-advisor--postgres-linter-splinter-engine--rls-auditing)
    - [32.1 3 Kategori Temuan Splinter Linter](#321--3-kategori-temuan-splinter-linter)
    - [32.2 Bedah Kasus: Mengapa Muncul 2 Warnings pada public.rls_auto_enable()?](#322--bedah-kasus-mengapa-muncul-2-warnings-pada-publicrls_auto_enable)
33. [Bedah Lengkap Supabase Integrations Marketplace (Data API, Vault, pg_cron, pgmq, & Observability)](#-33-bedah-lengkap-supabase-integrations-marketplace-data-api-vault-pg_cron-pgmq--observability)
    - [33.1 Integrasi Bawaan (Installed Integrations)](#331--integrasi-bawaan-installed-integrations)
    - [33.2 Fitur Komunitas Populer: pg_cron & pgmq](#332--fitur-komunitas-populer-pg_cron--pgmq)
    - [33.3 Observability & Platform Deployment Sync](#333--observability--platform-deployment-sync)
    - [33.4 Foreign Data Wrappers (FDW Integrations)](#334--foreign-data-wrappers-fdw-integrations)
34. [Bedah Lengkap Project Settings: General (Lifecycle, Engine Versions, & Custom Domains)](#-34-bedah-lengkap-project-settings-general-lifecycle-engine-versions--custom-domains)
    - [34.1 Metadata & Identitas Proyek MariFlow](#341--metadata--identitas-proyek-mariflow)
    - [34.2 Manajemen Siklus Hidup (Project Availability: Restart & Pause)](#342--manajemen-siklus-hidup-project-availability-restart--pause)
    - [34.3 Versi Mesin Layanan (Core Service Versions)](#343--versi-mesin-layanan-core-service-versions)
    - [34.4 Custom Domains: FREE Tier vs PRO Tier](#344--custom-domains-free-tier-vs-pro-tier)
    - [34.5 Transfer & Delete Project (Disaster Prevention)](#345--transfer--delete-project-disaster-prevention)
35. [Bedah Lengkap Infrastructure Settings (Compute Sizing, Telemetri RAM/CPU/WAL, & Read Replicas)](#-35-bedah-lengkap-infrastructure-settings-compute-sizing-telemetri-ramcpuwal--read-replicas)
    - [35.1 Topologi Primary Database Proyek MariFlow](#351--topologi-primary-database-proyek-mariflow)
    - [35.2 Anatomi Penggunaan Disk: Database, WAL, & System](#352--anatomi-penggunaan-disk-database-wal--system)
    - [35.3 Read Replicas: Penskalaan Horisontal (PRO TIER)](#353--read-replicas-penskalaan-horisontal--pro-tier)
    - [35.4 Pilihan Compute Sizing: FREE Tier vs PRO Tier](#354--pilihan-compute-sizing-free-tier-vs-pro-tier)

---

## 🏛️ 1. Konsep Inti & Hirarki Supabase

```text
┌─────────────────────────────────────────────────────────────────┐
│                    🏢 AKUN PENGGUNA UTAMA                       │
│                   (misal: hd.doko22@gmail.com)                  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
     🏢 ORGANISASI: Mari Partner       🏢 ORGANISASI: Klien Lain
     (Team, Billing, SSO, Integrations)
                 │
         ┌───────┴───────────────────────┐
         ▼                               ▼
  🚀 PROJECT: marifin-backend     🚀 PROJECT: mariflow-backend
  (Postgres, Auth, Storage, etc.)
         │
         ▼
  🗄️ DATABASE SCHEMA (public)
  (profiles, workspaces, tasks, etc.)
```

---

## 🚀 2. Anatomi Form Pembuatan Project Baru (*Create a New Project*)

Berdasarkan 4 tangkapan layar form `Create a new project`:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                     FORM CREATE A NEW PROJECT                           │
├───────────────────────┬─────────────────────────────────────────────────┤
│ Organization          │ Mari Partner (FREE)                             │
│ GitHub (optional)     │ Link repository hndko/app_mariflow_vue          │
│ Project Name          │ mariflow-backend                                │
│ Database Password     │ Generate strong password (Simpan di aman)       │
│ Region                │ Southeast Asia (Singapore) ap-southeast-1 🇸🇬    │
│ Security - Data API   │ ☑️ Enable Data API                              │
│ Security - Expose     │ ☑️ Automatically expose new tables              │
│ Security - Auto RLS   │ ☑️ Enable automatic RLS (Event Trigger)         │
└───────────────────────┴─────────────────────────────────────────────────┘
```

### 2.1 Pemilihan Region Database Terbaik

Supabase menyediakan puluhan region data center AWS di seluruh dunia.

> [!IMPORTANT]
> **Rekomendasi Mutlak untuk Indonesia & Asia Tenggara**:
> **Pilih `Southeast Asia (Singapore) ap-southeast-1`** 🇸🇬.
> - **Latensi**: Tercepat dari Indonesia (~15-25 ms) karena jalur kabel fiber optik bawah laut langsung ke Singapura.
> - Region Tokyo (`ap-northeast-1`) atau Seoul (`ap-northeast-2`) memiliki latensi lebih tinggi (~80-120 ms dari Jakarta).

---

### 2.2 Konfigurasi Opsi Security & Automatic RLS Trigger

Tiga opsi keamanan di bagian bawah form:

1. ☑️ **Enable Data API** *(WAJIB CENTANG)*:
   - Membuat RESTful API otomatis untuk schema `public` sehingga frontend Vue 3 (`@supabase/supabase-js`) bisa berkomunikasi langsung dengan database.
2. ☑️ **Automatically expose new tables** *(CENTANG)*:
   - Memberikan hak istimewa API pada setiap tabel baru yang Anda buat.
3. ☑️ **Enable automatic RLS** *(SANGAT DIREKOMENDASIKAN DICENTANG)*:
   - Memasang PostgreSQL Event Trigger yang otomatis mengaktifkan **Row Level Security (RLS)** pada setiap tabel baru. Ini menjamin keamanan 100% agar tabel tidak pernah terekspos tanpa proteksi otorisasi secara tidak sengaja.

---

### 2.3 Integrasi GitHub Repository

- **GitHub (optional)**: Anda dapat memilih repository `hndko/app_mariflow_vue`.
- **Manfaat**: Memungkinkan integrasi pipeline otomatis (*agent-first workflow*), di mana setiap kali file SQL di folder `supabase/migrations/` diperbarui dan di-push ke GitHub, Supabase akan langsung mengaplikasikan migrasi tersebut ke database server!

---

## 🖥️ 3. Anatomi Menu Organisasi — Bagian 1

- **Projects**: Daftar instance database aktif.
- **Team**: Mengelola akses developer (Owner, Administrator, Developer).
- **Integrations**: GitHub & Vercel Auto-sync Environment Variables.

---

## ⚙️ 4. Anatomi Menu Organisasi — Bagian 2

- **Data Privacy**: Pilihan **Schema Only** direkomendasikan agar Supabase AI di SQL Editor memahami nama tabel kita tanpa membaca data privat.
- **Security & MFA**: Pengaturan 2FA akun developer.
- **OAuth Apps**: Integrasi aplikasi pihak ketiga.

---

## 📜 5. Anatomi Menu Organisasi — Bagian 3

- **Compliance & Legal**: DPA, TIA, SOC2, ISO 27001 (Kepatuhan GDPR).
- **Usage Metrics**: Database Size (500 MB), Egress (5 GB), MAU (50.000), Realtime Peak Connections (200), Realtime Messages (2 Juta).

---

## 🎯 6. Panduan Langkah-demi-Langkah Pengisian Form untuk MariFlow

Saat Anda mengisi form di layar tersebut, ikuti panduan berikut:

1. **Organization**: Biarkan terpilih `Mari Partner (FREE)`.
2. **GitHub (optional)**: Pilih repository `app_mariflow_vue` (jika sudah terhubung).
3. **Project Name**: Ketik `mariflow-dev`.
4. **Database Password**:
   - Klik **Generate a password**.
   - **PENTING**: Salin dan simpan kata sandi ini di catatan aman Anda.
5. **Region**:
   - Klik dropdown `Asia-Pacific` ➔ Pilih **`Southeast Asia (Singapore) ap-southeast-1`**.
6. **Security**:
   - Pastikan **Enable Data API** dicentang (☑️).
   - Pastikan **Automatically expose new tables** dicentang (☑️).
   - Centang juga **Enable automatic RLS** (☑️).
7. Klik tombol hijau **`Create new project`**.
8. Tunggu proses provisi server (~1-2 menit) hingga status menjadi **Healthy**.

---

## 🖥️ 8. Anatomi Lengkap Project Dashboard (`Project Overview`)

Berdasarkan tangkapan layar antarmuka dashboard project `mariflow-dev`, berikut adalah penjelasan komprehensif seluruh komponennya:

```text
┌───────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚡ Mari Partner [FREE] / 📦 mariflow-dev / 🌿 main [PRODUCTION]            [Connect] [Search Ctrl+K]│
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                   │
│  mariflow-dev                                       ┌──────────────────────────────────────────┐  │
│  https://rtazqheauyiujjteburi.supabase.co [Copy]    │ 🗄️ Primary Database                      │  │
│                                                     │ Southeast Asia (Singapore) ap-southeast-1│  │
│  🟢 STATUS: Healthy      ⚙️ COMPUTE: NANO           │ CPU 2%  │ Disk 14% │ RAM 49% │ 5/60 conns │  │
│  🐙 GITHUB: No repo      🌱 BRANCH: No branches     └──────────────────────────────────────────┘  │
│  📜 MIGRATION: 0         💾 BACKUP: No backups                                                    │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  🔌 GET CONNECTED:                                                                                │
│  [Framework]  [Server]  [Direct]  [ORM]  [MCP (AI Agent)]  [API Keys]                             │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  📊 METRICS (Last 60 mins):  12 Total Requests │ 91.7% Success Rate                               │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                  │
│  │ 🌐 API GATEWAY  │ │ 📡 REALTIME     │ │ 📦 STORAGE      │ │ 🗄️ POSTGRES     │                  │
│  │ 5 Requests      │ │ 4 Requests      │ │ 2 Requests      │ │ 1 Request       │                  │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                  │
│                                                                                                   │
│ ───────────────────────────────────────────────────────────────────────────────────────────────── │
│  🛡️ SECURITY & ADVISOR: Advisor found no issues (No security or performance issues found)        │
│  📈 REPORTS: Build custom reports & query snippets                                                │
└───────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 8.1 Kartu Status Utama (*Project Header & Compute Health*)

1. **Project URL (`https://rtazqheauyiujjteburi.supabase.co`)**:
   - URL endpoint HTTPS dasar untuk seluruh REST API, Auth, dan Storage requests dari frontend MariFlow.
2. **Compute Tier (`NANO`)**:
   - Tingkat mesin komputasi virtual PostgreSQL Anda. Nano menyediakan resource yang sangat efisien untuk pengembangan dan tim kecil.
3. **Primary Database Health Widget**:
   - **`CPU 2%`**: Beban komputasi prosesor server database. Sangat enteng.
   - **`Disk 14%`**: Ruang penyimpanan disk SSD terpakai dari kuota 500 MB Free Tier.
   - **`RAM 49%`**: Memori PostgreSQL terpakai (~500 MB RAM).
   - **`5/60 conns`**: Jumlah koneksi database aktif saat ini (5 dari batas maksimal 60 koneksi langsung).

---

### 8.2 Bagian "Get Connected" (*Pintu Masuk Integrasi*)

Pada kartu **Get connected**, Supabase menyediakan 6 jalur integrasi utama:

1. **`Framework` (Client Library)**:
   - Menampilkan snippet inisialisasi `@supabase/supabase-js` untuk framework modern (Vue 3, React, Next.js, Flutter, Swift, Svelte). Inilah yang kita gunakan di `src/services/supabase.ts`.
2. **`Server` (API Handlers)**:
   - Panduan membuat API route aman di backend server (Express, NestJS, Laravel, FastAPI).
3. **`Direct` (Connection String)**:
   - URI koneksi database PostgreSQL standar (`postgresql://postgres:[PASSWORD]@db.rtazqheauyiujjteburi.supabase.co:5432/postgres`) untuk software database GUI seperti DBeaver, TablePlus, Navicat, atau pgAdmin.
4. **`ORM` (Object-Relational Mapping)**:
   - Konfigurasi untuk Prisma ORM, Drizzle, Kysely, TypeORM, atau Sequelize.
5. **`MCP` (Model Context Protocol)**:
   - **Fitur Baru Supabase**: Protokol standar terbuka yang memungkinkan AI Coding Agent (seperti Antigravity, Claude Code, Cursor) terhubung dan berinteraksi langsung dengan database Supabase secara cerdas dan aman!
6. **`API Keys` (Kunci Kredensial Project)**:
   - Kartu cepat untuk melihat dan menyalin **`anon` (public key)** untuk frontend dan **`service_role` (secret key)** untuk backend.

---

### 8.3 4 Pilar Metrik Layanan (*Service Metrics*)

Supabase membagi aktivitas sistem ke dalam 4 pilar visual:
1. **🌐 API GATEWAY**:
   - Mengukur jumlah request REST API yang masuk via PostgREST (contoh: query tabel `workspaces`, `tasks`, `projects`).
2. **📡 REALTIME**:
   - Mengukur koneksi WebSocket live yang menyinkronkan data tugas kanban secara instan ke layar pengguna lain tanpa perlu refresh halaman.
3. **📦 STORAGE**:
   - Mengukur request upload/download berkas avatar dan lampiran tugas kanban ke Supabase Storage S3-compatible engine.
4. **🗄️ POSTGRES**:
   - Mengukur query langsung dan transaksi database PostgreSQL murni.

---

### 8.4 Security & Performance Advisor

Supabase memiliki mesin audit internal pintar bernama **Supabase Advisor**:
- **Security Advisor**: Secara berkala memeriksa apakah ada tabel publik tanpa Row Level Security (RLS), kolom sensitif yang terekspos, atau policy yang bocor (`USING (true)`).
- **Performance Advisor**: Menganalisis query lambat (*slow queries*), merekomendasikan penambahan index pada foreign key yang sering difilter, serta mendeteksi query vacuum/bloat.
- **Ask Assistant**: Tombol asisten AI interaktif bawaan Supabase untuk membantu Anda menulis query SQL rumit atau memecahkan kendala database.

---

## 🧭 9. Anatomi Lengkap 13 Menu Sidebar Kiri (*Project Level*)

```text
┌────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│ Menu Sidebar                           │ Fungsi Utama & Keterkaitannya dengan MariFlow          │
├────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 🏠 1. Project Overview                 │ Ringkasan status, URL, compute health, & traffic.       │
│ 🗃️ 2. Table Editor                     │ Visual Spreadsheet editor untuk melihat & edit data DB.│
│ 💻 3. SQL Editor                       │ Menjalankan file migrasi SQL DDL & DML skema MariFlow. │
│ 🗄️ 4. Database                         │ Schema visualizer, foreign keys, triggers, RPC func.   │
│ 🔑 5. Authentication                   │ User management, Email OTP, OAuth, & Redirect URLs.    │
│ 📦 6. Storage                          │ Bucket file uploads (`avatars`, `task-attachments`).   │
│ ⚡ 7. Edge Functions                   │ Serverless function Deno untuk webhook / background job│
│ 📡 8. Realtime                         │ Konfigurasi realtime channel broadcast & Postgres sync.│
│ 💡 9. Advisors                         │ Laporan keamanan RLS & rekomendasi performa query.     │
│ 🔭 10. Observability                   │ Grafik latency, throughput, & pooler connection stats. │
│ 📋 11. Logs                            │ Catatan log request API Gateway, Database, & Auth.     │
│ 🧩 12. Integrations                    │ Menghubungkan GitHub, Vercel, Resend email SMTP, dll.  │
│ ⚙️ 13. Project Settings                │ Konfigurasi API keys, Connection Pooling, & Timezone.  │
└────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

---

## 🗃️ 10. Bedah Lengkap Menu Table Editor & Modal "Create a New Table"

Menu **Table Editor** (icon 🗃️ pada sidebar) adalah spreadsheet visual interaktif Supabase untuk mengelola dan memvisualisasikan data tabel PostgreSQL tanpa perlu menulis query SQL manual.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🗃️ Table Editor  [schema public ▼]  [+ New table]  [🔍 Search tables...]                           │
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────┤
│                          │  ┌───────────────────────────────────────────────────────────────────┐  │
│  DAFTAR TABEL:           │  │ ➕ Create a table (Design & create a new database table)           │  │
│  (No tables or views)    │  └───────────────────────────────────────────────────────────────────┘  │
│                          │                                                                         │
│  - profiles              │  🕒 RECENT ITEMS: No recent items yet                                   │
│  - workspaces            │                                                                         │
│  - workspace_members     │  ┌───────────────────────────────────────────────────────────────────┐  │
│  - projects              │  │ 💡 NEW FEATURE: Queue row edits in Table Editor                   │  │
│  - tasks                 │  │ Batch multiple row edits and review them before saving to database│  │
│                          │  └───────────────────────────────────────────────────────────────────┘  │
└──────────────────────────┴─────────────────────────────────────────────────────────────────────────┘
```

---

### 10.1 Komponen Halaman Utama Table Editor

1. **Dropdown Pemilih Schema (`schema public ▼`)**:
   - **`public`**: Schema utama tempat tabel aplikasi MariFlow berada (`profiles`, `workspaces`, `tasks`, dll).
   - **`auth`**: Schema privat milik Supabase Auth (`auth.users`, `auth.identities`, `auth.sessions`).
   - **`storage`**: Schema internal sistem penyimpanan file (`storage.buckets`, `storage.objects`).
   - **`realtime`**: Schema replikasi pesan WebSocket.
   - **`vault`**: Schema penyimpanan rahasia terenkripsi.

2. **Fitur "Queue row edits in Table Editor" (Batch Editing)**:
   - Fitur cerdas yang memungkinkan Anda mengedit puluhan sel data sekaligus layaknya Excel/Airtable secara offline di browser.
   - Perubahan akan di-review terlebih dahulu sebelum dikirim bersamaan (*atomic batch update*) ke server PostgreSQL. Hal ini mencegah terjadinya database lock dan request spam ke database.

---

### 10.2 Anatomi Modal Drawer "Create a new table under public"

Saat tombol **`+ New table`** diklik, Supabase membuka drawer konfigurasi tabel:

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Create a new table under public                                                               [X]  │
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                    │
│  Name:        [ workspaces                                                               ]         │
│  Description: [ Workspace multi-tenant untuk tim MariFlow                                ] (Opt)   │
│                                                                                                    │
│  ☑️ Enable Row Level Security (RLS)  [RECOMMENDED]                                                 │
│     Restrict access to your table by enabling RLS and writing Postgres policies.                   │
│                                                                                                    │
│  ┌──────────────────────────────────────────────────────────────────────────────────────────────┐  │
│  │ ℹ️ Policies are required to query data                                                       │  │
│  │    You need to create an access policy before you can query data from this table.            │  │
│  │    Without a policy, querying this table will return an empty array of results.              │  │
│  │    [ 📖 Documentation ]                                                                      │  │
│  └──────────────────────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                                    │
│  ☐ Enable Realtime                                                                                 │
│     Broadcast changes on this table to authorized subscribers.                                     │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  COLUMNS                                       [ 📖 About data types ]  [ 📥 Import data from CSV ]│
│  ┌──┬──────────────┬──────────────┬──────────────────┬──────────────┬───────────────────────────┐  │
│  │::│ Name         │ Type         │ Default Value    │ Primary (PK) │ Options (Gear)            │  │
│  ├──┼──────────────┼──────────────┼──────────────────┼──────────────┼───────────────────────────┤  │
│  │::│ id           │ uuid         │ uuid_generate_v4()│     ☑️       │ Is Unique: Yes            │  │
│  │::│ name         │ text         │ NULL             │     ☐        │ Is Nullable: No           │  │
│  │::│ slug         │ text         │ NULL             │     ☐        │ Is Unique: Yes            │  │
│  │::│ created_at   │ timestamptz  │ now()            │     ☐        │                           │  │
│  └──┴──────────────┴──────────────┴──────────────────┴──────────────┴───────────────────────────┘  │
│  [ + Add column ]                                                                                  │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  FOREIGN KEYS                                                                                      │
│  [ + Add foreign key relation ] ➔ (Contoh: owner_id REFERENCES auth.users(id) ON DELETE CASCADE)   │
│                                                                                                    │
│ ────────────────────────────────────────────────────────────────────────────────────────────────── │
│  DATA API ACCESS                                                                                   │
│  (🔘 ON) Allow this table to be queried via Supabase client libraries or the API directly          │
│                                                                                                    │
│                                                                               [Cancel] [Save Ctrl↵]│
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 10.3 Penjelasan Detail Tiap Opsi Pembuatan Tabel

#### 1. 🛡️ Enable Row Level Security (RLS) [RECOMMENDED]
- **Fungsi**: Mengaktifkan proteksi tingkat baris (*Row Level Security*) pada tabel PostgreSQL.
- **Mengapa Sangat Penting?**:
  - Di Supabase, jika RLS aktif dan belum ada policy dibuat, maka **seluruh query dari client frontend akan mengembalikan array kosong (`[]`)**.
  - Ini adalah desain keamanan *Secure by Default* agar data sensitif pengguna tidak bocor ke publik.
  - Untuk MariFlow, setiap tabel wajib memiliki policy berbasis keanggotaan `workspace_members`.

#### 2. 📡 Enable Realtime
- **Fungsi**: Memasukkan tabel ke dalam publikasi PostgreSQL `supabase_realtime`.
- **Penggunaan di MariFlow**:
  - Wajib dicentang untuk tabel **`tasks`** dan **`task_comments`** agar perpindahan kartu kanban dan komentar baru langsung muncul di layar anggota tim lain secara realtime tanpa perlu reload browser!

#### 3. 🧩 Columns Builder (Definisi Kolom Data)
- **`Name`**: Nama kolom dengan aturan baku huruf kecil (*snake_case*).
- **`Type`**: Tipe data PostgreSQL:
  - `uuid`: Identifier unik global (128-bit) yang aman dari tebakan ID sekuensial.
  - `text` / `varchar`: String teks dinamis.
  - `timestamptz`: Tanggal & waktu lengkap beserta timezone (UTC).
  - `bool`: Nilai boolean (`true` / `false`).
  - `jsonb`: Struktur data JSON biner untuk metadata fleksibel.
  - `int8` / `int4`: Bilangan bulat (*integer*).
- **`Default Value`**:
  - `now()`: Otomatis mengisi waktu saat data dibuat.
  - `uuid_generate_v4()`: Otomatis menghasilkan ID UUID acak.
- **`Primary (PK)`**: Menandai kolom sebagai kunci primer unik tabel.
- **`Options (Gear Icon)`**:
  - `Is Unique`: Memastikan tidak ada data duplikat pada kolom tersebut (misal: `slug` workspace).
  - `Is Array`: Mendukung penyimpanan array (misal: `text[]`).

#### 4. 🔗 Foreign Keys Relation
- **Fungsi**: Membangun integritas referensial antar tabel di PostgreSQL.
- **Aksi Penghapusan (*Action on Delete*)**:
  - **`CASCADE`**: Jika baris induk dihapus, seluruh baris anak otomatis terhapus (contoh: jika sebuah *Workspace* dihapus, semua *Proyek* dan *Tugas* di dalamnya otomatis terhapus bersih).
  - **`SET NULL`**: Jika baris induk dihapus, kolom anak disetel menjadi `NULL` (contoh: jika user dihapus, kolom `assigned_to` pada tugas menjadi kosong tapi tugas tidak ikut terhapus).
  - **`RESTRICT`**: Mencegah penghapusan baris induk jika masih memiliki data anak terkait.

#### 5. 🌐 Data API Access Toggle Switch
- **Fungsi**: Menentukan apakah tabel ini otomatis diekspos ke REST PostgREST API dan SDK `@supabase/supabase-js`.
- **Status Default (ON)**: Wajib aktif agar frontend MariFlow dapat melakukan query `supabase.from('tasks').select('*')`.

---

## 💎 11. Matriks Komparasi: FREE Tier vs PRO Tier (Panduan Batasan & Skalabilitas)

Karena saat ini kita menggunakan **FREE Tier** di organisasi `Mari Partner`, berikut adalah panduan lengkap fitur yang **Bebas Digunakan Gratis** vs fitur yang **Terkunci di Paket PRO ($25/bulan)**:

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🟢 FREE TIER (Paket MariFlow Saat Ini)          vs          🔒 PRO TIER ($25/bulan)                    │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 💾 500 MB Database PostgreSQL Storage                       💾 8 GB Database Storage Included          │
│ ⚙️ Compute NANO (Shared CPU, 0.5 GB RAM)                    ⚙️ Micro / Small / Medium Dedicated Compute │
│ ⏸️ Auto-pause setelah 7 hari tidak aktif                    🚫 Bebas Pause (Selalu Aktif 24/7)         │
│ 📦 1 GB Storage Buckets (File Max 50 MB)                    📦 100 GB Storage Buckets (File Max 5 GB)  │
│ 📡 200 Realtime Concurrent Connections                      📡 500 Realtime Concurrent Connections     │
│ 🔑 50,000 Monthly Active Users (MAU)                        🔑 100,000 MAU + SAML SSO (Okta / Azure)   │
│ ⚡ 500,000 Edge Function Invocations/bln                    ⚡ 2,000,000 Invocations/bln               │
│ 📋 1 Hari Log Retention                                     📋 7 Hari Log Retention + PITR Backup      │
│ 🌿 1 Branch Produksi (Main)                                 🌿 Database Branching per Pull Request     │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 11.1 Rincian Fitur Bebas Pakai di FREE Tier (Cukup untuk Pengembangan & MVP)

1. **Database PostgreSQL Penuh**:
   - Bebas membuat tabel, skema, foreign key, triggers, views, dan RPC stored procedures tanpa batas jumlah tabel.
2. **Row Level Security (RLS)**:
   - 100% didukung penuh tanpa batasan pada Free Tier.
3. **Supabase Auth (Otentikasi)**:
   - Mendukung login Email/Password, Magic Link, dan Social Login OAuth (Google, GitHub, Discord, dll) hingga 50.000 pengguna aktif per bulan.
4. **Realtime WebSockets**:
   - Hingga 200 pengguna online bersamaan (*concurrent connections*) yang memantau Kanban board MariFlow secara sinkron.
5. **Storage Buckets**:
   - Hingga 1 GB total kapasitas berkas avatar dan lampiran dokumen tugas (ukuran per file maksimal 50 MB).

---

### 11.2 Daftar Fitur Eksklusif PRO TIER 🔒 (Wajib Diperhatikan)

Jika Anda melihat tombol atau opsi berikut di dashboard Supabase, fitur tersebut **memerlukan langganan PRO**:

| Fitur | Status Tier | Dampak & Alternatif untuk MariFlow (FREE) |
| :--- | :---: | :--- |
| **Point-in-Time Recovery (PITR)** | 🔒 **PRO** | Rollback database ke detik tertentu. Di Free Tier, gunakan ekspor SQL berkala via SQL Editor / CLI. |
| **Database Branching** | 🔒 **PRO** | Membuat clone database terpisah per Git Pull Request. Di Free Tier, gunakan Supabase Local CLI Docker untuk staging. |
| **Image Transformation (`/render/image/`)** | 🔒 **PRO** | Resize & kompresi gambar on-the-fly dari URL Storage. Di Free Tier, kompres gambar di sisi frontend Vue sebelum upload. |
| **Custom Domain Auth (auth.mariflow.com)** | 🔒 **PRO** | Menghilangkan URL `supabase.co` pada email verifikasi. Di Free Tier, gunakan redirect URL frontend. |
| **SAML 2.0 / Enterprise SSO** | 🔒 **PRO** | Login via Okta, Azure AD, OneLogin untuk perusahaan korporat besar. |
| **Log Retention > 1 Hari** | 🔒 **PRO** | Free Tier menyimpan log API Gateway & Postgres selama 24 jam terakhir. |
| **Inactivity Auto-pause** | ⚠️ **FREE Note** | Jika database tidak menerima query selama **7 hari berturut-turut**, project akan otomatis tidur (*paused*). Cukup klik tombol **Restore** di dashboard untuk membangunkannya kembali tanpa kehilangan data. |

---

## 💻 12. Bedah Lengkap Menu SQL Editor (Query Builder, AI Assistant & Chart Visualizer)

Menu **SQL Editor** (icon `>_` pada sidebar) adalah pusat eksekusi perintah DDL (*Data Definition Language*) dan DML (*Data Manipulation Language*) PostgreSQL langsung di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 💻 SQL Editor   [+ New]   [🔍 Search queries...]           [♡] [≡] [🗄️ Database ▼] [Save Ctrl+S] [▶ Run Ctrl↵]│
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ 📁 SNIPPET ORGANIZER:    │ 1  -- Hit CTRL+SHIFT+K to generate query with Supabase AI                  │
│                          │ 2  SELECT                                                                   │
│  > SHARED (Team Snippets)│ 3      w.name AS workspace_name,                                            │
│  > FAVORITES (Starred)   │ 4      COUNT(t.id) AS total_tasks,                                          │
│  v PRIVATE               │ 5      COUNT(t.id) FILTER (WHERE t.status = 'completed') AS completed_tasks │
│    - 01_schema_ddl.sql   │ 6  FROM public.workspaces w                                                 │
│    - 02_rpc_analytics.sql│ 7  LEFT JOIN public.tasks t ON t.workspace_id = w.id                        │
│    - master_seed.sql     │ 8  GROUP BY w.id, w.name;                                                   │
│  > LOGS (Query History)  │                                                                             │
│                          ├─────────────────────────────────────────────────────────────────────────────┤
│ 📚 REFERENCE:            │ [📊 Results]  [📈 Chart]                                                    │
│  - Templates             ├──────────────────────────────────────────┬─────────────┬────────────────────┤
│  - Examples              │ workspace_name                           │ total_tasks │ completed_tasks    │
│                          ├──────────────────────────────────────────┼─────────────┼────────────────────┤
│  [View running queries]  │ Mari Partner Main Hub                    │ 11          │ 3                  │
│                          │ Client Projects & Marketing              │ 4           │ 2                  │
└──────────────────────────┴──────────────────────────────────────────┴─────────────┴────────────────────┘
```

---

### 12.1 Anatomi Panel Kiri (*Snippet Manager & References*)

1. **`SHARED` (Team Snippets)**:
   - Folder snippet SQL yang dapat dibaca dan dieksekusi oleh seluruh anggota tim di organisasi `Mari Partner`.
2. **`FAVORITES` (Starred Queries)**:
   - Tempat menyimpan query SQL yang sering Anda jalankan untuk pemeliharaan rutin atau audit metrik.
3. **`PRIVATE`**:
   - Workspace query pribadi akun Anda. Seluruh query yang Anda ketik akan **otomatis tersimpan (*auto-saved*)**.
4. **`LOGS` (Riwayat Eksekusi)**:
   - Menyimpan riwayat query yang pernah Anda jalankan sebelumnya, sangat berguna jika Anda ingin mengulang atau menelusuri query yang belum sempat di-bookmark.
5. **`REFERENCE` (`Templates` & `Examples`)**:
   - Kumpulan template SQL resmi bawaan Supabase:
     - *Quickstart RLS Policies* (Contoh kebijakan multi-tenant).
     - *Database Webhooks* (Trigger HTTP POST saat ada perubahan data).
     - *Stripe Billing Sync* (Skema langganan SaaS).
     - *Cron Scheduled Jobs* (`pg_cron` otomatisasi berkala).
6. **Tombol `View running queries` (`pg_stat_activity`)**:
   - Menampilkan daftar transaksi SQL yang sedang berjalan di PostgreSQL. Jika terjadi query berat yang macet (*stuck*), Anda dapat membatalkannya (*terminate/cancel backend*) dari modal ini.

---

### 12.2 Fitur Unggulan Editor & Supabase AI (`Ctrl+Shift+K`)

1. **Supabase AI Assistant (`Ctrl + Shift + K`)**:
   - Asisten kecerdasan buatan bawaan Supabase. Anda cukup mengetikkan prompt bahasa manusia (contoh: *"Buatkan query untuk menghitung persentase penyelesaian tugas per proyek"*), dan AI akan otomatis mengonversinya menjadi sintaks SQL PostgreSQL yang optimal.
2. **Target Connection Selector (`Database ▼`)**:
   - Memilih jalur koneksi eksekusi query:
     - **Direct Connection**: Koneksi langsung ke engine PostgreSQL (Port 5432).
     - **Connection Pooler (Supavisor)**: Koneksi melalui Transaction Pooler (Port 6543) yang hemat memori untuk query concurrent tinggi.
3. **Shortcut Eksekusi**:
   - **`Ctrl + ↵` (Windows)** / **`Cmd + ↵` (Mac)**: Menjalankan seluruh query atau blok teks yang sedang di-blok (*highlighted*).
   - **`Ctrl + S`**: Menyimpan query tab ke Snippet Organizer.

---

### 12.3 Panel Hasil Eksekusi: Tab `Results` & `Chart`

Supabase menyediakan dua tab visualisasi hasil query:

1. **Tab `Results` (Data Grid)**:
   - Menampilkan baris data dalam format tabel interaktif.
   - Dilengkapi tombol **Copy as CSV / JSON** untuk kemudahan ekspor data analisis.
   - Menampilkan durasi eksekusi query (contoh: `Success. 11 rows returned in 18ms`).
2. **Tab `Chart` (Visualisasi Grafik Instan)**:
   - **Fitur Cerdas**: Supabase secara otomatis dapat mengubah hasil query numerik menjadi grafik visual (**Bar Chart**, **Line Chart**, atau **Area Chart**) langsung di browser tanpa perlu menginstal aplikasi BI eksternal!

---

## 🗄️ 13. Bedah Komprehensif Menu Database (Schema Visualizer, Functions, Triggers & Access Control)

Menu **Database** (icon 🗄️ pada sidebar) adalah pusat kendali tingkat rendah (*low-level engine controller*) PostgreSQL di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🗄️ Database  [schema public ▼]                                                                         │
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ 📂 DATABASE MANAGEMENT:  │                                                                             │
│  - Schema Visualizer     │  ┌───────────────────────────────────────────────────────────────────────┐  │
│  - Tables                │  │ 🗺️ SCHEMA VISUALIZER (ER Diagram Interaktif)                          │  │
│  - Functions (RPC)       │  │                                                                       │  │
│  - Triggers              │  │  [workspaces] ────────1:N──────── [projects]                          │  │
│  - Enumerated Types      │  │        │                              │                               │  │
│  - Extensions            │  │        1:N                            1:N                             │  │
│  - Indexes               │  │        ▼                              ▼                               │  │
│  - Publications          │  │  [workspace_members]                  [tasks] ───1:N─── [task_comments]│  │
│                          │  └───────────────────────────────────────────────────────────────────────┘  │
│ 🛡️ ACCESS CONTROL:       │                                                                             │
│  - Policies (RLS)        │  ⚡ DATABASE FUNCTIONS (RPC):                                               │
│  - Roles (Postgres)      │  - rls_auto_enable (Definer)                                                │
│                          │  - get_role_dashboard_analytics (RPC KPI Analytics)                         │
│ ⚙️ CONFIGURATION:        │  - set_updated_at (Trigger Function)                                       │
│  - Settings              │                                                                             │
│                          │  🔔 DATABASE TRIGGERS:                                                      │
│ 🚀 PLATFORM:             │  - set_profiles_updated_at (BEFORE UPDATE ON profiles)                      │
│  - Replication [NEW]     │  - set_tasks_updated_at (BEFORE UPDATE ON tasks)                            │
│  - Backups               │                                                                             │
│  - Migrations            │                                                                             │
└──────────────────────────┴─────────────────────────────────────────────────────────────────────────────┘
```

---

### 13.1 Kelompok 1: DATABASE MANAGEMENT

#### 1. 🗺️ Schema Visualizer (Entity-Relationship Diagram Interaktif)
- **Fungsi**: Secara otomatis menggambar diagram relasi database (ERD) visual dengan menghubungkan tabel, kolom Primary Key (PK), dan Foreign Key (FK) garis penghubung secara interaktif.
- **Keterkaitannya dengan MariFlow**:
  - Anda dapat melihat peta relasi utuh dari `profiles` ➔ `workspace_members` ➔ `workspaces` ➔ `projects` ➔ `tasks` ➔ `task_comments` tanpa perlu aplikasi diagram eksternal seperti Draw.io atau DBeaver.

#### 2. 📋 Tables (Dashboard Metrik Tabel)
- **Fungsi**: Menampilkan daftar seluruh tabel dalam skema beserta metrik penting:
  - `COLUMNS`: Jumlah kolom pada tabel.
  - `ROWS (ESTIMATED)`: Perkiraan jumlah baris data yang tersimpan.
  - `SIZE (ESTIMATED)`: Perkiraan ukuran memori disk terpakai oleh tabel (dalam KB/MB).
  - `REALTIME`: Menandai apakah tabel telah aktif di replikasi WebSocket `supabase_realtime`.

#### 3. ⚡ Functions (Database Stored Procedures & Supabase RPC)
- **Fungsi**: Menyimpan fungsi PL/pgSQL atau SQL yang dapat dipanggil langsung dari frontend Vue via `supabase.rpc('function_name', { params })`.
- **Parameter Keamanan (*Security Context*)**:
  - **`SECURITY DEFINER`**: Fungsi dieksekusi dengan hak akses pemilik (*superuser/postgres*), mengabaikan RLS sementara. Sangat berguna untuk fungsi agregasi KPI seperti `get_role_dashboard_analytics` agar dapat menghitung total statistik tanpa terhambat batasan baris individual.
  - **`SECURITY INVOKER`**: Fungsi dieksekusi dengan hak akses pengguna yang sedang login (*auth.uid()*).

#### 4. 🔔 Triggers (Pemicu Otomatis)
- **Fungsi**: Mengeksekusi fungsi tertentu secara otomatis saat terjadi event database:
  - **Tab `Data` (DML Triggers)**: Pemicu saat data di-`INSERT`, `UPDATE`, atau `DELETE`. Contoh: Trigger `set_updated_at()` yang otomatis memperbarui nilai kolom `updated_at` menjadi waktu sekarang setiap kali kartu tugas diedit.
  - **Tab `Event` (DDL Triggers)**: Pemicu saat struktur skema berubah (`CREATE TABLE`, `DROP TABLE`). Contoh: `rls_auto_enable` yang otomatis mengaktifkan RLS saat tabel baru dibuat.
  - **Database Webhooks**: Memanggil HTTP REST endpoint eksternal saat data berubah (misal: mengirim pesan Telegram / Slack saat tugas baru dibuat).

#### 5. 🏷️ Enumerated Types (Custom ENUM Postgres)
- **Fungsi**: Menyimpan daftar tipe data pilihan kustom yang konsisten di level database:
  - `workspace_role`: `'owner'`, `'admin'`, `'member'`, `'viewer'`
  - `project_status`: `'planning'`, `'active'`, `'completed'`, `'archived'`
  - `task_status`: `'todo'`, `'in_progress'`, `'review'`, `'completed'`, `'cancelled'`
  - `task_priority`: `'low'`, `'medium'`, `'high'`, `'urgent'`
  - `user_role`: `'superadmin'`, `'owner'`, `'admin'`, `'member'`, `'viewer'`

#### 6. 🔌 Extensions (Ekstensi Ekosistem PostgreSQL)
- **Fungsi**: Mengaktifkan modul tambahan PostgreSQL dengan sekali klik (tanpa kompilasi server):
  - `uuid-ossp`: Menghasilkan UUID v4 (`uuid_generate_v4()`).
  - `pgcrypto`: Algoritma hashing kata sandi bcrypt (`crypt()`, `gen_salt()`).
  - `pgvector`: Penyimpanan vector embedding berkecepatan tinggi untuk fitur AI Search / LLM RAG.
  - `pg_cron`: Menjalankan scheduled cron job langsung di dalam database PostgreSQL.
  - `http`: Melakukan panggilan HTTP request langsung dari fungsi SQL.

#### 7. ⚡ Indexes (Indeks Pengoptimal Query)
- **Fungsi**: Mempercepat query pencarian dan penyaringan data (*filtering*) hingga ratusan kali lipat.
- **Wajib di MariFlow**: Indeks pada foreign key `workspace_id`, `project_id`, dan kolom status `status` serta `created_at DESC` untuk sorting cepat.

#### 8. 📡 Publications (Replikasi Logis Realtime)
- **Fungsi**: Mengatur publikasi PostgreSQL `supabase_realtime` yang menentukan tabel apa saja yang disiarkan ke client WebSocket frontend secara live.

---

### 13.2 Kelompok 2: ACCESS CONTROL

#### 1. 🛡️ Policies (Row Level Security Visual Manager)
- **Fungsi**: Tempat melihat, mengedit, dan mengaudit seluruh aturan RLS PostgreSQL secara visual. Anda dapat melihat policy mana yang aktif untuk operasi `SELECT`, `INSERT`, `UPDATE`, dan `DELETE`.

#### 2. 👥 Roles (PostgreSQL Database Roles)
- **Fungsi**: Hierarki akun sistem PostgreSQL internal:
  - `anon`: Pengguna tamu publik (sebelum login).
  - `authenticated`: Pengguna yang berhasil login dan memiliki token JWT valid.
  - `service_role`: Kunci rahasia backend dengan bypass RLS penuh (Dilarang ditaruh di frontend).
  - `postgres`: Superuser pemilik database.

---

### 13.3 Kelompok 3: CONFIGURATION & PLATFORM

#### 1. ⚙️ Settings (Konfigurasi Engine Postgres)
- Mengatur *Connection Pooling* (Supavisor), SSL mode enforce, parameter waktu *statement timeout* (mencegah query lambat menggantung server), dan zona waktu UTC.

#### 2. 🚀 Platform Tools (`Replication`, `Backups`, `Migrations`)
- **`Replication` [NEW]**: Replikasi data real-time ke database cadangan atau sinkronisasi data lake.
- **`Backups`**:
  - *Free Tier*: Backup manual via ekspor SQL / Supabase CLI.
  - *Pro Tier 🔒*: Backup harian otomatis dengan retensi 7 hari + Point-in-Time Recovery (PITR).
- **`Migrations`**: Riwayat pencatatan versioning skema database yang dieksekusi melalui Supabase CLI (`supabase migration up`).

---

## 🔌 14. Panduan Lengkap Ekstensi PostgreSQL (*Database Extensions Masterclass*)

Menu **Database ➔ Extensions** (icon 🔌) memungkinkan Anda mengaktifkan kemampuan tingkat lanjut (*superpowers*) pada database PostgreSQL hanya dengan satu kali klik toggle atau perintah SQL sederhana.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🔌 Database Extensions  [🔍 Search for an extension...]                                       [📖 Docs]│
├──────────────────────┬─────────┬────────────┬────────────────────────────────────────────┬─────────────┤
│ NAME                 │ VERSION │ SCHEMA     │ DESCRIPTION                                │ ENABLED     │
├──────────────────────┼─────────┼────────────┼────────────────────────────────────────────┼─────────────┤
│ 🟢 pgcrypto          │ 1.3     │ extensions │ Cryptographic functions & password hashing │ (🔘 ON)     │
│ 🟢 uuid-ossp         │ 1.1     │ extensions │ Generate universally unique identifiers    │ (🔘 ON)     │
│ 🟢 pg_stat_statements│ 1.11    │ extensions │ Track execution statistics of SQL queries  │ (🔘 ON)     │
│ 🟢 plpgsql           │ 1.0     │ pg_catalog │ PL/pgSQL procedural programming language   │ (🔘 ON)     │
│ ⚪ pg_net            │ 0.20.4  │ extensions │ Async HTTP client (Used by Webhooks)       │ (⚪ OFF)    │
│ ⚪ pg_cron           │ 1.6.4   │ extensions │ In-database job scheduler for PostgreSQL   │ (⚪ OFF)    │
│ ⚪ pgmq              │ 1.5.1   │ extensions │ Lightweight message queue (like AWS SQS)   │ (⚪ OFF)    │
│ ⚪ pg_hashids        │ 1.3.0   │ extensions │ Generate short alphanumeric YouTube-like ID│ (⚪ OFF)    │
│ ⚪ pgvector          │ 0.8.0   │ extensions │ Vector embeddings for AI & Semantic Search │ (⚪ OFF)    │
└──────────────────────┴─────────┴────────────┴────────────────────────────────────────────┴─────────────┘
```

---

### 14.1 Mengapa Supabase Menggunakan Schema `extensions`?

Secara default di PostgreSQL standar, ekstensi diinstal ke dalam skema `public`. Namun di Supabase, seluruh ekstensi diinstal secara rapi di dalam skema terpisah bernama **`extensions`**.

**Keuntungan Arsitektural**:
1. **Kebersihan Skema `public`**: Mencegah puluhan fungsi internal ekstensi mengotori daftar tabel/fungsi aplikasi MariFlow Anda di Table Editor.
2. **Keamanan Ekstra**: Skema `extensions` tidak diekspos secara publik oleh PostgREST API Gateway, sehingga aman dari potensi eksekusi fungsi kriptografi sewenang-wenang dari frontend.

---

### 14.2 4 Ekstensi Utama yang Wajib Aktif (*Enabled by Default*) untuk MariFlow

1. **`uuid-ossp` (v1.1)**:
   - **Fungsi**: Menyediakan fungsi `uuid_generate_v4()` untuk menghasilkan Primary Key unik global 128-bit pada tabel `workspaces`, `projects`, `tasks`, dan `comments`.
2. **`pgcrypto` (v1.3)**:
   - **Fungsi**: Menyediakan algoritma kriptografi canggih seperti `crypt()` dan `gen_salt('bf')` untuk mengenkripsi kata sandi akun pengguna demo di seeder serta fungsi HMAC/SHA256 untuk verifikasi signature.
3. **`pg_stat_statements` (v1.11)**:
   - **Fungsi**: Merekam metrik waktu eksekusi seluruh query SQL di latar belakang. Ekstensi ini menjadi fondasi bagi menu **Advisors** dan **Observability** untuk mendeteksi *Slow Queries*.
4. **`plpgsql` (v1.0)**:
   - **Fungsi**: Bahasa pemrograman prosedural inti PostgreSQL yang memungkinkan kita membuat stored procedures dan database triggers (seperti fungsi RPC statistik dashboard kita).

---

### 14.3 Ekstensi Pilihan SaaS Paling Berguna untuk Pengembangan Fitur Lanjutan

Berdasarkan daftar ekstensi yang ada di tangkapan layar, berikut adalah ekstensi terbaik yang dapat diaktifkan saat MariFlow berkembang:

| Nama Ekstensi | Deskripsi & Kegunaan Nyata untuk SaaS | Contoh Use Case di MariFlow |
| :--- | :--- | :--- |
| **`pg_net`** | **Async HTTP Networking Client**: Melakukan panggilan HTTP/HTTPS (GET, POST) asinkron langsung dari trigger database tanpa memblokir transaksi user. | Mengirim notifikasi webhook ke Slack, Discord, atau WhatsApp Gateway saat ada tugas kanban yang *Overdue*. |
| **`pg_cron`** | **In-Database Job Scheduler**: Menjadwalkan eksekusi query SQL berkala layaknya Linux Cron (`* * * * *`). | Mengarsipkan otomatis tugas yang sudah selesai lebih dari 30 hari atau mengirim rekap email mingguan setiap Senin pagi. |
| **`pgmq`** | **Lightweight Message Queue**: Sistem antrean pesan (Queue / Job Worker) murni di dalam PostgreSQL tanpa perlu Redis, RabbitMQ, atau AWS SQS. | Menangani antrean pengiriman email massal dan pemrosesan kompresi dokumen di latar belakang. |
| **`pg_hashids`** | **Short Unique ID Generator**: Mengubah ID integer menjadi kode pendek acak (seperti ID video YouTube `dQw4w9WgXcQ`). | Membuat tautan undangan workspace pendek yang ramah dibagikan (misal: `mariflow.app/invite/xK9jL2`). |
| **`index_advisor`** | **Query Optimization Advisor**: Menganalisis query yang Anda jalankan dan merekomendasikan pembuatan indeks yang tepat untuk mempercepat query. | Membantu menemukan kolom filter yang perlu diindeks saat jumlah data tugas mencapai puluhan ribu. |
| **`pg_jsonschema`** | **JSON Schema Validator**: Memvalidasi integritas struktur data kolom `jsonb` agar sesuai dengan skema JSON standar. | Memastikan kolom `metadata` atau `custom_fields` pada kartu tugas selalu memiliki tipe data yang valid. |
| **`fuzzystrmatch`** | **Fuzzy String Matching (Levenshtein)**: Algoritma pencocokan kemiripan string toleran saltik (*typo-tolerant search*). | Memungkinkan pencarian tugas tetap menemukan hasil meskipun pengguna salah mengetik 1-2 huruf pada judul tugas. |
| **`pg_repack`** | **Online Table Defragmentation**: Merapikan dan mengklaim kembali ruang disk kosong pada tabel besar tanpa mengunci (*table lock*) database. | Pemeliharaan database saat data lama dihapus secara massal agar ukuran database tetap hemat di Free Tier. |
| **`pgvector`** | **Vector Similarity Search**: Menyimpan dan mencari vektor embedding kecerdasan buatan. | Fitur AI Semantic Search untuk mencari tugas atau dokumen berdasarkan konteks makna, bukan sekadar kata kunci teks murni. |

---

### 14.4 Cara Mengaktifkan Ekstensi via SQL Script

Selain mengklik tombol toggle di dashboard, Anda dapat mengaktifkan ekstensi melalui SQL Editor:

```sql
-- Mengaktifkan ekstensi pgcrypto ke dalam skema extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;

-- Mengaktifkan ekstensi pg_net untuk Database Webhooks
CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA extensions;

-- Mengaktifkan ekstensi pg_cron untuk Scheduled Jobs
CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA extensions;
```

---

## ⚡ 15. Panduan Lengkap Optimasi Query & Database Indexes (*Query Optimization Masterclass*)

Menu **Database ➔ Indexes** (icon ⚡) dan panduan resmi [Supabase Query Optimization](https://supabase.com/docs/guides/database/query-optimization) menjelaskan strategi krusial untuk memastikan database MariFlow tetap cepat, hemat memori, dan mampu melayani ribuan request per detik tanpa *slow queries*.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚡ Database Indexes  [schema public ▼]  [🔍 Search for an index...]         [📖 Docs] [💡 Index Advisor]│
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ TABLE                    │ COLUMNS                                  │ NAME                             │
├──────────────────────────┼──────────────────────────────────────────┼──────────────────────────────────┤
│ public.workspaces        │ owner_id                                 │ idx_workspaces_owner_id          │
│ public.workspace_members │ workspace_id, user_id                   │ idx_workspace_members_ws_user    │
│ public.projects          │ workspace_id, status                     │ idx_projects_workspace_status    │
│ public.tasks             │ workspace_id, status, assigned_to        │ idx_tasks_workspace_status_pic  │
│ public.tasks             │ created_at DESC                          │ idx_tasks_created_at_desc        │
└──────────────────────────┴──────────────────────────────────────────┴──────────────────────────────────┘
```

---

### 15.1 Mengapa Database Index Sangat Penting bagi SaaS Multi-Tenant?

Tanpa indeks, setiap kali pengguna membuka papan Kanban di MariFlow, PostgreSQL harus melakukan **Sequential Scan (Seq Scan)** — yaitu membaca jutaan baris data dari awal hingga akhir disk satu per satu.

Dengan membuat **Index**, PostgreSQL membangun struktur data pohon seimbang (**B-Tree**) yang bertindak seperti *Daftar Isi Buku*. Query pencarian dapat langsung melompat ke baris yang dituju dalam waktu mikrodetik (**Index Scan**).

```text
Tanpa Index (Seq Scan):  [Baris 1] ➔ [Baris 2] ➔ [Baris 3] ... ➔ [Baris 100.000] (Lambat: ~350ms)
Dengan Index (B-Tree):   [Root Node] ➔ [Branch Node] ➔ [Leaf Pointer]             (Cepat: ~2ms 🚀)
```

---

### 15.2 Anatomi Tipe-Tipe Index di PostgreSQL & Rekomendasi Penggunaannya

Saat membuat indeks di Supabase, Anda dapat memilih tipe struktur data berikut:

| Tipe Index | Karakteristik & Operator yang Didukung | Kapan Digunakan di MariFlow SaaS? |
| :--- | :--- | :--- |
| **`B-Tree`** *(Default & Paling Populer)* | Mendukung pencarian kesetaraan (`=`), perbandingan (`<`, `>`, `<=`, `>=`), rentang (`BETWEEN`, `IN`), dan pengurutan (`ORDER BY`). | **Wajib di seluruh Foreign Key**: `workspace_id`, `project_id`, `assigned_to`, dan kolom tanggal `due_date`. |
| **`GIN`** *(Generalized Inverted Index)* | Indeks terbalik untuk mencari elemen di dalam array (`text[]`), dokumen JSON (`jsonb` dengan operator `@>`, `?`), dan pencarian teks penuh (*Full-Text Search* `tsvector`). | Digunakan jika tugas memiliki kolom `tags text[]` atau `metadata jsonb`. |
| **`GiST`** *(Generalized Search Tree)* | Indeks hierarkis untuk data geometri spasial (PostGIS) dan tipe data rentang waktu (`tsrange`). | Digunakan jika fitur pelacakan durasi kerja (*Time Tracking Range*) diaktifkan. |
| **`BRIN`** *(Block Range Index)* | Indeks berukuran sangat kecil (hanya beberapa KB) untuk tabel raksasa (jutaan baris) yang tersimpan berurutan secara fisik. | Sangat ideal untuk tabel riwayat log sistem **`activity_logs`** pada kolom `created_at`. |
| **`Hash`** | Hanya mendukung pencocokan kesetaraan persis (`=`). | Jarang digunakan karena B-Tree jauh lebih fleksibel. |

---

### 15.3 Teknik Optimasi Lanjutan (*Advanced SaaS Indexing Strategies*)

#### 1. Composite Index (Indeks Gabungan Multi-Kolom)
Jika query frontend Anda sering memfilter berdasarkan beberapa kolom sekaligus (misal: mengambil tugas berdasarkan `workspace_id` dan `status`):
```sql
-- Mempercepat query: SELECT * FROM tasks WHERE workspace_id = '...' AND status = 'in_progress'
CREATE INDEX idx_tasks_workspace_status ON public.tasks (workspace_id, status);
```

#### 2. Partial Index (Indeks Sebagian / Bersyarat)
Teknik brilian untuk menghemat ruang disk hingga **80%** di Free Tier dengan hanya mengindeks data aktif:
```sql
-- Hanya mengindeks tugas yang BELUM selesai (mengabaikan jutaan riwayat tugas 'completed')
CREATE INDEX idx_active_tasks ON public.tasks (workspace_id) 
WHERE status != 'completed';
```

#### 3. Covering Index dengan Klausul `INCLUDE`
Menyertakan kolom payload tambahan ke dalam indeks agar PostgreSQL tidak perlu membuka tabel utama (*Index-Only Scan*):
```sql
CREATE INDEX idx_tasks_lookup ON public.tasks (workspace_id) 
INCLUDE (title, priority);
```

---

### 15.4 Memeriksa Kinerja Query dengan `EXPLAIN ANALYZE`

Untuk membuktikan apakah query Anda sudah optimal dan menggunakan indeks, jalankan perintah `EXPLAIN ANALYZE` di **SQL Editor**:

```sql
EXPLAIN ANALYZE
SELECT id, title, priority 
FROM public.tasks 
WHERE workspace_id = '10000000-0000-0000-0000-000000000001' 
  AND status = 'in_progress';
```

**Hasil yang Diharapkan**:
- Muncul teks `Index Scan using idx_tasks_workspace_status ...` (Bukan `Seq Scan`).
- `Execution Time`: Kurang dari `< 5ms`.

---

### 15.5 Fitur Supabase Index Advisor (Tombol di Kanan Atas)
- Tombol **`Index Advisor`** pada dashboard Supabase secara cerdas menganalisis log riwayat query aplikasi Anda dan secara otomatis merekomendasikan query `CREATE INDEX` yang paling berdampak untuk mempercepat performa database!

---

## 🛡️ 16. Bedah Lengkap Database Publications, Policies (RLS), & Roles Architecture

Menu **Publications** dan kelompok **ACCESS CONTROL** (`Policies` & `Roles`) adalah benteng pertahanan utama keamanan (*Security Boundary*) dan pipa replikasi real-time di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🛡️ ACCESS CONTROL & PUBLICATIONS ARCHITECTURE                                                          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📡 PUBLICATIONS (Replikasi WebSocket Realtime):                                                        │
│  - [supabase_realtime] ──► Event: [✓] INSERT  [✓] UPDATE  [✓] DELETE  [✓] TRUNCATE                    │
│    └─ Tabel Terdaftar: public.tasks, public.task_comments, public.notifications                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 👥 POSTGRESQL ROLES (Hierarki Akun Database):                                                          │
│  1. anon             : Pengguna publik tanpa token login (Hanya baca data landing/public).            │
│  2. authenticated    : Pengguna sah yang telah login (Membawa JWT auth.uid()).                        │
│  3. authenticator    : Gateway PostgREST yang memvalidasi JWT dan bertukar peran.                     │
│  4. service_role     : Kunci rahasia backend dengan privilese BYPASSRLS penuh.                        │
│  5. supabase_admin   : Superuser pengelola internal server PostgreSQL.                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔐 POLICIES (Row Level Security Visual Auditor):                                                       │
│  - SELECT Policy     : Hanya tampilkan tugas di mana pengguna menjadi anggota workspace aktif.         │
│  - INSERT Policy     : Hanya izinkan anggota dengan role minimal 'member' membuat tugas baru.          │
│  - UPDATE Policy     : Hanya izinkan pembuat tugas / assignee / admin mengubah status kanban.          │
│  - DELETE Policy     : Hanya izinkan Owner & Admin workspace menghapus tugas.                          │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 16.1 📡 Database Publications (`supabase_realtime`)

Pada menu **Database ➔ Publications**, Anda melihat publikasi bernama **`supabase_realtime`** (System ID: `16430`).

#### 1. Cara Kerja Publikasi Replikasi
- Supabase Realtime memanfaatkan fitur **PostgreSQL Logical Replication**.
- Saat ada data yang berubah di database, engine PostgreSQL akan menerbitkan (*publish*) rekaman perubahan ke *Replication Stream* yang kemudian ditangkap oleh Realtime Server Elixir untuk disiarkan ke frontend Vue melalui WebSocket.

#### 2. Event Toggles (`INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`)
- Anda dapat mengontrol tipe event apa saja yang disiarkan:
  - **`INSERT`**: Menyiarkan baris data baru saat tugas / komentar baru dibuat.
  - **`UPDATE`**: Menyiarkan perubahan data saat kartu tugas dipindah antar kolom Kanban.
  - **`DELETE`**: Menyiarkan notifikasi penghapusan baris data.
  - **`TRUNCATE`**: Menyiarkan pembersihan seluruh data tabel.

> [!TIP]
> **Best Practice SaaS (Hemat Kuota Free Tier)**:
> Jangan daftarkan seluruh tabel ke dalam `supabase_realtime`. Daftarkan hanya tabel yang membutuhkan kolaborasi langsung (*live sync*), seperti **`tasks`**, **`task_comments`**, dan **`notifications`**. Tabel statis seperti `profiles` atau `workspaces` cukup diambil saat *page load*.

---

### 16.2 🔐 Policies (Row Level Security Visual Manager)

Menu **Database ➔ Policies** adalah tempat Anda memantau dan mengaudit seluruh aturan keamanan baris (RLS) di seluruh tabel skema `public`.

- **Kenapa RLS Wajib di MariFlow SaaS?**:
  - Di arsitektur Backend-as-a-Service (BaaS), frontend Vue berinteraksi langsung dengan database PostgreSQL.
  - RLS bertindak sebagai *filter otomatis permanen di level kernel database*. Pengguna dari Workspace A **secara matematis mustahil** membaca atau memanipulasi data milik Workspace B, meskipun mereka mencoba mengirim raw SQL/HTTP request dari Postman!

---

### 16.3 👥 Database Roles (Hierarki Peran PostgreSQL & Arsitektur Keamanan)

Menu **Database ➔ Roles** menampilkan seluruh peran (*database roles*) yang dikelola oleh Supabase (`Roles managed by Supabase - PROTECTED`):

| Nama Role | Status Proteksi | Deskripsi & Perannya dalam Ekosistem Supabase |
| :--- | :--- | :--- |
| **`anon`** | 🟢 Terproteksi | Digunakan untuk request publik sebelum pengguna login. Hanya boleh membaca tabel publik (seperti landing page). |
| **`authenticated`** | 🟢 Terproteksi | Digunakan setelah user login via `supabase.auth.signInWithPassword()`. Seluruh query SQL otomatis memiliki konteks `auth.uid()`. |
| **`authenticator`** | 🟢 Terproteksi | Peran jembatan (*bridge role*) yang dipakai oleh API Gateway PostgREST. Saat HTTP request masuk dengan Bearer Token JWT, `authenticator` memvalidasi signature token, lalu secara dinamis berganti peran (*assume role*) menjadi `authenticated` atau `anon`. |
| **`service_role`** | 🟢 Terproteksi | Kunci rahasia administratif (*secret key*) yang memiliki privilese **`BYPASSRLS`**. **Dilarang keras dimasukkan ke frontend Vue**. Hanya digunakan di Edge Functions atau backend terisolasi. |
| **`dashboard_user`** | 🟢 Terproteksi | Peran yang digunakan oleh browser Anda saat mengoperasikan Table Editor atau SQL Editor di dashboard Supabase. |
| **`pgbouncer`** | 🟢 Terproteksi | Peran internal untuk mengelola *Connection Pooler* (Supavisor / PgBouncer). |
| **`supabase_admin`** | 🟢 Terproteksi | Peran superuser internal sistem Supabase untuk pemeliharaan cloud infrastructure. |
| **`supabase_auth_admin`**| 🟢 Terproteksi | Peran khusus yang mengelola tabel otentikasi `auth.users` dan `auth.identities`. |

---

### 16.4 ➕ Anatomi Drawer "Create a new role" & Privilese Database

Saat Anda mengklik tombol **`+ Add role`**, Anda dapat membuat custom role untuk kebutuhan khusus (misal: bot data analytics atau integrasi read-only ETL):

1. **`User can login` (`LOGIN`)**: Mengizinkan role ini terhubung ke database menggunakan username & password.
2. **`User can create roles` (`CREATEROLE`)**: Mengizinkan role ini membuat sub-role baru.
3. **`User can create databases` (`CREATEDB`)**: Mengizinkan pembuatan database baru.
4. **`User bypasses every row level security policy` (`BYPASSRLS`)**:
   - ⚠️ **Sangat Berbahaya**: Mengabaikan seluruh aturan RLS (seperti `service_role`). Jangan aktifkan untuk akun publik!
5. **`User can initiate streaming replication` (`REPLICATION`)**: Mengizinkan sinkronisasi data replikasi eksternal.
6. **Batasan Keamanan Cloud**:
   - *These privileges cannot be granted via the Dashboard: User is a Superuser*.
   - Supabase menonaktifkan pemberian hak akses Superuser murni demi menjaga integritas dan keamanan cloud database multi-tenant.

---

## ⚙️ 17. Bedah Lengkap Database Settings (Password, Connection Pooling, SSL, & Security)

Menu **Database ➔ Settings** (kelompok `CONFIGURATION`) adalah panel pengaturan konektivitas, performa *connection pooling*, enkripsi SSL, dan restriksi jaringan database.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚙️ Database Settings (Connections, Security, and Network Configuration)                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔑 DATABASE PASSWORD:                                                                                  │
│  - [Reset password] ──► Password tidak dapat dilihat ulang. Reset memutus koneksi aktif.              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🏊 CONNECTION POOLING (Supavisor):                                                                     │
│  - Compute Tier (Free): Nano                                                                           │
│  - Direct Pool Size   : 15 connections (Cluster Postgres)                                              │
│  - Max Client Pool    : 200 clients (Concurrent Pooler Supavisor - Port 6543)                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔒 SSL CONFIGURATION:                                                                                  │
│  - [🔘] Enforce SSL on incoming connections (Tolak koneksi tanpa enkripsi TLS)                         │
│  - [⬇️ Download certificate] (prod-ca-2021.crt untuk verifikasi root CA)                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 NETWORK RESTRICTIONS & BANS:                                                                        │
│  - Network Restrictions: Membatasi IP Whitelist yang boleh mengakses port database 5432/6543.          │
│  - Network Bans        : Daftar IP yang diblokir otomatis akibat percobaan brute-force.                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📋 CONNECTION LOGGING:                                                                                 │
│  - [🔘] Log connections    : Mencatat setiap koneksi baru yang berhasil.                              │
│  - [🔘] Log disconnections : Mencatat akhir sesi beserta durasi koneksi.                               │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 17.1 🔑 Database Password & Dampak Reset Password

- **Prinsip Keamanan**: Supabase tidak pernah menyimpan kata sandi database Anda dalam bentuk teks terbuka (*plaintext*). Sekali dibuat saat inisialisasi proyek, kata sandi tersebut tidak dapat dilihat kembali.
- **Tombol `Reset password`**:
  - Jika Anda lupa kata sandi database direct connection, Anda dapat meresetnya kapan saja.
  - ⚠️ **Peringatan**: Mereset kata sandi akan langsung memutus seluruh koneksi database aktif yang sedang menggunakan kata sandi lama (misalnya koneksi aplikasi GUI DBeaver, pgAdmin, atau migrasi CLI).

---

### 17.2 🏊 Connection Pooling (Supavisor): Solusi 200 Koneksi di Free Tier

Database PostgreSQL tradisional menggunakan model *process-based connection*, di mana setiap 1 koneksi baru memakan ~2-10 MB memori RAM. Pada serverless atau aplikasi SaaS dengan ratusan pengguna aktif, koneksi database langsung bisa cepat habis (*Connection Exhaustion / Too many clients*).

Supabase menyediakan **Supavisor** — *Connection Pooler* generasi terbaru:

1. **Direct Cluster Pool Size (`15 connections`)**:
   - Jumlah koneksi langsung maksimal ke engine PostgreSQL fisik pada paket Free Tier (Compute Nano).
   - Digunakan untuk koneksi berdurasi panjang seperti DDL migrasi skema tabel.
2. **Max Client Connections (`200 clients`)**:
   - Jumlah pengguna / request bersamaan yang dapat dilayani oleh Supavisor Transaction Pooler (Port 6543).
   - **Cara Kerja**: Supavisor memegang koneksi ke klien, namun hanya meminjamkan koneksi PostgreSQL fisik selama transaksi query SQL berlangsung (dalam hitungan milidetik), lalu mengembalikannya ke *pool* agar bisa dipakai oleh pengguna lain!

---

### 17.3 🔒 SSL Configuration (Enkripsi Data In-Transit)

1. **Toggle `Enforce SSL on incoming connections`**:
   - Saat diaktifkan, database akan **menolak secara mutlak** seluruh koneksi plaintext tanpa enkripsi TLS/SSL. Ini mencegah penyerang di jaringan publik menyadap query data atau password database Anda (*Man-In-The-Middle attack*).
2. **Tombol `Download certificate`**:
   - Mengunduh sertifikat Root CA resmi Supabase (`prod-ca-2021.crt`).
   - Digunakan saat Anda mengonfigurasi koneksi database di aplikasi eksternal (seperti DBeaver, Prisma, atau backend Node) dengan mode `sslmode=verify-full`.

---

### 17.4 🌐 Network Restrictions (IP Whitelist) & Network Bans

1. **`Network restrictions` (`Restrict all access` / `+ Add restriction`)**:
   - Membatasi IP address mana saja di internet yang diizinkan melakukan koneksi langsung ke port PostgreSQL 5432 / 6543.
   - Sangat direkomendasikan untuk SaaS tahap produksi agar hanya IP server aplikasi atau VPN kantor yang boleh mengakses database langsung.
2. **`Network bans`**:
   - Sistem pertahanan otomatis Supabase (*Intrusion Detection System*). Jika ada IP luar yang mencoba menebak kata sandi database secara berulang-ulang (*brute-force attack*), IP tersebut akan langsung diblokir sementara di firewall dan dicatat di panel ini.

---

### 17.5 📋 Connection Logging (`log_connections` & `log_disconnections`)

- **`Log connections`**: Mencatat stempel waktu (*timestamp*) dan detail setiap ada klien baru yang terhubung ke database.
- **`Log disconnections`**: Mencatat saat sesi klien berakhir beserta durasi koneksi yang digunakan.
- **Kapan Digunakan?**:
  - Aktifkan saat Anda melakukan audit keamanan atau mendiagnosis *connection leak* (koneksi yang tidak ditutup dengan benar di kode backend).
  - Nonaktifkan saat produksi normal agar log database tetap bersih dan tidak memakan kuota log.

---

## 🚀 18. Bedah Lengkap Database Replication & Supabase Pipelines (BigQuery Analytics & Read Replicas)

Menu **Database ➔ Replication [NEW]** (kelompok `PLATFORM`) dan dokumentasi resmi [Supabase Replication Guides](https://supabase.com/docs/guides/database/replication) menyediakan fasilitas pengaliran data (*data streaming*) dan replikasi multi-node.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🚀 Database Replication (Send data to external destinations)                                            │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🗺️ VISUAL REPLICATION CANVAS:                                                                          │
│                                                                                                        │
│  ┌─────────────────────────────────────┐         Change Data Capture (CDC)    ┌─────────────────────┐ │
│  │ 🇸🇬 Primary Database                │ ─────────────────────────────────────► │ 📊 Google BigQuery  │ │
│  │   Southeast Asia (ap-southeast-1)   │          (Real-time Streaming)         │   (Data Warehouse)  │ │
│  └─────────────────────────────────────┘                                       └─────────────────────┘ │
│                                                                                                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔒 STATUS LISENSI TIER:                                                                                │
│  - Free Tier : Fitur Terkunci (Menampilkan tombol [Upgrade to Pro]).                                   │
│  - Pro Tier  : Mengaktifkan Supabase Pipelines untuk ekspor CDC instan ke BigQuery/Warehouse.          │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 18.1 Dua Jenis Replikasi di Supabase: Read Replicas vs Pipelines

Penting untuk memahami dua konsep replikasi yang berbeda di Supabase:

1. **A. Read Replicas (Dikelola di Halaman `Infrastructure`)**:
   - **Tujuan**: Membuka salinan database PostgreSQL sekunder di berbagai benua (misal: US East, Frankfurt, Tokyo).
   - **Use Case**: Mendistribusikan beban query `SELECT` agar pengguna global di Eropa atau Amerika mendapatkan latensi akses yang sangat cepat (*low latency*).
2. **B. Supabase Pipelines / External Destinations (Menu `Replication [NEW]`)**:
   - **Tujuan**: Mengalirkan seluruh perubahan data (Insert/Update/Delete) secara *real-time* (*Change Data Capture - CDC*) ke Data Warehouse eksternal seperti **Google BigQuery**.
   - **Use Case**: Kebutuhan analitik data besar (*Big Data Analytics*), Business Intelligence (Looker Studio / Tableau), dan Machine Learning.

---

### 18.2 Mengapa SaaS Membutuhkan Replikasi ke Google BigQuery?

Dalam arsitektur sistem SaaS modern, terdapat prinsip pemisahan beban:

- **OLTP (*Online Transaction Processing*) ➔ PostgreSQL (MariFlow)**:
  - Fokus pada transaksi cepat mikrodetik: Login, geser kartu Kanban, tambah tugas, dan buat komentar.
- **OLAP (*Online Analytical Processing*) ➔ Google BigQuery**:
  - Fokus pada kalkulasi agregasi data historis raksasa: *"Hitung rata-rata waktu penyelesaian tugas oleh 500.000 anggota tim selama 3 tahun terakhir berdasarkan kategori proyek."*

> [!TIP]
> **Manfaat Replikasi**:
> Menjalankan query analitik yang memproses jutaan baris data di database operasional PostgreSQL dapat menghabiskan CPU/RAM dan membuat aplikasi pengguna macet (*lag*). Dengan mereplikasi data ke BigQuery via Pipelines, database PostgreSQL MariFlow tetap ringan dan responsif!

---

### 18.3 🔒 Status Paket: FREE Tier vs PRO Tier

> [!WARNING]
> **Fitur Eksklusif PRO TIER 🔒**:
> - **Supabase Pipelines (BigQuery / External Destination)** dan **Read Replicas** memerlukan paket **Supabase Pro Plan ($25/bulan)**.
> - Pada akun **Free Tier** kita saat ini, panel ini menampilkan status *“Upgrade to the Pro plan to replicate database changes to BigQuery”*.

#### 💡 Solusi Analitik untuk MariFlow di Paket FREE Tier:
Karena saat ini kita menggunakan paket Free Tier, kita tidak perlu khawatir:
1. Kita telah mengimplementasikan Stored Procedure RPC **`get_role_dashboard_analytics`** yang sangat efisien dan cepat di dalam PostgreSQL.
2. Untuk pelaporan bulanan, Anda dapat mengekspor data dalam format **CSV / JSON** langsung melalui SQL Editor tanpa biaya sepeser pun.

---

## 💾 19. Bedah Lengkap Database Backups & Database Migrations

Kelompok **PLATFORM** (`Backups` & `Migrations`) menangani manajemen kelangsungan bisnis (*Disaster Recovery*) dan kontrol versi skema database (*Database Infrastructure as Code*).

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 💾 DATABASE BACKUPS & MIGRATIONS OVERVIEW                                                              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📦 DATABASE BACKUPS:                                                                                   │
│  ├─ [Scheduled Backups]    : Backup harian tengah malam (Retensi 7 hari) ──► 🔒 PRO TIER               │
│  ├─ [Point in Time (PITR)] : Rollback ke detik tertentu via WAL Logs     ──► 🔒 PRO TIER ADD-ON ($100) │
│  ├─ [Restore to New Proj]  : Kloning snapshot ke project baru [BETA]     ──► 🔒 PRO TIER               │
│  └─ [Manual CLI Dump]      : Backup via 'supabase db dump' atau pg_dump  ──► 🟢 FREE TIER (100% GRATIS)│
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚀 DATABASE MIGRATIONS (Supabase CLI):                                                                 │
│  1. $ supabase link --project-ref <PROJECT_REF>  (Hubungkan repo lokal ke Cloud)                      │
│  2. $ supabase migration new <migration_name>     (Buat file DDL SQL timestamped)                      │
│  3. $ supabase db push                           (Terapkan perubahan skema ke Cloud)                  │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 19.1 📦 Database Backups: Scheduled, PITR, & Strategi Backup Free Tier

Di menu **Database ➔ Backups**, terdapat 3 tab utama:

#### 1. Tab `Scheduled backups` (Cadangan Harian Otomatis)
- **Cara Kerja**: Supabase secara otomatis mengambil salinan database setiap hari sekitar tengah malam (berdasarkan zona waktu region project, misal: Singapore UTC+8).
- **🔒 Status Tier**: Fitur otomatis ini memerlukan **Pro Plan** (retensi riwayat hingga 7 hari).

#### 2. Tab `Point in time` (Point-in-Time Recovery / PITR)
- **Cara Kerja**: Memanfaatkan rekaman log transaksi kontinu PostgreSQL (**Write-Ahead Logging / WAL**). Jika seorang developer atau admin tidak sengaja menghapus tabel produksi pada pukul 14:32:15, database dapat diputar mundur (*rollback*) persis ke detik **14:32:14**!
- **🔒 Status Tier**: Fitur enterprise add-on untuk Pro Plan (mulai dari \$100/bulan).

#### 3. Tab `Restore to new project` [BETA]
- **Cara Kerja**: Memungkinkan Anda memulihkan snapshot database langsung ke proyek Supabase baru yang terisolasi tanpa menimpa database produksi yang sedang berjalan (sangat cocok untuk membuat lingkungan *Staging / Testing*).
- **🔒 Status Tier**: Memerlukan paket Pro Plan.

---

### 19.2 💡 Panduan Backup Manual 100% Gratis untuk MariFlow di FREE Tier

Meskipun fitur auto-backup UI terkunci di Free Tier, Anda tetap dapat mem-backup database MariFlow kapan saja secara mandiri tanpa biaya sepeser pun:

```bash
# Opsi 1: Menggunakan Supabase CLI (Rekomendasi)
supabase db dump -f backup_mariflow_$(date +%Y%m%d).sql

# Opsi 2: Menggunakan pg_dump standar PostgreSQL (Direct Connection)
pg_dump -h db.rtazqheauyiujjteburi.supabase.co -U postgres -d postgres -F p -f backup_mariflow.sql
```

---

### 19.3 🚀 Database Migrations: Mengelola Skema via Supabase CLI

Menu **Database ➔ Migrations** mencatat riwayat versioning perubahan struktur tabel database layaknya Git untuk skema SQL.

#### Alur Kerja Standar (*Best Practice Developer*):
1. **Hubungkan Local Repo ke Cloud**:
   ```bash
   supabase link --project-ref rtazqheauyiujjteburi
   ```
2. **Buat File Migrasi Baru**:
   ```bash
   supabase migration new tambah_kolom_prioritas_tasks
   ```
   *Perintah ini akan membuat file SQL baru di folder `supabase/migrations/<timestamp>_tambah_kolom_prioritas_tasks.sql`.*
3. **Tulis Script DDL SQL**:
   Isi file migrasi dengan query pembuatan tabel, indeks, atau RLS policies.
4. **Deploy Migrasi ke Cloud**:
   ```bash
   supabase db push
   ```
   *Supabase CLI akan secara otomatis mengecek migrasi mana yang belum pernah dijalankan di cloud dan menerapkannya secara transaksional atomic.*

> [!TIP]
> **Struktur Migrasi MariFlow**:
> Proyek MariFlow kita telah menerapkan standar ini secara sempurna dengan seluruh DDL migrasi tersimpan rapi di [supabase/migrations/](file:///d:/laragon/www/app_mariflow_vue/supabase/migrations/) dan seeder di [supabase/seeders/](file:///d:/laragon/www/app_mariflow_vue/supabase/seeders/).

---

## 👤🔒 20. Bedah Lengkap Menu Authentication (User Directory, Invitation, & OAuth 2.0 Server)

Menu **Authentication** (icon 👤🔒 pada sidebar utama) adalah pusat manajemen identitas, otorisasi token JWT, dan penyedia otentikasi multi-provider di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 👤🔒 Authentication (Identity & Access Management)                                                     │
├──────────────────────────┬─────────────────────────────────────────────────────────────────────────────┤
│ 📂 MANAGE:               │                                                                             │
│  - Users                 │  ┌───────────────────────────────────────────────────────────────────────┐  │
│  - OAuth Apps            │  │ 👥 USERS DIRECTORY:                                                   │  │
│                          │  │  [🔍 Search by email...] [All columns ▼]          [+ Add user ▼]      │  │
│ 🔔 NOTIFICATIONS:        │  │  ├─ Send invitation  (Kirim link undangan ajaib via email)            │  │
│  - Emails                │  │  └─ Create new user  (Buat akun manual + Auto confirm user)           │  │
│                          │  └───────────────────────────────────────────────────────────────────────┘  │
│ ⚙️ CONFIGURATION:        │                                                                             │
│  - Policies ↗            │  🔑 OAUTH 2.0 SERVER [BETA]:                                                │
│  - Sign In / Providers   │  - Menjadikan MariFlow sebagai Identity Provider ("Sign in with MariFlow") │
│  - Passkeys [BETA]       │  - Base Site URL     : http://localhost:3000                                │
│  - OAuth Server [BETA]   │  - Authorization Path: /oauth/consent (Halaman persetujuan izin pengguna)  │
│  - Sessions & Rate Limits│                                                                             │
│  - Multi-Factor (MFA)    │  🛡️ ADVANCED AUTH CONTROLS:                                                 │
│  - URL Configuration     │  - Rate Limits, Multi-Factor MFA (TOTP), Auth Hooks, Audit Logs.          │
│  - Attack Protection     │                                                                             │
└──────────────────────────┴─────────────────────────────────────────────────────────────────────────────┘
```

---

### 20.1 👥 Direktori Pengguna (`Authentication ➔ Users`)

Panel **Users** menampilkan seluruh akun yang terdaftar di dalam skema `auth.users`:

1. **Kolom Data Utama**:
   - `UID`: UUID v4 unik identitas pengguna global yang menjadi referensi `auth.uid()`.
   - `Display name` & `Email`: Alamat email dan nama tampilan pengguna.
   - `Phone`: Nomor telepon (jika menggunakan SMS Auth OTP).
   - `Provider`: Metode login akun (`email`, `google`, `github`, dll).
   - `Provider type`: Tipe penyedia identitas.
2. **Keterkaitannya dengan MariFlow**:
   - Setiap kali ada user baru mendaftar di `auth.users`, database trigger otomatis menduplikasi datanya ke tabel aplikasi **`public.profiles`** agar data non-kredensial (seperti nama lengkap, avatar URL, dan bio) dapat diakses aman oleh anggota tim lain.

---

### 20.2 ➕ Anatomi Opsi Pembuatan Akun: `Create User` vs `Send Invitation`

Di tombol **`Add user ▼`** pada kanan atas, terdapat dua opsi:

#### 1. `Create new user` (Shortcut: `I then U`)
- **Field**:
  - `Email address`: Email pengguna (misal: `superadmin@example.com`).
  - `User Password`: Kata sandi akun awal.
  - `Auto confirm user?` (☑️ Tercentang secara default):
    - **Manfaat**: Email pengguna langsung berstatus *Confirmed* seketika tanpa perlu mengirimkan tautan verifikasi email konfirmasi. Sangat ideal untuk tim developer saat membuat akun admin/demo pertama kali.

#### 2. `Send invitation` (Shortcut: `I then I`)
- **Field**: `User email`.
- **Manfaat**: Supabase akan mengirimkan email undangan berisi *Magic Link*. Ketika penerima mengklik link tersebut, mereka akan diarahkan ke halaman aplikasi MariFlow untuk mengatur kata sandi mereka sendiri.

---

### 20.3 🔑 OAuth Apps & OAuth 2.0 Server [BETA]

Menu **OAuth Apps** dan **OAuth Server** adalah fitur generasi baru Supabase untuk ekosistem integrasi aplikasi pihak ketiga:

1. **Apa itu OAuth Server di Supabase?**:
   - Fitur ini memungkinkan aplikasi **MariFlow Anda bertindak sebagai Identity Provider (IdP)**.
   - Aplikasi pihak ketiga (misal: plugin Figma, ekstensi VS Code, atau aplikasi mobile pihak ketiga) dapat menampilkan tombol **"Log in with MariFlow"**.
2. **Anatomi Konfigurasi OAuth Server**:
   - `Enable the Supabase OAuth Server`: Mengaktifkan server otorisasi OAuth 2.0.
   - `Site URL`: URL dasar aplikasi MariFlow (`http://localhost:3000` atau domain produksi `https://mariflow.app`).
   - `Authorization Path` (`/oauth/consent`):
     - Rute halaman di frontend Vue tempat pengguna melihat dialog persetujuan: *"Aplikasi X ingin mengakses tugas dan profil Anda. Izinkan atau Tolak?"*.
   - `Allow Dynamic OAuth Apps`: Mengizinkan pendaftaran klien OAuth baru secara terprogram melalui REST API.

---

## 📧 21. Bedah Lengkap Email Notifications & Custom SMTP Server (Templates & Security Alerts)

Menu **Authentication ➔ Emails** (kelompok `NOTIFICATIONS`) mengelola seluruh sistem pengiriman email transaksional, verifikasi akun, pemulihan kata sandi, dan notifikasi keamanan akun.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 📧 Authentication Emails (Templates & SMTP Settings)                                                   │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📑 TAB 1: TEMPLATES (Daftar Template Email Sistem):                                                    │
│  ├─ [Authentication]:                                                                                  │
│  │   - Confirm sign up      : Tautan konfirmasi email setelah pendaftaran mandiri.                     │
│  │   - Invite user          : Email undangan bergabung ke MariFlow dengan Magic Link.                  │
│  │   - Magic link or OTP    : Token passwordless 1-klik untuk login instan.                            │
│  │   - Change email address : Verifikasi kepemilikan saat email akun diganti.                          │
│  │   - Reset password       : Tautan pemulihan kata sandi lupa password.                               │
│  │   - Reauthentication     : Verifikasi ulang identitas sebelum aksi berbahaya.                       │
│  └─ [Security Notifications]:                                                                          │
│      - Password changed, Email changed, Phone changed, MFA added/removed (Notifikasi peringatan).      │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ⚙️ TAB 2: SMTP SETTINGS (Integrasi Provider Email Kustom):                                             │
│  - [🔘 ON] Enable custom SMTP (Buka kunci kustomisasi HTML template & naikkan batas limit)            │
│  - Sender Email / Name : noreply@mariflow.app / "MariFlow Team"                                        │
│  - Host & Port         : smtp.resend.com / smtp.sendgrid.net (Port 465 SSL / 587 TLS)                  │
│  - Anti-Spam Interval  : 60 detik (Minimum jeda pengiriman per user)                                   │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 21.1 Perbedaan Email Bawaan (*Built-in Pool*) vs Custom SMTP Provider

| Fitur | Email Bawaan Supabase (Free Tier) | Custom SMTP (Resend / SendGrid / Brevo) |
| :--- | :--- | :--- |
| **Alamat Pengirim (*From*)** | `noreply@mail.app.supabase.io` (Domain bersama) | `notifications@mariflow.app` (Domain Brand Sendiri) |
| **Kustomisasi Template** | 🔒 **Terkunci** (Subjek & Body tidak bisa diedit) | 🟢 **Bebas Di-kustom** (HTML, CSS Tailwind, Logo SaaS) |
| **Batas Pengiriman (*Rate Limit*)** | Sangat terbatas: **3-4 email per jam** | **30+ email/jam hingga puluhan ribu/hari** |
| **Reputasi Inbox / Spam** | Rentan masuk folder Promosi/Spam | Sangat tinggi (Didukung SPF, DKIM, DMARC domain sendiri) |

---

### 21.2 📑 6 Template Otentikasi Utama & Variabel Dinamisnya

Saat Anda mengaktifkan Custom SMTP, Anda dapat mendesain ulang seluruh template email menggunakan variabel template Go:

1. **`Confirm sign up`**:
   - Tautan verifikasi: `{{ .ConfirmationURL }}`
   - Token OTP angka: `{{ .Token }}`
2. **`Invite user`**:
   - Tautan undangan: `{{ .ConfirmationURL }}`
3. **`Magic link or OTP`**:
   - Tautan login instan tanpa kata sandi.
4. **`Change email address`**:
   - Mengirim token verifikasi ganda ke email lama dan email baru.
5. **`Reset password`**:
   - Tautan pengaturan ulang kata sandi yang terhubung ke halaman `/reset-password` di Vue router.
6. **`Reauthentication`**:
   - Kode OTP verifikasi identitas sebelum pengguna melakukan tindakan sensitif (seperti menghapus seluruh Workspace).

---

### 21.3 🛡️ 7 Notifikasi Peringatan Keamanan (*Security Notifications*)

Di bagian bawah tab Templates, terdapat sakelar notifikasi keamanan akun:
- **`Password changed`**: Mengirim email otomatis saat kata sandi user berhasil diubah.
- **`Email address changed`**: Memperingatkan user jika email login akunnya diubah.
- **`Phone number changed`**: Memperingatkan user jika nomor telepon diganti.
- **`Sign-in method linked / removed`**: Notifikasi saat akun Google/GitHub baru ditautkan atau dilepas.
- **`MFA method added / removed`**: Notifikasi peringatan saat aplikasi authenticator 2FA (TOTP) diaktifkan atau dinonaktifkan.

---

### 21.4 ⚙️ Konfigurasi Custom SMTP Provider (Tab `SMTP Settings`)

Untuk menghubungkan provider seperti **Resend**, **SendGrid**, **Mailgun**, atau **AWS SES**:

1. **`Sender email address` & `Sender name`**:
   - Contoh: `noreply@mariflow.app` dan nama `MariFlow Notifikasi`.
2. **`Host` & `Port number`**:
   - Host: `smtp.resend.com` (atau `smtp.sendgrid.net`).
   - Port: **`465`** (SSL) atau **`587`** (TLS / STARTTLS).
   - ⚠️ *Peringatan*: Jangan gunakan Port 25 karena sebagian besar ISP dan cloud hosting memblokir port tersebut untuk mencegah spam bot.
3. **`Minimum interval per user` (`60 seconds`)**:
   - Jeda waktu tunggu anti-spam. Mencegah user mengklik tombol "Kirim Ulang Email" berulang kali dalam waktu singkat.
4. **`Username` & `Password`**:
   - Kredensial API Key SMTP Anda (disimpan terenkripsi secara aman di database Supabase).

---

## 🔑 22. Bedah Lengkap Sign In & Providers (User Signups, Social OAuth, & Custom OIDC)

Menu **Authentication ➔ Sign In / Providers** (kelompok `CONFIGURATION`) mengatur gerbang registrasi pengguna, aktivasi metode login sosial (Google, GitHub, Apple, Azure), dan pendaftaran Custom OpenID Connect (OIDC) SSO.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🔑 Sign In / Providers (Supabase Auth & Third-Party Auth)                                              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 👥 USER SIGNUPS CONTROLS:                                                                              │
│  - [🔘 ON]  Allow new users to sign up   (Buka registrasi publik / Matikan untuk Invite-Only)          │
│  - [🔘 ON]  Confirm email                (Wajibkan konfirmasi email sebelum login pertama)             │
│  - [⚪ OFF] Allow manual linking         (Tautkan banyak provider ke 1 akun user_id)                   │
│  - [⚪ OFF] Allow anonymous sign-ins     (Sesi tamu tanpa email yang dapat di-upgrade nanti)           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 AUTH PROVIDERS (20+ Pilihan Login):                                                                 │
│  - 🟢 Email (Bawaan Aktif)               - ⚪ Google, GitHub, Apple, Microsoft Azure, Discord, Figma   │
│  - ⚪ SAML 2.0 (Enterprise SSO)          - ⚪ Web3 Wallet (Login dompet crypto Ethereum/Solana)        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🏢 CUSTOM PROVIDERS [NEW] (OpenID Connect / OIDC SSO):                                                 │
│  - [+ New Provider] ──► Integrasi Custom OAuth Perusahaan / Okta / Keycloak                            │
│  - Discovery URL    : https://auth.company.com/.well-known/openid-configuration                        │
│  - Callback URL     : https://rtazqheauyiujjteburi.supabase.co/auth/v1/callback                        │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 22.1 👥 Kontrol Registrasi Pengguna (*User Signups*)

1. **`Allow new users to sign up`**:
   - **🔘 Aktif (Default)**: Siapa saja dapat mendaftar mandiri (*Self-Registration*) melalui halaman register `/register` MariFlow.
   - **⚪ Nonaktif**: Menutup pintu pendaftaran publik. Aplikasi beralih menjadi mode **Invite-Only SaaS** (hanya admin yang dapat mengundang anggota via menu Users atau Workspace Member Invite).
2. **`Confirm email`**:
   - **🔘 Aktif (Rekomendasi Produksi)**: Pengguna wajib mengklik link konfirmasi di email mereka sebelum akun diizinkan login. Mencegah pendaftaran bot dan spam akun palsu.
3. **`Allow manual linking`**:
   - Mengizinkan pengguna menghubungkan beberapa metode login ke satu akun yang sama (misal: user awalnya mendaftar dengan email/password, lalu menautkan akun Google-nya via `supabase.auth.linkIdentity()`).
4. **`Allow anonymous sign-ins`**:
   - Menghasilkan sesi login tamu anonim tanpa email. Sangat populer untuk aplikasi *try-before-you-buy* di mana data tugas tamu dapat otomatis ditransfer ke akun permanen saat user memutuskan untuk sign-up.

---

### 22.2 🌐 Mengaktifkan Social Login di MariFlow (Google & GitHub)

Supabase mendukung lebih dari 20 provider otentikasi pihak ketiga:

```text
[Frontend Vue] ──(1. signInWithOAuth)──► [Google / GitHub OAuth Screen]
      ▲                                                  │ (2. User Setuju)
      │                                                  ▼
[MariFlow App] ◄──(4. Session JWT)─────── [Supabase Callback Gateway]
```

#### Cara Menghubungkan Google Login:
1. Buat *OAuth 2.0 Client ID* di **Google Cloud Console**.
2. Masukkan **Authorized Redirect URI**:
   `https://rtazqheauyiujjteburi.supabase.co/auth/v1/callback`
3. Salin `Client ID` dan `Client Secret` ke panel **Auth Providers ➔ Google** di Supabase.
4. Di frontend Vue, panggil:
   ```typescript
   await supabase.auth.signInWithOAuth({
     provider: 'google',
     options: { redirectTo: window.location.origin }
   })
   ```

---

### 22.3 🏢 Custom Auth Providers [NEW] (Enterprise OIDC SSO)

Fitur **Custom Providers** memungkinkan MariFlow terhubung ke Identity Provider kustom internal perusahaan klien (seperti Keycloak, Okta, Auth0, atau Active Directory):

1. **`Provider Identifier`**: Kode unik untuk pemanggilan SDK (misal: `custom:perusahaan-x` ➔ `supabase.auth.signInWithOAuth({ provider: 'custom:perusahaan-x' })`).
2. **`Configuration Method (Auto-discovery)`**:
   - Cukup masukkan `Discovery URL` OpenID Connect (misal: `https://auth.perusahaan.com/.well-known/openid-configuration`), dan Supabase akan otomatis mengambil endpoint token, authorization, dan public JWKS keys!
3. **`Callback URL`**:
   - URL yang wajib didaftarkan di portal SSO perusahaan:
     `https://rtazqheauyiujjteburi.supabase.co/auth/v1/callback`

---

## 🌐 23. Bedah Lengkap Third-Party Auth (Integrasi Eksternal JWT: Clerk, Firebase, Auth0, & AWS Cognito)

Tab **Authentication ➔ Sign In / Providers ➔ `Third-Party Auth`** adalah fitur arsitektur decoupled di mana Anda dapat menggunakan penyedia identitas eksternal (*External Identity Provider*) untuk mengakses database PostgreSQL Supabase dengan tetap mempertahankan Row Level Security (RLS).

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🌐 THIRD-PARTY AUTH ARCHITECTURE (External JWT Verification)                                           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. User login di aplikasi via ──► [🟣 Clerk] / [🔥 Firebase] / [🟠 Auth0] / [🟪 AWS Cognito]          │
│ 2. Provider menerbitkan JWT   ──► Ditandatangani dengan Private Key Provider (JWKS)                   │
│ 3. Frontend panggil Supabase  ──► Request HTTP dengan header 'Authorization: Bearer <EXTERNAL_JWT>'    │
│ 4. PostgREST API Gateway      ──► Memverifikasi JWT via Public Key JWKS ➔ auth.uid() tervalidasi!     │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 23.1 Apa itu Third-Party Auth di Supabase?

Secara standar, Supabase menggunakan modul internal **GoTrue** untuk mengelola pendaftaran user, kata sandi, dan menerbitkan token JWT.

Namun jika aplikasi Anda sudah memiliki basis pengguna di sistem lain, Supabase memungkinkan Anda **mengabaikan GoTrue** dan langsung menggunakan token JWT yang diterbitkan oleh penyedia pihak ketiga:

| Provider yang Didukung | Karakteristik Utama | Skenario Penggunaan |
| :--- | :--- | :--- |
| 🔥 **Firebase Auth** | Menggunakan token Google Identity Platform / Firebase. | Migrasi aplikasi dari Firebase Firestore ke database relasional PostgreSQL Supabase. |
| 🟣 **Clerk** | Komponen UI Otentikasi modern dan manajemen user B2B multi-tenant yang sangat cepat. | Jika developer ingin menggunakan komponen UI Drop-in siap pakai dari Clerk namun tetap memakai PostgreSQL & RLS Supabase. |
| 🔷 **WorkOS** | Spesialis Single Sign-On (SAML/OIDC) dan Directory Sync (SCIM) untuk klien Enterprise. | Aplikasi SaaS B2B yang melayani integrasi login korporat dengan Active Directory / Okta. |
| 🟠 **Auth0** | Platform identitas enterprise dari Okta dengan rule/action pipeline yang sangat matang. | Perusahaan yang memiliki regulasi kepatuhan identitas ketat (HIPAA / SOC2). |
| 🟪 **Amazon Cognito** | Layanan User Pools bawaan ekosistem AWS Cloud. | Aplikasi yang terintegrasi erat dengan AWS Lambda, S3, dan DynamoDB. |

---

### 23.2 Bagaimana Cara Kerja Verifikasi JWT Eksternal dengan PostgreSQL RLS?

1. Anda mendaftarkan URL Issuer atau Public Key JWKS dari provider eksternal di menu **Add provider**.
2. Saat request masuk ke Supabase, API Gateway PostgREST memvalidasi bahwa token tersebut benar-benar diterbitkan oleh Clerk/Firebase yang sah.
3. Nilai klaim `sub` (Subject / User ID) di dalam token JWT otomatis dimasukkan ke dalam fungsi PostgreSQL **`auth.jwt()`** dan **`auth.uid()`**.
4. **Hasilnya**: Seluruh aturan **Row Level Security (RLS)** yang telah kita buat di tabel `workspaces`, `projects`, dan `tasks` **tetap berjalan 100% aman dan otomatis** tanpa perlu mengubah satu baris pun kode database SQL!

---

### 23.3 💡 Rekomendasi untuk MariFlow SaaS

- **Status MariFlow**: Aplikasi MariFlow kita menggunakan **Supabase Auth Native** (`Supabase Auth` tab).
- **Keuntungan Memakai Supabase Auth Native**:
  - 100% Gratis dan sudah terintegrasi bawaan dengan Pinia Store (`src/stores/auth.ts`) dan Database Trigger `handle_new_user()`.
  - Tidak memerlukan biaya langganan MAU (*Monthly Active Users*) tambahan dari layanan pihak ketiga seperti Clerk atau Auth0.

---

## 🛡️ 24. Bedah Lengkap Passkeys, User Sessions, Token Lifecycle, & Auth Rate Limits

Menu **Passkeys [BETA]**, **Sessions**, dan **Rate Limits** (kelompok `CONFIGURATION`) mengatur keamanan autentikasi modern tanpa password (*Biometric WebAuthn*), siklus hidup token JWT, dan proteksi dari serangan DDoS brute-force.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🛡️ AUTH SECURITY & LIFECYCLE CONTROLS                                                                  │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔑 PASSKEYS [BETA] (Login Biometrik WebAuthn):                                                         │
│  - Relying Party ID     : localhost / mariflow.app                                                    │
│  - Relying Party Origins: http://localhost:5173, https://mariflow.app                                  │
│  - Dukungan Hardware    : Touch ID (Mac/iOS), Windows Hello, Fingerprint Sensor, YubiKey FIDO2.       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ⏳ SESSIONS & TOKEN LIFECYCLE:                                                                         │
│  - Access Token Expiry  : 3600 detik (1 Jam) ──► Ditukar otomatis via Refresh Token.                  │
│  - Refresh Token Security: [🔘 ON] Detect and revoke compromised refresh tokens (Anti Replay Attack).  │
│  - Reuse Interval       : 10 detik (Toleransi network retry).                                          │
│  - Enforce Single Session: 🔒 PRO TIER (Mencegah 1 akun dipakai bersamaan di banyak device).          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚦 AUTH RATE LIMITS (Proteksi Brute-Force & Stabilitas Cloud):                                         │
│  - Sign-up & Sign-in    : 30 request / 5 menit per IP (360 req/jam).                                   │
│  - Token Refreshes      : 150 request / 5 menit per IP (1800 req/jam).                                 │
│  - Built-in Email Rate  : 2 email / jam (Naik ke ribuan jika Custom SMTP aktif).                      │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 24.1 🔑 Passkeys [BETA] (WebAuthn / Login Biometrik Modern)

Passkeys menggantikan kata sandi tradisional dengan kunci kriptografi publik/privat yang tersimpan di chip keamanan perangkat pengguna:

1. **Komponen Pengaturan**:
   - `Enable Passkey authentication`: Mengaktifkan registrasi dan login WebAuthn.
   - `Relying Party Display Name`: Nama aplikasi yang muncul saat pop-up biometrik (misal: `MariFlow SaaS`).
   - `Relying Party ID`: Domain aplikasi (`localhost` untuk dev, `mariflow.app` untuk production).
   - `Relying Party Origins`: URL lengkap asal web (`http://localhost:5173`, `https://mariflow.app`).
2. **Kelebihan untuk MariFlow**:
   - Pengguna dapat login hanya dengan menempelkan sidik jari (Touch ID / Fingerprint) atau memindai wajah (Face ID / Windows Hello) tanpa perlu mengingat kata sandi.

---

### 24.2 ⏳ User Sessions & Siklus Hidup Token JWT (*Token Lifecycle*)

PostgreSQL RLS dan API Supabase bekerja berdasarkan masa berlaku token JWT:

1. **`Access token expiry time` (`3600 seconds / 1 Jam`)**:
   - Access Token adalah tiket digital berdurasi pendek (1 jam) yang dibawa frontend Vue di setiap query database.
   - Durasi pendek menjamin jika token dicuri di jaringan publik, token tersebut akan segera hangus dengan sendirinya.
2. **`Refresh Tokens & Automatic Renewal`**:
   - SDK `@supabase/supabase-js` di MariFlow secara otomatis memperbarui Access Token baru di latar belakang menggunakan Refresh Token sebelum masa 1 jam berakhir.
3. **`Detect and revoke potentially compromised refresh tokens` (🔘 Aktif)**:
   - Fitur keamanan canggih (*Refresh Token Rotation*). Jika sebuah Refresh Token lama yang sudah pernah dipakai mencoba dipakai ulang oleh penyerang (*Replay Attack*), Supabase akan **langsung membatalkan (*revoke*) seluruh sesi akun tersebut** dan memaksa login ulang demi melindungi user.
4. **`Refresh token reuse interval` (`10 seconds`)**:
   - Jeda toleransi waktu singkat untuk menangani kondisi jaringan seluler yang lambat jika request refresh dikirim berulang bersamaan.

---

### 24.3 🔒 Status Sesi: FREE Tier vs PRO Tier

> [!WARNING]
> **Fitur User Sessions Tertentu Memerlukan PRO TIER 🔒**:
> - **`Enforce single session per user`**: Memaksa logout otomatis dari perangkat lama saat user login di perangkat baru.
> - **`Time-box user sessions`** & **`Inactivity timeout`**: Membatasi durasi sesi login maksimal (misal: auto-logout setelah 30 menit tidak aktif).
> - Fitur kontrol sesi enterprise di atas memerlukan paket **Pro Plan ($25/bulan)**.
> - Pada **Free Tier**, sesi pengguna tetap aman menggunakan mekanisme standar JWT token refresh (refresh token rotation).

---

### 24.4 🚦 Auth Rate Limits (Perlindungan DDoS & Brute-Force)

Panel **Rate Limits** melindungi aplikasi MariFlow Anda dari serangan bot otomatis:

- **`Sign-ups & Sign-ins` (`30 req / 5 menit`)**: Mencegah bot menebak kata sandi ribuan kali per detik. Jika batas terlampaui, Supabase akan mengembalikan pesan error `429 Too Many Requests`.
- **`Token refreshes` (`150 req / 5 menit`)**: Memastikan refresh token berjalan lancar untuk banyak tab browser bersamaan.
- **`Enable IP address forwarding`**:
  - Diaktifkan jika Anda menempatkan server proxy backend (misal: NGINX / Cloudflare) di depan Supabase agar rate limit dihitung berdasarkan IP asli pengguna (*Client IP*), bukan IP server proxy.

---

## 🔐 25. Bedah Lengkap Multi-Factor (MFA), URL Configuration, & Attack Protection

Menu **Multi-Factor**, **URL Configuration**, dan **Attack Protection** (kelompok `CONFIGURATION`) menangani autentikasi dua faktor (2FA TOTP), keamanan pengalihan URL pasca-login (*Open Redirect Whitelist*), dan perlindungan dari bot serangan kata sandi bocor.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🔐 MULTI-FACTOR, URL CONFIGURATION, & ATTACK PROTECTION                                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📱 MULTI-FACTOR AUTHENTICATION (MFA / 2FA):                                                             │
│  ├─ [🟢 Enabled] TOTP (Google/Apple Authenticator) ──► Standar RFC 6238 (100% GRATIS di Free Tier).    │
│  ├─ [🔒 PRO TIER] SMS MFA                          ──► OTP via SMS Twilio/MessageBird.                │
│  └─ [Enhanced Security] Limit duration of AAL1     ──► Batasi sesi ke 15 menit jika belum verifikasi. │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 URL CONFIGURATION (Redirect Whitelisting):                                                         │
│  - Site URL     : Fallback default URL aplikasi (http://localhost:5173 atau https://mariflow.app).    │
│  - Redirect URLs: Whitelist domain yang diizinkan menerima token (http://localhost:5173/**).           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛡️ ATTACK PROTECTION:                                                                                  │
│  - Enable Captcha Protection       : Integrasi Cloudflare Turnstile / hCaptcha untuk form login.       │
│  - Prevent use of leaked passwords : Tolak pendaftaran kata sandi yang pernah bocor (HaveIBeenPwned).  │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 25.1 📱 Multi-Factor Authentication (MFA / 2FA)

Supabase Auth mengimplementasikan standar **Authenticator Assurance Levels (AAL)** dari NIST:

1. **`TOTP (App Authenticator)` (🟢 Aktif / Gratis di Free Tier)**:
   - Menggunakan kode 6 digit berbasis waktu (*Time-based One-Time Password*) yang dibuat oleh aplikasi seperti **Google Authenticator**, **Microsoft Authenticator**, atau **1Password**.
   - Di MariFlow, pengguna dapat mengaktifkan 2FA langsung dari menu pengaturan profil (`ProfileSettingsView.vue`) via SDK `supabase.auth.mfa.enroll({ factorType: 'totp' })`.
2. **`SMS MFA` (🔒 Fitur Eksklusif PRO TIER)**:
   - Mengirim kode OTP 6 digit melalui SMS. Memerlukan akun **Pro Plan ($25/bulan)** dan konfigurasi penyedia gateway SMS (Twilio).
3. **`Enhanced MFA Security (Limit duration of AAL1 sessions)`**:
   - `AAL1` (Level 1): Pengguna baru memasukkan email + password.
   - `AAL2` (Level 2): Pengguna sukses memvalidasi kode TOTP 6 digit.
   - **Opsi 15 Menit**: Jika pengguna telah mengaktifkan 2FA, sesi AAL1 otomatis dibatalkan jika pengguna tidak memasukkan kode TOTP dalam waktu 15 menit.

---

### 25.2 🌐 URL Configuration (Mencegah Serangan Open Redirect)

Pengaturan **URL Configuration** adalah salah satu hal paling penting saat mendeploy aplikasi MariFlow ke produksi:

1. **`Site URL`**:
   - URL utama aplikasi Anda (misal: `http://localhost:5173` saat development, atau `https://app.mariflow.com` saat production).
   - Menjadi tujuan akhir tautan email jika tidak ada parameter `redirectTo` spesifik.
2. **`Redirect URLs (Allow List Whitelist)`**:
   - **Penting**: Supabase menolak mengirim token login/reset password ke domain asing yang tidak terdaftar di daftar ini guna mencegah pencurian kredensial (*Open Redirect Vulnerability*).
   - **Format yang Wajib Didaftarkan**:
     ```text
     http://localhost:5173/**
     http://localhost:5173/reset-password
     https://app.mariflow.com/**
     https://app.mariflow.com/reset-password
     ```

---

### 25.3 🛡️ Attack Protection (Bot Captcha & Leaked Passwords)

1. **`Enable Captcha protection`**:
   - Melindungi endpoint pendaftaran dan login dari serangan brute-force otomatis.
   - Mendukung **Cloudflare Turnstile** (bebas verifikasi gambar membingungkan) dan **hCaptcha**.
2. **`Prevent use of leaked passwords`**:
   - Saat pengguna mendaftar atau mengganti kata sandi, Supabase secara otomatis memeriksa hash password ke database **Have I Been Pwned**.
   - Jika kata sandi tersebut merupakan kata sandi umum yang pernah bocor di internet (misal: `password123`, `qwertyuiop`), pendaftaran akan langsung ditolak demi keamanan akun pengguna.

---

## 🪝 26. Bedah Lengkap Auth Hooks, Audit Logs, & Auth Performance Tuning

Menu **Auth Hooks [BETA]**, **Audit Logs**, dan **Performance** (kelompok `CONFIGURATION`) memberikan kendali tingkat lanjut untuk memodifikasi alur otentikasi secara terprogram, mengaudit jejak keamanan pengguna, dan menyetel performa server otentikasi GoTrue.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🪝 AUTH HOOKS, AUDIT LOGS, & PERFORMANCE ARCHITECTURE                                                  │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🪝 AUTH HOOKS (Trigger Eksekusi Alur Autentikasi):                                                     │
│  ├─ 🟢 [Customize JWT Claims Hook] : Menyuntikkan 'role' / 'workspace_id' langsung ke JWT Token!       │
│  ├─ 🟢 [Before User Created Hook]  : Validasi domain email (@perusahaan.com) sebelum akun dibuat.      │
│  ├─ 🟢 [Send Email / SMS Hook]     : Forward pengiriman email/SMS ke Edge Function kustom.             │
│  └─ 🔒 [MFA / Password Attempt]    : Memerlukan Team / Enterprise Plan.                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📜 AUDIT LOGS:                                                                                         │
│  - Toggle: Write audit logs to database (Tabel 'audit_log_entries')                                    │
│  - Catat setiap event sign-in, token refresh, password recovery, dan kegagalan login.                 │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ⚡ PERFORMANCE TUNING:                                                                                 │
│  - 🔒 Eksklusif PRO TIER: Set Max Request Duration (10s) & Connection Pool Strategy (10 koneksi).      │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 26.1 🪝 Auth Hooks [BETA] (Intersepsi Alur Otentikasi dengan Postgres & Edge Functions)

Auth Hooks memungkinkan Anda mengeksekusi fungsi SQL Postgres atau HTTP Endpoint Edge Function pada tahap-tahap krusial proses otentikasi:

#### 1. `Customize Access Token (JWT) Claims Hook` ⭐ (Fitur Paling Populer untuk SaaS)
- **Fungsi**: Secara bawaan, token JWT Supabase hanya berisi `sub` (User ID) dan `email`.
- **Manfaat**: Dengan hook ini, Anda dapat membuat Stored Procedure PostgreSQL yang secara otomatis menyuntikkan data tambahan (seperti `user_role: 'admin'`, `current_workspace_id: '...'`) langsung ke dalam payload JWT.
- **Dampak Performa**: Query RLS di database menjadi jauh lebih cepat karena Postgres tidak perlu lagi melakukan query JOIN ke tabel `workspace_members` untuk mengetahui role pengguna—cukup baca dari `(auth.jwt()->>'user_role')`!

#### 2. `Before User Created Hook` (Pre-Signup Gatekeeper)
- **Fungsi**: Berjalan tepat sebelum data user baru disimpan ke `auth.users`.
- **Skenario SaaS**: Memblokir pendaftaran akun jika domain email bukan domain korporat (misal: tolak email gratisan `@gmail.com` / `@yahoo.com` jika SaaS Anda khusus B2B).

#### 3. `Send Email Hook` & `Send SMS Hook`
- **Fungsi**: Meneruskan pengiriman email konfirmasi / SMS OTP ke provider kustom (misal: Mailgun API atau WhatsApp Gateway lokal Indonesia) menggunakan Supabase Edge Functions.

#### 4. 🔒 Hooks Eksklusif Team/Enterprise:
- `MFA Verification Attempt Hook` & `Password Verification Attempt Hook` (Mendeteksi dan memblokir upaya pembobolan OTP secara terprogram).

---

### 26.2 📜 Audit Logs (`audit_log_entries`)

Menu **Audit Logs** mencatat seluruh rekaman aktivitas otentikasi di proyek MariFlow:

1. **`Write audit logs to the database` (Toggle Sakelar)**:
   - **🔘 Aktif**: Setiap kali ada pengguna login, refresh token, ganti email, atau gagal verifikasi password, rekaman event akan disimpan ke tabel internal **`auth.audit_log_entries`**.
   - **⚪ Nonaktif (Rekomendasi Free Tier)**: Log tetap dapat dilihat di dashboard web, namun tidak memakan kapasitas kuota disk database 500 MB Free Tier Anda.

---

### 26.3 ⚡ Auth Performance Tuning (FREE Tier vs PRO Tier)

> [!WARNING]
> **Fitur Auth Performance Memerlukan PRO TIER 🔒**:
> - Menu **Authentication ➔ Performance** menampilkan status *“Only available on the Pro Plan and above. Upgrade to the Pro Plan to configure Auth server performance settings.”*.
> - **Parameter yang Disediakan di Pro Plan**:
>   - `Maximum allowed duration for an Auth request` (Default 10 detik): Membatasi timeout request otentikasi untuk mencegah server hang akibat koneksi lambat.
>   - `Connection management (Allocation strategy & Maximum connections)`: Mengatur alokasi jumlah pool koneksi Postgres khusus untuk engine GoTrue (misal: 10 dari 60 koneksi).
> - **Kondisi di Free Tier**: Supabase telah mengatur alokasi performa default yang sangat optimal dan stabil untuk menangani ratusan pengguna harian MariFlow secara gratis.

---

## 📦 27. Bedah Lengkap Supabase Storage (Object Storage, Public vs Private Buckets, & Storage RLS)

Menu **Storage** (icon 📄📦 pada sidebar utama) adalah layanan penyimpanan file dan media berbasis objek yang terintegrasi langsung dengan mesin database PostgreSQL.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 📦 SUPABASE STORAGE ARCHITECTURE                                                                       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🗄️ BUCKETS (Wadah Penyimpanan Objek):                                                                 │
│  ├─ [avatars]          : Foto profil pengguna (Public Bucket / Restriksi MIME: image/*)                │
│  └─ [task-attachments] : Lampiran file tugas/kanban (Public Bucket / Gambar, PDF, DOCX, ZIP)          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛡️ STORAGE ROW LEVEL SECURITY (RLS di Tabel 'storage.objects'):                                        │
│  - INSERT Policy : Hanya authenticated user yang boleh upload file ke foldernya sendiri.               │
│  - SELECT Policy : Publik/anggota workspace boleh membaca file.                                        │
│  - DELETE Policy : Hanya uploader asli yang boleh menghapus file lampirannya.                          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ⚙️ SETTINGS & TIER COMPARISON:                                                                         │
│  - Free Tier Limit        : Maksimal 50 MB per file upload & kuota 1 GB storage (100% GRATIS).         │
│  - Image Transformation   : 🔒 PRO TIER (On-the-fly image resizing & WebP compression via URL).        │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 27.1 🗄️ Anatomi Bucket: `Public` vs `Private`

Saat membuat bucket baru via modal **Create file bucket**:

1. **`Bucket name`**:
   - Nama penampung objek (misal: `avatars` dan `task-attachments`).
   - ⚠️ *Catatan*: Nama bucket tidak dapat diubah setelah dibuat.
2. **`Public bucket` (Sakelar Publik vs Privat)**:
   - **🔘 Aktif (`Public = true`)**: URL file dapat diakses secara langsung oleh siapapun melalui browser tanpa perlu otentikasi token JWT (`https://<REF>.supabase.co/storage/v1/object/public/avatars/user-123.png`). Sangat cocok untuk avatar pengguna dan lampiran publik MariFlow.
   - **⚪ Nonaktif (`Public = false`)**: File hanya bisa diunduh jika pengguna membawa token autentikasi atau menggunakan **Signed URL** berdurasi sementara (`supabase.storage.from('invoices').createSignedUrl('inv-01.pdf', 60)`).
3. **`Restrict file size`**:
   - Membatasi ukuran maksimal per file (misal: batasi bucket avatar max 2 MB).
4. **`Restrict MIME types`**:
   - Membatasi tipe ekstensi file yang diizinkan (misal: `image/jpeg, image/png, image/webp` untuk bucket avatar agar tidak disusupi file executable `.exe` berbahaya).

---

### 27.2 🛡️ Keunggulan Arsitektur: RLS di Tingkat File (`storage.objects`)

Berbeda dengan AWS S3 tradisional yang menggunakan JSON IAM Policy yang rumit, Supabase menyimpan seluruh metadata file di tabel database PostgreSQL **`storage.objects`** dan **`storage.buckets`**.

Artinya, Anda dapat membuat aturan keamanan menggunakan sintaks SQL PostgreSQL yang sama persis:

```sql
-- Contoh Kebijakan: Hanya user yang login yang boleh mengupload avatar
CREATE POLICY "Pengguna login boleh upload avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
```

---

### 27.3 ⚙️ Storage Settings: FREE Tier vs PRO Tier

Di tab **Settings**, terdapat perbandingan fitur:

| Parameter | Free Tier (Akun Kita) | Pro Tier ($25/bulan) 🔒 |
| :--- | :--- | :--- |
| **Batas Maksimal Upload File** | **50 MB** per file (Sangat cukup untuk dokumen/gambar) | Hingga **500 GB** per file |
| **Total Kuota Storage** | **1 GB** Gratis | **100 GB** Termasuk |
| **Image Transformation** | ⚪ Nonaktif | 🟢 **Aktif** (Resize gambar otomatis on-the-fly) |

> [!TIP]
> **Apa itu Image Transformation?**:
> Fitur Pro Tier yang memungkinkan frontend meminta gambar yang sudah dioptimasi secara dinamis cukup dengan menambahkan parameter URL:
> `https://.../avatar.jpg?width=100&height=100&resize=cover&format=webp`

---

## 📊🤖 28. Bedah Lengkap Analytics Buckets (Apache Iceberg) & Vector Buckets (AI Embeddings)

Sub-menu **Analytics [NEW]** dan **Vectors [NEW]** (di bawah menu `Storage ➔ MANAGE`) adalah inovasi infrastruktur *Data Lakehouse* & *AI Storage* generasi terbaru di Supabase.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 📊🤖 ADVANCED STORAGE ENGINES (Analytics & Vector Buckets)                                             │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📊 1. ANALYTICS BUCKETS (Purpose-built for Analytical Workloads):                                      │
│  - Teknologi Integrasi: Ekstensi 'wrappers' + 'Apache Iceberg Wrapper' (PostgreSQL FDW).               │
│  - Format Data        : File Apache Parquet terkompresi di Object Storage.                             │
│  - Keunggulan         : Query jutaan log riwayat via SQL murni tanpa membebani disk PostgreSQL!       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🤖 2. VECTOR BUCKETS (Purpose-built for AI Embeddings at Scale):                                       │
│  - Teknologi Integrasi: Ekstensi 'wrappers' + 'S3 Vectors Wrapper' + 'pgvector'.                       │
│  - Fungsi             : Menyimpan dan mengindeks miliaran vector embedding teks/dokumen secara murah.  │
│  - Skenario MariFlow  : AI Semantic Search & RAG Chatbot asisten tugas proyek.                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ⚠️ TAHAP RILIS & KESIAPAN:                                                                             │
│  - Status: Private Alpha [NEW] (Eksplorasi / Belum wajib diimplementasikan untuk MVP MariFlow).      │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 28.1 📊 Analytics Buckets (PostgreSQL Foreign Data Wrapper + Apache Iceberg)

1. **Apa itu Analytics Buckets?**:
   - Wadah penyimpanan khusus data masif (*Data Lake*) berbasis format tabel terbuka **Apache Iceberg**.
2. **Cara Kerja Teknis**:
   - Saat Anda membuat bucket ini, Supabase secara otomatis mengaktifkan ekstensi **`wrappers`** dan menghubungkan PostgreSQL ke S3 menggunakan protokol *Foreign Data Wrapper (FDW)*.
   - Data historis (seperti jutaan activity logs atau data analitik tugas) dapat diekspor ke format Parquet di storage.
   - Developer dapat menjalankan query analitik SQL langsung (`SELECT AVG(duration) FROM iceberg_task_metrics WHERE created_at >= '2025-01-01'`) langsung dari database MariFlow dengan kecepatan tinggi dan biaya penyimpanan yang sangat murah.

---

### 28.2 🤖 Vector Buckets (AI Embeddings & Semantic Search Skala Besar)

1. **Apa itu Vector Buckets?**:
   - Wadah penyimpanan yang dirancang untuk menyimpan jutaan representasi vektor (*embeddings*) dari model AI (seperti OpenAI text-embedding-3 atau Google Gemini Embeddings).
2. **Mengapa Diperlukan Vector Bucket Terpisah?**:
   - Menyimpan jutaan array vektor berdimensi 1536 di dalam tabel PostgreSQL standar dapat memakan banyak RAM (Memory) dan kapasitas disk SSD database.
   - Dengan **Vector Buckets**, file vektor mentah disimpan di S3 storage yang murah, sementara PostgreSQL melalui **`S3 Vectors Wrapper`** bertindak sebagai mesin pencari cepat (*Approximate Nearest Neighbor / Cosine Distance Search*).
3. **Peluang Implementasi di MariFlow**:
   - **Fitur Pencarian Cerdas AI (*Smart Semantic Search*)**: Anggota tim dapat mencari tugas hanya dengan mengetik pertanyaan bahasa alami: *"Di mana file mockup yang dibuat minggu lalu tentang halaman login?"*.

---

### 28.3 ⚠️ Status Tier & Tahap Rilis

- **Status Saat Ini**: Kedua fitur ini berstatus **`Private Alpha [NEW]`**.
- **Untuk Tahap MariFlow Saat Ini**: Kita menggunakan tabel relasional standar `projects`, `tasks`, dan `activity_logs` yang didukung oleh RPC functions analitik berkinerja tinggi, sehingga kita belum memerlukan Analytics / Vector Buckets untuk tahap MVP / rilis awal.

---

## 🪣 29. Bedah Lengkap S3-Compatible Protocol & S3 Access Keys (AWS SDK, Rclone, & RLS Bypass Warning)

Menu **Storage ➔ S3** (kelompok `CONFIGURATION`) membuka antarmuka standar industri **Amazon S3 API Gateway** di atas Supabase Storage.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🪣 S3 PROTOCOL & ACCESS KEYS ARCHITECTURE                                                              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 CONNECTION PARAMETERS:                                                                              │
│  - S3 Protocol Status : [🔘 ON] Allow clients to connect via S3 protocol.                              │
│  - S3 Endpoint        : https://rtazqheauyiujjteburi.storage.supabase.co/storage/v1/s3                 │
│  - Region             : ap-southeast-1 (Singapore)                                                     │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔑 S3 ACCESS KEYS:                                                                                     │
│  - Terdiri dari: Access Key ID & Secret Access Key.                                                    │
│  - Digunakan untuk: AWS CLI, Boto3 (Python), AWS SDK (Node.js), Rclone, Cyberduck, FileZilla.          │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚨 PERINGATAN KEAMANAN KRITIS (SECURITY BOUNDARY):                                                     │
│  - ⚠️ S3 Access Keys MEMILIKI AKSES PENUH ke semua bucket & MELEWATI (BYPASS) seluruh RLS Policies!    │
│  - ⛔ DILARANG KERAS mengekspos S3 Access Key ke Frontend Vue / Browser!                               │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 29.1 🌐 Apa itu S3-Compatible Protocol di Supabase?

Supabase Storage menyediakan endpoint yang 100% kompatibel dengan protokol **Amazon S3**. 

Hal ini memungkinkan developer untuk mengelola file di Supabase Storage menggunakan berbagai macam alat (*tools*) dan pustaka (*libraries*) standar ekosistem AWS tanpa perlu menggunakan Supabase JavaScript SDK:

- **Bahasa Pemrograman / SDK**: AWS SDK for JavaScript/TypeScript, Python (`boto3`), Go (`aws-sdk-go`), PHP (`aws-sdk-php`).
- **Peralatan CLI & Backup**: `aws-cli`, `rclone` (sinkronisasi backup harian), `s3cmd`.
- **GUI File Explorer**: Cyberduck, Transmit, FileZilla Pro.

---

### 29.2 ⚙️ Parameter Koneksi S3

1. **`S3 protocol connection` (🔘 Aktif)**: Mengaktifkan gerbang S3 API pada project.
2. **`Endpoint`**: URL khusus untuk gateway S3:
   `https://rtazqheauyiujjteburi.storage.supabase.co/storage/v1/s3`
3. **`Region`**: `ap-southeast-1` (Wilayah Singapore).

---

### 29.3 🔑 Contoh Penggunaan dengan AWS SDK & Python Boto3

#### Menggunakan Python Boto3:
```python
import boto3

s3_client = boto3.client(
    's3',
    endpoint_url='https://rtazqheauyiujjteburi.storage.supabase.co/storage/v1/s3',
    aws_access_key_id='YOUR_S3_ACCESS_KEY_ID',
    aws_secret_access_key='YOUR_S3_SECRET_ACCESS_KEY',
    region_name='ap-southeast-1'
)

# Upload file attachment
s3_client.upload_file('laporan.pdf', 'task-attachments', 'laporan_2026.pdf')
```

---

### 29.4 🚨 Peringatan Keamanan Kritis: S3 Access Keys Bypass RLS!

> [!CAUTION]
> **Tingkat Hak Akses Tertinggi (*Superadmin / Service Role*)**:
> - Berbeda dengan koneksi frontend yang dibatasi oleh aturan **Row Level Security (RLS)**, **S3 Access Keys memiliki akses penuh (Full Control)** untuk membaca, mengunggah, menimpa, dan menghapus objek apa pun di semua bucket tanpa terikat RLS.
> - **Aturan Baku**: S3 Access Keys hanya boleh disimpan di server backend terisolasi, CI/CD pipeline, atau script worker batch offline. Dilarang menaruhnya di file `.env` frontend atau repository publik!

---

## ⚡ 30. Bedah Lengkap Supabase Edge Functions (Deno Runtime, Webhooks, & Secrets)

Menu **Edge Functions** (icon 🌀⚡ pada sidebar utama) adalah layanan *Serverless Computing* terdistribusi global berbasis runtime **Deno** (TypeScript & JavaScript) yang berjalan sedekat mungkin dengan pengguna Anda (*Edge Network*).

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚡ SUPABASE EDGE FUNCTIONS ARCHITECTURE                                                                │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚀 3 CARA PEMBUATAN & DEPLOYMENT:                                                                      │
│  ├─ 1. [<>] Via Editor      : Tulis dan deploy kode Deno TypeScript langsung di browser.               │
│  ├─ 2. [🤖] Via AI Assistant: Dibuat otomatis oleh asisten AI Supabase berdasarkan prompt.             │
│  └─ 3. [>_] Via CLI         : $ supabase functions new <nama> ──► $ supabase functions deploy <nama>  │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛠️ SKENARIO SAAS UTAMA:                                                                                │
│  - Payment Webhooks   : Memproses notifikasi Midtrans, Xendit, atau Stripe secara aman.                │
│  - AI / LLM Gateway   : Memanggil OpenAI / Gemini API tanpa mengekspos API Key ke frontend.            │
│  - Email Transaksional: Mengirim email laporan berformat custom via Resend API.                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔐 EDGE FUNCTION SECRETS:                                                                              │
│  - Mengenkripsi API Key sensitif (e.g. STRIPE_SECRET_KEY, OPENAI_API_KEY, RESEND_API_KEY).             │
│  - Diakses di kode via: Deno.env.get('NAMA_SECRET')                                                    │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🟢 FREE TIER BENEFIT:                                                                                  │
│  - Gratis 500.000 panggilan fungsi (Invocations) setiap bulan!                                         │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 30.1 ⚡ Apa itu Supabase Edge Functions & Mengapa Memakai Deno?

1. **Runtime Deno Modern**:
   - Berbeda dengan AWS Lambda standar yang menggunakan Node.js lawas, Edge Functions menggunakan **Deno**, runtime TypeScript modern dengan standar Web API (`fetch`, `Request`, `Response`, `WebSockets`).
   - Tidak memerlukan folder `node_modules` raksasa karena modul diimpor langsung via URL ESM (`import { serve } from "https://deno.land/std@.../server.ts"`).
2. **Kecepatan Edge Global (Cold Start Mendekati 0ms)**:
   - Dijalankan di ratusan *edge server* di seluruh dunia. Waktu startup (*Cold Start*) terjadi dalam hitungan milidetik, jauh lebih cepat daripada serverless container tradisional.

---

### 30.2 🚀 3 Cara Pembuatan & Deployment Edge Functions

Di header dashboard, terdapat menu **`Deploy a new function ▼`**:

#### 1. `<> Via Editor` (Di Dalam Browser)
- Anda dapat mengetik kode Deno TypeScript langsung di editor dashboard Supabase dan men-deploy-nya secara instan hanya dengan 1 klik.

#### 2. `🤖 Via AI Assistant`
- Memberikan instruksi bahasa alami: *"Buatkan Edge Function untuk memvalidasi webhook pembayaran Midtrans dan mengupdate status langganan workspace MariFlow ke 'pro'"*, dan AI akan menghasilkan kode Deno lengkap.

#### 3. `>_ Via Supabase CLI` (Standar Praktik Terbaik Developer)
```bash
# 1. Buat scaffold fungsi baru
supabase functions new send-task-notification

# 2. Test fungsi di localhost
supabase functions serve send-task-notification

# 3. Deploy ke cloud produksi
supabase functions deploy send-task-notification
```

---

### 30.3 🔐 Manajemen Kunci Rahasia (*Edge Function Secrets*)

Di sub-menu **Edge Functions ➔ Secrets**, Anda menyimpan kunci rahasia pihak ketiga yang terenkripsi aman:

1. **Parameter**:
   - `Name`: Nama variabel lingkungan (misal: `MIDTRANS_SERVER_KEY`, `RESEND_API_KEY`, `OPENAI_API_KEY`).
   - `Value`: Kunci API atau Private Key PEM multi-baris.
2. **Cara Mengakses di Kode Deno**:
   ```typescript
   Deno.serve(async (req) => {
     const apiKey = Deno.env.get('OPENAI_API_KEY')
     // Jalankan logika serverless yang aman...
     return new Response(JSON.stringify({ success: true }), {
       headers: { 'Content-Type': 'application/json' }
     })
   })
   ```

---

### 30.4 🟢 Kuota Paket: FREE Tier vs PRO Tier

- **Free Tier (Akun MariFlow Saat Ini)**:
  - **500.000 Invocations per bulan** (100% GRATIS).
  - Sangat mencukupi untuk menangani webhook pembayaran, pengiriman email, dan integrasi API AI tim kecil.
- **Pro Tier ($25/bulan) 🔒**:
  - **2.000.000 Invocations per bulan** + batas memori dan CPU time yang lebih tinggi.

---

## 📡 31. Bedah Lengkap Supabase Realtime (Postgres Changes, Broadcast, Presence, & Realtime RLS)

Menu **Realtime** (icon 📡🖱️ pada sidebar utama) mengelola infrastruktur komunikasi dua arah latensi rendah (*Full-Duplex WebSockets*) yang memungkinkan kolaborasi tim instan di MariFlow SaaS.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 📡 SUPABASE REALTIME WEBSOCKET ARCHITECTURE                                                            │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔮 3 PILAR UTAMA REALTIME:                                                                             │
│  ├─ 1. [Postgres Changes] : Dengarkan INSERT/UPDATE/DELETE database (Sinkronisasi Kanban Board).      │
│  ├─ 2. [Broadcast]        : Kirim pesan kilat antar klien tanpa simpan ke DB (Indikator Typing Chat). │
│  └─ 3. [Presence]         : Lacak siapa user/anggota tim yang sedang Online di Workspace.             │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔍 REALTIME INSPECTOR:                                                                                 │
│  - Live WebSocket packet sniffer untuk debugging siaran pesan & channel secara langsung di dashboard. │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛡️ REALTIME AUTHORIZATION & POLICIES (Tabel 'realtime.messages'):                                      │
│  - Amankan Private Channels dengan RLS! Hanya anggota workspace sah yang boleh mendengarkan siaran.   │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🟢 FREE TIER LIMITS:                                                                                   │
│  - 200 Concurrent Connected Clients (200 pengguna online bersamaan) & 100 events/detik (100% GRATIS). │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 31.1 🔮 3 Pilar Utama Fitur Realtime di MariFlow SaaS

#### 1. `Postgres Changes` (Change Data Capture / CDC)
- **Cara Kerja**: Terhubung langsung ke publikasi logical replication PostgreSQL (`supabase_realtime`).
- **Penerapan di MariFlow**: Saat seorang anggota tim memindahkan kartu tugas di Kanban Board dari *In Progress* ke *Completed*, kartu tugas di layar browser anggota tim lainnya akan **otomatis bergeser seketika** tanpa perlu merefresh halaman!
- **Contoh Kode Vue 3**:
  ```typescript
  const channel = supabase
    .channel('tasks-db-changes')
    .on('postgres_changes', { event: '*', schema: 'public', table: 'tasks' }, (payload) => {
      taskStore.handleRealtimeUpdate(payload)
    })
    .subscribe()
  ```

#### 2. `Broadcast` (Client-to-Client Ephemeral Messages)
- **Cara Kerja**: Mengirim pesan kilat berlatensi ultra-rendah antar browser tanpa menyimpannya ke database disk.
- **Penerapan di MariFlow**: Indikator *"Budi sedang mengetik komentar..."* atau kursor kolaboratif live (*Figma-like live cursors*).

#### 3. `Presence` (Status Online & Sinkronisasi State)
- **Cara Kerja**: Melacak status koneksi pengguna yang sedang aktif membuka halaman workspace.
- **Penerapan di MariFlow**: Menampilkan avatar bercahaya hijau *"3 Anggota Tim Sedang Online di Workspace Ini"*.

---

### 31.2 🔍 Realtime Inspector (Alat Debugging Langsung)

Menu **Realtime ➔ Inspector** menyediakan konsol pemantau siaran WebSocket:
- Anda dapat memilih channel (misal: `workspace-123`), memilih role (`authenticated` / `postgres`), lalu mengklik tombol **`▶ Start listening`**.
- Seluruh paket pesan WebSocket yang melintas akan tercatat secara visual dan real-time untuk mempermudah investigasi bug.

---

### 31.3 🛡️ Realtime Authorization & RLS Policies (`realtime.messages`)

Supabase Realtime v2 mendukung otorisasi keamanan berbasis **Row Level Security**:
- Di menu **Realtime ➔ Policies**, Anda dapat membuat kebijakan RLS pada tabel internal **`realtime.messages`**.
- **Tujuan**: Mencegah kebocoran data siaran. Pengguna dari luar Workspace tidak akan bisa menguping pesan siaran Broadcast maupun Presence dari Workspace orang lain!

```sql
-- Contoh Kebijakan: Hanya user terautentikasi yang boleh mendengarkan siaran Broadcast
CREATE POLICY "Allow listening for broadcasts for authenticated users only"
ON realtime.messages FOR SELECT
TO authenticated
USING ( realtime.messages.extension = 'broadcast' );
```

---

### 31.4 ⚙️ Realtime Settings: FREE Tier vs PRO Tier

Di tab **Realtime ➔ Settings**:

| Parameter | Free Tier (Akun Kita) | Pro Tier ($25/bulan) 🔒 |
| :--- | :--- | :--- |
| **Max Concurrent Clients** | **200 Pengguna Online Bersamaan** | **500+ hingga puluhan ribu koneksi** |
| **Max Events per Second** | **100 Event / Detik** | Tanpa batas (*Unlimited event throughput*) |
| **Database Pool Size** | 2 Koneksi pool khusus Realtime Auth | Dapat dikustomisasi sesuai beban traffic |

---

### 31.5 🧹 Higienitas Subscription di Vue 3 (*Anti-Memory Leak*)

> [!IMPORTANT]
> **Aturan Wajib Pengembangan MariFlow (`AGENTS.md`)**:
> Seluruh channel WebSocket Realtime yang dibuka pada hook `onMounted()` **wajib di-unsubscribe** pada hook `onBeforeUnmount()` di komponen Vue untuk mencegah kebocoran memori (*memory leak*):
>
> ```typescript
> onBeforeUnmount(() => {
>   supabase.removeChannel(channel)
> })
> ```

---

## 🛡️💡 32. Bedah Lengkap Security Advisor & Postgres Linter (Splinter Engine & RLS Auditing)

Menu **Advisors ➔ Security Advisor** (icon 💡 pada sidebar utama) adalah sistem pemindaian kerentanan database otomatis yang ditenagai oleh **Splinter (Supabase Postgres LINTER)**.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🛡️💡 SECURITY ADVISOR & SPLINTER LINTER ARCHITECTURE                                                  │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚥 3 KATEGORI TEMUAN KEAMANAN:                                                                         │
│  ├─ 🚩 [Errors]   : Masalah Kritis (Tabel publik tanpa RLS, Policy USING true pada data sensitif).   │
│  ├─ ⚠️ [Warnings] : Potensi Risiko Izin (Fungsi SECURITY DEFINER dapat dipanggil publik/authenticated).│
│  └─ ℹ️ [Info]     : Saran Optimasi Struktur & Best Practice Keamanan Tambahan.                        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔍 ANALISIS TEMUAN MARIFLOW DEV (Status Saat Ini):                                                     │
│  - 🚩 Errors   : 0 Errors (Sempurna! Seluruh 10 tabel MariFlow terproteksi RLS 100%).                 │
│  - ⚠️ Warnings : 2 Warnings pada fungsi 'public.rls_auto_enable()'                                     │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛠️ CARA RESOLUSI WARNING 'Public/Signed-In Can Execute SECURITY DEFINER Function':                    │
│  - Masalah : Fungsi trigger superuser otomatis dapat dipanggil oleh user biasa via API.               │
│  - Solusi  : Cabut izin eksekusi dari role publik via 'REVOKE EXECUTE ON FUNCTION ...'                 │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 32.1 🚥 3 Kategori Temuan Splinter Linter

1. **🚩 `Errors` (Kerentanan Kritis)**:
   - Pelanggaran fatal yang dapat menyebabkan kebocoran data (misal: ada tabel baru yang lupa dinyalakan RLS-nya atau tabel profil yang tidak memiliki SELECT policy).
   - **Hasil Audit MariFlow**: **`0 Errors`** (Semua tabel kita telah terlindungi RLS secara sempurna).
2. **⚠️ `Warnings` (Peringatan Risiko Hak Akses)**:
   - Kondisi di mana kode SQL berjalan dengan baik, tetapi memberikan izin (*privileges*) yang lebih luas daripada yang seharusnya dibutuhkan.
3. **ℹ️ `Info / Suggestions` (Saran Rekomendasi)**:
   - Tips peningkatan struktur basis data dan efisiensi query.

---

### 32.2 🔍 Bedah Kasus: Mengapa Muncul 2 Warnings pada `public.rls_auto_enable()`?

Pada tangkapan layar, Splinter mendeteksi:
1. `Public Can Execute SECURITY DEFINER Function` ➔ `public.rls_auto_enable()`
2. `Signed-In Users Can Execute SECURITY DEFINER Function` ➔ `public.rls_auto_enable()`

#### Penjelasan Teknis:
- Fungsi `public.rls_auto_enable()` dibuat dengan modifier **`SECURITY DEFINER`**, yang artinya fungsi ini berjalan menggunakan hak akses penuh superuser (`postgres`).
- Secara bawaan di PostgreSQL, setiap fungsi baru di skema `public` secara otomatis dapat dipanggil (*callable*) oleh siapapun (role `anon` publik dan role `authenticated`).
- Meskipun fungsi ini hanya sebuah trigger, membiarkan fungsi `SECURITY DEFINER` terbuka untuk dieksekusi langsung oleh klien PostgREST adalah sebuah celah risiko potensial.

#### Solusi Perbaikan (*Best Practice SQL Fix*):
Jalankan query berikut di **SQL Editor** untuk mencabut izin eksekusi publik:

```sql
-- Cabut izin eksekusi dari publik dan user biasa, sisakan hanya untuk superuser dan database trigger:
REVOKE EXECUTE ON FUNCTION public.rls_auto_enable() FROM PUBLIC, anon, authenticated;
```

Setelah query di atas dieksekusi, klik tombol **`Rerun linter`** di dashboard Security Advisor, dan status Warnings akan berubah menjadi **`0 Warnings`**!

---

## 🧩🔌 33. Bedah Lengkap Supabase Integrations Marketplace (Data API, Vault, pg_cron, pgmq, & Observability)

Menu **Integrations** (icon 🪟🧩 pada sidebar utama) adalah direktori marketplace ekosistem resmi dan pihak ketiga untuk memperluas kapabilitas database Supabase Anda (*Extend your database*).

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🧩🔌 SUPABASE INTEGRATIONS & PARTNER ECOSYSTEM ARCHITECTURE                                            │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📦 1. NATIVE EXTENSIONS & WRAPPERS (Tersedia Langsung di Database):                                    │
│  ├─ [</> Data API]    : Engine PostgREST otomatis men-generate RESTful API dari skema tabel Postgres.  │
│  ├─ [🔒 Vault]        : Enkripsi tingkat aplikasi (AES-GCM-256) untuk menyimpan data sensitif.         │
│  ├─ [⏰ Cron (pg_cron)]: Penjadwal tugas otomatis langsung di dalam SQL PostgreSQL.                   │
│  └─ [📨 Queues (pgmq)]: Antrean pesan ringan (Message Queue) tanpa perlu server Redis/RabbitMQ.        │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 2. THIRD-PARTY PARTNER INTEGRATIONS:                                                                │
│  ├─ Observability   : Grafana Cloud, Datadog, Axiom (Metrik CPU, RAM, Slow Queries & Latency).         │
│  ├─ Deployment Sync : Vercel Marketplace, Netlify, Cloudflare Workers (Auto-inject ENV Variables).     │
│  └─ Foreign Wrappers: Airtable, ClickHouse, BigQuery, Firebase, Stripe (Query API luar via SQL).       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🛠️ 3. BUILD YOUR OWN INTEGRATIONS:                                                                    │
│  - Supabase OAuth 2.0 Server & Management API untuk membangun aplikasi/plugin SaaS pihak ketiga.       │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 33.1 📦 Integrasi Bawaan (*Installed Integrations*)

Di akun proyek MariFlow, terdapat 2 integrasi bawaan yang berstatus **`INSTALLED`**:

1. **`</> Data API (PostgREST Engine)`**:
   - Secara instan menghasilkan REST API dan GraphQL API otomatis langsung dari setiap tabel, view, dan fungsi PostgreSQL yang ada di skema `public`.
   - Dilengkapi dokumentasi interaktif otomatis di menu **API Docs**.
2. **`🔒 Vault (Application Level Encryption)`**:
   - Modul enkripsi berbasis `pgsodium` / `pgcrypto` untuk mengenkripsi kolom database sensitif (seperti nomor rekening pembayaran, API keys, atau token rahasia pengguna) menggunakan standar enkripsi AES-GCM-256 tingkat militer.

---

### 33.2 ⏰ Fitur Komunitas Populer: `pg_cron` & `pgmq`

1. **`⏰ Cron (pg_cron by Citus Data)`**:
   - Memungkinkan Anda menjalankan query SQL secara otomatis pada interval waktu tertentu (mirip Linux Cron Job).
   - **Contoh di MariFlow**: Membersihkan notifikasi yang sudah kedaluwarsa lebih dari 30 hari setiap tengah malam:
     ```sql
     SELECT cron.schedule('cleanup-old-notifications', '0 0 * * *', $$
       DELETE FROM public.notifications WHERE created_at < NOW() - INTERVAL '30 days';
     $$);
     ```
2. **`📨 Queues (pgmq)`**:
   - Sistem antrean pesan (*Message Queue*) ringan di dalam Postgres.
   - Menggantikan kebutuhan server Redis atau RabbitMQ terpisah untuk tugas-tugas antrean email atau background processing di MariFlow.

---

### 33.3 🌐 Observability & Platform Deployment Sync

1. **Grafana Cloud Observability Platform (Partner)**:
   - Menghubungkan metrik telemetri database PostgreSQL (penggunaan koneksi pool, I/O disk, cache hit ratio) ke dashboard Grafana secara real-time.
2. **Vercel & Netlify Marketplace**:
   - Saat Anda menghubungkan proyek Supabase ke repository Vercel, Supabase akan secara otomatis menginjeksi variabel `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY` ke konfigurasi production Vercel tanpa perlu copy-paste manual.

---

### 33.4 🔌 Foreign Data Wrappers (FDW Integrations)

Integrasi seperti **`Airtable Wrapper`**, **`Stripe Wrapper`**, dan **`ClickHouse Wrapper`** memungkinkan developer melakukan query SQL terhadap API eksternal seolah-olah API tersebut adalah tabel lokal PostgreSQL:

```sql
-- Query data customer langsung dari Stripe API menggunakan SQL murni!
SELECT customer_id, email, subscription_status 
FROM stripe.subscriptions 
WHERE status = 'active';
```

---

## ⚙️🏢 34. Bedah Lengkap Project Settings: General (Lifecycle, Engine Versions, & Custom Domains)

Menu **Settings ➔ General** (icon ⚙️ pada sidebar bawah) adalah pusat kendali konfigurasi identitas, siklus hidup (*lifecycle*), versi mesin infrastruktur, dan kepemilikan proyek MariFlow.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ⚙️🏢 PROJECT GENERAL SETTINGS ARCHITECTURE                                                             │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🏷️ 1. GENERAL METADATA:                                                                                │
│  - Project Name   : mariflow-dev (Nama proyek tampilan di dashboard).                                  │
│  - Project ID     : rtazqheauyiujjteburi (Reference string 20 karakter di URL API & Connection String). │
│  - Project Region : ap-southeast-1 (Singapore / Latensi terendah untuk pengguna Indonesia).           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🔄 2. PROJECT AVAILABILITY (LIFECYCLE MANAGEMENT):                                                     │
│  - Restart Project : Me-reboot container PostgreSQL & Auth/API engine saat maintenance.               │
│  - Pause Project   : Menidurkan proyek. (Free Tier otomatis pause jika tidak aktif selama 7 hari).    │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🏗️ 3. CORE SERVICE VERSIONS:                                                                          │
│  - PostgreSQL Engine : 17.6.1 [LATEST] (Mesin SQL basis data relasional tercanggih).                  │
│  - PostgREST Engine  : 14.5 (Pembangkit REST API instan).                                              │
│  - Auth Engine       : 2.196.0 (Server otentikasi GoTrue).                                             │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌐 4. CUSTOM DOMAINS (BRANDED EXPERIENCE):                                                             │
│  - Free Tier Default : https://rtazqheauyiujjteburi.supabase.co (100% GRATIS).                         │
│  - 🔒 PRO TIER ADD-ON: Menggunakan domain kustom sendiri (e.g. api.mariflow.com) seharga $10/bulan.    │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🚨 5. PROJECT TRANSFER & DISASTER RECOVERY:                                                            │
│  - Transfer Project : Pindahkan proyek antar Organization anggota tim.                                 │
│  - Delete Project   : ⚠️ Hapus permanen seluruh database, skema, tabel, storage, dan pengguna!        │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 34.1 🏷️ Metadata & Identitas Proyek MariFlow

1. **`Project Name`**: Nama proyek tampilan di dashboard (`mariflow-dev`).
2. **`Project ID (Reference ID)`**: 
   - ID alfanumerik unik (`rtazqheauyiujjteburi`).
   - String ini menjadi subdomain default untuk seluruh API, Storage, dan Realtime endpoint: `https://rtazqheauyiujjteburi.supabase.co`.
3. **`Project Region`**: 
   - `ap-southeast-1` (Singapore). Lokasi server fisik AWS terdekat dengan Indonesia untuk menjamin kecepatan akses (*ping* < 30ms).

---

### 34.2 🔄 Manajemen Siklus Hidup (*Project Availability: Restart & Pause*)

1. **`Restart Project`**:
   - Me-reboot ulang container PostgreSQL dan seluruh background service tanpa menghilangkan data sedikit pun. Berguna jika koneksi database mengalami deadlock atau setelah perubahan konfigurasi ekstensi.
2. **`Pause Project` & Kebijakan Free Tier Auto-Pause**:
   - **Fitur Pause**: Menghentikan sementara komputasi server.
   - **Kebijakan Free Tier**: Pada paket Free, jika proyek tidak menerima request API selama 7 hari berturut-turut, Supabase akan secara otomatis menidurkan proyek (*Auto-pause*).
   - **Cara Membangunkan (*Unpause*)**: Cukup buka dashboard web Supabase dan klik tombol **`Restore project`**. Proyek akan aktif kembali dalam 1-2 menit dengan seluruh data utuh 100%.

---

### 34.3 🏗️ Versi Mesin Layanan (*Core Service Versions*)

Dashboard menampilkan transparansi versi teknologi open-source yang mendasari proyek:

- **`Postgres version: 17.6.1` [LATEST]**: Versi PostgreSQL terbaru dengan performa indexing B-Tree, JSONB query, dan memori yang sangat efisien.
- **`PostgREST version: 14.5`**: Server HTTP otomatis yang menerjemahkan skema SQL menjadi REST API berkecepatan tinggi.
- **`Auth version: 2.196.0`**: Server otentikasi GoTrue yang mengelola token JWT, refresh token, dan hashing password argon2/bcrypt.

---

### 34.4 🌐 Custom Domains: FREE Tier vs PRO Tier

- **Free Tier (Akun MariFlow Saat Ini)**:
  - Menggunakan endpoint resmi: `https://rtazqheauyiujjteburi.supabase.co`.
  - Sangat aman, didukung SSL/TLS otomatis dari Supabase, dan ideal untuk aplikasi SaaS modern.
- **Pro Tier ($25/bulan) + Add-on ($10/bulan) 🔒**:
  - Memungkinkan Anda menghubungkan domain sendiri seperti `https://api.mariflow.com` atau `https://auth.mariflow.com` agar nama brand terlihat 100% independen bagi pengguna enterprise (*Branded Experience*).

---

### 34.5 🚨 Transfer & Delete Project (*Disaster Prevention*)

1. **`Transfer project`**:
   - Memindahkan kepemilikan proyek ke Organization lain (misal: memindahkan proyek dari akun personal developer ke akun Organization perusahaan Mari Partner).
2. **`Delete project` (Tindakan Destruktif)**:
   - Menghapus total seluruh database PostgreSQL, tabel, storage bucket, dan daftar pengguna secara permanen dari server cloud.

---

## 🖥️⚡ 35. Bedah Lengkap Infrastructure Settings (Compute Sizing, Telemetri RAM/CPU/WAL, & Read Replicas)

Menu **Settings ➔ Infrastructure** (di bawah kelompok `CONFIGURATION`) menampilkan peta topologi server fisik, metrik penggunaan resource komputasi (*Compute & Memory*), ukuran disk PostgreSQL, serta opsi penskalaan (*Vertical & Horizontal Scaling*).

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 🖥️⚡ SUPABASE INFRASTRUCTURE ARCHITECTURE                                                              │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🇸🇬 1. PRIMARY DATABASE INSTANCE:                                                                       │
│  - Region        : ap-southeast-1 (Singapore).                                                         │
│  - Instance Type : AWS t3.nano (Compute Size: NANO / 0.5 GB RAM, Shared CPU).                          │
│  - Status Beban  : CPU ~2-8%, Memory ~54%, Disk ~14%, Connection Pool: 7/60 koneksi (Sangat Sehat!).  │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 💾 2. ANATOMI PENGGUNAAN DISK (500 MB Free Tier):                                                      │
│  - Database Data : ~24.5 MB (Data relasional tabel proyek, tugas, anggota, dsb).                       │
│  - WAL Logs      : ~80.0 MB (Write-Ahead Logging untuk integritas transaksi ACID).                    │
│  - System Catalog: ~167.3 MB (Metadata skema PostgreSQL, pg_catalog, extension).                       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 🌍 3. READ REPLICAS (Horizontal Scaling) [🔒 PRO TIER]:                                                │
│  - Menyalin database ke berbagai belahan dunia (e.g. US, Frankfurt, Tokyo) untuk query SELECT cepat.  │
│  - Persyaratan: Membutuhkan akun PRO Plan & Compute Size minimal 'Small' (2 GB RAM).                   │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 📈 4. COMPUTE SIZING (Vertical Scaling) [🔒 PRO TIER]:                                                 │
│  - NANO   : $0 / jam (0.5 GB RAM, Shared CPU) ──► Free Tier bawaan.                                   │
│  - MICRO  : $0.01344 / jam (~$10/bln) (1 GB RAM, 2-core CPU).                                         │
│  - SMALL  : $0.0206 / jam (~$15/bln) (2 GB RAM, 2-core CPU).                                          │
│  - MEDIUM : $0.0822 / jam (~$60/bln) (4 GB RAM, 2-core CPU).                                          │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 35.1 🇸🇬 Topologi Primary Database Proyek MariFlow

Peta visual menampilkan status server database utama:
1. **Lokasi Server**: Singapore (`ap-southeast-1`).
2. **Tipe Mesin Virtual**: `t3.nano` (Compute NANO).
3. **Telemetri Live**:
   - **CPU**: `2% - 8%` (Beban prosesor sangat ringan).
   - **RAM / Memory**: `~54%` (Penggunaan memori stabil di batas aman).
   - **Connection Pool**: `7 / 60 conns` (Hanya terpakai 7 koneksi dari batas maksimal 60 koneksi bersamaan).

---

### 35.2 💾 Anatomi Penggunaan Disk: Database, WAL, & System

Di bagian bawah dashboard, kuota disk database Free Tier (500 MB) terbagi menjadi 3 komponen:
1. **`Database` (~24.5 MB)**: Ukuran data murni dari baris tabel `workspaces`, `tasks`, `projects`, dan relasinya.
2. **`WAL` (Write-Ahead Logging) (~80 MB)**: Log transaksi PostgreSQL yang mencatat setiap perubahan data sebelum ditulis ke file disk untuk menjamin pemulihan data (*Crash Recovery & Data Durability*).
3. **`System` (~167.3 MB)**: Skema bawaan PostgreSQL (`pg_catalog`, `information_schema`, `auth`, `storage`).

---

### 35.3 🌍 Read Replicas: Penskalaan Horisontal (🔒 PRO TIER)

- **Fungsi Read Replicas**:
  - Menempatkan salinan database *read-only* di berbagai region dunia (misal: US East Ohio, Frankfurt, Sydney).
  - Ketika jutaan pengguna dari Amerika atau Eropa membuka MariFlow, query `SELECT` akan diarahkan ke server replica terdekat untuk memangkas latensi dari ratusan milidetik menjadi hitungan milidetik.
- **Kondisi Free Tier**:
  - Pada Free Tier, seluruh operasi baca (*Reads*) dan tulis (*Writes*) ditangani secara terpusat oleh **Primary Database Singapore**.

---

### 35.4 📈 Pilihan Compute Sizing: FREE Tier vs PRO Tier

| Ukuran Compute | Biaya / Jam | RAM (Memori) | Kapasitas CPU | Status di Akun Kita |
| :--- | :--- | :--- | :--- | :--- |
| **NANO** | **$0 / jam** | **0.5 GB (512 MB)** | **Shared Burstable** | 🟢 **Aktif (Free Tier)** |
| **MICRO** 🔒 | $0.01344 / jam | 1 GB | Dedicated 2-Core | 🔒 PRO Plan |
| **SMALL** 🔒 | $0.0206 / jam | 2 GB | Dedicated 2-Core | 🔒 PRO Plan (Syarat Read Replica) |
| **MEDIUM** 🔒 | $0.0822 / jam | 4 GB | Dedicated 2-Core | 🔒 PRO Plan |

> [!NOTE]
> **Kapasitas Free Tier NANO**:
> Instance NANO bawaan Free Tier yang kita miliki saat ini sudah sangat sanggup melayani ribuan request harian aplikasi **MariFlow SaaS** untuk kebutuhan tim kecil hingga menengah tanpa kendala performa.

---

*MariFlow SaaS — Panduan Resmi Edukasi & Penguasaan Platform Supabase.*



























