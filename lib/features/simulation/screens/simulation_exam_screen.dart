import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/repository/simulation_situation_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/features/simulation/screens/simulation_exam_result_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimulationExamScreen extends StatefulWidget {
  final List<SimulationSituation> situations;

  const SimulationExamScreen({
    super.key,
    required this.situations,
  });

  @override
  State<SimulationExamScreen> createState() => _SimulationExamScreenState();
}

class _SimulationExamScreenState extends State<SimulationExamScreen> {
  final _repository = SimulationSituationRepository.remote();

  late final DateTime _startedAt;
  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;
  late List<SimulationExamAnswerInput?> _answers;

  int _currentIndex = 0;
  double? _flagSecond;
  int? _score;
  bool _isSubmitting = false;

  SimulationSituation get _situation => widget.situations[_currentIndex];
  bool get _hasFlagged => _flagSecond != null && _score != null;
  bool get _isLastQuestion => _currentIndex == widget.situations.length - 1;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _answers = List<SimulationExamAnswerInput?>.filled(
      widget.situations.length,
      null,
    );
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

  String _formatPlaybackTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
      _answers[_currentIndex] = SimulationExamAnswerInput(
        situationId: _situation.id,
        orderIndex: _currentIndex,
        score: score,
        flagSecond: second,
        duration: _situation.duration,
      );
    });
  }

  SimulationExamAnswerInput _currentAnswerOrZero() {
    return _answers[_currentIndex] ??
        SimulationExamAnswerInput(
          situationId: _situation.id,
          orderIndex: _currentIndex,
          score: 0,
          flagSecond: null,
          duration: _situation.duration,
        );
  }

  Future<void> _goNext() async {
    _answers[_currentIndex] = _currentAnswerOrZero();

    if (_isLastQuestion) {
      await _submit();
      return;
    }

    final oldController = _controller;
    setState(() {
      _currentIndex += 1;
      _flagSecond = null;
      _score = null;
      _createController();
    });
    await oldController.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final submittedAt = DateTime.now();
    final completedAnswers = [
      for (var index = 0; index < widget.situations.length; index++)
        _answers[index] ??
            SimulationExamAnswerInput(
              situationId: widget.situations[index].id,
              orderIndex: index,
              score: 0,
              flagSecond: null,
              duration: widget.situations[index].duration,
            ),
    ];
    final totalScore = completedAnswers.fold<int>(
      0,
      (sum, answer) => sum + answer.score,
    );

    try {
      await _repository.saveExamResult(
        totalScore: totalScore,
        startedAt: _startedAt,
        submittedAt: submittedAt,
        answers: completedAnswers,
      );
    } catch (_) {
      // The result screen should still be shown even if local history fails.
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimulationExamResultScreen(
          totalScore: totalScore,
          situations: widget.situations,
          answers: completedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Câu ${_currentIndex + 1}/${widget.situations.length}'),
      ),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Không thể tải video mô phỏng.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text(
                _situation.displayTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
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
                allowScrubbing: false,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary,
                  bufferedColor: Color(0xFF93C5FD),
                ),
              ),
              const SizedBox(height: 6),
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
              _ExamStatusPanel(
                flagSecond: _flagSecond,
                score: _score,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _hasFlagged ? null : _flagSituation,
                icon: const Icon(Icons.flag_rounded),
                label: Text(
                  _hasFlagged ? 'Đã gắn cờ' : 'Gắn cờ tình huống',
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _isSubmitting ? null : _goNext,
                icon: Icon(
                  _isLastQuestion
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(_isLastQuestion ? 'Nộp bài' : 'Câu tiếp theo'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExamStatusPanel extends StatelessWidget {
  final double? flagSecond;
  final int? score;
  final bool isDark;

  const _ExamStatusPanel({
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
          Icon(
            hasFlag ? Icons.emoji_events_rounded : Icons.timer_rounded,
            color: hasFlag ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasFlag
                  ? 'Gắn cờ tại ${flagSecond!.toStringAsFixed(2)}s • $score/5 điểm'
                  : 'Bấm gắn cờ khi phát hiện tình huống nguy hiểm.',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
