# Warung Tani

Warung Tani merupakan marketplace yang menyediakan jasa berupa perantara antara petani dan konsumen. Ide proyek ini kami implementasikan untuk tugas akhir mata kuliah interaksi manusia komputer semester 5 dengan membuat UI/UX dan beberapa dokumen yang diperlukan, kemudian proyek ini kami lanjutkan untuk tugas akhir di Aplikasi Berbasis Platform yang merupakan mata kuliah di semester 6 dengan membuat situs web backend dan API menggunakan framework laravel dan aplikasi seluler dengan Flutter

## User Role
Ini merupakan versi Mobilenya yang mana hanya dapat menggunakan Role Customer, Versi ini menggunakan API dari versi Web yang tersedia pada https://github.com/mraihanfauzii/WarungTaniWebAPI, Versi Web dapat menggunakan Role Customer maupun Admin
- Customer : Melakukan autentikasi kemudian dapat membeli barang(sayur dan buah) dengan berbagai dukungan fitur pada aplikasi warung tani yang mempermudah mereka dalam mencari sayur dan buah-buahan yang berkualitas.

- Admin : Menambahkan barang(sayur dan buah), mengedit informasi barang, menambahkan gudang, mengedit informasi gudang, menghapus gudang, mengubah proses setiap transaksi mulai dari konfirmasi pembayaran ke pemesanan sedang diproses ke pengiriman.

## Autentikasi

Pada Aplikasi Warung Tani pengguna bisa membuat akun dengan mendaftar dan melakukan login untuk mengambil serta mengautentikasi informasi pengguna  yang telah terdaftar pada database kami.

### CRUD

- User --> C: Buat Akun, R : Lihat informasi akun di profile, U : Edit Informasi Akun diprofile, D : Hapus Akun di profile

- Keranjang --> C : Tambah barang ke dalam keranjang, R : Lihat barang-barang yang telah dimasukkan ke dalam keranjang, U : Edit jumlah barang, D : Hapus barang dari keranjang

- Barang --> C: Tambah barang, R : Barang dapat dicari di aplikasi, U : Edit Informasi barang dapat dilakukan oleh admin, D : Hapus Barang dapat dilakukan oleh admin

- Gudang --> C: Tambah gudang, R : Gudang dapat di cari di aplikasi, U : Edit Informasi gudang dapat dilakukan oleh admin, D : Hapus gudang dapat dilakukan oleh admin
