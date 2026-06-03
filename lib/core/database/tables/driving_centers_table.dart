import 'package:drift/drift.dart';

@DataClassName('DrivingCenterRecord')
class DrivingCenterRecords extends Table {
  TextColumn get id => text()();
  TextColumn get province => text()();
  TextColumn get name => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get photoUrl => text()();
  TextColumn get website => text()();
  RealColumn get rating => real().withDefault(const Constant(0))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  TextColumn get businessStatus => text()();
  TextColumn get address => text()();
  TextColumn get district => text()();
  TextColumn get city => text()();
  TextColumn get openingStatus => text()();
  TextColumn get searchQuery => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get cachedPage => integer()();
  IntColumn get pageSize => integer()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {province, id};
}

@DataClassName('DrivingCenterPageCache')
class DrivingCenterPageCaches extends Table {
  TextColumn get province => text()();
  IntColumn get page => integer()();
  IntColumn get pageSize => integer()();
  IntColumn get total => integer().withDefault(const Constant(0))();
  BoolColumn get hasMore => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {province, page};
}
