import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/exam_groups_table.dart';

class ExamSets extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  IntColumn  get examGroupsId => integer().nullable().references(ExamGroups, #examGroupsId)();
  TextColumn get name         => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}