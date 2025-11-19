# Konsep — Aplikasi Top Up

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
  <img src="https://img.shields.io/badge/platform-Flutter-02569B.svg" alt="Flutter" />
</p>

---

## ✨ Ringkasan Singkat

Konesp adalah **konsep aplikasi top-up** dengan desain premium dan pengalaman pengguna yang halus. Dibangun dengan Flutter, aplikasi ini menonjolkan estetika modern (Poppins), animasi halus, dan komponen interaktif untuk pengalaman pembelian voucher dan top-up yang menyenangkan.

---

## 🌟 Fitur Utama

* **Desain Premium & Modern** — Tipografi *Poppins* (google_fonts), palet warna elegan, dan tata letak yang konsisten untuk nuansa mewah.
* **Splash Screen Animasi** — Efek *breathing* dan gradasi untuk impresi awal yang kuat.
* **Kartu Game Interaktif** — Kartu responsif dengan efek tekan (press down) dan aksi favorite (simulasi visual).
* **Bottom Menu Inovatif** — BottomAppBar bergaya *frosted glass* dengan Floating Action Button (FAB) sebagai CTA utama.
* **State Management Efisien** — Riverpod untuk arsitektur yang mudah diuji dan dipelihara.
* **Halaman Voucher Khusus** — Desain kupon menarik untuk menampilkan detail voucher.
* **Data Mock Lengkap** — Data mock yang siap dipakai untuk demo, UI testing, dan prototype.

---

## ⚙️ Teknologi & Dependencies

Proyek ini dibangun dengan fokus pada performa dan estetika:

* **Flutter** — UI & aplikasi cross-platform
* **flutter_riverpod** — State management
* **google_fonts** — Poppins sebagai font utama

> Daftar paket utama ada di `pubspec.yaml`. Tambahkan paket lain sesuai kebutuhan seperti paket animasi, http client, atau payment SDK.

---

## 🛠 Instalasi & Menjalankan Proyek

**Prasyarat**

* Flutter SDK terpasang (lihat dokumentasi Flutter resmi)
* Editor (VS Code / Android Studio) + plugin Flutter

**Langkah singkat**

```bash
# Clone repository
git clone https://github.com/USERNAME/REPO.git
cd sr_topup

# Install dependencies
flutter pub get

# Siapkan assets (placeholder)
mkdir -p assets/images
# Taruh gambar placeholder di assets/images/ atau sesuaikan mock_data.dart

# Jalankan aplikasi
flutter run
```

> Jika Anda menggunakan path asset lokal pada `pubspec.yaml`, pastikan file/folder `assets/images/` ada. Alternatifnya, ubah `mock_data.dart` untuk menggunakan network images sementara.

---

## 📂 Struktur Proyek

```
lib/
├── main.dart             # Entry point
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   └── voucher_screen.dart
├── components/
│   ├── game_card.dart
│   └── bottom_menu.dart
├── data/
│   ├── mock_data.dart
│   └── voucher_data.dart
├── state/
│   └── game_provider.dart
└── utils/
    └── palette.dart
```

Keterangan singkat: setiap folder berisi komponen UI, model data mock, provider Riverpod, dan utilitas desain seperti palet warna dan gradien.

---

## 🎨 Palet Warna & Tipografi

Palet dirancang untuk nuansa elegan dan profesional:

| Variabel         | Warna (Hex)           | Keterangan                  |
| ---------------- | --------------------- | --------------------------- |
| `background`     | `#F6F7FB`             | Latar bersih                |
| `surface`        | `#FFFFFF`             | Kartu & permukaan utama     |
| `textPrimary`    | `#0B1020`             | Warna teks utama            |
| `accent`         | `#F59E0B`             | Aksen oranye hangat         |
| `promoAccent`    | `#7C3AED`             | Aksen promo/CTA (ungu)      |
| `appBarGradient` | `#0F1724` → `#2E2A72` | Gradien elegan untuk header |

**Tipografi**: Gunakan `Poppins` sebagai font utama (google_fonts) untuk konsistensi dan kesan premium.

---

## 🔧 Konfigurasi Penting

* **Assets**: Sesuaikan `pubspec.yaml` untuk mendaftarkan `assets/images/**`.
* **Mock Data**: `lib/data/mock_data.dart` berisi model `Game` dan daftar harga; ubah untuk menyesuaikan katalog game/voucher.
* **State**: `lib/state/game_provider.dart` berisi contoh penggunaan Riverpod untuk manajemen daftar game dan keranjang/top-up.
* **Payment Webhook**: Ini adalah konsep — integrasikan gateway seperti Midtrans/Xendit/Stripe pada level backend jika diperlukan.

---

## 📸 Screenshot

Letakkan screenshot berkualitas tinggi di `docs/` atau `assets/screenshots/` lalu referensikan di sini:

![Screenshot Home](docs/screenshot-home.png)

---

## 🤝 Kontribusi

Kontribusi sangat disambut — meskipun ini proyek konsep.

1. Fork repository
2. Buat branch fitur: `git checkout -b feature/YourFeature`
3. Commit perubahan: `git commit -m "Add: fitur baru"`
4. Push: `git push origin feature/YourFeature`
5. Buka Pull Request

Buat issue untuk diskusi desain atau fitur baru.

---

## 📝 Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Lihat file `LICENSE` untuk detail.

---

## 💬 Kontak

Dibuat dengan ❤️ oleh **[Nama Anda / Organisasi]** — silakan hubungi untuk kerja sama atau pertanyaan desain.

---

> *Catatan desain*: README ini dibuat agar mencerminkan estetika aplikasi — ringkas, berkelas, dan mudah dinavigasi. Jika ingin versi bahasa Inggris, atau versi yang lebih singkat untuk halaman GitHub, beri tahu saya dan saya akan bantu susun ulang sesuai kebutuhan.
