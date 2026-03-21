import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/topics_table.dart';

class Questions extends Table {
  IntColumn  get id            => integer()();
  IntColumn  get topicId       => integer().nullable().references(Topics, #id)();
  TextColumn get question      => text()();
  TextColumn get imageUrl      => text().nullable()();
  TextColumn get answerA       => text().nullable()();
  TextColumn get answerB       => text().nullable()();
  TextColumn get answerC       => text().nullable()();
  TextColumn get answerD       => text().nullable()();
  IntColumn  get ofRankA       => integer().withDefault(const Constant(0))();
  IntColumn  get ofRankB1      => integer().withDefault(const Constant(0))();
  TextColumn get correctAnswer => text()();
  TextColumn get explanation   => text().nullable()();
  IntColumn  get isCritical    => integer().withDefault(const Constant(0))();
}