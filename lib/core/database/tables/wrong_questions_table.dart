import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/tables/questions_table.dart';

class WrongQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionId => integer().nullable().references(Questions, #id)();
  TextColumn get rankId => text().nullable()();
  IntColumn get wrongCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastWrongAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {questionId, rankId},
  ];
}
