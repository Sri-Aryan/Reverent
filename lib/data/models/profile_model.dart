// lib/data/models/profile_model.dart
class Profile {
  final String id;
  final String name;
  final String email;
  final String faith;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.faith,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      faith: json['faith'] ?? '',
      role: json['role'] ?? 'worshiper',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'faith': faith,
      'role': role,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
