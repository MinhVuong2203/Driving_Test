import 'package:drift/drift.dart';

@DataClassName('RecognitionHistoryData')
class RecognitionHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  TextColumn get result => text()();
  TextColumn get signName => text().nullable()();
  TextColumn get signType => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}