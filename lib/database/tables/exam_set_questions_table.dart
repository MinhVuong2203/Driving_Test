import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/exam_sets_table.dart';
import 'package:driving_test_prep/database/tables/questions_table.dart';

class ExamSetQuestions extends Table {
  IntColumn get id            => integer().autoIncrement()();
  IntColumn get examSetId     => integer().nullable().references(ExamSets, #id)();
  IntColumn get questionId    => integer().nullable().references(Questions, #id)();
  IntColumn get questionOrder => integer().nullable()();
}