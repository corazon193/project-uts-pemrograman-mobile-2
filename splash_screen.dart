// lib/splash_screen.dart
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainCtrl;
  late final AnimationController _breatheCtrl;

  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _contentFadeAnim;

  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    // 1. Controller Utama (One-shot untuk entrance)
    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Durasi masuk lebih lambat
    );

    // 2. Controller untuk efek "Bernafas" (Looping sangat lambat)
    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    // Animasi Skala: Tidak memantul, tapi "mendarat" dengan lembut (Zoom In halus)
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _mainCtrl, curve: Curves.easeOutQuart),
    );

    // Animasi Opasitas Logo
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Animasi Opasitas Teks (Muncul sedikit setelah logo)
    _contentFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Jalankan animasi
    _mainCtrl.forward();

    // Timer Navigasi
    _navTimer = Timer(const Duration(milliseconds: 3500), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 800), // Transisi page lebih halus
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _mainCtrl.dispose();
    _breatheCtrl.dispose();
    super.dispose();
  }

  // Efek "Bokeh" Background (Bulatan besar blur yang bergerak sangat lambat)
  Widget _buildBokeh(int index, Color color, double size) {
    return AnimatedBuilder(
      animation: _breatheCtrl,
      builder: (context, child) {
        // Pergerakan sangat halus berdasarkan waktu
        final t = _breatheCtrl.value;
        final seed = index * 100;

        // Gerakan sinusoidal yang sangat lambat
        final dx = sin((t + seed) * 0.5) * 20;
        final dy = cos((t + seed) * 0.3) * 20;

        return Positioned(
          left: (index * 80.0) + dx + (index % 2 == 0 ? 20 : 200),
          top: (index * 120.0) + dy + 50,
          child: Opacity(
            opacity: 0.15 + (0.1 * sin(t * pi)), // Opasitas berdenyut pelan
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color,
                    blurRadius: 60, // Blur radius sangat besar untuk efek bokeh
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020), // Warna dasar gelap solid
      body: Stack(
        children: [
          // 1. Background Gradient Statis (Elegan)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E1B4B), // Indigo gelap
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          // 2. Efek Bokeh (Atmosphere) - Pengganti partikel cepat
          _buildBokeh(1, Colors.blueAccent, 200),
          _buildBokeh(2, Colors.purpleAccent, 150),
          Positioned(
              bottom: -50,
              right: -50,
              child: _buildBokeh(3, Colors.indigoAccent, 300)),

          // 3. Vignette halus
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Center Content
          Center(
            child: AnimatedBuilder(
              animation: _mainCtrl,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: GestureDetector(
                      onTap: _navigateToHome, // Tap to skip
                      child: Container(
                        width: 320, // Sedikit lebih lebar
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 40),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.03), // Sangat transparan
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo dengan efek "Bernafas" halus (Glow)
                            AnimatedBuilder(
                              animation: _breatheCtrl,
                              builder: (context, child) {
                                final glow = _breatheCtrl.value;
                                return Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.indigo
                                            .withOpacity(0.15 + (glow * 0.1)),
                                        blurRadius: 30 + (glow * 10),
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.05),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/gambar1.jpeg',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons
                                                .videogame_asset_outlined, // Icon outline lebih elegan
                                            size: 40,
                                            color: Colors.white70,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // Teks dengan Fade terpisah
                            FadeTransition(
                              opacity: _contentFadeAnim,
                              child: Column(
                                children: [
                                  Text(
                                    'SR TopUp',
                                    style: GoogleFonts.outfit(
                                      // Menggunakan font modern & bersih
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Premium Game Store', // Tagline lebih simple
                                    style: GoogleFonts.outfit(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Loading Indicator Minimalis
                                  SizedBox(
                                    width: 120,
                                    height: 2, // Garis sangat tipis
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.1),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white.withOpacity(0.5),
                                        ),
                                        minHeight: 2,
                                      ),
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
                );
              },
            ),
          ),

          // 5. Copyright Footer (Minimalis)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _contentFadeAnim,
              child: Center(
                child: Text(
                  'v1.0.0',
                  style: GoogleFonts.outfit(
                      color: Colors.white24, fontSize: 10, letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
