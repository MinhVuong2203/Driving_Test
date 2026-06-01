import 'package:driving_test_prep/data/services/sqlite/question_image_cache_service.dart';
import 'package:flutter/material.dart';

class QuestionDataDownloadBanner extends StatelessWidget {
  const QuestionDataDownloadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QuestionImageDownloadState>(
      valueListenable: QuestionImageCacheService.progress,
      builder: (context, state, _) {
        if (!state.isRunning || state.total <= 0) {
          return const SizedBox.shrink();
        }

        final percent = ((state.completed / state.total) * 100)
            .clamp(0, 100)
            .round();

        return Positioned(
          top: MediaQuery.paddingOf(context).top + 54,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Đang tải dữ liệu $percent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
