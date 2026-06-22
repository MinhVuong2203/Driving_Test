import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/repository/simulation_situation_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/features/simulation/screens/simulation_history_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimulationPlayerScreen extends StatefulWidget {
  final SimulationSituation situation;
  final List<SimulationSituation> situations;
  final int initialIndex;

  const SimulationPlayerScreen({
    super.key,
    required this.situation,
    this.situations = const [],
    this.initialIndex = 0,
  });

  @override
  State<SimulationPlayerScreen> createState() => _SimulationPlayerScreenState();
}

class _SimulationPlayerScreenState extends State<SimulationPlayerScreen> {
  final _repository = SimulationSituationRepository.remote();

  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;
  late Future<SimulationProgressSummary?> _progressFuture;
  late int _currentIndex;
  late List<SimulationSituation> _situations;

  double? _flagSecond;
  int? _score;

  SimulationSituation get _situation => _situations[_currentIndex];
  bool get _hasFlagged => _flagSecond != null && _score != null;
  bool get _canGoPrevious => _currentIndex > 0;
  bool get _canGoNext => _currentIndex < _situations.length - 1;

  String _formatPlaybackTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _situations = widget.situations.isEmpty
        ? [widget.situation]
        : List<SimulationSituation>.from(widget.situations);
    _currentIndex = widget.initialIndex
        .clamp(0, _situations.length - 1)
        .toInt();
    _progressFuture = _repository.getProgress(_situation.id);
    _createController();
  }

  void _createController() {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_situation.videoUrl),
    );
    _controller = controller;
    _initializeFuture = controller.initialize().then((_) {
      if (!mounted || _controller != controller) return;
      setState(() {});
      controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_controller.value.isInitialized) return;

    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  Future<void> _flagSituation() async {
    if (_hasFlagged || !_controller.value.isInitialized) return;

    final second = _controller.value.position.inMilliseconds / 1000.0;
    final score = _situation.scoreFor(second);
    await _controller.pause();

    if (!mounted) return;
    setState(() {
      _flagSecond = second;
      _score = score;
    });

    try {
      await _repository.recordPracticeAttempt(
        situation: _situation,
        score: score,
        flagSecond: second,
      );
      if (!mounted) return;
      setState(() {
        _progressFuture = _repository.getProgress(_situation.id);
      });
    } catch (_) {
      // Practice scoring must stay usable even if local history cannot be saved.
    }
  }

  Future<void> _replay() async {
    if (!_controller.value.isInitialized) return;

    await _controller.seekTo(Duration.zero);
    await _controller.play();
    if (!mounted) return;
    setState(() {
      _flagSecond = null;
      _score = null;
    });
  }

  Future<void> _goToIndex(int index) async {
    if (index < 0 || index >= _situations.length || index == _currentIndex) {
      return;
    }

    final oldController = _controller;
    setState(() {
      _currentIndex = index;
      _flagSecond = null;
      _score = null;
      _progressFuture = _repository.getProgress(_situation.id);
      _createController();
    });
    await oldController.dispose();
  }

  Future<void> _retry() async {
    final oldController = _controller;
    setState(() {
      _flagSecond = null;
      _score = null;
      _progressFuture = _repository.getProgress(_situation.id);
      _createController();
    });
    await oldController.dispose();
  }

  void _openCurrentHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimulationHistoryScreen(
          situation: _situation,
          situations: _situations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(_situation.displayTitle)),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _VideoErrorState(onRetry: _retry);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              GestureDetector(
                onTap: _togglePlay,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_controller),
                        if (!_controller.value.isPlaying)
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.42),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary,
                  bufferedColor: Color(0xFF93C5FD),
                ),
              ),
              const SizedBox(height: 6),
              if (_hasFlagged) ...[
                _ScoreTimelineGuide(situation: _situation, isDark: isDark),
                const SizedBox(height: 6),
              ],
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatPlaybackTime(value.position),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _formatPlaybackTime(value.duration),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _ResultPanel(
                situation: _situation,
                flagSecond: _flagSecond,
                score: _score,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _ScoreScale(score: _score, isDark: isDark),
              const SizedBox(height: 12),
              FutureBuilder<SimulationProgressSummary?>(
                future: _progressFuture,
                builder: (context, snapshot) {
                  return _ProgressPanel(
                    progress: snapshot.data,
                    isDark: isDark,
                    onOpenHistory: _openCurrentHistory,
                  );
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _canGoPrevious
                              ? () => _goToIndex(_currentIndex - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                          label: const Text('Trước'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _canGoNext
                              ? () => _goToIndex(_currentIndex + 1)
                              : null,
                          icon: const Icon(Icons.chevron_right_rounded),
                          iconAlignment: IconAlignment.end,
                          label: const Text('Tiếp'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _replay,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Làm lại'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: _hasFlagged ? null : _flagSituation,
                icon: const Icon(Icons.flag_rounded),
                label: Text(
                  _hasFlagged ? 'Đã gắn cờ tình huống' : 'Gắn cờ tình huống',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScoreTimelineGuide extends StatelessWidget {
  final SimulationSituation situation;
  final bool isDark;

  const _ScoreTimelineGuide({required this.situation, required this.isDark});

  Color _scoreColor(int score) {
    switch (score) {
      case 5:
        return AppColors.success;
      case 4:
        return const Color(0xFF84CC16);
      case 3:
        return AppColors.warning;
      case 2:
        return const Color(0xFFF97316);
      case 1:
        return AppColors.danger;
      default:
        return isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = situation.duration <= 0
        ? 1.0
        : situation.duration.toDouble();
    final windows =
        situation.scoreWindows
            .where((window) => window.to > window.from && window.score > 0)
            .toList()
          ..sort((a, b) => a.from.compareTo(b.from));

    if (windows.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 22,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 7,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputBackground
                        : AppColors.lightInputDisabledBackground,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              for (final window in windows)
                _ScoreWindowSegment(
                  left: ((window.from / duration).clamp(0.0, 1.0)) * width,
                  width:
                      (((window.to - window.from) / duration).clamp(0.0, 1.0)) *
                      width,
                  color: _scoreColor(window.score),
                  score: window.score,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ScoreWindowSegment extends StatelessWidget {
  final double left;
  final double width;
  final Color color;
  final int score;

  const _ScoreWindowSegment({
    required this.left,
    required this.width,
    required this.color,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final segmentWidth = width < 3 ? 3.0 : width;

    return Positioned(
      left: left,
      top: 5,
      width: segmentWidth,
      height: 12,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: segmentWidth >= 28
            ? Center(
                child: Text(
                  '$scoređ',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final SimulationSituation situation;
  final double? flagSecond;
  final int? score;
  final bool isDark;

  const _ResultPanel({
    required this.situation,
    required this.flagSecond,
    required this.score,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasFlag = flagSecond != null && score != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (hasFlag ? AppColors.success : AppColors.primary)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasFlag ? Icons.emoji_events_rounded : Icons.timer_rounded,
              color: hasFlag ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasFlag
                      ? 'Gắn cờ tại ${flagSecond!.toStringAsFixed(2)}s'
                      : 'Thời lượng ${situation.durationText}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasFlag
                      ? 'Điểm của bạn: $score/5'
                      : 'Bấm gắn cờ khi phát hiện tình huống nguy hiểm.',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  final SimulationProgressSummary? progress;
  final bool isDark;
  final VoidCallback onOpenHistory;

  const _ProgressPanel({
    required this.progress,
    required this.isDark,
    required this.onOpenHistory,
  });

  String _formatSecond(double? second) {
    if (second == null) return '--';
    return '${second.toStringAsFixed(2)}s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ProgressStat(
                  label: 'Số lần',
                  value: '${progress?.attemptCount ?? 0}',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _ProgressStat(
                  label: 'Cao nhất',
                  value: '${progress?.bestScore ?? 0}/5',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _ProgressStat(
                  label: 'Bấm tốt nhất',
                  value: _formatSecond(progress?.bestFlagSecond),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenHistory,
              icon: const Icon(Icons.history_rounded),
              label: const Text('Xem lịch sử câu này'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextMuted
                : AppColors.lightTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _ScoreScale extends StatelessWidget {
  final int? score;
  final bool isDark;

  const _ScoreScale({required this.score, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const scores = [5, 4, 3, 2, 1];

    return Row(
      children: [
        for (final item in scores) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: score == item
                    ? AppColors.success
                    : (isDark ? AppColors.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: score == item
                      ? AppColors.success
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Text(
                '$item điểm',
                style: TextStyle(
                  color: score == item
                      ? Colors.white
                      : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          if (item != scores.last) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _VideoErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _VideoErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_file_rounded, size: 46),
            const SizedBox(height: 12),
            const Text(
              'Không thể tải video mô phỏng.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
