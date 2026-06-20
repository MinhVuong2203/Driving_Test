import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ScoringModeSection extends StatelessWidget {
  final bool scoringAfterSubmit;
  final ValueChanged<bool> onChanged;

  const ScoringModeSection({
    super.key,
    required this.scoringAfterSubmit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.lightDivider;

    return Column(
      children: [
        _ScoringOptionTile(
          title: 'Chấm điểm sau khi nộp bài',
          isSelected: scoringAfterSubmit,
          onTap: () => onChanged(true),
          cardColor: cardColor,
          textColor: primaryTextColor,
        ),
        Divider(height: 1, indent: 16, color: dividerColor),
        _ScoringOptionTile(
          title: 'Chấm điểm nhanh khi chọn đáp án',
          isSelected: !scoringAfterSubmit,
          onTap: () => onChanged(false),
          cardColor: cardColor,
          textColor: primaryTextColor,
        ),
        Container(
          color: cardColor,

          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Ứng dụng sẽ chấm điểm và hiển thị kết quả sau khi bạn nộp bài thi.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• Chế độ này tương tự khi thi sát hạch và phù hợp để luyện tập thi thử.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoringOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color cardColor;
  final Color textColor;

  const _ScoringOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blue, size: 22),
          ],
        ),
      ),
    );
  }
}
