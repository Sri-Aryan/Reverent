// lib/data/models/leader.dart
class Leader {
  final String id;
  final String name;
  final String faith;
  final String bio;
  final bool isFollowing;

  Leader({
    required this.id,
    required this.name,
    required this.faith,
    required this.bio,
    this.isFollowing = false,
  });
}
