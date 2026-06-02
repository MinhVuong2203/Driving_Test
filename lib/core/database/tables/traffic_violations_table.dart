import 'package:drift/drift.dart';

@DataClassName('TrafficViolationRecord')
class TrafficViolationRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get vehicleTypesJson => text()();
  TextColumn get subjectText => text()();
  TextColumn get penaltyText => text()();
  TextColumn get penaltyLegalBasis => text()();
  TextColumn get additionalPenaltyText => text()();
  TextColumn get additionalPenaltyLegalBasis => text()();
  IntColumn get fineMin => integer().withDefault(const Constant(0))();
  IntColumn get fineMax => integer().withDefault(const Constant(0))();
  TextColumn get aliasesJson => text()();
  TextColumn get keywordsJson => text()();
  TextColumn get searchText => text()();
  TextColumn get relatedViolationIdsJson => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
