// Update lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/models.dart';
import '../../../../data/repositories/leader_repositories.dart';
import '../../../../data/repositories/post_repositiories.dart';
import '../../../../data/repositories/reel_repositories.dart';

final allPostsProvider = FutureProvider<List<Post>>((ref) async {
  final repo = ref.read(postRepositoryProvider);
  return repo.getAllPosts();
});

final leadersProvider = FutureProvider<List<Leader>>((ref) async {
  final repo = ref.read(leaderRepositoryProvider);
  return repo.getAllLeaders();
});

final reelsProvider = FutureProvider<List<Reel>>((ref) async {
  final repo = ref.read(reelRepositoryProvider);
  return repo.getAllReels();
});
