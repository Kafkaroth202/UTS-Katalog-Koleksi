# 01 - Perencanaan

## Tujuan

Membuat aplikasi desktop sederhana **Katalog Koleksi** menggunakan Flutter dan SQLite sebagai tugas UTS Mobile Dev II. Aplikasi ini menyimpan **riwayat dan daftar tunggu** buku, film, anime, game, dan koleksi lain. Aplikasi dimulai dalam keadaan kosong, dan semua data ditambahkan sendiri oleh pengguna. Setiap koleksi punya gambar thumbnail, dan di bawah gambar tampil potongan deskripsi sebagai pratinjau.

## Revisi desain

Rancangan awal berisi data contoh, banyak jenis status, dan filter. Setelah melihat versi pertama tampilan grid, desain disederhanakan sesuai kebutuhan:

- Aplikasi dimulai **tanpa data**, tanpa data contoh.
- Satu-satunya hal yang tetap adalah **kategori**.
- Status disederhanakan menjadi tiga: Finished, sedang berjalan (Watching/Reading/Playing), dan Not yet.
- Form tambah data berisi Name, Year, Author/Director/Studio, Rating (X/10), dan Description.

## Teknologi

| Komponen | Pilihan |
|---|---|
| Framework | Flutter |
| Database lokal | SQLite lewat paket `sqflite` |
| Dukungan desktop | `sqflite_common_ffi` (target Windows) |
| Path database | paket `path` |
| Platform | Windows desktop |
| Bahasa | Tampilan aplikasi dalam bahasa Inggris, dokumentasi dalam bahasa Indonesia |

## Kategori (tetap)

Book, Movie, Anime, Game, dan Other. Daftar ini tertulis di kode dan tidak bisa diubah pengguna.

## Status

| Kode | Tampilan | Keterangan |
|---|---|---|
| `finished` | Finished | Tampil otomatis di halaman depan (tab Finished) |
| `ongoing` | Reading / Watching / Playing / In progress | Label mengikuti kategori. Tampil di tab Queue |
| `not_yet` | Not yet | Memakai tata letak kartu yang sama dengan `ongoing`, di tab Queue |

Label status sedang berjalan menurut kategori: Book = Reading, Movie dan Anime = Watching, Game = Playing, Other = In progress.

## Fitur

- Saat pertama dibuka, tidak ada yang tampil. Data ditambahkan lewat tombol ikon plus
- Form tambah: Category, Name, Author/Director/Studio (label mengikuti kategori), Year, Status, Rating (10 bintang, bisa setengah bintang), Description, dan Image URL (opsional)
- Kartu dalam grid: gambar di atas, nama, kategori dan tahun, rating, lalu potongan deskripsi (maksimal 3 baris)
- Tab **Finished** sebagai halaman depan, dan tab **Queue** yang berisi bagian In progress dan Not yet
- Ketuk kartu untuk melihat detail lengkap
- Ubah dan hapus data (hapus dengan konfirmasi)
- Validasi form
- Opsional jika waktu cukup: pencarian berdasarkan nama dan filter kategori

## Desain data

### Tabel `items`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER | primary key, autoincrement |
| category | TEXT | `book`, `movie`, `anime`, `game`, atau `other`, wajib |
| title | TEXT | nama, wajib |
| creator | TEXT | penulis, sutradara, studio, developer, atau pembuat, opsional |
| year | INTEGER | tahun rilis, opsional |
| status | TEXT | `finished`, `ongoing`, atau `not_yet`, wajib |
| rating | REAL | 0,5 sampai 10 dengan kelipatan 0,5, opsional |
| description | TEXT | deskripsi, opsional |
| image_url | TEXT | alamat gambar thumbnail, opsional |

## Keputusan desain

- **Satu tabel** agar sesuai dengan materi kelas dan mudah dijelaskan.
- **`creator` satu kolom untuk semua kategori.** Yang berbeda hanya label di form (Author, Director, Studio, Developer, Creator).
- **`status` disimpan sebagai kode**, sedangkan label ditentukan oleh kategori di sisi tampilan.
- **Kategori berupa daftar tetap di kode.**
- **Tanpa data contoh.** Tabel dibuat kosong saat database pertama kali dibuat.
- **Gambar memakai alamat URL** (`Image.network`), dengan ikon pengganti jika kosong atau gagal dimuat.
- **Detail lengkap ditampilkan dengan dialog**, bukan halaman baru.
- **Teks antarmuka berbahasa Inggris**, sedangkan seluruh dokumentasi berbahasa Indonesia.

## Layar

1. **Halaman utama**: dua tab (Finished dan Queue), grid kartu, dan tombol plus
2. **Form tambah/ubah**: bottom sheet
3. **Dialog detail**: muncul saat kartu diketuk, berisi tombol ubah dan hapus

## Struktur project

```
lib/
|-- main.dart
|-- models/      item.dart
|-- helper/      database_helper.dart
`-- pages/       home_screen.dart
```

## Rencana kerja

| Fase | Isi | Dokumen |
|---|---|---|
| 1 | Setup project, repo, dan README awal | `02-setup-project.md` |
| 2 | Model `Item` dan `DatabaseHelper` | `03-database.md` |
| 3 | Halaman utama (tab, grid, keadaan kosong) dan form tambah | `04-tampilan-dan-tambah.md` |
| 4 | Dialog detail, ubah, dan hapus | `05-detail-ubah-hapus.md` |
| 5 | Pencarian dan filter kategori (opsional) | `06-cari-filter.md` |
| 6 | Polish dan screenshot | `07-polish.md` |
| 7 | Dokumentasi final | `README.md` |
