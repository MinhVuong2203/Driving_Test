import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/repository/simulation_situation_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SimulationExamResultScreen extends StatelessWidget {
  final int totalScore;
  final List<SimulationSituation> situations;
  final List<SimulationExamAnswerInput> answers;

  const SimulationExamResultScreen({
    super.key,
    required this.totalScore,
    required this.situations,
    required this.answers,
  });

  bool get isPassed =>
      totalScore >= SimulationSituationRepository.simulationPassingScore;

  String _formatSecond(double? second) {
    if (second == null) return 'Chưa gắn cờ';
    return '${second.toStringAsFixed(2)}s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = isPassed ? AppColors.success : AppColors.danger;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả thi mô phỏng'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(
                  isPassed
                      ? Icons.emoji_events_rounded
                      : Icons.error_outline_rounded,
                  color: statusColor,
                  size: 38,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPassed ? 'Đạt' : 'Không đạt',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalScore/${SimulationSituationRepository.simulationMaxScore} điểm',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Điểm đạt: ${SimulationSituationRepository.simulationPassingScore}/50',
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
          const SizedBox(height: 16),
          Text(
            'Chi tiết bài thi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < answers.length; index++) ...[
            _ResultItem(
              index: index,
              situation: situations[index],
              answer: answers[index],
              isDark: isDark,
              formatSecond: _formatSecond,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          FilledButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home_rounded),
            label: const Text('Về trang chính'),
          ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final int index;
  final SimulationSituation situation;
  final SimulationExamAnswerInput answer;
  final bool isDark;
  final String Function(double?) formatSecond;

  const _ResultItem({
    required this.index,
    required this.situation,
    required this.answer,
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
            width: 44,
            height: 44,
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
                  'Câu ${index + 1}: ${situation.displayTitle}',
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
