import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/tables/questions_table.dart';

class SavedQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionId => integer().unique().nullable().references(Questions, #id)();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
