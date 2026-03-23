import 'package:drift/drift.dart';

class ExamHistory extends Table {
  IntColumn  get id             => integer().autoIncrement()();
  TextColumn get licenseType    => text().nullable()();
  IntColumn  get totalQuestions => integer().nullable()();
  IntColumn  get correctAnswers => integer().nullable()();
  IntColumn  get isPassed       => integer().nullable()();
  IntColumn  get timeSpent      => integer().nullable()();
  DateTimeColumn get createdAt  => dateTime().withDefault(currentDateAndTime)();
}