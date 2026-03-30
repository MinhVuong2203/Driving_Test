import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_quest_dao.dart';
import 'package:driving_test_prep/data/repository/exam_sets_quest_repository.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'exam_topic_quets_screen.dart';

class ExamTopicScreen extends StatefulWidget {
  final int topicId;

  const ExamTopicScreen({
    super.key,
    required this.topicId,
  });

  @override
  State<ExamTopicScreen> createState() => _ExamTopicScreenState();
}

class _ExamTopicScreenState extends State<ExamTopicScreen> {
  late final ExamSetsQuestRepository _repo = ExamSetsQuestRepository(
    ExamSetsQuestDao(DBProvider().db),
  );
  bool _gradeAfterSubmit = true; // true: chấm sau khi nộp
  bool _gradeInstantly = false;  // true: chấm nhanh khi chọn đáp án


  Topic? _topic;
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _error;

  int _selectedMode = 0; // 0: full, 1: random 20, 2: critical only

  @override
  void initState() {
    super.initState();
    _loadTopicData();
  }

  Future<void> _loadTopicData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final topicFuture = _repo.getTopicInfo(widget.topicId);
      final questionsFuture = _repo.getQuestionsByTopic(widget.topicId);
      final results = await Future.wait([topicFuture, questionsFuture]);

      if (!mounted) return;

      setState(() {
        _topic = results[0] as Topic?;
        _questions = results[1] as List<Question>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không tải được dữ liệu chủ đề. Vui lòng thử lại.';
        _isLoading = false;
      });
    }
  }

  int get _totalQuestions => _questions.length;

  int get _criticalQuestions =>
      _questions.where((q) => q.isCritical == 1).length;

  int get _withExplanation =>
      _questions.where((q) => (q.explanation ?? '').trim().isNotEmpty).length;

  String get _modeTitle {
    switch (_selectedMode) {
      case 1:
        return 'Ôn ngẫu nhiên 20 câu';
      case 2:
        return 'Ôn câu điểm liệt';
      default:
        return 'Ôn toàn bộ câu hỏi';
    }
  }

  int get _estimatedCount {
    switch (_selectedMode) {
      case 1:
        return _totalQuestions >= 20 ? 20 : _totalQuestions;
      case 2:
        return _criticalQuestions;
      default:
        return _totalQuestions;
    }
  }

  void _onStartPressed() {
    if (_estimatedCount == 0) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamTopicQuetsScreen(
          topicId: widget.topicId,
          mode: _selectedMode,
          gradeInstantly: _gradeInstantly,
          topicTitle: _topic?.fullname ?? _topic?.name,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final topicName = (_topic?.fullname ?? _topic?.name ?? 'Chủ đề ${widget.topicId}').trim();
    final topicDesc = (_topic?.description ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn luyện theo chủ đề'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _ErrorState(
        message: _error!,
        onRetry: _loadTopicData,
      )
          : _totalQuestions == 0
          ? _EmptyState(topicName: topicName)
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topicName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (topicDesc.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    topicDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Tổng câu',
                  value: '$_totalQuestions',
                  icon: Icons.help_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Điểm liệt',
                  value: '$_criticalQuestions',
                  icon: Icons.warning_amber_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Có giải thích',
                  value: '$_withExplanation',
                  icon: Icons.lightbulb_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Chế độ ôn luyện',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            title: 'Ôn toàn bộ câu hỏi',
            subtitle: 'Làm tuần tự toàn bộ câu trong chủ đề',
            selected: _selectedMode == 0,
            onTap: () => setState(() => _selectedMode = 0),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            title: 'Ôn ngẫu nhiên 20 câu',
            subtitle: 'Lấy ngẫu nhiên để luyện nhanh',
            selected: _selectedMode == 1,
            onTap: () => setState(() => _selectedMode = 1),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            title: 'Ôn câu điểm liệt',
            subtitle: 'Tập trung câu hỏi quan trọng',
            selected: _selectedMode == 2,
            onTap: () => setState(() => _selectedMode = 2),
          ),
          const SizedBox(height: 24),
          const Text(
            'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _gradeAfterSubmit = true;
                      _gradeInstantly = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chấm điểm sau khi nộp bài',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _gradeAfterSubmit ? '✔' : '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _gradeAfterSubmit = false;
                      _gradeInstantly = true;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chấm điểm nhanh khi chọn đáp án',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _gradeInstantly ? '✔' : '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bạn đang chọn: $_modeTitle - $_estimatedCount câu',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isLoading || _error != null || _totalQuestions == 0
          ? null
          : SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _estimatedCount == 0 ? null : _onStartPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              'Bắt đầu ôn luyện',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardDark
        : AppColors.cardLight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.primary.withValues(alpha: 0.1)
        : (Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardDark
        : AppColors.cardLight);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.primary : Colors.grey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 38, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String topicName;

  const _EmptyState({required this.topicName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Chưa có câu hỏi cho "$topicName".',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
