// lib/data/repositories/leader_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'mock_data.dart';

final leaderRepositoryProvider = Provider<LeaderRepository>((ref) => LeaderRepository());

class LeaderRepository {
  Future<List<Leader>> getAllLeaders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.leaders;
  }
}
