import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/questions_table.dart';

class WrongQuestions extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  IntColumn  get questionId  => integer().unique().nullable().references(Questions, #id)();
  IntColumn  get wrongCount  => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastWrongAt => dateTime().withDefault(currentDateAndTime)();
}