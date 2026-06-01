import 'dart:math';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/wrong_question_notification_service.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/question_image.dart';
import 'package:flutter/material.dart';

final wrongQuestionReminderOverlayKey =
    GlobalKey<WrongQuestionReminderOverlayState>();

class WrongQuestionReminderOverlay extends StatefulWidget {
  const WrongQuestionReminderOverlay({super.key});

  @override
  State<WrongQuestionReminderOverlay> createState() =>
      WrongQuestionReminderOverlayState();
}

class WrongQuestionReminderOverlayState
    extends State<WrongQuestionReminderOverlay> {
  late final UserProgressRepository _repo = UserProgressRepository(
    UserProgressDao(DBProvider().db),
  );

  final _random = Random();

  Question? _question;
  String? _selectedAnswer;
  bool? _isCorrectAnswer;
  bool _isSaving = false;
  bool _visible = false;

  Future<void> showFromNotification() async {
    await Future.delayed(const Duration(milliseconds: 220));
    await _showRandomWrongQuestion();
  }

  Future<void> _showRandomWrongQuestion() async {
    final wrongQuestions = await _repo.getWrongQuestions();
    if (!mounted || wrongQuestions.isEmpty) return;

    setState(() {
      _question = wrongQuestions[_random.nextInt(wrongQuestions.length)];
      _selectedAnswer = null;
      _isCorrectAnswer = null;
      _isSaving = false;
      _visible = true;
    });
  }

  void _dismiss() {
    setState(() => _visible = false);
  }

  String _normalize(String value) => value.trim().toUpperCase();

  bool _isCorrect(Question question, String label) {
    return _normalize(question.correctAnswer) == _normalize(label);
  }

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

  Future<void> _selectAnswer(Question question, String label) async {
    if (_selectedAnswer != null || _isSaving) return;

    final ok = _isCorrect(question, label);
    setState(() {
      _selectedAnswer = label;
      _isCorrectAnswer = ok;
      _isSaving = true;
    });

    await _repo.logAnswer(question.id, label, ok);
    if (ok) {
      await _repo.removeWrongQuestion(question.id);
    } else {
      await _repo.logWrongAnswer(question.id);
    }

    await WrongQuestionNotificationService.instance.syncCurrentReminderState();

    if (!mounted) return;
    setState(() => _isSaving = false);
  }

  Future<void> _nextWrongQuestion() async {
    if (_isSaving) return;
    await _showRandomWrongQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height - media.padding.top - 28;

    return Positioned(
      left: 12,
      right: 12,
      top: media.padding.top + 12,
      child: IgnorePointer(
        ignoring: !_visible,
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _visible ? Offset.zero : const Offset(0, -0.08),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: q == null
                ? const SizedBox.shrink()
                : _ReminderCard(
                    question: q,
                    options: _optionsOf(q),
                    selectedAnswer: _selectedAnswer,
                    isCorrectAnswer: _isCorrectAnswer,
                    isSaving: _isSaving,
                    maxHeight: maxHeight,
                    isDark: isDark,
                    onSelectAnswer: (label) => _selectAnswer(q, label),
                    onClose: _dismiss,
                    onNext: _nextWrongQuestion,
                    normalize: _normalize,
                    optionTextByLabel: _optionTextByLabel,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Question question;
  final List<MapEntry<String, String>> options;
  final String? selectedAnswer;
  final bool? isCorrectAnswer;
  final bool isSaving;
  final double maxHeight;
  final bool isDark;
  final ValueChanged<String> onSelectAnswer;
  final VoidCallback onClose;
  final VoidCallback onNext;
  final String Function(String value) normalize;
  final String Function(List<MapEntry<String, String>> options, String label)
  optionTextByLabel;

  const _ReminderCard({
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.isCorrectAnswer,
    required this.isSaving,
    required this.maxHeight,
    required this.isDark,
    required this.onSelectAnswer,
    required this.onClose,
    required this.onNext,
    required this.normalize,
    required this.optionTextByLabel,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final mutedSurface = isDark
        ? AppColors.darkInputBackground
        : AppColors.lightBackground;
    final image = question.imageUrl?.trim() ?? '';
    final correctLabel = normalize(question.correctAnswer);
    final correctText = optionTextByLabel(options, correctLabel);
    final selectedText = selectedAnswer == null
        ? ''
        : optionTextByLabel(options, selectedAnswer!);
    final explanation = (question.explanation ?? '').trim();
    final hasAnswered = selectedAnswer != null;

    return Material(
      elevation: 14,
      shadowColor: isDark ? AppColors.darkShadow : AppColors.lightShadow,
      color: surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkButtonSecondary
                          : AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ôn lại câu sai',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Chọn đáp án để ghi câu này khỏi danh sách sai',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: Icon(Icons.close_rounded, color: textSecondary),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 17,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (image.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: mutedSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: border),
                        ),
                        child: QuestionImage(path: image),
                      ),
                    ],
                    const SizedBox(height: 12),
                    ...options.map((option) {
                      return _AnswerOption(
                        label: option.key,
                        text: option.value,
                        selectedAnswer: selectedAnswer,
                        correctLabel: correctLabel,
                        hasAnswered: hasAnswered,
                        isDark: isDark,
                        onTap: () => onSelectAnswer(option.key),
                      );
                    }),
                    if (hasAnswered) ...[
                      const SizedBox(height: 10),
                      _ResultPanel(
                        isCorrect: isCorrectAnswer == true,
                        selectedAnswer: selectedAnswer!,
                        selectedText: selectedText,
                        correctAnswer: correctLabel,
                        correctText: correctText,
                        explanation: explanation,
                        isDark: isDark,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isSaving ? null : onNext,
                            icon: const Icon(Icons.shuffle_rounded, size: 18),
                            label: const Text('Câu khác'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: hasAnswered && !isSaving
                                ? onClose
                                : null,
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check_rounded, size: 18),
                            label: Text(hasAnswered ? 'Xong' : 'Chọn đáp án'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: isDark
                                  ? AppColors.darkButtonDisabled
                                  : AppColors.lightButtonDisabled,
                              disabledForegroundColor: isDark
                                  ? AppColors.darkButtonDisabledText
                                  : AppColors.lightButtonDisabledText,
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
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final String? selectedAnswer;
  final String correctLabel;
  final bool hasAnswered;
  final bool isDark;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.text,
    required this.selectedAnswer,
    required this.correctLabel,
    required this.hasAnswered,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedAnswer == label;
    final correct = correctLabel == label;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final border = isDark ? AppColors.darkBorderStrong : AppColors.lightBorder;
    final baseSurface = isDark
        ? AppColors.darkInputBackground
        : AppColors.lightSurface;

    Color activeColor = AppColors.primary;
    Color background = baseSurface;
    Color borderColor = selected ? AppColors.primary : border;
    IconData? icon;

    if (hasAnswered) {
      if (correct) {
        activeColor = AppColors.success;
        background = isDark
            ? AppColors.successDark.withValues(alpha: 0.22)
            : AppColors.successLight;
        borderColor = AppColors.success;
        icon = Icons.check_rounded;
      } else if (selected) {
        activeColor = AppColors.danger;
        background = isDark
            ? AppColors.dangerDark.withValues(alpha: 0.22)
            : AppColors.dangerLight;
        borderColor = AppColors.danger;
        icon = Icons.close_rounded;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: hasAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected || (hasAnswered && correct)
                      ? activeColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: activeColor, width: 1.5),
                ),
                child: icon != null
                    ? Icon(icon, color: Colors.white, size: 16)
                    : Text(
                        label,
                        style: TextStyle(
                          color: selected ? Colors.white : activeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final bool isCorrect;
  final String selectedAnswer;
  final String selectedText;
  final String correctAnswer;
  final String correctText;
  final String explanation;
  final bool isDark;

  const _ResultPanel({
    required this.isCorrect,
    required this.selectedAnswer,
    required this.selectedText,
    required this.correctAnswer,
    required this.correctText,
    required this.explanation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isCorrect ? AppColors.success : AppColors.danger;
    final background = isCorrect
        ? (isDark
              ? AppColors.successDark.withValues(alpha: 0.18)
              : AppColors.successLight)
        : (isDark
              ? AppColors.dangerDark.withValues(alpha: 0.18)
              : AppColors.dangerLight);
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect ? 'Chính xác' : 'Chưa đúng',
                  style: TextStyle(
                    color: accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn chọn: $selectedAnswer${selectedText.isEmpty ? "" : ". $selectedText"}',
            style: TextStyle(color: textPrimary, fontSize: 13.5, height: 1.35),
          ),
          const SizedBox(height: 4),
          Text(
            'Đáp án đúng: $correctAnswer${correctText.isEmpty ? "" : ". $correctText"}',
            style: TextStyle(
              color: textPrimary,
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              explanation,
              style: TextStyle(
                color: textSecondary,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
