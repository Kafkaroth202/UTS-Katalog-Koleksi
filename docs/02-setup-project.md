# 02 - Setup Project

## Tujuan fase

Menyiapkan project Flutter, repositori GitHub, dan dokumentasi awal sebelum mulai menulis fitur.

## Langkah yang dilakukan

### 1. Membuat repositori GitHub

Repositori `UTS-Katalog-Koleksi` dibuat di GitHub dengan visibilitas publik. README, `.gitignore`, dan lisensi sengaja tidak dicentang agar tidak bentrok dengan file yang dibuat Flutter.

### 2. Membuat project Flutter

Project dibuat lewat VS Code (**Flutter: New Project**, template **Empty Application**) dengan nama `uts_katalog_koleksi`. Folder project diletakkan di luar folder tugas pertemuan sebelumnya supaya repositori Git tidak bersarang.

Nama project memakai huruf kecil dan garis bawah karena itu aturan penamaan package Dart.

### 3. Menambahkan package

```
flutter pub add sqflite sqflite_common_ffi path
```

| Package | Fungsi |
|---|---|
| `sqflite` | Akses database SQLite |
| `sqflite_common_ffi` | Membuat `sqflite` berjalan di Windows desktop |
| `path` | Menyusun lokasi file database |

### 4. Menyiapkan dokumentasi

Folder `docs/` dibuat untuk menyimpan dokumen tiap fase, dan `README.md` bawaan Flutter diganti dengan README proyek.

### 5. Commit pertama

```
git init -b main
git add .
git commit -m "Phase 1: project setup, planning doc, and README"
git remote add origin https://github.com/Kafkaroth202/UTS-Katalog-Koleksi.git
git push -u origin main
```

## Hasil

Project berjalan di Windows (`flutter run -d windows`) dan kode sudah tersimpan di GitHub.

## Catatan

- Aplikasi dijalankan di target Windows, bukan Chrome, karena `sqflite` dan `dart:io` tidak berjalan di browser.
