// lib/data/repositories/post_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'mock_data.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => PostRepository());

class PostRepository {
  Future<List<Post>> getAllPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.posts;
  }
}
