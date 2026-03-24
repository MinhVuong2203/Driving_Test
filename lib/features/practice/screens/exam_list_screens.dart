import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_dao.dart';
import 'package:driving_test_prep/data/repository/exam_sets_repository.dart';
import 'package:driving_test_prep/features/practice/screens/exam_detail_screen.dart';
import 'package:driving_test_prep/features/practice/widgets/exam_card.dart';
import 'package:flutter/material.dart';


class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExamListScreenState();

}

class _ExamListScreenState extends State<ExamListScreen>{
  late final db = DBProvider().db;
  late final ExamSetsRepository exam_repo;
  List<ExamSet> exams = [];

  @override
  void initState(){
    super.initState();
    exam_repo = ExamSetsRepository(ExamSetsDao(this.db));
    loadData();
  }

  Future<void> loadData() async {
    final data = await exam_repo.getExamByGroup(5);
    setState(() {
      exams = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn đề thi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: exams.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final exam = exams[index];
          return ExamCard(
            title: exam.name ?? 'Đề ${exam.id}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExamDetailScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}