// lib/data/repositories/reel_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'mock_data.dart';

final reelRepositoryProvider = Provider<ReelRepository>((ref) => ReelRepository());

class ReelRepository {
  Future<List<Reel>> getAllReels() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.reels;
  }
}
