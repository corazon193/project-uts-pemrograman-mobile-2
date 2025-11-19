// lib/game_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_data.dart';

// Provider untuk daftar game (mock)
final gamesProvider = Provider<List<Game>>((ref) => mockGames);

// Provider untuk game yang dipilih (null jika tidak ada)
final selectedGameProvider = StateProvider<Game?>((ref) => null);

// Contoh StateProvider untuk jumlah item keranjang (mock)
final cartCountProvider = StateProvider<int>((ref) => 0);
