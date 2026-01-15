// lib/features/home/presentation/pages/leader_profile_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';

class LeaderProfileScreen extends StatelessWidget {
  final Leader leader;

  const LeaderProfileScreen({super.key, required this.leader});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with Profile Header
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Profile Image Background
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      child: leader.profileImageUrl != null && leader.profileImageUrl!.isNotEmpty
                          ? Image.network(
                        leader.profileImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                          : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                  // Profile Content Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        // Profile Avatar
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          leader.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Faith Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            leader.faith,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Slivers
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Follow Button Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Toggle follow
                          },
                          icon: Icon(
                            leader.isFollowing ? Icons.check : Icons.add,
                          ),
                          label: Text(leader.isFollowing ? 'Following' : 'Follow'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Open messages
                        },
                        icon: const Icon(Icons.message_outlined),
                        label: const Text(''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bio Section
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    leader.bio,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppColors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    children: [
                      _StatCard('Posts', '127'),
                      const SizedBox(width: 12),
                      _StatCard('Followers', '23.4k'),
                      const SizedBox(width: 12),
                      _StatCard('Following', '45'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tabs Section
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.grey,
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: 'Posts'),
                            Tab(text: 'Reels'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              _PostsTab(leaderId: leader.id),
                              _ReelsTab(leaderId: leader.id),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  final String leaderId;

  const _PostsTab({required this.leaderId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        height: 200,
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _ReelsTab extends StatelessWidget {
  final String leaderId;

  const _ReelsTab({required this.leaderId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
