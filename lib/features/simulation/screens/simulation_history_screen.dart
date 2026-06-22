import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/repository/simulation_situation_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SimulationHistoryScreen extends StatefulWidget {
  final SimulationSituation? situation;
  final List<SimulationSituation> situations;

  const SimulationHistoryScreen({
    super.key,
    this.situation,
    this.situations = const [],
  });

  @override
  State<SimulationHistoryScreen> createState() =>
      _SimulationHistoryScreenState();
}

class _SimulationHistoryScreenState extends State<SimulationHistoryScreen> {
  final _repository = SimulationSituationRepository.remote();

  late Future<_HistoryViewData> _future;
  late Future<_ExamHistoryViewData> _examFuture;

  @override
  void initState() {
    super.initState();
    _future = _loadHistory();
    _examFuture = _loadExamHistory();
  }

  void _reload() {
    setState(() {
      _future = _loadHistory();
      _examFuture = _loadExamHistory();
    });
  }

  Future<_HistoryViewData> _loadHistory() async {
    final attempts = widget.situation == null
        ? await _repository.getRecentAttemptHistory()
        : await _repository.getAttemptHistory(widget.situation!.id);

    final situations = widget.situations.isNotEmpty
        ? widget.situations
        : widget.situation == null
            ? await _repository.getAllActive()
            : [widget.situation!];

    return _HistoryViewData(
      attempts: attempts,
      situationsById: {
        for (final situation in situations) situation.id: situation,
      },
    );
  }

  Future<_ExamHistoryViewData> _loadExamHistory() async {
    final sessions = await _repository.getExamHistory();
    final situations = widget.situations.isNotEmpty
        ? widget.situations
        : await _repository.getAllActive();

    return _ExamHistoryViewData(
      sessions: sessions,
      situationsById: {
        for (final situation in situations) situation.id: situation,
      },
    );
  }

  String _formatSecond(double second) {
    return '${second.toStringAsFixed(2)}s';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/${date.year} $hour:$minute';
  }

