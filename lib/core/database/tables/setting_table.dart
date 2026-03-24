import 'package:drift/drift.dart';

class Setting extends Table {
  IntColumn get SettingId    => integer()();
  TextColumn get rankId      => text().withDefault(const Constant("A1"))();
  IntColumn get models       => integer().withDefault(const Constant(0))();
  IntColumn get mode         => integer().withDefault(const Constant(0))();
  IntColumn get vibration    => integer().withDefault(const Constant(0))();
}