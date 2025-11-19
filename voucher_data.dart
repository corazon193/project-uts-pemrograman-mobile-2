// lib/voucher_data.dart

import 'package:flutter/material.dart';

class Voucher {
  final String code;
  final String title;
  final String description;
  final String discount;
  final Color color;
  final IconData icon;

  const Voucher({
    required this.code,
    required this.title,
    required this.description,
    required this.discount,
    required this.color,
    required this.icon,
  });
}

// Data mock voucher
const List<Voucher> mockVouchers = [
  Voucher(
    code: 'SR-WEL-50K',
    title: 'Welcome Bonus',
    description: 'Diskon spesial untuk transaksi pertama Anda di game apa pun.',
    discount: 'Rp 50.000',
    color: Color(0xFF7C3AED), // Ungu (Promo Accent)
    icon: Icons.local_activity_rounded,
  ),
  Voucher(
    code: 'SR-ML-15P',
    title: 'Top Up MLBB Hemat',
    description: 'Diskon 15% untuk semua diamond Mobile Legends. Buruan sebelum habis!',
    discount: '15% OFF',
    color: Color(0xFFF59E0B), // Oranye (Accent)
    icon: Icons.diamond_rounded,
  ),
  Voucher(
    code: 'SR-HBD-FRE',
    title: 'Voucher Ulang Tahun',
    description: 'Selamat ulang tahun! Nikmati top up GRATIS hingga Rp 25.000 khusus hari ini.',
    discount: 'GRATIS',
    color: Color(0xFF0F172A), // Biru gelap (Dark)
    icon: Icons.cake_rounded,
  ),
];