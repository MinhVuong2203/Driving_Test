import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_quest_dao.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/exam_sets_quest_repository.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/data/services/firebase/user_vip_service.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/question_image.dart';
import 'package:flutter/material.dart';

class ExamResultScreen extends StatefulWidget {
  final int examSetId;
  final String examTitle;
  final int passScore;
  final bool popToExamListOnBack;

  const ExamResultScreen({
    super.key,
    required this.examSetId,
    required this.examTitle,
    required this.passScore,
    this.popToExamListOnBack = false,
  });

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  late final ExamSetsQuestRepository _questionRepository =
      ExamSetsQuestRepository(ExamSetsQuestDao(DBProvider().db));
  late final UserProgressRepository _progressRepository =
      UserProgressRepository(UserProgressDao(DBProvider().db));

  List<ExamQuestionView> _questions = [];
  Map<int, String> _answers = {};
  ExamSetResultSummary? _summary;
  bool _isLoading = true;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final questions = await _questionRepository.getQuestionsByExamSet(
      widget.examSetId,
    );
    final answers = await _progressRepository.getExamSetSavedAnswers(
      widget.examSetId,
    );
    final summary = await _progressRepository.getExamSetResultSummary(
      widget.examSetId,
    );

    if (!mounted) return;
    setState(() {
      _questions = questions;
      _answers = answers;
      _summary = summary;
      _isLoading = false;
    });
  }

  void _handleBack() {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (widget.popToExamListOnBack && navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _resetExam() async {
    if (_isResetting) return;
    setState(() => _isResetting = true);

    final currentVip = await UserVipService().getCurrentUserVip();
    if (!mounted) return;

    if (currentVip == null) {
      setState(() => _isResetting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nâng cấp VIP để làm lại đề này.')),
      );
      return;
    }

    await _progressRepository.resetExamSetProgress(widget.examSetId);
    if (!mounted) return;

    setState(() {
      _answers = {};
      _summary = null;
      _isResetting = false;
    });
    _handleBack();
  }

  String _normalize(String value) => value.trim().toUpperCase();

  List<MapEntry<String, String>> _optionsOf(Question question) {
    final raw = <MapEntry<String, String?>>[
      MapEntry('A', question.answerA),
      MapEntry('B', question.answerB),
      MapEntry('C', question.answerC),
      MapEntry('D', question.answerD),
    ];

    return raw
        .where((entry) => (entry.value ?? '').trim().isNotEmpty)
        .map((entry) => MapEntry(entry.key, entry.value!.trim()))
        .toList();
  }

  String _optionTextByLabel(
    List<MapEntry<String, String>> options,
    String label,
  ) {
    for (final option in options) {
      if (_normalize(option.key) == _normalize(label)) return option.value;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final summary = _summary;
    final localCorrectAnswers = _questions.where((item) {
      final question = item.question;
      final selected = _answers[question.id];
      return selected != null &&
          _normalize(selected) == _normalize(question.correctAnswer);
    }).length;
    final localTotalQuestions = _questions.length;
    final hasCompletedAnswers =
        localTotalQuestions > 0 && _answers.length >= localTotalQuestions;
    final hasResult = summary != null || hasCompletedAnswers;
    final isPassed =
        summary?.isPassed ??
        (widget.passScore > 0 && localCorrectAnswers >= widget.passScore);
    final correctAnswers = summary?.correctAnswers ?? localCorrectAnswers;
    final totalQuestions = summary?.totalQuestions ?? localTotalQuestions;
    final resultColor = !hasResult
        ? AppColors.warning
        : (isPassed ? AppColors.success : AppColors.danger);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Kết quả bài thi'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _handleBack,
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _ResultSummaryCard(
                    examTitle: widget.examTitle,
                    hasResult: hasResult,
                    isPassed: isPassed,
                    correctAnswers: correctAnswers,
                    totalQuestions: totalQuestions,
                    resultColor: resultColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _isResetting ? null : _resetExam,
                      icon: _isResetting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Icon(Icons.restart_alt_rounded),
                      label: Text(_isResetting ? 'Đang reset...' : 'Làm lại'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_questions.length, (index) {
                    final question = _questions[index].question;
                    final options = _optionsOf(question);
                    final selectedLabel = _answers[question.id] ?? '';
                    final correctLabel = _normalize(question.correctAnswer);
                    final selectedText = selectedLabel.isEmpty
                        ? ''
                        : _optionTextByLabel(options, selectedLabel);
                    final correctText = _optionTextByLabel(
                      options,
                      correctLabel,
                    );
                    final isCorrect =
                        selectedLabel.isNotEmpty &&
                        _normalize(selectedLabel) == correctLabel;
                    final image = question.imageUrl;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCorrect
                              ? AppColors.success.withValues(alpha: 0.45)
                              : AppColors.danger.withValues(alpha: 0.42),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: isCorrect
                                    ? AppColors.success
                                    : AppColors.danger,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Câu ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.question,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                              color: textPrimary,
                            ),
                          ),
                          if (image != null && image.trim().isNotEmpty) ...[
                            const SizedBox(height: 10),
                            QuestionImage(path: image),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            selectedLabel.isEmpty
                                ? 'Bạn chọn: Chưa chọn'
                                : 'Bạn chọn: $selectedLabel. $selectedText',
                            style: TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Đáp án đúng: $correctLabel${correctText.isEmpty ? "" : ". $correctText"}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}

class _ResultSummaryCard extends StatelessWidget {
  final String examTitle;
  final bool hasResult;
  final bool isPassed;
  final int correctAnswers;
  final int totalQuestions;
  final Color resultColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;

  const _ResultSummaryCard({
    required this.examTitle,
    required this.hasResult,
    required this.isPassed,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.resultColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: resultColor.withValues(alpha: 0.14),
            ),
            child: Icon(
              !hasResult
                  ? Icons.hourglass_empty_rounded
                  : isPassed
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              color: resultColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  !hasResult
                      ? 'Chưa có kết quả'
                      : '${isPassed ? "Đạt" : "Rớt"} - $correctAnswers/$totalQuestions câu đúng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: resultColor,
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
