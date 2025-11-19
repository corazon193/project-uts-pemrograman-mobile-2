import 'dart:ui'; // for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mock_data.dart';
import 'game_provider.dart';
import 'palette.dart'; 
class GameCard extends ConsumerStatefulWidget {
  final Game game;

  const GameCard({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  ConsumerState<GameCard> createState() => _GameCardState();
}

class _GameCardState extends ConsumerState<GameCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _favorited = false;
  late final AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _openTopupSheet() {
    ref.read(selectedGameProvider.notifier).state = widget.game;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => TopUpSheet(game: widget.game),
    );
  }

  String _minPrice() {
    if (widget.game.priceOptions.isEmpty) return '-';
    final minP = widget.game.priceOptions.reduce((a, b) => a < b ? a : b);
    return 'Rp ${_formatCurrency(minP)}';
  }

  String _formatCurrency(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _openTopupSheet();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        margin: const EdgeInsets.all(8),
        // Constrain max width so card won't become huge on tablets
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.surface.withOpacity(0.98),
              Palette.muted.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 2,
              spreadRadius: -4,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _openTopupSheet,
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: _PreviewDialog(game: game),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              // Use IntrinsicHeight + mainAxisSize.min to avoid unbounded expansion
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top area: icon + badges
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Hero(
                          tag: 'game-hero-${game.id}',
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: game.color.withOpacity(0.14),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(34),
                              child: Image.asset(
                                game.imagePath,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.videogame_asset,
                                        color: game.color),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -6,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: IconButton(
                              key: ValueKey(_favorited),
                              onPressed: () => setState(() {
                                _favorited = !_favorited;
                                if (_favorited) {
                                  _shineController.forward(from: 0.0);
                                }
                              }),
                              icon: _favorited
                                  ? const Icon(Icons.favorite,
                                      color: Colors.redAccent)
                                  : const Icon(Icons.favorite_border,
                                      color: Colors.grey),
                              tooltip: 'Favorite',
                              splashRadius: 20,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -8,
                          top: -8,
                          child: _buildRibbon(game),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title & subtitle (clamp long text)
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Palette.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      game.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          color: Palette.textSecondary, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_minPrice(),
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Palette.textPrimary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                              '${widget.game.priceOptions.length} option',
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: Palette.textSecondary)),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Actions: keep buttons compact to avoid overflow
                    Row(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Palette.accent,
                                Palette.promoAccent
                              ]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Palette.accent.withOpacity(0.28),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6))
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                textStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700),
                              ),
                              onPressed: _openTopupSheet,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.flash_on, size: 18),
                                    SizedBox(width: 8),
                                    Text('Top Up'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRibbon(Game g) {
    final isBest = g.priceOptions.any((p) => p >= 50000);
    final isHot = !isBest && g.priceOptions.length >= 3;

    if (!isBest && !isHot) return const SizedBox.shrink();

    final label = isBest ? 'Best Value' : 'Hot';
    final color = isBest ? Colors.deepOrange : Colors.redAccent;

    return Transform.rotate(
      angle: -0.35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ==========================================================
//                     TOP UP SHEET (UPGRADED) - FIXED
// ==========================================================

class TopUpSheet extends ConsumerStatefulWidget {
  final Game game;

  const TopUpSheet({Key? key, required this.game}) : super(key: key);

  @override
  ConsumerState<TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends ConsumerState<TopUpSheet> {
  int? _selectedPrice;
  int _qty = 1;

  String _formatCurrency(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  void initState() {
    super.initState();
    if (widget.game.priceOptions.isNotEmpty)
      _selectedPrice = widget.game.priceOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);

    final total = (_selectedPrice ?? 0) * _qty;

    // Wrap with SafeArea + SingleChildScrollView to avoid overflow when keyboard shows
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(
              top: 12,
              left: 18,
              right: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 18),
          decoration: BoxDecoration(
              color: Palette.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 46,
                    height: 6,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6))),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                      radius: 26,
                      backgroundColor: widget.game.color.withOpacity(0.12),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Image.asset(widget.game.imagePath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.videogame_asset,
                                  color: widget.game.color)))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.game.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(widget.game.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 14),
              Text('Pilih nominal',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              // Price chips: keep wrapped and allow them to flow vertically
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.game.priceOptions.map((p) {
                  final selected = p == _selectedPrice;
                  return ChoiceChip(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6),
                      child: Text('Rp ${_formatCurrency(p)}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? Colors.white
                                  : Palette.textPrimary)),
                    ),
                    selected: selected,
                    selectedColor: Palette.accent,
                    backgroundColor: Palette.muted,
                    onSelected: (_) => setState(() => _selectedPrice = p),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jumlah',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => setState(() {
                                if (_qty > 1) _qty--;
                              }),
                          icon: const Icon(Icons.remove_circle_outline)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Palette.muted,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('$_qty',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                          onPressed: () => setState(() => _qty++),
                          icon: const Icon(Icons.add_circle_outline)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text('Batal',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Palette.accent, Palette.promoAccent]),
                          borderRadius: BorderRadius.circular(10)),
                      child: ElevatedButton(
                        onPressed: (_selectedPrice == null)
                            ? null
                            : () {
                                final cart = ref.read(cartCountProvider);
                                ref.read(cartCountProvider.notifier).state =
                                    cart + _qty;
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Ditambahkan (${_qty}x) ${widget.game.title} • Rp ${_formatCurrency(total)}')));
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                              _selectedPrice == null
                                  ? 'Pilih nominal'
                                  : 'Tambah ke keranjang • Rp ${_formatCurrency(total)}',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Items in cart: $cartCount',
                  style: GoogleFonts.poppins(color: Palette.textSecondary)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// Small preview dialog used on long-press (fixed to avoid overflow)
class _PreviewDialog extends StatelessWidget {
  final Game game;
  const _PreviewDialog({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.92;
    final maxHeight = MediaQuery.of(context).size.height * 0.86;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: width,
          constraints: BoxConstraints(maxHeight: maxHeight),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                    tag: 'game-hero-${game.id}',
                    child: Image.asset(game.imagePath,
                        width: width * 0.9,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.videogame_asset, size: 80))),
                const SizedBox(height: 12),
                Text(game.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 6),
                Text(game.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.black54)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => TopUpSheet(game: game));
                        },
                        child: const Text('Top Up'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
