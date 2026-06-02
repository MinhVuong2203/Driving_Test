import 'dart:async';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/database/daos/exam_sets_quest_dao.dart';
import '../../../core/database/daos/setting_dao.dart';
import '../../../core/database/daos/user_progress_dao.dart';
import '../../../data/repository/exam_sets_quest_repository.dart';
import '../../../data/repository/setting_reponsitory.dart';
import '../../../data/repository/user_progress_repository.dart';
import '../../../data/services/sqlite/wrong_question_notification_service.dart';
import '../../../shared/utils/constants/app_colors.dart';
import '../../../shared/widgets/question_image.dart';
import '../../../shared/widgets/interstitial_ad_helper.dart';
import '../../../data/repository/admob_config_repository.dart';

class ExamSetsQuestScreen extends StatefulWidget {
  final int examSetId;
  final bool gradeInstantly;
  final int durationMinutes;
  final int passScore;

  const ExamSetsQuestScreen({
    super.key,
    required this.examSetId,
    this.gradeInstantly = false,
    this.durationMinutes = 20,
    this.passScore = 0,
  });

  @override
  State<StatefulWidget> createState() => _ExamSetsQuestScreenState();
}

class _ExamSetsQuestScreenState extends State<ExamSetsQuestScreen> {
  late final db = DBProvider().db;
  late final ExamSetsQuestRepository repo;

  late final UserProgressRepository userProgressRepo;
  late final SettingRepository settingRepo;
  final _adHelper = InterstitialAdHelper();
  final _adMobRepo = AdMobConfigRepository();

  List<ExamQuestionView> questions = [];
  int currentIndex = 0;
  Duration remaining = Duration.zero;
  Timer? timer;
  Timer? _autoNextTimer;

  // Luu dap an theo nhan A/B/C/D
  final Map<int, String> selectedAnswers = {};
  final Set<int> bookmarkedQuestionIds = {};

  // Dung cho che do cham nhanh: cau nao da cham thi khoa chon lai
  final Set<int> judgedQuestionIds = {};

