import 'package:driving_test_prep/features/home/screens/traffic_sign_screen.dart';
import 'package:driving_test_prep/features/practice/screens/exam_list_screens.dart';
import 'package:driving_test_prep/features/practice/screens/exam_topic_quets_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MenuGrid extends StatelessWidget {
  final VoidCallback? onNavigationComplete;

  const MenuGrid({super.key, this.onNavigationComplete});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.assignment_rounded,
        text: 'Thi thử',
        color: const Color(0xFF0866FF),
        route: const ExamListScreen(),
      ),
      _MenuItem(
        icon: Icons.close_rounded,
        text: 'Câu sai',
        color: const Color(0xFFEF4444),
        route: const ExamTopicQuetsScreen(
          topicId: -1,
          mode: 4,
          gradeInstantly: true,
          topicTitle: 'Câu làm sai',
        ),
      ),
      _MenuItem(
        icon: Icons.bookmark_rounded,
        text: 'Đã lưu',
        color: const Color(0xFFF59E0B),
        route: const ExamTopicQuetsScreen(
          topicId: -1,
          mode: 3,
          gradeInstantly: true,
          topicTitle: 'Câu đã lưu',
        ),
      ),
      _MenuItem(
        icon: Icons.menu_book_rounded,
        text: 'Câu khó',
        color: const Color(0xFF16A34A),
        route: const ExamTopicQuetsScreen(
          topicId: -1,
          mode: 2,
          topicTitle: 'Câu hỏi điểm liệt',
        ),
      ),
      _MenuItem(
        icon: Icons.change_history_rounded,
        text: 'Sa hình',
        color: const Color(0xFF8B5CF6),
      ),
      _MenuItem(
        icon: Icons.lightbulb_rounded,
        text: 'Mẹo',
        color: const Color(0xFFEA580C),
      ),
      _MenuItem(
        icon: Icons.traffic_rounded,
        text: 'Biển báo',
        color: const Color(0xFFE11D48),
        route: const TrafficSignsScreen(),
      ),
      _MenuItem(
        icon: Icons.forum_rounded,
        text: 'Hỏi đáp',
        color: const Color(0xFF2563EB),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.82,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                if (item.route != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.route!),
                  );
                  onNavigationComplete?.call();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(item.icon, color: item.color, size: 25),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.text,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String text;
  final Color color;
  final Widget? route;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.color,
    this.route,
  });
}
