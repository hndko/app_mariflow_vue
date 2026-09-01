# 📊 Dashboard Analytics Optimizer & Role-Based Customization (Milestone Upgrade)

## 1. Objective
Mendokumentasikan peningkatan sistem analitik dashboard MariFlow SaaS menggunakan **Dashboard Analytics Optimizer Framework** dengan adaptasi antarmuka dan metrik khusus untuk setiap peran (*Owner*, *Admin*, *Member*, *Viewer*).

---

## 2. Matriks Implementasi Berbasis Peran (*Role-Based Matrix*)

| Role | Sudut Pandang Utama | KPI & Metrik Utama | Visualisasi Grafik | Aksi Cepat |
| :--- | :--- | :--- | :--- | :--- |
| 👑 **Owner** | **Executive & Strategic** | Total Proyek Aktif, Tingkat Penyelesaian Workspace (%), Total Anggota, Penggunaan Storage | **Area Chart**: Tren Kecepatan Tugas (Velocity), **Donut Chart**: Status Proyek | Kelola Workspace, Tambah Proyek, Modal Invite |
| ⚡ **Admin** | **Operational & Bottlenecks** | Backlog Todo, Tugas Dalam Pengerjaan, Tugas Lewat Tenggat (Overdue), Tugas Belum Ditugaskan | **Bar Chart**: Beban Kerja Anggota (Workload), **Bar Chart**: Urgensi Prioritas | Penugasan Anggota, Eskalasi Overdue, Buat Tugas |
| 🛠️ **Member** | **Personal Productivity** | Tugasku Aktif, Tugas Selesai Saya, Deadline Terdekat 7 Hari, Skor Produktivitas (%) | **Donut Chart**: Distribusi Status Tugasku | Buka Detail Tugas, Pindah Status Kanban |
| 👁️ **Viewer** | **Read-Only Observability** | Progres Workspace, Total Proyek, Total Tugas Terbuka (Tanpa Tombol Modifikasi Data) | Status Distribusi Global | Lihat Kanban & Proyek |

---

## 3. Strategi Optimasi Performa & Query

1. **PostgreSQL Single-Pass RPC**:
   - `get_role_dashboard_statistics(target_ws_id, target_user_id, time_filter)` mengeksekusi seluruh kalkulasi agregasi dalam 1 query mikrodetik di server database.
2. **Filter Rentang Waktu Global**:
   - Presets: `Hari Ini`, `Minggu Ini`, `Bulan Ini`, `Tahun Ini`, `Semua Waktu`.
3. **Pencegahan N+1 Query**:
   - Tabel ringkas tugas terbaru menggunakan eager loading relasional (`assignee` dan `project`).
4. **Debounced Filter**:
   - Seluruh perubahan filter menerapkan debounce guna melindungi database dari query flooding.
