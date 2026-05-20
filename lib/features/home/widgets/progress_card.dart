import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  int total = 600;
  int correct = 0;
  int wrong = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final userProgressRepo = UserProgressRepository(UserProgressDao(DBProvider().db));
    final stats = await userProgressRepo.getProgressStats();
    if (mounted) {
      setState(() {
        total = stats['total'] ?? 600;
        correct = stats['correct'] ?? 0;
        wrong = stats['wrong'] ?? 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = total == 0 ? 0 : (correct + wrong) / total;
    if (progress > 1.0) progress = 1.0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tiến độ ôn tập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 6),
          if (isLoading)
            const Text('Đang tải...')
          else
            Text('${correct + wrong}/$total câu - $correct đúng, $wrong sai'),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
