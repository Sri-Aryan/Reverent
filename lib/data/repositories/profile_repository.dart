// lib/data/repositories/profile_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> completeProfile(String name, String email, String faith) async {
    try {
      // Get current user ID
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Insert or update profile in Supabase
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'name': name,
        'email': email,
        'faith': faith,
        'role': user.userMetadata?['role'] ?? 'worshiper',
        'updated_at': DateTime.now().toIso8601String(),
      });

      print('Profile saved successfully for user: ${user.id}');
    } catch (e) {
      print('Profile save error: $e');
      rethrow;
    }
  }

  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      return Profile.fromJson(response);
    } catch (e) {
      print('Profile fetch error: $e');
      return null;
    }
  }

  Future<bool> isProfileComplete(String userId) async {
    final profile = await getProfile(userId);
    return profile != null && profile.name.isNotEmpty;
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
