
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(supabaseServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabaseService;

  AuthNotifier(this._supabaseService) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    final user = _supabaseService.currentUser;
    if (user != null) {
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    }

    _supabaseService.authStateChanges.listen((authState) {
      final user = authState.session?.user;
      state = AuthState(
        user: user,
        isAuthenticated: user != null,
        isLoading: false,
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _supabaseService.signInWithEmail(
        email: email,
        password: password,
      );

      state = AuthState(
        user: response.user,
        isAuthenticated: response.user != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _supabaseService.signUpWithEmail(
        email: email,
        password: password,
        role: role,
      );

      state = AuthState(
        user: response.user,
        isAuthenticated: response.user != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _supabaseService.signOut();
      state = AuthState.initial();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;

  AuthState({
    this.user,
    required this.isAuthenticated,
    required this.isLoading,
  });

  factory AuthState.initial() {
    return AuthState(
      user: null,
      isAuthenticated: false,
      isLoading: false,
    );
  }

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
