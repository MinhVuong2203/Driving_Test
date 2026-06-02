import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/features/home/widgets/menu_grid.dart';
import 'package:driving_test_prep/features/home/widgets/pro_banner.dart';
import 'package:driving_test_prep/features/home/widgets/progress_card.dart';
import 'package:driving_test_prep/features/home/widgets/topic_card.dart';
import 'package:driving_test_prep/features/practice/screens/exam_topic_screen.dart';
import 'package:driving_test_prep/features/practice/screens/exam_topic_quets_screen.dart';
import 'package:driving_test_prep/features/settings/screens/settings_screens.dart';
import 'package:driving_test_prep/data/services/firebase/user_vip_service.dart';
import 'package:driving_test_prep/shared/utils/app_state_notifiers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onUpgradeVip;

  const HomeScreen({super.key, this.onUpgradeVip});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<bool> _shouldShowProBanner;
  int _progressRefreshTrigger = 0;
  Map<int, Map<String, int>> _topicProgressStats = {};
  Map<String, int> _criticalProgressStats = {};

  late final SettingRepository _settingRepository = SettingRepository(
    SettingDao(DBProvider().db),
  );

  @override
  void initState() {
    super.initState();
    _shouldShowProBanner = _loadProBannerVisibility();
    rankNotifier.addListener(_refreshProgress);
    _loadTopicProgress();
  }

  @override
  void dispose() {
    rankNotifier.removeListener(_refreshProgress);
    super.dispose();
  }

  Future<bool> _loadProBannerVisibility() async {
    try {
      final vip = await UserVipService().getCurrentUserVip();
      return vip == null;
    } catch (_) {
      return false;
    }
  }

  void _refreshProgress() {
    if (!mounted) return;
    setState(() {
      _progressRefreshTrigger++;
    });
    _loadTopicProgress();
  }

  Future<void> _openPage(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _refreshProgress();
  }

  Future<void> _toggleThemeMode() async {
    final newMode = themeNotifier.value == 0 ? 1 : 0;
    themeNotifier.value = newMode;
    await _settingRepository.updateMode(newMode);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadTopicProgress() async {
    try {
      final repo = UserProgressRepository(UserProgressDao(DBProvider().db));
      final stats = await repo.getTopicProgressStats();
      final criticalStats = await repo.getCriticalProgressStats();
      if (!mounted) return;
      setState(() {
        _topicProgressStats = stats;
        _criticalProgressStats = criticalStats;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _topicProgressStats = {};
        _criticalProgressStats = {};
      });
    }
  }

  int _topicStat(int topicId, String key) {
    return _topicProgressStats[topicId]?[key] ?? 0;
  }

  int _criticalStat(String key) {
    return _criticalProgressStats[key] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _GlassIconButton(
            icon: Icons.settings_rounded,
            iconSize: 21,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ),
        title: const Text(
          'Ôn luyện GPLX',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ValueListenableBuilder<int>(
              valueListenable: themeNotifier,
              builder: (context, modeValue, _) {
                final isDark = modeValue == 0;
                return _GlassIconButton(
                  icon: isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  onPressed: _toggleThemeMode,
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // const _HomeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroHeader(),
                  const SizedBox(height: 16),
                  FutureBuilder<bool>(
                    future: _shouldShowProBanner,
                    builder: (context, snapshot) {
                      if (snapshot.data != true) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ProBanner(onUpgrade: widget.onUpgradeVip),
                      );
                    },
                  ),
                  MenuGrid(onNavigationComplete: _refreshProgress),
                  const SizedBox(height: 16),
                  ProgressCard(refreshTrigger: _progressRefreshTrigger),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ôn tập theo chủ đề',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Xem tất cả'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TopicCard(
                    title: 'Quy định chung và quy tắc giao thông đường bộ',
                    done: _topicStat(1, 'answered'),
                    total: _topicStat(1, 'total'),
                    correct: _topicStat(1, 'correct'),
                    wrong: _topicStat(1, 'wrong'),
                    accentColor: const Color(0xFF2F80ED),
                    icon: Icons.route_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 1));
                    },
                  ),
                  TopicCard(
                    title:
                        'Văn hóa giao thông, đạo đức người lái xe, kỹ năng phòng cháy, chữa cháy và cứu hộ, cứu nạn',
                    done: _topicStat(2, 'answered'),
                    total: _topicStat(2, 'total'),
                    correct: _topicStat(2, 'correct'),
                    wrong: _topicStat(2, 'wrong'),
                    accentColor: const Color(0xFFFF7A45),
                    icon: Icons.volunteer_activism_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 2));
                    },
                  ),
                  TopicCard(
                    title: 'Kỹ thuật lái xe',
                    done: _topicStat(3, 'answered'),
                    total: _topicStat(3, 'total'),
                    correct: _topicStat(3, 'correct'),
                    wrong: _topicStat(3, 'wrong'),
                    accentColor: const Color(0xFF14B8A6),
                    icon: Icons.sports_motorsports_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 3));
                    },
                  ),
                  TopicCard(
                    title: 'Cấu tạo và sửa chữa',
                    done: _topicStat(4, 'answered'),
                    total: _topicStat(4, 'total'),
                    correct: _topicStat(4, 'correct'),
                    wrong: _topicStat(4, 'wrong'),
                    accentColor: const Color(0xFF8B5CF6),
                    icon: Icons.build_circle_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 4));
                    },
                  ),
                  TopicCard(
                    title: 'Báo hiệu đường bộ',
                    done: _topicStat(5, 'answered'),
                    total: _topicStat(5, 'total'),
                    correct: _topicStat(5, 'correct'),
                    wrong: _topicStat(5, 'wrong'),
                    accentColor: const Color(0xFFEF4444),
                    icon: Icons.traffic_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 5));
                    },
                  ),
                  TopicCard(
                    title: 'Sa hình và kỹ năng xử lý tình huống giao thông',
                    done: _topicStat(6, 'answered'),
                    total: _topicStat(6, 'total'),
                    correct: _topicStat(6, 'correct'),
                    wrong: _topicStat(6, 'wrong'),
                    accentColor: const Color(0xFF06B6D4),
                    icon: Icons.map_rounded,
                    onPress: () {
                      _openPage(const ExamTopicScreen(topicId: 6));
                    },
                  ),
                  TopicCard(
                    title: 'Câu hỏi điểm liệt',
                    done: _criticalStat('answered'),
                    total: _criticalStat('total'),
                    correct: _criticalStat('correct'),
                    wrong: _criticalStat('wrong'),
                    accentColor: const Color(0xFFE11D48),
                    icon: Icons.warning_amber_rounded,
                    onPress: () {
                      _openPage(
                        const ExamTopicQuetsScreen(
                          topicId: -1,
                          mode: 2,
                          topicTitle: 'Câu hỏi điểm liệt',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0866FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0866FF).withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sẵn sàng bứt tốc',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Học nhanh,\nnhớ chắc luật',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Chọn bài ôn, luyện đề và theo dõi tiến độ mỗi ngày.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 52,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;

  const _GlassIconButton({
    required this.icon,
    this.iconSize = 24,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF0F172A),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
    );
  }
}
