import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_provider.dart';

/// Reusable Bottom Menu + Center FAB for SR TopUp app.
/// This variant adds smooth micro-animations and a frosted glass / elegant look.
class BottomMenu extends ConsumerStatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomMenu({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  ConsumerState<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends ConsumerState<BottomMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      elevation: 8,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left group
                Row(
                  children: [
                    _NavItemAnimated(
                      icon: Icons.home,
                      label: 'Home',
                      index: 0,
                      currentIndex: widget.currentIndex,
                      onTap: widget.onTabSelected,
                    ),
                    const SizedBox(width: 6),
                    _NavItemAnimated(
                      icon: Icons.video_library,
                      label: 'Reels',
                      index: 1,
                      currentIndex: widget.currentIndex,
                      onTap: widget.onTabSelected,
                    ),
                  ],
                ),

                // Right group
                Row(
                  children: [
                    _NavItemAnimated(
                      icon: Icons.history,
                      label: 'History',
                      index: 3,
                      currentIndex: widget.currentIndex,
                      onTap: widget.onTabSelected,
                    ),

                    const SizedBox(width: 6),

                    // Profile with cart badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _NavItemAnimated(
                          icon: Icons.person,
                          label: 'Profile',
                          index: 4,
                          currentIndex: widget.currentIndex,
                          onTap: widget.onTabSelected,
                        ),

                        // Animated cart count badge
                        Positioned(
                          right: -6,
                          top: -8,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, anim) {
                              return ScaleTransition(scale: anim, child: child);
                            },
                            child: cartCount > 0
                                ? Container(
                                    key: const ValueKey('badge_on'),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      cartCount.toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemAnimated extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItemAnimated({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            // Animated icon scale + color gradient when active
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: active ? 1.14 : 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: active
                        ? [const Color(0xFF2E2A72), Colors.deepPurpleAccent]
                        : [Colors.black54, Colors.black54],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, 24, 24));
                },
                blendMode: BlendMode.srcIn,
                child: Icon(icon, size: 22),
              ),
            ),

            // Animated label show/hide
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: active
                    ? Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E2A72),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Center FAB specifically for Top Up quick action. Use together with BottomMenu
class CenterTopUpFab extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label;

  const CenterTopUpFab({
    super.key,
    required this.onPressed,
    this.label,
  });

  @override
  State<CenterTopUpFab> createState() => _CenterTopUpFabState();
}

class _CenterTopUpFabState extends State<CenterTopUpFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1.03).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
      ),
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        elevation: 12,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flash_on, color: Colors.white, size: 22),
              if (widget.label != null) ...[
                const SizedBox(height: 2),
                Text(widget.label!,
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: Colors.white)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

/*
Usage notes:
- Replace your existing bottom_menu.dart with this file (or rename and update imports).
- This version uses a frosted glass BottomAppBar, animated nav items (scale + label enter),
  an animated cart badge, and a pulsing gradient FAB to make the top-up CTA feel premium.
- Keep `google_fonts` and `flutter_riverpod` in your pubspec.
- If you want Lottie for the FAB icon or sound on press, I can add that next.
*/
