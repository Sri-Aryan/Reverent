// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/profile/presentation/pages/profile_setup_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../services/supabase_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = supabaseService.currentUser != null;
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuth = state.matchedLocation.startsWith('/auth');

      if (isOnSplash) {
        return null;
      }

      if (!isAuthenticated && !isOnAuth) {
        return '/auth/role-selection';
      }

      if (isAuthenticated && isOnAuth) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/auth/role-selection',
        pageBuilder: (context, state) => _buildSlideTransition(
          state,
          const RoleSelectionPage(),
        ),
      ),
      GoRoute(
        path: '/auth/login',
        pageBuilder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'worshiper';
          return _buildSlideTransition(
            state,
            LoginPage(role: role),
          );
        },
      ),
      GoRoute(
        path: '/auth/register',
        pageBuilder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'worshiper';
          return _buildSlideTransition(
            state,
            RegisterPage(role: role),
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _buildSlideTransition(
          state,
          const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/profile-setup',
        pageBuilder: (context, state) => _buildSlideTransition(state, const ProfileSetupPage()),
      ),
    ],
  );
});

CustomTransitionPage _buildSlideTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
