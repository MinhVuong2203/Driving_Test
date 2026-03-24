import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/ranks_dao.dart';
import 'package:driving_test_prep/data/repository/ranks_repository.dart';
import 'package:driving_test_prep/features/practice/screens/exam_sets_quest_screen.dart';
import 'package:driving_test_prep/features/practice/widgets/start_button.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
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
  bool isChecked1 = true;
  bool isChecked2 = false;
  Rank? rank;

  @override
  void initState() {
    super.initState();
    loadRanks();
  }

  Future<void> loadRanks() async {
    final rs = await _ranksRepository.getRankById(widget.rankId);
    setState(() {
      rank = rs;
    });
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
                    onTap: () {
                      setState(() {
                        isChecked1 = true;
                        isChecked2 = false;
                      });
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
                    onTap: () {
                      setState(() {
                        isChecked1 = false;
                        isChecked2 = true;
                      });
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

            StartButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExamSetsQuestScreen(
                      examSetId: widget.exam.id,
                      durationMinutes: rank?.time ?? 20,
                      gradeInstantly:
                          isChecked2, // Chấm điểm nhanh khi chọn đáp án
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
