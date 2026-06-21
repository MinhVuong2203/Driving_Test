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

  @override
  void initState() {
    super.initState();
    _future = _loadHistory();
  }

  void _reload() {
    setState(() {
      _future = _loadHistory();
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.situation == null
        ? 'Lịch sử mô phỏng'
        : 'Lịch sử ${widget.situation!.displayTitle}';

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
