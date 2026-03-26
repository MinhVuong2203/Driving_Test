import 'package:drift/drift.dart';

class TrafficSigns extends Table {
  TextColumn get signId    => text()();
  TextColumn get category  => text()();
  TextColumn get name      => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl  => text().nullable()();

  @override
  Set<Column> get primaryKey => {signId};
}