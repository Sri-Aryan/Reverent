
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/repositories/profile_repository.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.read(profileRepositoryProvider));
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState.initial());

  Future<void> completeProfile({
    required String name,
    required String email,
    required String faith,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.completeProfile(name, email, faith);
      state = ProfileState.completed();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final profile = await _repository.getProfile(user.id);
        if (profile != null) {
          state = ProfileState.loaded(profile: profile);
        } else {
          state = ProfileState.initial();
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> checkProfileComplete() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    return await _repository.isProfileComplete(user.id);
  }
}

class ProfileState {
  final bool isCompleted;
  final bool isLoading;
  final String? error;
  final Profile? profile;

  ProfileState({
    required this.isCompleted,
    required this.isLoading,
    this.error,
    this.profile,
  });

  factory ProfileState.initial() =>
      ProfileState(isCompleted: false, isLoading: false);

  factory ProfileState.completed() =>
      ProfileState(isCompleted: true, isLoading: false);

  factory ProfileState.loaded({required Profile profile}) =>
      ProfileState(isCompleted: true, isLoading: false, profile: profile);

  ProfileState copyWith({
    bool? isCompleted,
    bool? isLoading,
    String? error,
    Profile? profile,
  }) {
    return ProfileState(
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      profile: profile ?? this.profile,
    );
  }
}
