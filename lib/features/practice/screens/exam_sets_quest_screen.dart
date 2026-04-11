import 'dart:async';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/material.dart';

import '../../../core/database/daos/exam_sets_quest_dao.dart';
import '../../../data/repository/exam_sets_quest_repository.dart';
import '../../../shared/utils/constants/app_colors.dart';

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

  List<ExamQuestionView> questions = [];
  int currentIndex = 0;
  Duration remaining = Duration.zero;
  Timer? timer;

  // Luu dap an theo nhan A/B/C/D
  final Map<int, String> selectedAnswers = {};
  final Set<int> bookmarkedQuestionIds = {};

  // Dung cho che do cham nhanh: cau nao da cham thi khoa chon lai
  final Set<int> judgedQuestionIds = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    repo = ExamSetsQuestRepository(ExamSetsQuestDao(db));
    remaining = Duration(minutes: widget.durationMinutes);
    _loadData();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await repo.getQuestionsByExamSet(widget.examSetId);
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

  String _optionTextByLabel(List<MapEntry<String, String>> options, String label) {
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
    final path = rawPath.trim();
    if (path.isEmpty) return const SizedBox.shrink();

    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    final assetPath = path.startsWith('assets/')
        ? path
        : 'assets/images/questions/$path';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: isRemote
            ? Image.network(
          path,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        )
            : Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
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

  void _onSelectAnswer(Question q, String label) {
    final qId = q.id;
    final isJudged = judgedQuestionIds.contains(qId);

    if (widget.gradeInstantly && isJudged) return;

    setState(() {
      selectedAnswers[qId] = label;
      if (widget.gradeInstantly) {
        judgedQuestionIds.add(qId);
      }
    });

    if (widget.gradeInstantly) {
      final ok = _isCorrect(q, label);
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
    final selectedText = selectedLabel.isEmpty ? '' : _optionTextByLabel(opts, selectedLabel);
    final showInstantReview = widget.gradeInstantly && isJudged;
    final isLastQuestion = currentIndex == questions.length - 1;
    final isFirstQuestion = currentIndex == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(24),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFF1F1F1),
                      child: Icon(Icons.close, size: 30, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _timeText(remaining),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
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
                  final hasAnswer = selectedAnswers.containsKey(questions[i].question.id);
                  return GestureDetector(
                    onTap: () => setState(() => currentIndex = i),
                    child: Container(
                      width: 38,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: active
                            ? Colors.white
                            : (hasAnswer ? const Color(0xFFEAF3FF) : const Color(0xFFF0F0F0)),
                        border: Border.all(
                          color: active ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isBookmarked) {
                                bookmarkedQuestionIds.remove(qId);
                              } else {
                                bookmarkedQuestionIds.add(qId);
                              }
                            });
                          },
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: Colors.black,
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

                      Color borderColor = Colors.black;
                      IconData? stateIcon;
                      Color iconColor = AppColors.primary;

                      if (widget.gradeInstantly && isJudged) {
                        if (label == correctLabel) {
                          borderColor = Colors.green;
                          stateIcon = Icons.check;
                          iconColor = Colors.green;
                        } else if (checked && label != correctLabel) {
                          borderColor = Colors.red;
                          stateIcon = Icons.close;
                          iconColor = Colors.red;
                        } else {
                          borderColor = Colors.black45;
                        }
                      } else {
                        borderColor = checked ? AppColors.primary : Colors.black;
                        stateIcon = checked ? Icons.check : null;
                        iconColor = AppColors.primary;
                      }

                      return Column(
                        children: [
                          InkWell(
                            onTap: () => _onSelectAnswer(q, label),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: borderColor,
                                        width: 2.1,
                                      ),
                                    ),
                                    child: stateIcon != null
                                        ? Icon(
                                      stateIcon,
                                      color: iconColor,
                                      size: 12,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      '$label. $text',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        height: 1.35,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 10),
                        ],
                      );
                    }),
                    if (showInstantReview) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD6E6FF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Giải thích',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bạn chọn: ${selectedLabel.isEmpty ? "Chưa chọn" : "$selectedLabel. $selectedText"}',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Đáp án đúng: $correctLabel${correctText.isEmpty ? "" : ". $correctText"}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              explanation.isEmpty ? 'Chưa có lời giải cho câu này.' : explanation,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Colors.black87,
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
        color: AppColors.primary,
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
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () => setState(() => currentIndex -= 1),
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
              onPressed: () => _openQuestionSheet(context),
              icon: const Icon(
                Icons.keyboard_double_arrow_up,
                color: Colors.white,
                size: 36,
              ),
            ),
            Expanded(
              child: Visibility(
                visible: !isLastQuestion,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => setState(() => currentIndex += 1),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            children: [
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final q = questions[i].question;
                    final opts = _optionsOf(q);
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => currentIndex = i);
                      },
                      title: Text(
                        'Câu ${i + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        q.question,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
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
                                : const Color(0xFFEFEFEF),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: chosen ? Colors.white : Colors.black,
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
