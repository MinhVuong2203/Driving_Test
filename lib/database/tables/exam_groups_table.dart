import 'package:drift/drift.dart';

class ExamGroups extends Table {
  @override
  String get tableName => 'exam_groups';

  IntColumn  get examGroupsId    => integer().autoIncrement()();
  TextColumn get name            => text().nullable()();
  IntColumn  get totalQuestions  => integer().nullable()();
}