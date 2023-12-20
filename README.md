# Proyek Akhir Semester F01: LiteraLoka

## Anggota Kelompok F01 
* [Muhammad Hilmy Erryanto](https://github.com/m-hilmy-erryanto) (2206025905)
* [Fernando Valentino Sitinjak](https://github.com/Scarletra) (2206081332)
* [Fathirahma Alyssa Pristanti](https://github.com/alyssapristanti) (2206082215)
* [Chika Marsya Diandra Lumban Gaol](https://github.com/chikamarsyaa) (2206083344)
* [Pradipta Arya Pramudita](https://github.com/Pradiptaa) (2206083685)
* [Leticia Kalila Darlene](https://github.com/leticiakalila) (2206830561)

## Deskripsi Aplikasi Flutter
LiteraLoka merupakan aplikasi yang berfokus kepada penjualan buku untuk dapat memudahkan akses kepada buku-buku yang berkualitas bagi masyarakat Indonesia. Di LiteraLoka, user dapat membeli, menjual, bahkan menulis resensi buku.

## 📁 Daftar dan Pembagian Tugas Modul
Berikut ini fitur-fitur yang tersedia di LiteraLoka:
### 🗃️ Main Page dan Autentikasi - Nando
Homepage adalah modul yang akan menjadi halaman utama aplikasi. Pada halaman ini, akan ditampilkan seluruh dataset buku dan seluruh halaman lainnya akan terintegrasi melalui halaman aplikasi ini. Halaman ini juga akan menerapkan filter.
Autentikasi adalah modul yang menghandle login dan logout user, user juga bisa melakukan registrasi akun pada modul ini.

### 💰 Penjualan Buku User - Chika
Modul ini hanya dapat digunakan oleh user yang sedang login untuk menjual buku mereka ke LiteraLoka. Pada page penjualan buku, user dapat menjual buku dengan cara menginput judul, tahun terbit, dan lainnya pada form pengisian. Pada form ini user juga dapat menginput foto dari buku yang akan dijual. Setelah submit form, buku akan ditampilkan pada dataset penjualan.

### 🛒 Shopping Cart & Checkout - Dipta
Modul ini hanya dapat digunakan oleh user yang sedang login. User dapat membeli buku dengan menambahkan ke shopping cart. Setelah user sudah menentukan buku-bukunya, page shopping cart dapat diteruskan ke page checkout, di mana pada page checkout user diminta untuk mengisi form terkait data pengiriman. Setelah form diisi, buku-buku pada shopping cart akan berpindah ke inventori user untuk diakses. 

### 📃 Wishlist - Alyssa
Modul ini hanya dapat digunakan oleh user yang sedang login. Pada halaman wishlist ini nantinya user dapat memasukkan buku yang ingin mereka minati. Untuk memasukkan buku ke dalam wishlist, akan disediakan form khusus bagi user. Pada form ini nantinya user akan diminta judul buku dan kategori buku. Setelah user mengisi form, buku yang dimasukkan akan otomatis berada di halaman wishlist. Wishlist bersifat personalized untuk masing-masing user yang berbeda.

### ✍️ Resensi - Kalila
Modul ini hanya dapat digunakan oleh user yang sedang login untuk menulis resensi. Modul ini akan menampilkan halaman yang berisi daftar semua buku yang ada di katalog, dimana user dapat membuat resensi mereka terhadap suatu buku dengan mengklik buku spesifik mulai menulis pada form yang telah disiapkan. Resensi yang sudah ditulis user akan terlihat di bagian buku tersebut beserta resensi user-user lainnya.

### 🗣️ Review - Hilmy
Modul ini hanya dapat digunakan oleh user yang sedang login. Modul ini bertujuan untuk menampilkan buku-buku beserta ratingnya dari user. Pada modul ini user dapat memberi rating sekaligus menulis komentar singkat (review) untuk buku tersebut.

## Peran Aplikasi
| Role  | Description |
| ------------- | ------------- |
| User | User disini adalah pengunjung yang punya akun dan sedang login, user bisa menggunakan semua modul kecuali manajemen inventori |
| Guest | Guest adalah pengunjung tanpa akun atau sedang tidak login, guest hanya bisa melihat main page, katalog, halaman review, dan halaman resensi. Guest tidak bisa membeli, menjual, dan mengunggah hal apapun ke website LiteraLoka |

## Alur Pengintegrasian dengan Web Service
* Membuat fungsi baru untuk menerima request dan mengirimkan respon ke aplikasi mobile dengan method GET dan POST.
* Pada flutter aplikasi mobile, menambahkan request ke url fungsi tersebut dan mengolah data yang didapatkan dari hasil request.
* Web service django memberikan response dalam bentuk JSON.
* Melakukan debugging dan memperbaiki apabila ada error atau hal lainnya sampai aplikasi berjalan dengan baik dan memenuhi ketentuan yang diinginkan.

## Tautan Berita Acara
[Tautan Berita Acara](https://docs.google.com/spreadsheets/d/1OgDLNwG6hoevTCDRE_hrmAe9ShIobUsRR0xR4fEhtlg/edit#gid=0)

## Tautan App Center
[![Build status](https://build.appcenter.ms/v0.1/apps/e1e016da-ac13-4b4e-8a39-e5ec20d6f219/branches/main/badge)](https://appcenter.ms)

## Link Download App Center
https://install.appcenter.ms/orgs/f01/apps/literaloka/distribution_groups/public