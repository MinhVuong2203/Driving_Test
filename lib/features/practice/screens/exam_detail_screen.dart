import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/ranks_dao.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/ranks_repository.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/data/services/firebase/user_vip_service.dart';
import 'package:driving_test_prep/features/practice/screens/exam_sets_quest_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/car_animated_button.dart';
import 'package:flutter/material.dart';

class ExamDetailScreen extends StatefulWidget {
  final ExamSet exam;
  final String rankId;
  const ExamDetailScreen({super.key, required this.exam, required this.rankId});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  late final RanksRepository _ranksRepository = RanksRepository(
    RanksDao(DBProvider().db),
  );
  late final SettingRepository _settingRepository = SettingRepository(
    SettingDao(DBProvider().db),
  );
  late final UserProgressRepository _userProgressRepository =
      UserProgressRepository(UserProgressDao(DBProvider().db));
  bool isChecked1 = true;
  bool isChecked2 = false;
  Rank? rank;
  bool _isVipActive = false;
  int _answeredCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    loadRanks();
  }

  Future<void> loadRanks() async {
    final rs = await _ranksRepository.getRankById(widget.rankId);
    final setting = await _settingRepository.getSetting();
    final currentVip = await UserVipService().getCurrentUserVip();
    final progress = await _userProgressRepository.getExamSetProgressStatsById(
      widget.exam.id,
    );
    final gradeInstantly = setting?.models == 1;

    if (!mounted) return;
    setState(() {
      rank = rs;
      isChecked1 = !gradeInstantly;
      isChecked2 = gradeInstantly;
      _isVipActive = currentVip != null;
      _answeredCount = progress['answered'] ?? 0;
      _totalCount = progress['total'] ?? 0;
    });
  }

  Future<void> _resetExamProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset đề này?'),
        content: const Text(
          'Toàn bộ đáp án đã lưu của đề đang chọn sẽ được xóa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _userProgressRepository.resetExamSetProgress(widget.exam.id);
    await loadRanks();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã reset tiến độ đề này.')));
  }

  @override
  Widget build(BuildContext context) {
    if (rank == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isVipActive && _answeredCount > 0)
            IconButton(
              tooltip: 'Reset đề',
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: _resetExamProgress,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thi thử lý thuyết - hạng ${rank?.rankId}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Box thông tin
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Số lượng câu hỏi', style: TextStyle(fontSize: 16)),
                      Text(
                        '${rank?.totalExam} câu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Thời gian làm bài', style: TextStyle(fontSize: 16)),
                      Text(
                        '${rank?.time} phút',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Điểm đậu tối thiểu',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${rank?.totalPass}/${rank?.totalExam} câu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_isVipActive && _answeredCount > 0) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _resetExamProgress,
                icon: const Icon(Icons.restart_alt_rounded),
                label: Text('Reset đề đã làm ($_answeredCount/$_totalCount)'),
              ),
            ],

            const SizedBox(height: 40),

            const Text(
              'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isChecked1 = true;
                        isChecked2 = false;
                      });
                      await _settingRepository.updateModels(0);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chấm điểm sau khi nộp bài',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          isChecked1 ? '✔' : '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isChecked1 = false;
                        isChecked2 = true;
                      });
                      await _settingRepository.updateModels(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chấm điểm nhanh khi chọn đáp án',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          isChecked2 ? '✔' : '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // StartButton(
            //   onTap: ()
            // ),
            Center(
              child: CarAnimatedButton(
                text: 'BẮT ĐẦU LÀM BÀI',
                width: 360,
                time: 500,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExamSetsQuestScreen(
                        examSetId: widget.exam.id,
                        examTitle: widget.exam.name ?? 'Đề ${widget.exam.id}',
                        durationMinutes: rank?.time ?? 20,
                        gradeInstantly: isChecked2,
                        passScore: rank?.totalPass ?? 0,
                      ),
                    ),
                  );
                  if (!mounted) return;
                  await loadRanks();
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
