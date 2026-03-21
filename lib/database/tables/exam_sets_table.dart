import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/exam_groups_table.dart';

class ExamSets extends Table {
  IntColumn  get id           => integer()();
  IntColumn  get examGroupsId => integer().references(ExamGroups, #examGroupsId)();
  TextColumn get name         => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

}