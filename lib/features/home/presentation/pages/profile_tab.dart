// lib/features/home/presentation/pages/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userEmail = authState.user?.email ?? 'User';
    final userRole = authState.user?.userMetadata?['role'] ?? 'worshiper';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 100,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // User Info
                Text(
                  userEmail.split('@')[0], // Display name from email
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userRole == 'religious_leader' ? 'Religious Leader' : 'Worshiper',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Stats Row
                Row(
                  children: [
                    Expanded(child: _StatItem('Posts', '12')),
                    Expanded(child: _StatItem('Following', '5')),
                    Expanded(child: _StatItem('Followers', '23')),
                  ],
                ),
                const SizedBox(height: 32),

                // Profile Actions
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/profile-setup');
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await ref.read(authProvider.notifier).signOut();

                          if (context.mounted) {
                            context.go('/auth/role-selection');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sign out failed: $e'),
                                backgroundColor: Colors.red.shade400,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.exit_to_app_outlined),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
