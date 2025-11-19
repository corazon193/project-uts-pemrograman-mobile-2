// lib/palette.dart
import 'package:flutter/material.dart';

class Palette {
  Palette._();

  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0B1020);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color accent = Color(0xFFF59E0B);
  static const Color muted = Color(0xFFE6E9F2);

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF0F1724), Color(0xFF2E2A72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color promoAccent = Color(0xFF7C3AED);
  static const Color indicatorActive = accent;
  static final Color indicatorInactive = Colors.grey.shade300;
}
