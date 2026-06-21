import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<PostVideoPlayer> createState() =>
      _PostVideoPlayerState();
}

class _PostVideoPlayerState
    extends State<PostVideoPlayer> {
  VideoPlayerController? _controller;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller =
      VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await controller.initialize();
      await controller.setLooping(false);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Load post video error: $e');

      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải video';
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePlay() async {
    final controller = _controller;

    if (controller == null) return;

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _controller == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam_off_outlined,
                size: 42,
              ),
              SizedBox(height: 8),
              Text('Không thể phát video'),
            ],
          ),
        ),
      );
    }

    final controller = _controller!;

    final aspectRatio =
    controller.value.aspectRatio == 0
        ? 16 / 9
        : controller.value.aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _togglePlay,
                child: Container(
                  color: controller.value.isPlaying
                      ? Colors.transparent
                      : Colors.black26,
                  alignment: Alignment.center,
                  child: controller.value.isPlaying
                      ? null
                      : const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 62,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}