import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/tables/topics_table.dart';

class PracticeSessions extends Table {
  IntColumn  get id             => integer().autoIncrement()();
  TextColumn get mode           => text().nullable()();
  IntColumn  get topicId        => integer().nullable().references(Topics, #id)();
  IntColumn  get totalQuestions => integer().nullable()();
  IntColumn  get correctAnswers => integer().nullable()();
  IntColumn  get score          => integer().nullable()();
  DateTimeColumn get createdAt  => dateTime().withDefault(currentDateAndTime)();
}