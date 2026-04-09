import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_quest_dao.dart';
import 'package:driving_test_prep/data/repository/exam_sets_quest_repository.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExamTopicQuetsScreen extends StatefulWidget {
  final int topicId;
  final int mode; // 0: full, 1: random 20, 2: critical only
  final bool gradeInstantly;
  final String? topicTitle;

  const ExamTopicQuetsScreen({
    super.key,
    required this.topicId,
    this.mode = 0,
    this.gradeInstantly = false,
    this.topicTitle,
  });

  @override
  State<ExamTopicQuetsScreen> createState() => _ExamTopicQuetsScreenState();
}

class _ExamTopicQuetsScreenState extends State<ExamTopicQuetsScreen> {
  late final ExamSetsQuestRepository repo =
  ExamSetsQuestRepository(ExamSetsQuestDao(DBProvider().db));

  List<Question> questions = [];
  int currentIndex = 0;

  final Map<int, String> selectedAnswers = {};
  final Set<int> bookmarkedQuestionIds = {};
  final Set<int> judgedQuestionIds = {};

  final ScrollController _numberStripController = ScrollController();

  static const double _numberItemWidth = 38;
  static const double _numberItemGap = 6;

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _numberStripController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await repo.getQuestionsByTopic(widget.topicId);
      final filtered = _applyMode(data, widget.mode);

      if (!mounted) return;
      setState(() {
        questions = filtered;
        currentIndex = 0;
        _isLoading = false;
      });

      _scheduleStripScroll(animated: false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Không tải được câu hỏi theo chủ đề.';
      });
    }
  }

  List<Question> _applyMode(List<Question> source, int mode) {
    final list = List<Question>.from(source);
    switch (mode) {
      case 1:
        list.shuffle();
        return list.take(20).toList();
      case 2:
        return list.where((q) => q.isCritical == 1).toList();
      default:
        return list;
    }
  }

  void _setCurrentIndex(int index, {bool animated = true}) {
    if (index < 0 || index >= questions.length) return;
    setState(() {
      currentIndex = index;
    });
    _scheduleStripScroll(animated: animated);
  }

  void _scheduleStripScroll({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollNumberStripToCurrent(animated: animated);
    });
  }

  void _scrollNumberStripToCurrent({bool animated = true}) {
    if (!_numberStripController.hasClients) return;

    final position = _numberStripController.position;
    final viewportWidth = position.viewportDimension;
    final itemExtent = _numberItemWidth + _numberItemGap;

    final rawOffset =
        (currentIndex * itemExtent) - ((viewportWidth - _numberItemWidth) / 2);

    final target = rawOffset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if (animated) {
      _numberStripController.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    } else {
      _numberStripController.jumpTo(target);
    }
  }

  String _normalize(String v) => v.trim().toUpperCase();

  bool _isCorrect(Question q, String selectedLabel) {
    return _normalize(q.correctAnswer) == _normalize(selectedLabel);
  }

  int _countCorrectAnswers() {
    var correct = 0;
    for (final q in questions) {
      final selected = selectedAnswers[q.id];
      if (selected != null && _isCorrect(q, selected)) {
        correct++;
      }
    }
    return correct;
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

  String _optionTextByLabel(List<MapEntry<String, String>> options, String label) {
    for (final opt in options) {
      if (_normalize(opt.key) == _normalize(label)) return opt.value;
    }
    return '';
  }

  Future<void> _submitExam() async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    final total = questions.length;
    final answered = selectedAnswers.length;
    final correct = _countCorrectAnswers();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Kết quả ôn luyện'),
        content: Text(
          'Đã làm: $answered/$total câu\n'
              'Đúng: $correct/$total câu',
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
            child: const Text('Về chủ đề'),
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
          duration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.topicTitle?.trim().isNotEmpty == true
        ? widget.topicTitle!.trim()
        : 'Ôn luyện theo chủ đề';

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ôn luyện theo chủ đề')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ôn luyện theo chủ đề')),
        body: const Center(
          child: Text('Không có câu hỏi cho chủ đề này.'),
        ),
      );
    }

    final q = questions[currentIndex];
    final opts = _optionsOf(q);
    final qId = q.id;
    final selected = selectedAnswers[qId];
    final isBookmarked = bookmarkedQuestionIds.contains(qId);
    final correctLabel = _normalize(q.correctAnswer);
    final isJudged = judgedQuestionIds.contains(qId);
    final correctText = _optionTextByLabel(opts, correctLabel);
    final explanation = (q.explanation ?? '').trim();
    final selectedLabel = selected ?? '';
    final selectedText =
    selectedLabel.isEmpty ? '' : _optionTextByLabel(opts, selectedLabel);

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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _submitExam,
                      child: const Text(
                        'Nộp bài',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 40,
              child: ListView.separated(
                controller: _numberStripController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: questions.length,
                separatorBuilder: (_, __) => const SizedBox(width: _numberItemGap),
                itemBuilder: (_, i) {
                  final active = i == currentIndex;
                  final hasAnswer = selectedAnswers.containsKey(questions[i].id);

                  return GestureDetector(
                    onTap: () => _setCurrentIndex(i),
                    child: Container(
                      width: _numberItemWidth,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: active
                            ? Colors.white
                            : (hasAnswer
                            ? const Color(0xFFEAF3FF)
                            : const Color(0xFFF0F0F0)),
                        border: Border.all(
                          color: active ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Câu ${currentIndex + 1}/${questions.length}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 6),
                    Text(
                      q.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(height: 24),

                    ...List.generate(opts.length, (i) {
                      final label = opts[i].key;
                      final text = opts[i].value;
                      final checked = selected == label;

                      Color borderColor;
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
                                    child: stateIcon != null ? Icon(
                                      stateIcon,
                                      color: iconColor,
                                      size: 12,
                                    ) : null,
                                  ),

                                  const SizedBox(width: 12),
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
                              explanation.isEmpty
                                  ? 'Chưa có lời giải cho câu này.'
                                  : explanation,
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
              child: isFirstQuestion
                  ? const SizedBox()
                  : TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () => _setCurrentIndex(currentIndex - 1),
                icon: const Icon(Icons.chevron_left),
                label: const Text(
                  'CÂU TRƯỚC',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _openQuestionSheet(context),
              icon: const Icon(
                Icons.keyboard_double_arrow_up,
                color: Colors.white,
                size: 34,
              ),
            ),
            Expanded(
              child: isLastQuestion
                  ? const SizedBox()
                  : TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () => _setCurrentIndex(currentIndex + 1),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'CÂU SAU',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right),
                  ],
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
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Danh sách câu hỏi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
                    final q = questions[i];
                    final opts = _optionsOf(q);
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _setCurrentIndex(i);
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
                            radius: 14,
                            backgroundColor:
                            chosen ? AppColors.primary : const Color(0xFFEFEFEF),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: chosen ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
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
