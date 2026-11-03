# 04 - Tampilan Utama dan Tambah Data

## Tujuan fase

Membuat halaman utama yang menampilkan data dari database dalam bentuk kartu, lengkap dengan keadaan kosong dan form untuk menambah data.

## Langkah yang dilakukan

### 1. Kerangka halaman dengan dua tab

`HomeScreen` memakai `DefaultTabController` dengan dua tab:

- **Finished**: halaman depan, berisi semua item berstatus `finished`.
- **Queue**: berisi item berstatus `ongoing` (bagian "In progress") dan `not_yet` (bagian "Not yet"), keduanya dengan tampilan kartu yang sama.

Data dimuat dari database dengan `_loadItems()` pada `initState()`, lalu dipisahkan per status memakai `_withStatus()`.

### 2. Grid kartu

Kartu disusun dengan `SliverGrid` di dalam `CustomScrollView`, sehingga satu tab bisa berisi beberapa bagian bergulir sekaligus. Jumlah kolom menyesuaikan lebar jendela lewat `SliverGridDelegateWithMaxCrossAxisExtent`.

Setiap kartu berisi:

- gambar thumbnail di atas (`Image.network`), dengan ikon pengganti jika URL kosong atau gagal dimuat;
- nama, lalu kategori dan tahun;
- label status untuk item yang belum selesai (Reading, Watching, Playing, atau Not yet);
- rating;
- potongan deskripsi maksimal 3 baris (`maxLines: 3` dengan `TextOverflow.ellipsis`).

### 3. Keadaan kosong

Aplikasi dimulai tanpa data, sehingga tiap tab menampilkan pesan petunjuk selama belum ada item. Pesan hilang otomatis setelah item pertama ditambahkan.

### 4. Form tambah data

Tombol ikon plus (`FloatingActionButton`) membuka `showModalBottomSheet` berisi `Form`. Isian form berurutan: Category, Name, Author/Director/Studio, Year, Status, Rating, Image URL, dan Description.

- Label isian creator dan label pilihan status berubah mengikuti kategori yang dipilih. Karena itu isi bottom sheet dibungkus `StatefulBuilder` agar bisa dibangun ulang tanpa menutup sheet.
- **Name** wajib diisi (validator).
- **Year** hanya menerima angka dan dibatasi 4 digit memakai `inputFormatters` (`digitsOnly` dan `LengthLimitingTextInputFormatter(4)`). Jika diisi, harus tepat 4 digit.
- **Rating** berupa deretan 10 bintang. Sisi kiri bintang memberi setengah poin dan sisi kanan memberi satu poin penuh, sehingga nilainya 0,5 sampai 10 dengan kelipatan 0,5. Mengetuk nilai yang sama lagi menghapus rating.
- **Image URL** ditempatkan di atas Description agar form terlihat lebih rapi.

Tombol Save memanggil `_saveItem()`, yang menyimpan ke database lalu memuat ulang daftar, sehingga item langsung muncul di tab yang sesuai.

## Hasil

Aplikasi terbuka dalam keadaan kosong. Setelah item ditambahkan lewat tombol plus, item tampil sebagai kartu di tab Finished atau Queue sesuai statusnya.

## Catatan

- Form sudah dibuat agar bisa menerima item yang sudah ada (parameter `item`), sehingga fitur ubah pada fase berikutnya tinggal menyambungkannya.
- Rating awalnya berupa angka 1 sampai 10, lalu diganti menjadi bintang, dan kemudian mendukung setengah bintang. Karena itu kolom `rating` pada database diubah dari INTEGER menjadi REAL.
