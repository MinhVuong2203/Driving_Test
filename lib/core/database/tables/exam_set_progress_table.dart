import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/tables/exam_sets_table.dart';

class ExamSetProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get examSetId => integer().references(ExamSets, #id)();
  TextColumn get rankId => text().nullable()();
  IntColumn get remainingSeconds => integer().nullable()();
  IntColumn get totalQuestions => integer().nullable()();
  IntColumn get correctAnswers => integer().nullable()();
  IntColumn get isPassed => integer().nullable()();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
