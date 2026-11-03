# Katalog Koleksi

Aplikasi desktop (Windows) untuk menyimpan **waiting list** dan **review** buku, film, anime, game, dan koleksi lain. Dibuat dengan Flutter dan SQLite sebagai tugas UTS Mobile Dev II.

**Status:** dalam pengerjaan (Fase 1: setup project).

## Teknologi

- Flutter (target Windows desktop)
- SQLite lewat `sqflite` dan `sqflite_common_ffi`
- `path`

## Dokumentasi

Proses pembuatan dicatat per fase di folder [`docs/`](docs/):

| Fase | Dokumen | Status |
|---|---|---|
| 0 | [Perencanaan](docs/01-perencanaan.md) | Selesai |
| 1 | Setup project | Berjalan |
| 2 | Database | - |
| 3 | Tampilan grid | - |
| 4 | Form CRUD | - |
| 5 | Cari dan filter | - |
| 6 | Polish | - |

## Menjalankan aplikasi

```
flutter pub get
flutter run -d windows
```
