// lib/home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mock_data.dart';
import 'game_card.dart';
import 'game_provider.dart';
import 'bottom_menu.dart';
import 'voucher_screen.dart';

/// Elegant color palette used across the screen
class Palette {
  Palette._();

  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0B1020);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color accent = Color(0xFFF59E0B); // orange-ish
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  final PageController _promoController =
      PageController(viewportFraction: 0.88);
  int _promoIndex = 0;
  Timer? _promoTimer; // auto-scroll timer

  @override
  void initState() {
    super.initState();
    // start auto-scroll after first frame so providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    final games = ref.read(gamesProvider);
    if (games.length <= 1) return; // no need to auto-scroll

    // cancel existing timer if any
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (!_promoController.hasClients) return;
      final next = (_promoIndex + 1) % games.length;
      _promoController.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  void _onFabPressed() => _openQuickTopUp(context);

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gamesProvider);
    final cartCount = ref.watch(cartCountProvider);

    // filter games by search query (client side)
    final filteredGames = _searchQuery.isEmpty
        ? games
        : games
            .where((g) =>
                g.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                g.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final pages = <Widget>[
      _buildHomePage(context, filteredGames, cartCount),
      _buildReelsPage(games),
      const SizedBox.shrink(), // reserved center FAB
      _buildHistoryPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Palette.background,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(129),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildAppBar(context, cartCount),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          _buildCenterFab(onPressed: _onFabPressed, context: context),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, int cartCount) {
    return Container(
      decoration: BoxDecoration(
        gradient: Palette.appBarGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      padding: const EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withOpacity(0.12),
            child: Image.asset(
              'assets/images/gambar1.jpeg',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => const Icon(
                Icons.videogame_asset,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SR TopUp',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const SizedBox(height: 6),
                _buildSearchField(),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Items in cart: $cartCount'))),
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6)
                      ],
                    ),
                    child: Text('$cartCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Material(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
          hintText: 'Cari game atau nominal...',
          hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _buildCenterFab(
      {required VoidCallback onPressed, required BuildContext context}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Palette.accent,
      child: const Icon(Icons.flash_on),
      elevation: 6,
    );
  }

  Widget _buildHomePage(BuildContext context, List<Game> games, int cartCount) {
    return SafeArea(
      key: const ValueKey('home'),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: 140,
                      child: PageView.builder(
                        controller: _promoController,
                        itemCount: games.length,
                        onPageChanged: (i) => setState(() => _promoIndex = i),
                        itemBuilder: (context, index) {
                          final g = games[index];
                          return _promoCard(g);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      games.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _promoIndex == i ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _promoIndex == i
                              ? Palette.indicatorActive
                              : Palette.indicatorInactive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text('Popular Games',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedIndex = 1);
                        },
                        child: Text('Lihat Semua',
                            style: GoogleFonts.poppins(
                                color: Colors.black54, fontSize: 13)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final g = games[index];
                  return GameCard(game: g);
                },
                childCount: games.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.88,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: kBottomNavigationBarHeight +
                  24 +
                  MediaQuery.of(context).viewPadding.bottom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard(Game g) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedGameProvider.notifier).state = g;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _PromoBottomSheet(game: g),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                g.color.withOpacity(0.9),
                Palette.promoAccent.withOpacity(0.9)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6)),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'game-hero-${g.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    g.imagePath,
                    width: 86,
                    height: 86,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) =>
                        const Icon(Icons.videogame_asset, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(g.title,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(g.subtitle,
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('Diskon spesial hari ini!',
                        style: GoogleFonts.poppins(
                            color: Colors.yellowAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReelsPage(List<Game> games) {
    return Container(
      key: const ValueKey('reels'),
      color: Colors.black,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: games.length,
        itemBuilder: (context, index) {
          final g = games[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.grey.shade900]),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'game-hero-${g.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          g.imagePath,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.videogame_asset, size: 120),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(g.title,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Promo top up untuk ${g.title} - Harga spesial!',
                        style: GoogleFonts.poppins(color: Colors.white70),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Positioned(
                right: 18,
                bottom: 120,
                child: Column(
                  children: [
                    _buildReelBtn(
                        icon: Icons.thumb_up_alt_outlined, label: 'Like'),
                    const SizedBox(height: 12),
                    _buildReelBtn(
                        icon: Icons.comment_outlined, label: 'Comment'),
                    const SizedBox(height: 12),
                    _buildReelBtn(icon: Icons.share_outlined, label: 'Share'),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildReelBtn({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration:
              BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryPage() {
    return SafeArea(
      key: const ValueKey('history'),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History Top Up',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, idx) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(Icons.receipt)),
                    title: Text('Top Up #${idx + 1}',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        'Status: Sukses • Rp ${(5000 + idx * 3000).toString()}',
                        style: GoogleFonts.poppins()),
                    trailing: Text('Nov ${10 + idx}',
                        style: GoogleFonts.poppins(color: Colors.black54)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return SafeArea(
      key: const ValueKey('profile'),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 36)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Player123',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Level: 12 • VIP',
                        style: GoogleFonts.poppins(color: Colors.black54)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text('Saldo',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                trailing: Text('Rp 45.000',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text('Settings',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuickTopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quick Top Up',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text('Pilih nominal top up cepat',
                  style: GoogleFonts.poppins(color: Colors.black54)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chipNominal('Rp 5.000'),
                  _chipNominal('Rp 10.000'),
                  _chipNominal('Rp 20.000'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Top Up berhasil (mock)')));
                },
                child: Text('Bayar Sekarang',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _chipNominal(String label) {
    return ChoiceChip(
        label: Text(label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        selected: false,
        onSelected: (_) {});
  }
}

/// Small promo bottom sheet (called from promo card)
class _PromoBottomSheet extends ConsumerWidget {
  final Game game;
  const _PromoBottomSheet({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(
          top: 12,
          left: 18,
          right: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 46,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 12),
          Row(
            children: [
              Hero(
                  tag: 'game-hero-${game.id}',
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: game.color.withOpacity(0.12),
                      child: ClipOval(
                          child: Image.asset(game.imagePath,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.videogame_asset,
                                  color: game.color))))),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(game.title,
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text(game.subtitle,
                        style: GoogleFonts.poppins(color: Colors.grey[600]))
                  ])),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Diskon spesial! Pilih nominal dan lanjutkan ke pembayaran.',
              style: GoogleFonts.poppins(color: Colors.black54)),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: game.priceOptions
                  .map((p) => ElevatedButton(
                      onPressed: () {
                        final cartCount = ref.read(cartCountProvider);
                        ref.read(cartCountProvider.notifier).state =
                            cartCount + 1;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Ditambahkan: ${game.title} - Rp $p')));
                      },
                      child: Text('Rp $p')))
                  .toList()),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
