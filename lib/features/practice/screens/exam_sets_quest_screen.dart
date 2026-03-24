import 'dart:async';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/material.dart';

import '../../../core/database/daos/exam_sets_quest_dao.dart';
import '../../../data/repository/exam_sets_quest_repository.dart';
import '../../../shared/utils/constants/app_colors.dart';

class ExamSetsQuestScreen extends StatefulWidget {
  final int examSetId;
  final int durationMinutes;

  const ExamSetsQuestScreen({
    super.key,
    required this.examSetId,
    this.durationMinutes = 20,
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

  final Map<int, String> selectedAnswers = {};
  final Set<int> bookmarkedQuestionIds = {};

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

  List<String> _optionsOf(Question q) {
    return [q.answerA, q.answerB, q.answerC, q.answerD]
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .toList();
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
    final opts = _optionsOf(q);
    final qId = q.id;
    final selected = selectedAnswers[qId];
    final isBookmarked = bookmarkedQuestionIds.contains(qId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                      onPressed: () {},
                      child: const Text('Nộp bài'),
                    ),
                  ),
                ],
              ),
            ),

            // Number grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(questions.length, (i) {
                  final active = i == currentIndex;
                  final hasAnswer =
                  selectedAnswers.containsKey(questions[i].question.id);
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
                            : (hasAnswer
                            ? const Color(0xFFEAF3FF)
                            : const Color(0xFFF0F0F0)),
                        border: Border.all(
                          color: active ? AppColors.primary : Colors
                              .transparent,
                          width: 2,
                        ),
                      ),
                      child: Text('${i + 1}', style: const TextStyle(
                          fontSize: 14)),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // Content
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
                            fontSize: 42,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF707070),
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
                            isBookmarked ? Icons.bookmark : Icons
                                .bookmark_border,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.question,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const Divider(height: 26),

                    ...List.generate(opts.length, (i) {
                      final value = '${i + 1}';
                      final text = opts[i];
                      final checked = selected == value;

                      return Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => selectedAnswers[qId] = value),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: checked
                                            ? AppColors.primary
                                            : Colors.black,
                                        width: 2.2,
                                      ),
                                    ),
                                    child: checked
                                        ? const Icon(
                                        Icons.check, color: AppColors.primary)
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      '$value. $text',
                                      style: const TextStyle(
                                          fontSize: 24, height: 1.35),
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
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom bar
      bottomNavigationBar: Container(
        height: 72,
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: currentIndex == 0
                    ? null
                    : () => setState(() => currentIndex -= 1),
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                label: const Text(
                  'CÂU TRƯỚC',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _openQuestionSheet(context),
              icon: const Icon(
                  Icons.keyboard_double_arrow_up, color: Colors.white,
                  size: 36),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: currentIndex == questions.length - 1
                    ? null
                    : () => setState(() => currentIndex += 1),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                label: const Text(
                  'CÂU SAU',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
                child: Row(
                  children: const [
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
                      title: Text('Câu ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        q.question,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Wrap(
                        spacing: 6,
                        children: List.generate(opts.length, (idx) {
                          final n = '${idx + 1}';
                          final chosen = selectedAnswers[q.id] == n;
                          return CircleAvatar(
                            radius: 16,
                            backgroundColor: chosen ? AppColors.primary : const Color(0xFFEFEFEF),
                            child: Text(
                              n,
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