// lib/data/models/models.dart
class Leader {
  final String id;
  final String name;
  final String faith;
  final String bio;
  final bool isFollowing;
  final String? profileImageUrl;

  const Leader({
    required this.id,
    required this.name,
    required this.faith,
    required this.bio,
    this.isFollowing = false,
    this.profileImageUrl,
  });
}

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

  const Post({
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

class Reel {
  final String id;
  final String leaderName;
  final String faith;
  final String caption;
  final String videoUrl;
  final String thumbnailUrl;
  final int likes;
  final int comments;
  final String? profileImageUrl;

  const Reel({
    required this.id,
    required this.leaderName,
    required this.faith,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    this.profileImageUrl
  });
}
