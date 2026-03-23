import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/tables/practice_sessions_table.dart';
import 'package:driving_test_prep/core/database/tables/questions_table.dart';

class UserAnswers extends Table {
  IntColumn  get id             => integer().autoIncrement()();
  IntColumn  get sessionId      => integer().nullable().references(PracticeSessions, #id)();
  IntColumn  get questionId     => integer().nullable().references(Questions, #id)();
  TextColumn get selectedAnswer => text().nullable()();
  IntColumn  get isCorrect      => integer().nullable()();
}