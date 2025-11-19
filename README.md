SR TopUp - Aplikasi Top Up Game Premium (Konsep Flutter)

SR TopUp adalah sebuah konsep aplikasi mobile (dibuat dengan Flutter) yang dirancang untuk menyediakan layanan top-up mata uang dalam game (Diamond, UC, Koin, dll.) dengan antarmuka pengguna yang modern, elegan, dan berfokus pada pengalaman pengguna (UX) yang mulus.

Proyek ini adalah demonstrasi fungsionalitas utama seperti tampilan beranda, kartu game interaktif, penggunaan state management dengan Riverpod, dan tampilan khusus untuk Voucher.

🌟 Fitur Utama

Desain Premium & Modern: Menggunakan palet warna yang elegan dan tipografi yang konsisten (google_fonts - Poppins) untuk memberikan nuansa premium.

Splash Screen Animasi: Splash screen yang menarik dengan efek visual halus (breathing dan gradasi) untuk kesan awal yang baik.

Kartu Game Interaktif: Kartu game responsif yang dilengkapi dengan efek tekanan (press down) dan fitur favorite (simulasi).

Bottom Menu Inovatif: Menggunakan BottomAppBar dengan desain frosted glass dan Floating Action Button (FAB) yang menonjol untuk CTA utama (Call To Action).

State Management Efisien: Menggunakan Flutter Riverpod untuk manajemen status yang sederhana dan mudah diuji.

Halaman Voucher Khusus: Antarmuka khusus untuk menampilkan voucher dengan desain kupon yang menarik.

Data Mock Lengkap: Menggunakan data mock yang lengkap untuk berbagai jenis game dan opsi harga.

⚙️ Teknologi & Dependencies

Proyek ini dibangun menggunakan Flutter dan memanfaatkan beberapa paket penting:

Paket

Deskripsi

flutter_riverpod

State management yang kuat dan reaktif.

google_fonts

Memastikan tipografi yang konsisten dan menarik (Poppins).

🛠 Instalasi & Menjalankan Proyek

Untuk menjalankan proyek ini di lingkungan pengembangan Anda, ikuti langkah-langkah berikut:

Prasyarat

Flutter SDK terinstal.

Editor kode (VS Code atau Android Studio) dengan plugin Flutter.

Langkah-langkah

Clone repositori:

git clone [https://theengravedgifts.com/products/repo-dane-12inch-black](https://theengravedgifts.com/products/repo-dane-12inch-black)
cd sr_topup


Instal dependencies:

flutter pub get


Tambahkan asset (simulasi):
Karena proyek ini menggunakan path asset lokal (assets/images/*.png), Anda perlu membuat direktori dan menempatkan gambar placeholder di dalamnya, atau memodifikasi mock_data.dart.

# Buat direktori assets
mkdir -p assets/images
# Tempatkan gambar placeholder di sini, atau hapus baris asset dari pubspec.yaml


(Catatan: Dalam konsep ini, path gambar adalah placeholder dan diasumsikan ada. Anda mungkin perlu menyesuaikan pubspec.yaml atau mock_data.dart.)

Jalankan aplikasi:

flutter run


Aplikasi akan berjalan di emulator, simulator, atau perangkat fisik yang terhubung.

📂 Struktur Proyek

Struktur folder utama proyek adalah sebagai berikut:

lib/
├── main.dart             # Titik masuk aplikasi
├── screens/
│   ├── splash_screen.dart    # Tampilan awal yang menarik
│   ├── home_screen.dart      # Tampilan utama daftar game dan TopUp Sheet
│   └── voucher_screen.dart   # Tampilan daftar voucher & placeholder screen lainnya
├── components/
│   ├── game_card.dart        # Komponen kartu game interaktif
│   └── bottom_menu.dart      # Komponen navigasi bawah (Frosted Glass FAB)
├── data/
│   ├── mock_data.dart        # Definisi model Game dan data mock
│   └── voucher_data.dart     # Definisi model Voucher dan data mock
├── state/
│   └── game_provider.dart    # Implementasi Riverpod untuk state management (Game & Keranjang)
└── utils/
    └── palette.dart      # Definisi palet warna dan gradien yang digunakan


🎨 Palet Warna Utama

Variabel

Warna (Hex)

Deskripsi

background

#F6F7FB

Latar belakang keseluruhan yang bersih.

surface

#FFFFFF

Permukaan kartu dan elemen utama.

textPrimary

#0B1020

Teks utama.

accent

#F59E0B

Warna aksen utama (oranye).

promoAccent

#7C3AED

Warna aksen untuk promo/CTA (ungu).

appBarGradient

#0F1724 -> #2E2A72

Gradien elegan untuk AppBar.

🤝 Kontribusi

Proyek ini adalah konsep demo. Saran dan kontribusi disambut baik!

Fork repositori ini.

Buat branch baru (git checkout -b feature/AmazingFeature).

Lakukan commit perubahan Anda (git commit -m 'Add some AmazingFeature').

Push ke branch (git push origin feature/AmazingFeature).

Buka Pull Request.

📄 Lisensi

Didistribusikan di bawah Lisensi MIT. Lihat LICENSE untuk informasi lebih lanjut.

Dibuat dengan ❤️ oleh [Nama Anda/Organisasi Anda]
