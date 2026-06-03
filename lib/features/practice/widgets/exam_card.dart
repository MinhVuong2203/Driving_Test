import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool locked;
  final int answered;
  final int total;
  final String? resultLabel;
  final bool? passed;

  const ExamCard({
    super.key,
    required this.title,
    required this.onTap,
    this.locked = false,
    this.answered = 0,
    this.total = 0,
    this.resultLabel,
    this.passed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total <= 0 ? 0.0 : (answered / total).clamp(0.0, 1.0);
    final hasProgress = progress > 0;
    final progressColor = progress >= 1
        ? AppColors.success.withValues(alpha: 0.72)
        : AppColors.primary.withValues(alpha: 0.56);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark
              : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasProgress)
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: locked ? Colors.grey : null,
                      ),
                    ),
                    if (resultLabel != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (passed == true
                                      ? AppColors.success
                                      : AppColors.danger)
                                  .withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          resultLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: passed == true
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (locked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
