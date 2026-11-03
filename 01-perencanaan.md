# 01 - Perencanaan

## Tujuan

Membuat aplikasi desktop sederhana **Katalog Koleksi** menggunakan Flutter dan SQLite sebagai tugas UTS Mobile Dev II. Aplikasi ini menyimpan **waiting list** dan **review** buku, film, anime, game, dan koleksi lain yang lebih spesifik (kategori Others). Setiap koleksi punya gambar thumbnail, dan di bawah gambar tampil potongan teks review sebagai pratinjau.

## Teknologi

| Komponen | Pilihan |
|---|---|
| Framework | Flutter |
| Database lokal | SQLite lewat paket `sqflite` |
| Dukungan desktop | `sqflite_common_ffi` (target Windows) |
| Path database | paket `path` |
| Platform | Windows desktop |
| Bahasa | Tampilan aplikasi dalam bahasa Inggris, dokumentasi dalam bahasa Indonesia |

## Fitur (MVP)

- Koleksi tampil sebagai kartu dalam grid: gambar di atas, judul, lalu potongan review (maksimal 3 baris)
- Tambah, ubah, dan hapus koleksi (hapus dengan konfirmasi)
- Validasi form
- Ketuk kartu untuk membaca review lengkap dalam dialog
- Satu daftar untuk waiting list dan review, dibedakan oleh status
- Pencarian berdasarkan judul
- Filter berdasarkan jenis (All / Books / Movies / Anime / Games / Others) dan status (All / Waiting list / Reviewed)
- Ringkasan di bagian atas: total koleksi dan jumlah per jenis

## Desain data

### Tabel `items`

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER | primary key, autoincrement |
| type | TEXT | `book`, `movie`, `anime`, `game`, atau `other`, wajib |
| subtype | TEXT | jenis spesifik, hanya diisi jika `type` = `other` (misalnya manga, podcast, board game), opsional |
| title | TEXT | judul, wajib |
| creator | TEXT | penulis, sutradara, studio, developer, atau pembuat |
| year | INTEGER | tahun rilis, opsional |
| category | TEXT | genre, dipilih dari daftar tetap |
| status | TEXT | `wishlist`, `ongoing`, atau `done`, wajib |
| rating | INTEGER | 1 sampai 5, opsional |
| review | TEXT | teks review, opsional |
| image_url | TEXT | alamat gambar thumbnail, opsional |

### Label status menurut jenis (teks yang tampil di aplikasi)

| Kode | Book | Movie | Anime | Game | Other |
|---|---|---|---|---|---|
| wishlist | Want to read | Want to watch | Want to watch | Want to play | Want to try |
| ongoing | Reading | Watching | Watching | Playing | In progress |
| done | Finished | Watched | Watched | Completed | Done |

## Keputusan desain

- **Satu tabel** agar sesuai dengan materi kelas dan mudah dijelaskan.
- **`creator` satu kolom untuk semua jenis.** Yang berbeda hanya label di form (Author, Director, Studio, Developer, Maker).
- **Jenis `other` menampung koleksi yang lebih spesifik** (misalnya manga, podcast, board game). Saat jenis ini dipilih, form menampilkan satu isian tambahan "Specific type" yang disimpan di kolom `subtype`.
- **`status` disimpan sebagai kode**, sedangkan label ditentukan oleh jenis di sisi tampilan.
- **Kategori berupa daftar tetap di kode**, seperti daftar kategori pada materi sebelumnya.
- **Gambar memakai alamat URL** (`Image.network`), dengan ikon pengganti jika kosong atau gagal dimuat.
- **Review lengkap ditampilkan dengan dialog**, bukan halaman baru.
- **Teks antarmuka berbahasa Inggris**, sedangkan seluruh dokumentasi berbahasa Indonesia.

## Pengembangan opsional (setelah MVP selesai)

- Memisahkan kategori ke tabel `categories` dengan foreign key
- Gambar dari file lokal
- Pengurutan (judul, tahun, rating)
- Halaman detail

## Layar

1. **Home**: ringkasan, pencarian, filter, grid kartu, dan tombol Add
2. **Form tambah/ubah**: bottom sheet
3. **Dialog review**: muncul saat kartu diketuk

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
| 3 | Home menampilkan kartu dari database | `04-tampilan-grid.md` |
| 4 | Form tambah, ubah, hapus, dan dialog review | `05-form-crud.md` |
| 5 | Pencarian dan filter | `06-cari-filter.md` |
| 6 | Polish dan screenshot | `07-polish.md` |
| 7 | Dokumentasi final | `README.md` |
