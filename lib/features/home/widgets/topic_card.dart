import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {

  final String title;
  final int done;
  final int total;
  final int correct;
  final int wrong;

  const TopicCard({
    super.key,
    required this.title,
    required this.done,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: done / total),
          const SizedBox(height: 6),
          Text('$done/$total câu hỏi - $correct đúng, $wrong sai'),
        ],
      ),
    );
  }

}