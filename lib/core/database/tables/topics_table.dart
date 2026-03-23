import 'package:drift/drift.dart';

class Topics extends Table {
  IntColumn  get id          => integer()();
  TextColumn get name        => text()();
  TextColumn get fullname    => text()();
  TextColumn get description => text().nullable()();
}