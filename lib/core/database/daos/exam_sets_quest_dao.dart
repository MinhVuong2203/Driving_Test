import 'package:drift/drift.dart';

import '../app_database.dart';

class ExamQuestionView {
  final ExamSetQuestion link;
  final Question question;

  ExamQuestionView({
    required this.link,
    required this.question,
  });
}

class ExamSetsQuestDao {
  final AppDatabase db;
  ExamSetsQuestDao(this.db);

  // Lấy tất cả câu hỏi của exam set dựa trên exam set id
  Future<List<ExamQuestionView>> getExamQuestions(int examSetId) async {
    final query = db.select(db.examSetQuestions).join([
      innerJoin(
        db.questions,
        db.questions.id.equalsExp(db.examSetQuestions.questionId),
      ),
    ])
      ..where(db.examSetQuestions.examSetId.equals(examSetId))
      ..orderBy([OrderingTerm.asc(db.examSetQuestions.questionOrder)]);

    final rows = await query.get();

    return rows
        .map(
          (row) => ExamQuestionView(
        link: row.readTable(db.examSetQuestions),
        question: row.readTable(db.questions),
      ),
    )
        .toList();
  }
}