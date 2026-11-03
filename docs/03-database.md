# 03 - Database

## Tujuan fase

Membuat model data `Item` dan kelas `DatabaseHelper` yang mengelola tabel `items` di SQLite, mengikuti pola yang dipakai pada materi SQLite di kelas.

## Langkah yang dilakukan

### 1. Model `Item` (`lib/models/item.dart`)

Kelas `Item` merepresentasikan satu baris tabel `items`. Kolom yang boleh kosong (`creator`, `year`, `rating`, `description`, `imageUrl`). `rating` bertipe `double` karena nilainya bisa 0,5 sampai 10 dengan kelipatan 0,5. bertipe nullable.

- `toMap()` mengubah objek menjadi `Map` untuk disimpan ke SQLite. Nama kunci mengikuti nama kolom, termasuk `image_url`.
- `Item.fromMap()` melakukan sebaliknya saat membaca data dari database.
- Daftar kategori dan status disimpan sebagai konstanta (`Item.categories`, `Item.statuses`).
- Fungsi label (`categoryLabelFor`, `creatorLabelFor`, `statusLabelFor`) mengubah kode menjadi teks yang tampil. Misalnya status `ongoing` tampil sebagai Reading untuk Book, Watching untuk Movie dan Anime, serta Playing untuk Game.

### 2. `DatabaseHelper` (`lib/helper/database_helper.dart`)

Dibuat sebagai singleton (`DatabaseHelper.instance`) supaya seluruh aplikasi memakai satu koneksi database.

- `_initDB()` membuka database `katalog_koleksi_v3.db` lewat `getDatabasesPath()` dan `join()` dari paket `path`.
- `_onCreate()` hanya membuat tabel `items` sesuai desain di dokumen perencanaan. Tabel sengaja dibiarkan kosong karena aplikasi dimulai tanpa data.
- Empat operasi CRUD: `insertItem`, `getItems`, `updateItem`, `deleteItem`. `getItems` mengurutkan dari `id` terbaru.

`onCreate` hanya berjalan sekali, saat file database pertama kali dibuat. Karena struktur tabel berubah dari rancangan awal, nama database diganti dari `v1` menjadi `v2`, lalu `v3` saat kolom `rating` diubah dari INTEGER menjadi REAL agar mendukung setengah bintang. Setiap penggantian nama membuat tabel baru terbentuk.

### 3. Inisialisasi di `main.dart`

Pada Windows, `sqflite` tidak punya implementasi bawaan, sehingga `main()` memanggil `sqfliteFfiInit()` dan menetapkan `databaseFactory = databaseFactoryFfi` sebelum `runApp`.

## Hasil

Database terbentuk dengan tabel kosong, dan kelas `DatabaseHelper` siap dipakai oleh layar utama pada fase berikutnya.

## Catatan

- Setelah menambah file baru atau mengubah `main()`, aplikasi perlu hot restart, bukan hot reload.
- Versi pertama fase ini memakai struktur tabel yang lebih rumit dan data contoh. Struktur tersebut dibuang setelah desain direvisi (lihat bagian Revisi desain pada dokumen perencanaan).
