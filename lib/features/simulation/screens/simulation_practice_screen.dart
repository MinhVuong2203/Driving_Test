import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/repository/simulation_situation_repository.dart';
import 'package:driving_test_prep/features/simulation/screens/simulation_history_screen.dart';
import 'package:driving_test_prep/features/simulation/screens/simulation_situation_list_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SimulationPracticeScreen extends StatefulWidget {
  const SimulationPracticeScreen({super.key});

  @override
  State<SimulationPracticeScreen> createState() =>
      _SimulationPracticeScreenState();
}

class _SimulationPracticeScreenState extends State<SimulationPracticeScreen> {
  final _repository = SimulationSituationRepository.remote();

  late final Future<List<SimulationSituation>> _future;

  static const _chapters = [
    _SimulationChapter(
      id: 1,
      title: 'Khu đô thị, dân cư đông đúc',
      icon: Icons.apartment_rounded,
      color: Color(0xFF2563EB),
    ),
    _SimulationChapter(
      id: 2,
      title: 'Đường gấp khúc vào buổi tối',
      icon: Icons.dark_mode_rounded,
      color: Color(0xFF7C3AED),
    ),
    _SimulationChapter(
      id: 3,
      title: 'Đường cao tốc',
      icon: Icons.speed_rounded,
      color: Color(0xFFE11D48),
    ),
    _SimulationChapter(
      id: 4,
      title: 'Đường đồi, núi',
      icon: Icons.terrain_rounded,
      color: Color(0xFF16A34A),
    ),
    _SimulationChapter(
      id: 5,
      title: 'Khu vực ngoại thành',
      icon: Icons.nature_people_rounded,
      color: Color(0xFFF59E0B),
    ),
    _SimulationChapter(
      id: 6,
      title: 'Tình huống hỗn hợp',
      icon: Icons.route_rounded,
      color: Color(0xFF0891B2),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _future = _repository.getAllActive();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn thi mô phỏng'),
      ),
      body: FutureBuilder<List<SimulationSituation>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(
              message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            );
          }

          final situations = snapshot.data ?? [];
          if (situations.isEmpty) {
            return const _ErrorState(message: 'Chưa có dữ liệu mô phỏng.');
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _SummaryPanel(total: situations.length),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SimulationHistoryScreen(
                        situations: situations,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history_rounded),
                label: const Text('Xem lịch sử làm'),
              ),
              const SizedBox(height: 16),
              Text(
                'Chọn chủ đề',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
              ..._chapters.map((chapter) {
                final chapterSituations = _repository.filterByChapter(
                  situations,
                  chapter.id,
                );

                return _ChapterCard(
                  chapter: chapter,
                  count: chapterSituations.length,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SimulationSituationListScreen(
                          chapterId: chapter.id,
                          chapterTitle: chapter.title,
                          situations: chapterSituations,
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final int total;

  const _SummaryPanel({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.personal_video_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '120 tình huống mô phỏng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Đã tải $total tình huống để ôn theo từng chủ đề.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 13,
                    height: 1.3,
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

class _ChapterCard extends StatelessWidget {
  final _SimulationChapter chapter;
  final int count;
  final bool isDark;
  final VoidCallback onTap;

  const _ChapterCard({
    required this.chapter,
    required this.count,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
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
                  decoration: BoxDecoration(
                    color: chapter.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(chapter.icon, color: chapter.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chương ${chapter.id}',
                        style: TextStyle(
                          color: chapter.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        chapter.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$count tình huống',
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
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 44),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimulationChapter {
  final int id;
  final String title;
  final IconData icon;
  final Color color;

  const _SimulationChapter({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}