  Future<bool> _confirmDeleteOne() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa lượt làm này?'),
            content: const Text('Lịch sử đã xóa sẽ không thể khôi phục.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteAttempt(SimulationAttemptHistory attempt) async {
    try {
      await _repository.deleteAttempt(attempt.id);
      if (!mounted) return;
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa lịch sử.')),
      );
    }
  }

  Future<bool> _confirmDeleteExamSession() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa lần thi này?'),
            content: const Text(
              'Chi tiết từng câu trong lần thi này cũng sẽ bị xóa.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteExamSession(
    SimulationExamSessionHistory session,
  ) async {
    try {
      await _repository.deleteExamHistorySession(session.id);
      if (!mounted) return;
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa lịch sử thi.')),
      );
    }
  }

  Future<void> _clearExamHistory() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa tất cả lịch sử thi?'),
            content: const Text(
              'Toàn bộ các lần thi mô phỏng và chi tiết câu trả lời sẽ bị xóa.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa tất cả'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    try {
      await _repository.clearExamHistory();
      if (!mounted) return;
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa lịch sử thi.')),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa tất cả lịch sử?'),
            content: Text(
              widget.situation == null
                  ? 'Toàn bộ lịch sử làm mô phỏng sẽ bị xóa.'
                  : 'Toàn bộ lịch sử của tình huống này sẽ bị xóa.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa tất cả'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    try {
      await _repository.clearAttemptHistory(
        situationId: widget.situation?.id,
      );
      if (!mounted) return;
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa lịch sử.')),
      );
    }
  }

  Widget _buildPracticeHistory(bool isDark) {
    return FutureBuilder<_HistoryViewData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _HistoryEmptyState(
            icon: Icons.error_outline_rounded,
            message: snapshot.error.toString().replaceFirst('Exception: ', ''),
          );
        }

        final data = snapshot.data;
        final attempts = data?.attempts ?? const <SimulationAttemptHistory>[];
        if (attempts.isEmpty) {
          return const _HistoryEmptyState(
            icon: Icons.history_rounded,
            message: 'Chưa có lịch sử làm mô phỏng.',
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            OutlinedButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep_rounded),
              label: const Text('Xóa tất cả lịch sử ôn'),
            ),
            const SizedBox(height: 12),
            for (final attempt in attempts) ...[
              _PracticeAttemptTile(
                attempt: attempt,
                situation: data?.situationsById[attempt.situationId],
                isDark: isDark,
                formatSecond: _formatSecond,
                formatDate: _formatDate,
                confirmDelete: _confirmDeleteOne,
                deleteAttempt: _deleteAttempt,
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }

  Widget _buildExamHistory(bool isDark) {
    return FutureBuilder<_ExamHistoryViewData>(
      future: _examFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _HistoryEmptyState(
            icon: Icons.error_outline_rounded,
            message: snapshot.error.toString().replaceFirst('Exception: ', ''),
          );
        }

        final data = snapshot.data;
        final sessions =
            data?.sessions ?? const <SimulationExamSessionHistory>[];
        if (sessions.isEmpty) {
          return const _HistoryEmptyState(
            icon: Icons.assignment_turned_in_rounded,
            message: 'Chưa có lịch sử thi mô phỏng.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: sessions.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == 0) {
              return OutlinedButton.icon(
                onPressed: _clearExamHistory,
                icon: const Icon(Icons.delete_sweep_rounded),
                label: const Text('Xóa tất cả lịch sử thi'),
              );
            }

            final session = sessions[index - 1];
            final statusColor =
                session.isPassed ? AppColors.success : AppColors.danger;

            return Dismissible(
              key: ValueKey('simulation-exam-session-${session.id}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmDeleteExamSession(),
              onDismissed: (_) => _deleteExamSession(session),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                ),
              ),
              child: Material(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _SimulationExamHistoryDetailScreen(
                        session: session,
                        situationsById:
                            data?.situationsById ??
                            const <int, SimulationSituation>{},
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${session.totalScore}/50',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.isPassed ? 'Đạt' : 'Không đạt',
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Nộp bài: ${_formatDate(session.submittedAt)}',
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
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.situation == null
        ? 'Lịch sử mô phỏng'
        : 'Lịch sử ${widget.situation!.displayTitle}';

    if (widget.situation == null) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Ôn tập'),
                Tab(text: 'Thi mô phỏng'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildPracticeHistory(isDark),
              _buildExamHistory(isDark),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: _clearAll,
            tooltip: 'Xóa tất cả',
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
        ],
      ),
      body: FutureBuilder<_HistoryViewData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _HistoryEmptyState(
              icon: Icons.error_outline_rounded,
              message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            );
          }

          final data = snapshot.data;
          final attempts = data?.attempts ?? const <SimulationAttemptHistory>[];
          if (attempts.isEmpty) {
            return const _HistoryEmptyState(
              icon: Icons.history_rounded,
              message: 'Chưa có lịch sử làm mô phỏng.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: attempts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              final situation = data?.situationsById[attempt.situationId];

              return Dismissible(
                key: ValueKey('simulation-attempt-${attempt.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDeleteOne(),
                onDismissed: (_) => _deleteAttempt(attempt),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${attempt.score}/5',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              situation?.displayTitle ??
                                  'Tình huống ${attempt.situationId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gắn cờ ${_formatSecond(attempt.flagSecond)} • ${_formatDate(attempt.createdAt)}',
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryViewData {
  final List<SimulationAttemptHistory> attempts;
  final Map<int, SimulationSituation> situationsById;

  const _HistoryViewData({
    required this.attempts,
    required this.situationsById,
  });
}

class _ExamHistoryViewData {
  final List<SimulationExamSessionHistory> sessions;
  final Map<int, SimulationSituation> situationsById;

  const _ExamHistoryViewData({
    required this.sessions,
    required this.situationsById,
  });
}

class _PracticeAttemptTile extends StatelessWidget {
  final SimulationAttemptHistory attempt;
  final SimulationSituation? situation;
  final bool isDark;
  final String Function(double) formatSecond;
  final String Function(DateTime) formatDate;
  final Future<bool> Function() confirmDelete;
  final Future<void> Function(SimulationAttemptHistory) deleteAttempt;

  const _PracticeAttemptTile({
    required this.attempt,
    required this.situation,
    required this.isDark,
    required this.formatSecond,
    required this.formatDate,
    required this.confirmDelete,
    required this.deleteAttempt,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('simulation-attempt-${attempt.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => confirmDelete(),
      onDismissed: (_) => deleteAttempt(attempt),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      child: Container(
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
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${attempt.score}/5',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    situation?.displayTitle ??
                        'Tình huống ${attempt.situationId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gắn cờ ${formatSecond(attempt.flagSecond)} • ${formatDate(attempt.createdAt)}',
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
      ),
    );
  }
}

class _SimulationExamHistoryDetailScreen extends StatefulWidget {
  final SimulationExamSessionHistory session;
  final Map<int, SimulationSituation> situationsById;

  const _SimulationExamHistoryDetailScreen({
    required this.session,
    required this.situationsById,
  });

  @override
  State<_SimulationExamHistoryDetailScreen> createState() =>
      _SimulationExamHistoryDetailScreenState();
}

class _SimulationExamHistoryDetailScreenState
    extends State<_SimulationExamHistoryDetailScreen> {
  final _repository = SimulationSituationRepository.remote();

  late final Future<List<SimulationExamAnswerHistory>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getExamAnswerHistory(widget.session.id);
  }

  String _formatSecond(double? second) {
    if (second == null) return 'Chưa gắn cờ';
    return '${second.toStringAsFixed(2)}s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor =
        widget.session.isPassed ? AppColors.success : AppColors.danger;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bài thi')),
      body: FutureBuilder<List<SimulationExamAnswerHistory>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final answers =
              snapshot.data ?? const <SimulationExamAnswerHistory>[];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: statusColor.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.session.isPassed
                          ? Icons.emoji_events_rounded
                          : Icons.error_outline_rounded,
                      color: statusColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${widget.session.isPassed ? 'Đạt' : 'Không đạt'} • ${widget.session.totalScore}/50 điểm',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (final answer in answers) ...[
                _ExamAnswerTile(
                  answer: answer,
                  situation: widget.situationsById[answer.situationId],
                  isDark: isDark,
                  formatSecond: _formatSecond,
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ExamAnswerTile extends StatelessWidget {
  final SimulationExamAnswerHistory answer;
  final SimulationSituation? situation;
  final bool isDark;
  final String Function(double?) formatSecond;

  const _ExamAnswerTile({
    required this.answer,
    required this.situation,
    required this.isDark,
    required this.formatSecond,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${answer.score}/5',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu ${answer.orderIndex + 1}: ${situation?.displayTitle ?? 'Tình huống ${answer.situationId}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gắn cờ: ${formatSecond(answer.flagSecond)}',
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

class _HistoryEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _HistoryEmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
