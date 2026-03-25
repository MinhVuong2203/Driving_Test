import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DeleteHistoryTile extends StatelessWidget {
  final VoidCallback onTap;

  const DeleteHistoryTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color:Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Xoá dữ liệu lịch sử',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: const Text(
            'Xoá tất cả dữ liệu lịch sử ôn tập và làm bài thi thử.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}