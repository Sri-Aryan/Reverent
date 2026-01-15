// lib/features/home/presentation/pages/reels_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../../data/repositories/reel_repositories.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reelsAsync = ref.watch(reelsProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: reelsAsync.when(
        data: (reels) {
          _initializeControllers(reels);
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _playVideo(index);
              _pauseOtherVideos(index);
            },
            itemBuilder: (context, index) => ReelItem(
              reel: reels[index],
              controller: _controllers[index],
              isActive: _currentIndex == index,
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stack) => Center(child: Text('Error: $error', style: const TextStyle(color: AppColors.white))),
      ),
    );
  }

  void _initializeControllers(List<Reel> reels) {
    while (_controllers.length < reels.length) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(reels[_controllers.length].videoUrl));
      _controllers.add(controller);
      _initializeVideoController(controller);
    }
  }

  Future<void> _initializeVideoController(VideoPlayerController controller) async {
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(100.0); // Muted autoplay
  }

  void _playVideo(int index) {
    if (index < _controllers.length) {
      _controllers[index].play();
    }
  }

  void _pauseOtherVideos(int activeIndex) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i != activeIndex && i < _controllers.length) {
        _controllers[i].pause();
      }
    }
  }
}

class ReelItem extends StatefulWidget {
  final Reel reel;
  final VideoPlayerController controller;
  final bool isActive;

  const ReelItem({
    super.key,
    required this.reel,
    required this.controller,
    required this.isActive,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !widget.controller.value.isPlaying) {
      widget.controller.play();
    } else if (!widget.isActive) {
      widget.controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Video Player
        widget.controller.value.isInitialized
            ? Center(
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.reel.thumbnailUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Progress Indicator
        if (!widget.controller.value.isInitialized)
          const Center(child: CircularProgressIndicator(color: AppColors.primary)),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),

        // Leader info
        Positioned(
          left: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: widget.reel.profileImageUrl != null
                        ? NetworkImage(widget.reel.profileImageUrl!)
                        : null,
                    backgroundColor: AppColors.primary.withOpacity(0.9),
                    child: widget.reel.profileImageUrl == null
                        ? Text(
                      widget.reel.leaderName[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reel.leaderName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.reel.faith,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.reel.caption,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Action buttons
        Positioned(
          right: 20,
          bottom: 50,
          child: Column(
            children: [
              _ActionButton(
                icon: Icons.favorite,
                count: widget.reel.likes.toString(),
                isActive: false,
              ),
              const SizedBox(height: 32),
              _ActionButton(
                icon: Icons.comment_outlined,
                count: widget.reel.comments.toString(),
              ),
              const SizedBox(height: 32),
              _ActionButton(icon: Icons.share_outlined),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => widget.controller.value.isPlaying
                    ? widget.controller.pause()
                    : widget.controller.play(),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? count;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    this.count,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 32),
        if (count != null) ...[
          const SizedBox(height: 8),
          Text(count!, style: const TextStyle(color: AppColors.white, fontSize: 14)),
        ],
      ],
    );
  }
}

final reelsProvider = FutureProvider<List<Reel>>((ref) async {
  final repo = ref.read(reelRepositoryProvider);
  return repo.getAllReels();
});
