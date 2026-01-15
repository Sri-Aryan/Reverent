// lib/data/models/post.dart
class Post {
  final String id;
  final String leaderId;
  final String leaderName;
  final String faith;
  final String caption;
  final String imageUrl;
  final int likes;
  final int comments;
  final int saves;

  Post({
    required this.id,
    required this.leaderId,
    required this.leaderName,
    required this.faith,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.saves,
  });
}
