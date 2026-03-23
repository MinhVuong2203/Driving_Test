import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/tables/exam_groups_table.dart';

class Ranks extends Table {
  TextColumn get rankId         => text()();
  TextColumn get name           => text()();
  TextColumn get description    => text().nullable()();
  IntColumn  get totalQuestions => integer().nullable()();
  IntColumn  get totalExam      => integer().nullable()();
  IntColumn  get totalPass      => integer().nullable()();
  IntColumn  get time           => integer().nullable()();
  IntColumn  get examGroupsId   => integer().nullable().references(ExamGroups, #examGroupsId)();

  @override
  Set<Column> get primaryKey => {rankId};
}