import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_dao.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/exam_sets_repository.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/data/services/firebase/user_vip_service.dart';
import 'package:driving_test_prep/features/practice/screens/exam_detail_screen.dart';
import 'package:driving_test_prep/features/practice/screens/exam_result_screen.dart';
import 'package:driving_test_prep/features/practice/widgets/exam_card.dart';
import 'package:flutter/material.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late final SettingRepository _settingRepository = SettingRepository(
    SettingDao(DBProvider().db),
  );
  late final ExamSetsRepository examRepo;
  late final UserProgressRepository userProgressRepo;

  List<ExamSet> exams = [];
  Map<int, Map<String, int>> _progressByExamId = {};
  Map<int, ExamSetResultSummary> _resultByExamId = {};
  SettingData? st;
  bool _isVipActive = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    examRepo = ExamSetsRepository(ExamSetsDao(DBProvider().db));
    userProgressRepo = UserProgressRepository(UserProgressDao(DBProvider().db));
    loadData();
  }

  Future<void> loadData() async {
    final setting = await _settingRepository.getSetting();
    if (setting == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final data = await examRepo.getExamByRank(setting.rankId);
    final progress = await userProgressRepo.getExamSetProgressStats(
      data.map((exam) => exam.id).toList(),
    );
    final results = await userProgressRepo.getExamSetResultSummaries(
      data.map((exam) => exam.id).toList(),
    );
    final currentVip = await UserVipService().getCurrentUserVip();

    if (!mounted) return;
    setState(() {
      st = setting;
      exams = data;
      _progressByExamId = progress;
      _resultByExamId = results;
      _isVipActive = currentVip != null;
      _isLoading = false;
    });
  }

  bool _isLockedExam(int index) {
    if (_isVipActive || exams.length <= 10) return false;
    return index >= exams.length - 10;
  }

  void _showVipRequiredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nâng cấp VIP để mở 10 đề cuối.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setting = st;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn đề thi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: exams.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final exam = exams[index];
                final isLocked = _isLockedExam(index);
                final progress = _progressByExamId[exam.id];
                final result = _resultByExamId[exam.id];
                final answered = progress?['answered'] ?? 0;
                final total = progress?['total'] ?? 0;
                final isCompleted = total > 0 && answered >= total;

                return ExamCard(
                  title: exam.name ?? 'Đề ${exam.id}',
                  locked: isLocked,
                  answered: answered,
                  total: total,
                  resultLabel: result == null
                      ? null
                      : (result.isPassed ? 'Đạt' : 'Rớt'),
                  passed: result?.isPassed,
                  onTap: () {
                    if (isLocked || setting == null) {
                      _showVipRequiredMessage();
                      return;
                    }

                    if (isCompleted || result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamResultScreen(
                            examSetId: exam.id,
                            examTitle: exam.name ?? 'Đề ${exam.id}',
                            passScore: 0,
                          ),
                        ),
                      ).then((_) => loadData());
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamDetailScreen(
                          exam: exam,
                          rankId: setting.rankId,
                        ),
                      ),
                    ).then((_) => loadData());
                  },
                );
              },
            ),
    );
  }
}