  bool _isSubmitting = false;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    repo = ExamSetsQuestRepository(ExamSetsQuestDao(db));
    userProgressRepo = UserProgressRepository(UserProgressDao(db));
    settingRepo = SettingRepository(SettingDao(db));
    remaining = Duration(minutes: widget.durationMinutes);
    _loadVibrationSetting();
    _loadData();
    _startTimer();
    _initAd();
  }

  @override
  void dispose() {
    timer?.cancel();
    _autoNextTimer?.cancel();
    _adHelper.dispose();
    super.dispose();
  }

  Future<void> _loadVibrationSetting() async {
    final setting = await settingRepo.getSetting();
    if (!mounted) return;
    setState(() {
      _vibrationEnabled = (setting?.vibration ?? 1) == 1;
    });
  }

  Future<void> _vibrateOnAnswerSelected() async {
    if (!_vibrationEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  void _goToQuestion(int index) {
    if (index < 0 || index >= questions.length) return;
    _autoNextTimer?.cancel();
    setState(() => currentIndex = index);
  }

  void _scheduleAutoNext(int selectedQuestionId, int selectedQuestionIndex) {
    _autoNextTimer?.cancel();
    if (selectedQuestionIndex >= questions.length - 1) return;

    _autoNextTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || questions.isEmpty) return;
      if (currentIndex != selectedQuestionIndex) return;
      if (questions[currentIndex].question.id != selectedQuestionId) return;
      setState(() {
        currentIndex += 1;
      });
    });
  }

  Future<void> _initAd() async {
    final config = await _adMobRepo.getConfig();
    _adHelper.setAdUnitId(config.interstitialId);
    _adHelper.loadAd();
  }

  Future<void> _loadData() async {
    final data = await repo.getQuestionsByExamSet(widget.examSetId);

    final savedQuestions = await userProgressRepo.getSavedQuestions();
    bookmarkedQuestionIds.clear();
    bookmarkedQuestionIds.addAll(savedQuestions.map((q) => q.id));

    if (!mounted) return;
    setState(() {
      questions = data;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (remaining.inSeconds <= 0) {
        timer?.cancel();
        _submitExam(autoSubmit: true);
        return;
      }
      setState(() {
        remaining -= const Duration(seconds: 1);
      });
    });
  }

  String _timeText(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  List<MapEntry<String, String>> _optionsOf(Question q) {
    final raw = <MapEntry<String, String?>>[
      MapEntry('A', q.answerA),
      MapEntry('B', q.answerB),
      MapEntry('C', q.answerC),
      MapEntry('D', q.answerD),
    ];

    return raw
        .where((e) => (e.value ?? '').trim().isNotEmpty)
        .map((e) => MapEntry(e.key, e.value!.trim()))
        .toList();
  }

  String _normalize(String v) => v.trim().toUpperCase();

  bool _isCorrect(Question q, String selectedLabel) {
    return _normalize(q.correctAnswer) == _normalize(selectedLabel);
  }

  String _optionTextByLabel(
    List<MapEntry<String, String>> options,
    String label,
  ) {
    for (final opt in options) {
      if (_normalize(opt.key) == _normalize(label)) {
        return opt.value;
      }
    }
    return '';
  }

  int _countCorrectAnswers() {
    var correct = 0;
    for (final item in questions) {
      final q = item.question;
      final selected = selectedAnswers[q.id];
      if (selected != null && _isCorrect(q, selected)) {
        correct++;
      }
    }
    return correct;
  }

  Widget _buildQuestionImage(String rawPath) {
    return QuestionImage(path: rawPath);
  }

  Future<void> _submitExam({bool autoSubmit = false}) async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    timer?.cancel();

    final total = questions.length;
    final answered = selectedAnswers.length;
    final correct = _countCorrectAnswers();
    final passNeed = widget.passScore > 0 ? widget.passScore : total;
    final passed = correct >= passNeed;
    var reminderStateChanged = false;

    // Lưu vào database
    for (final item in questions) {
      final q = item.question;
      final selected = selectedAnswers[q.id];
      if (selected != null) {
        final ok = _isCorrect(q, selected);
        await userProgressRepo.logAnswer(q.id, selected, ok);
        if (!ok) {
          await userProgressRepo.logWrongAnswer(q.id);
          reminderStateChanged = true;
        } else {
          await userProgressRepo.removeWrongQuestion(q.id);
          reminderStateChanged = true;
        }
      }
    }

    if (reminderStateChanged) {
      await WrongQuestionNotificationService.instance
          .syncCurrentReminderState();
    }

    if (!mounted) return;
    await _adHelper.showAd();
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(autoSubmit ? 'Hết giờ làm bài' : 'Kết quả bài thi'),
        content: Text(
          'Đã làm: $answered/$total câu\n'
          'Đúng: $correct/$total câu\n'
          'Điểm đậu tối thiểu: $passNeed\n'
          'Kết quả: ${passed ? "ĐẠT" : "KHÔNG ĐẠT"}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Về danh sách đề'),
          ),
        ],
      ),
    );

    _isSubmitting = false;
  }

  Future<void> _onSelectAnswer(Question q, String label) async {
    final qId = q.id;
    final isJudged = judgedQuestionIds.contains(qId);

    if (widget.gradeInstantly && isJudged) return;
    final selectedQuestionIndex = currentIndex;
    await _vibrateOnAnswerSelected();

    setState(() {
      selectedAnswers[qId] = label;
      if (widget.gradeInstantly) {
        judgedQuestionIds.add(qId);
      }
    });
    _scheduleAutoNext(qId, selectedQuestionIndex);

    if (widget.gradeInstantly) {
      final ok = _isCorrect(q, label);

      await userProgressRepo.logAnswer(q.id, label, ok);
      if (!ok) {
        await userProgressRepo.logWrongAnswer(q.id);
      } else {
        await userProgressRepo.removeWrongQuestion(q.id);
      }

      await WrongQuestionNotificationService.instance
          .syncCurrentReminderState();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Chính xác' : 'Sai rồi'),
          backgroundColor: ok ? Colors.green : Colors.red,
          duration: const Duration(milliseconds: 650),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final item = questions[currentIndex];
    final q = item.question;
    final image = item.question.imageUrl;
    final opts = _optionsOf(q);
    final qId = q.id;
    final selected = selectedAnswers[qId];
    final isBookmarked = bookmarkedQuestionIds.contains(qId);
    final correctLabel = _normalize(q.correctAnswer);
    final isJudged = judgedQuestionIds.contains(qId);
    final correctText = _optionTextByLabel(opts, correctLabel);
    final explanation = (q.explanation ?? '').trim();
    final selectedLabel = selected ?? '';
    final selectedText = selectedLabel.isEmpty
        ? ''
        : _optionTextByLabel(opts, selectedLabel);
    final showInstantReview = widget.gradeInstantly && isJudged;
    final isLastQuestion = currentIndex == questions.length - 1;
    final isFirstQuestion = currentIndex == 0;
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
    final selectedSurface = isDark
        ? AppColors.darkButtonSecondary
        : AppColors.primaryLight;
    final neutralSurface = isDark
        ? AppColors.darkInputBackground
        : AppColors.lightSurface;
    final answeredChipColor = isDark
        ? AppColors.darkChipBackground
        : AppColors.lightChipBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(24),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: isDark
                          ? AppColors.darkInputBackground
                          : AppColors.primaryLight,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
   
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer_rounded,
                              size: 18,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _timeText(remaining),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.warningDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => _submitExam(),
                      child: const Text(
                        'Nộp bài',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(questions.length, (i) {
                  final active = i == currentIndex;
                  final hasAnswer = selectedAnswers.containsKey(
                    questions[i].question.id,
                  );
                  return GestureDetector(
                    onTap: () => _goToQuestion(i),
                    child: Container(
                      width: 38,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active
                            ? AppColors.primary
                            : (hasAnswer ? answeredChipColor : surfaceColor),
                        border: Border.all(
                          color: active
                              ? AppColors.primary
                              : (hasAnswer ? AppColors.primary : borderColor),
                          width: active ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: active
                              ? AppColors.white
                              : (hasAnswer ? AppColors.primary : textSecondary),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Câu ${currentIndex + 1}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            await userProgressRepo.toggleSavedQuestion(qId);
                            setState(() {
                              if (isBookmarked) {
                                bookmarkedQuestionIds.remove(qId);
                              } else {
                                bookmarkedQuestionIds.add(qId);
                              }
                            });
                          },
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? AppColors.warning
                                : textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.question,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (image != null && image.trim().isNotEmpty) ...[
                      _buildQuestionImage(image),
                      const SizedBox(height: 12),
                    ],
                    const Divider(height: 26),
                    ...List.generate(opts.length, (i) {
                      final label = opts[i].key;
                      final text = opts[i].value;
                      final checked = selected == label;

                      Color optionBorderColor = borderColor;
                      Color optionBackground = neutralSurface;
                      IconData? stateIcon;
                      Color iconColor = AppColors.primary;

                      if (widget.gradeInstantly && isJudged) {
                        if (label == correctLabel) {
                          optionBorderColor = AppColors.success;
                          optionBackground = isDark
                              ? AppColors.successDark.withValues(alpha: 0.18)
                              : AppColors.successLight;
                          stateIcon = Icons.check;
                          iconColor = AppColors.success;
                        } else if (checked && label != correctLabel) {
                          optionBorderColor = AppColors.danger;
                          optionBackground = isDark
                              ? AppColors.dangerDark.withValues(alpha: 0.18)
                              : AppColors.dangerLight;
                          stateIcon = Icons.close;
                          iconColor = AppColors.danger;
                        } else {
                          optionBorderColor = borderColor;
                        }
                      } else {
                        optionBorderColor = checked
                            ? AppColors.primary
                            : borderColor;
                        optionBackground = checked
                            ? selectedSurface
                            : neutralSurface;
                        stateIcon = checked ? Icons.check : null;
                        iconColor = AppColors.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _onSelectAnswer(q, label),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: optionBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: optionBorderColor,
                                width: checked || stateIcon != null ? 1.8 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: checked || stateIcon != null
                                        ? iconColor
                                        : AppColors.transparent,
                                    border: Border.all(
                                      color: optionBorderColor,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: stateIcon != null
                                      ? Icon(
                                          stateIcon,
                                          color: AppColors.white,
                                          size: 16,
                                        )
                                      : Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            color: checked
                                                ? AppColors.white
                                                : textSecondary,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: checked
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      height: 1.35,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (showInstantReview) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkButtonSecondary
                              : AppColors.infoLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorderStrong
                                : AppColors.info.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giải thích',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bạn chọn: ${selectedLabel.isEmpty ? "Chưa chọn" : "$selectedLabel. $selectedText"}',
                              style: TextStyle(
                                fontSize: 16,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Đáp án đúng: $correctLabel${correctText.isEmpty ? "" : ". $correctText"}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              explanation.isEmpty
                                  ? 'Chưa có lời giải cho câu này.'
                                  : explanation,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Visibility(
                visible: !isFirstQuestion,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: selectedSurface,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _goToQuestion(currentIndex - 1),
                  icon: const Icon(Icons.chevron_left),
                  iconAlignment: IconAlignment.start,
                  label: const Text(
                    'CÂU TRƯỚC',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => _openQuestionSheet(context),
              icon: const Icon(Icons.keyboard_double_arrow_up, size: 36),
            ),
            Expanded(
              child: Visibility(
                visible: !isLastQuestion,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: selectedSurface,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _goToQuestion(currentIndex + 1),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text(
                    'CÂU SAU',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuestionSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final chipColor = isDark
        ? AppColors.darkInputBackground
        : AppColors.lightInputDisabledBackground;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            children: [
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.close, color: Colors.white, size: 30),
                    SizedBox(width: 16),
                    Text(
                      'Danh sách câu hỏi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: questions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final q = questions[i].question;
                    final opts = _optionsOf(q);
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _goToQuestion(i);
                      },
                      title: Text(
                        'Câu ${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        q.question,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textSecondary),
                      ),
                      trailing: Wrap(
                        spacing: 6,
                        children: List.generate(opts.length, (idx) {
                          final label = opts[idx].key;
                          final chosen = selectedAnswers[q.id] == label;
                          return CircleAvatar(
                            radius: 16,
                            backgroundColor: chosen
                                ? AppColors.primary
                                : chipColor,
                            child: Text(
                              label,
                              style: TextStyle(
                                color: chosen ? AppColors.white : textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
