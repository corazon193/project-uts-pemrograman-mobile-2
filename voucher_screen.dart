// lib/voucher_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';
import 'voucher_data.dart';

/// Halaman utama untuk menampilkan daftar voucher.
class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        flexibleSpace: Container(
          // Menggunakan gradient elegan yang sama dengan AppBar Home
          decoration: const BoxDecoration(gradient: Palette.appBarGradient),
        ),
        title: Text('Voucher Saya',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          Text('Voucher yang Tersedia',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Palette.textPrimary)),
          const SizedBox(height: 16),
          // Menampilkan daftar VoucherCard
          ...mockVouchers.map((voucher) => VoucherCard(voucher: voucher)).toList(),
          const SizedBox(height: 80), // Padding bawah agar tidak terpotong BottomMenu
        ],
      ),
    );
  }
}

/// Widget kartu voucher dengan efek Glassmorphism dan animasi sentuhan.
class VoucherCard extends StatefulWidget {
  final Voucher voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    // Animasi scale untuk efek sentuhan (slight press)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          // Aksi ketika voucher diklik (misalnya, salin kode)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Voucher ${widget.voucher.code} berhasil disalin!'),
            duration: const Duration(seconds: 1),
          ));
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            clipBehavior: Clip.antiAlias,
            // Warna latar belakang yang transparan dengan warna voucher
            decoration: BoxDecoration(
              color: widget.voucher.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              // Border tipis dengan warna accent voucher
              border: Border.all(color: widget.voucher.color.withOpacity(0.4), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: widget.voucher.color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                // Efek blur (Glassmorphism)
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Kiri: Diskon & Icon (Area bergradien penuh)
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: widget.voucher.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: widget.voucher.color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.voucher.icon, color: Colors.white, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              widget.voucher.discount,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Kanan: Detail Voucher
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.voucher.title,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Palette.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.voucher.description,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Palette.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Kode Voucher
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.voucher.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'CODE: ${widget.voucher.code}',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: widget.voucher.color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder untuk Keranjang
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: Palette.appBarGradient)),
        title: Text('Keranjang', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Center(child: Text('Daftar Keranjang Anda (Masih Kosong)', style: GoogleFonts.poppins(color: Palette.textSecondary))),
    );
  }
}

// Placeholder untuk Profil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: Palette.appBarGradient)),
        title: Text('Profil Pengguna', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Center(child: Text('Halaman Profil Pengguna (Belum Diimplementasi)', style: GoogleFonts.poppins(color: Palette.textSecondary))),
    );
  }
}