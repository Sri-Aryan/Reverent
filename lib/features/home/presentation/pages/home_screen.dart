// lib/features/home/presentation/pages/home_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reverent/features/auth/presentation/providers/auth_provider.dart';
import 'package:reverent/features/home/presentation/pages/profile_tab.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../providers/home_provider.dart';
import 'leaders_screen.dart';
import 'reels_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final pages = [
    const HomeTab(),
    const LeadersScreen(),
    const ReelsScreen(),
    ProfileTab(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(_currentIndex, _onItemTapped),
    );
  }

  Widget _buildBottomNavigationBar(int currentIndex, Function(int) onTap) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.black.withOpacity(0.4),
              selectedFontSize: 12,
              unselectedFontSize: 11,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.black.withOpacity(0.5),
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.home_outlined, 0, currentIndex),
                  activeIcon: _buildActiveNavIcon(Icons.home_rounded, 0, currentIndex),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.people_outline_rounded, 1, currentIndex),
                  activeIcon: _buildActiveNavIcon(Icons.people_rounded, 1, currentIndex),
                  label: 'Leaders',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.play_circle_outline_rounded, 2, currentIndex),
                  activeIcon: _buildActiveNavIcon(Icons.play_circle_rounded, 2, currentIndex),
                  label: 'Reels',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.person_outline_rounded, 3, currentIndex),
                  activeIcon: _buildActiveNavIcon(Icons.person_rounded, 3, currentIndex),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, int currentIndex) {
    final isActive = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: isActive ? AppColors.primary : Colors.black.withOpacity(0.4),
      ),
    );
  }

  Widget _buildActiveNavIcon(IconData icon, int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 26,
        color: AppColors.primary,
      ),
    );
  }
}

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(allPostsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey,
            tabs: [
              Tab(text: 'Explore'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPostsList(postsAsync, 'Explore all leaders', ref),
            _buildPostsList(postsAsync, 'Follow some leaders to see content', ref),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(AsyncValue<List<Post>> postsAsync, String emptyText, WidgetRef ref) {
    return postsAsync.when(
      data: (posts) => posts.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.content_copy, size: 64, color: AppColors.grey),
              const SizedBox(height: 16),
              Text(emptyText,
                  //style: Theme.of(context).textTheme.bodyLarge?.copyWith(color:AppColors.grey)
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: () => ref.refresh(allPostsProvider.future),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    post.leaderName[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.leaderName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(post.faith, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Divider(height: 1, color: Colors.grey,),
            if (post.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(post.imageUrl, height: 200,width: 500, fit: BoxFit.fill),
              ),
            ],
            const SizedBox(height: 12),
            Text(post.caption, style: Theme.of(context).textTheme.bodyLarge),

            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(icon: Icons.favorite_border_outlined, label: '${post.likes}'),
                _ActionButton(icon: Icons.comment_outlined, label: '${post.comments}'),
                _ActionButton(icon: Icons.bookmark_border, label: '${post.saves}'),
                const Spacer(),
                _ActionButton(icon: Icons.share_outlined, label: 'Share'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.grey),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey)),
        ],
      ),
    );
  }
}
