// lib/mock_data.dart

import 'package:flutter/material.dart';
extension TruncateString on String {
  String truncate(int max, {String omission = '\u2026'}) {
    if (length <= max) return this;
    if (max <= omission.length) return omission;
    return substring(0, max - omission.length) + omission;
  }
}

class Game {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath; // path to local asset
  final Color color;
  final List<int> priceOptions;

  const Game({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.color,
    required this.priceOptions,
  })  : assert(id != ''),
        assert(title != ''),
        assert(subtitle != '');

  /// Convenience getters for UI safety
  String displayTitle({int maxChars = 32}) => title.truncate(maxChars);
  String displaySubtitle({int maxChars = 48}) => subtitle.truncate(maxChars);
}

/// Mock games: Expanded list with various genres
const List<Game> mockGames = [
  // --- MOBA ---
  Game(
    id: 'ml',
    title: 'Mobile Legends',
    subtitle: 'Diamond Top-up',
    imagePath: 'assets/images/ml.png',
    color: Colors.purple,
    priceOptions: [5000, 12500, 25000, 50000, 150000, 500000],
  ),
  Game(
    id: 'hok',
    title: 'Honor of Kings',
    subtitle: 'Tokens Top-up',
    imagePath: 'assets/images/hok.jpeg',
    color: Colors.amber,
    priceOptions: [3000, 10000, 25000, 50000],
  ),
  Game(
    id: 'aov',
    title: 'Arena of Valor',
    subtitle: 'Vouchers',
    imagePath: 'assets/images/aov.jpg',
    color: Colors.deepOrange,
    priceOptions: [5000, 15000, 30000, 100000],
  ),
  Game(
    id: 'wr',
    title: 'LoL: Wild Rift',
    subtitle: 'Wild Cores',
    imagePath: 'assets/images/wildrift.jpg',
    color: Colors.blueAccent,
    priceOptions: [15000, 45000, 75000, 150000],
  ),
  Game(
    id: 'pokemon_unite',
    title: 'Pokémon UNITE',
    subtitle: 'Aeos Gems',
    imagePath: 'assets/images/poke.jpg',
    color: Colors.indigoAccent,
    priceOptions: [15000, 75000, 149000],
  ),

  // --- Battle Royale / FPS ---
  Game(
    id: 'ff',
    title: 'Free Fire',
    subtitle: 'Diamond Top-up',
    imagePath: 'assets/images/ff.jpg',
    color: Colors.orange,
    priceOptions: [10000, 20000, 50000, 100000, 300000],
  ),
  Game(
    id: 'pubg',
    title: 'PUBG Mobile',
    subtitle: 'UC Top-up',
    imagePath: 'assets/images/pubg.jpg',
    color: Colors.black87,
    priceOptions: [10000, 30000, 60000, 120000, 250000],
  ),
  Game(
    id: 'valorant',
    title: 'Valorant',
    subtitle: 'Riot Points',
    imagePath: 'assets/images/valo.jpg',
    color: Colors.redAccent,
    priceOptions: [15000, 50000, 100000, 150000],
  ),
  Game(
    id: 'codm',
    title: 'Call of Duty Mobile',
    subtitle: 'CP Top-up',
    imagePath: 'assets/images/cod.jpg',
    color: Colors.grey,
    priceOptions: [5000, 25000, 50000, 100000],
  ),
  Game(
    id: 'dfg',
    title: 'Delta Force',
    subtitle: 'Top-up',
    imagePath: 'assets/images/df.jpg',
    color: Colors.teal,
    priceOptions: [5000, 15000, 30000],
  ),
  Game(
    id: 'farlight',
    title: 'Farlight 84',
    subtitle: 'Diamonds',
    imagePath: 'assets/images/fairlight.jpg',
    color: Colors.yellow,
    priceOptions: [10000, 30000, 60000],
  ),
  Game(
    id: 'pb',
    title: 'Point Blank',
    subtitle: 'PB Cash',
    imagePath: 'assets/images/pb.jpg',
    color: Colors.red,
    priceOptions: [10000, 20000, 50000, 100000],
  ),
  Game(
    id: 'super_sus',
    title: 'Super Sus',
    subtitle: 'Goldstar',
    imagePath: 'assets/images/supeesus.jpg',
    color: Colors.deepPurple,
    priceOptions: [10000, 25000, 50000],
  ),
  Game(
    id: 'bloodstrike',
    title: 'Blood Strike',
    subtitle: 'Gold',
    imagePath: 'assets/images/bs.png',
    color: Colors.red,
    priceOptions: [15000, 45000, 90000],
  ),

  // --- RPG / Gacha / Open World ---
  Game(
    id: 'genshin',
    title: 'Genshin Impact',
    subtitle: 'Genesis Crystals',
    imagePath: 'assets/images/ghensin.jpg',
    color: Colors.lightBlue,
    priceOptions: [16000, 79000, 249000, 479000, 799000],
  ),
  Game(
    id: 'hsr',
    title: 'Honkai: Star Rail',
    subtitle: 'Oneiric Shards',
    imagePath: 'assets/images/hsr.jpg',
    color: Colors.indigo,
    priceOptions: [16000, 79000, 249000, 479000],
  ),
  Game(
    id: 'zzs',
    title: 'Zenless Zone Zero',
    subtitle: 'Monochromes',
    imagePath: 'assets/images/zzz.jpg',
    color: Colors.grey,
    priceOptions: [16000, 79000, 249000],
  ),
  Game(
    id: 'undawn',
    title: 'Garena Undawn',
    subtitle: 'RC Top-up',
    imagePath: 'assets/images/undawn.jpg',
    color: Colors.brown,
    priceOptions: [5000, 15000, 50000, 100000],
  ),
  Game(
    id: 'ragnarok_origin',
    title: 'Ragnarok Origin',
    subtitle: 'Nyan Berry',
    imagePath: 'assets/images/roo.jpg',
    color: Colors.pinkAccent,
    priceOptions: [15000, 50000, 150000],
  ),
  Game(
    id: 'wuthering',
    title: 'Wuthering Waves',
    subtitle: 'Lunite',
    imagePath: 'assets/images/ww.jpg',
    color: Colors.blueGrey,
    priceOptions: [15000, 75000, 250000],
  ),
  Game(
    id: 'nikke',
    title: 'Goddess of Victory: NIKKE',
    subtitle: 'Gem',
    imagePath: 'assets/images/nikke.jpg',
    color: Colors.redAccent,
    priceOptions: [15000, 75000, 250000],
  ),
  Game(
    id: 'blue_archive',
    title: 'Blue Archive',
    subtitle: 'Pyroxenes',
    imagePath: 'assets/images/bluearchive.jpg',
    color: Colors.cyan,
    priceOptions: [15000, 75000, 150000],
  ),

  // --- Casual / Strategy / Simulator ---
  Game(
    id: 'roblox',
    title: 'Roblox',
    subtitle: 'Robux Instant',
    imagePath: 'assets/images/roblox.jpg',
    color: Colors.red,
    priceOptions: [10000, 25000, 50000, 100000, 250000],
  ),
  Game(
    id: 'stumble',
    title: 'Stumble Guys',
    subtitle: 'Gems & Tokens',
    imagePath: 'assets/images/stumble.jpg',
    color: Colors.lightGreen,
    priceOptions: [10000, 20000, 50000],
  ),
  Game(
    id: 'cc',
    title: 'Clash of Clans',
    subtitle: 'Gems Top-up',
    imagePath: 'assets/images/coc.png',
    color: Colors.orangeAccent,
    priceOptions: [15000, 75000, 149000],
  ),
  Game(
    id: 'cr',
    title: 'Clash Royale',
    subtitle: 'Gems',
    imagePath: 'assets/images/cr.jpg',
    color: Colors.blue,
    priceOptions: [15000, 75000, 149000],
  ),
  Game(
    id: 'bs',
    title: 'Brawl Stars',
    subtitle: 'Gems',
    imagePath: 'assets/images/brawlstars.jpg',
    color: Colors.yellow,
    priceOptions: [15000, 45000, 75000],
  ),
  Game(
    id: 'higgs',
    title: 'Higgs Domino',
    subtitle: 'Koin Emas (MD)',
    imagePath: 'assets/images/higgs.jpg',
    color: Colors.amber,
    priceOptions: [5000, 10000, 30000, 60000],
  ),
  Game(
    id: 'ludo',
    title: 'Ludo King',
    subtitle: 'Coins & Diamonds',
    imagePath: 'assets/images/ludo.jpg',
    color: Colors.blueAccent,
    priceOptions: [5000, 15000, 30000],
  ),

  // --- Sports ---
  Game(
    id: 'efootball',
    title: 'eFootball 2024',
    subtitle: 'myClub Coins',
    imagePath: 'assets/images/pes.jpg',
    color: Colors.blue,
    priceOptions: [15000, 75000, 149000],
  ),
  Game(
    id: 'fifa',
    title: 'FC Mobile',
    subtitle: 'FC Points',
    imagePath: 'assets/images/fifa.jpg',
    color: Colors.tealAccent,
    priceOptions: [15000, 75000, 150000],
  ),
];
