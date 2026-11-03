# Katalog Koleksi

Aplikasi desktop (Windows) untuk menyimpan **waiting list** dan **review** buku, film, anime, game, dan koleksi lain. Dibuat dengan Flutter dan SQLite sebagai tugas UTS Mobile Dev II.

**Status:** dalam pengerjaan (Fase 2: database).

## Teknologi

- Flutter (target Windows desktop)
- SQLite lewat `sqflite` dan `sqflite_common_ffi`
- `path`

## Dokumentasi

Proses pembuatan dicatat per fase di folder [`docs/`](docs/):

| Fase | Dokumen | Status |
|---|---|---|
| 0 | [Perencanaan](docs/01-perencanaan.md) | Selesai |
| 1 | Setup project | Selesai |
| 2 | Database | Berjalan |
| 3 | Tampilan utama dan tambah data | - |
| 4 | Detail, ubah, dan hapus | - |
| 5 | Cari dan filter (opsional) | - |
| 6 | Polish | - |

## Menjalankan aplikasi

```
flutter pub get
flutter run -d windows
```
