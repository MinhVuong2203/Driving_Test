import 'package:drift/drift.dart';

class TrafficSigns extends Table {
  TextColumn get signId    => text()();
  TextColumn get category  => text()(); // 'cam', 'canh-bao', 'chi-dan', 'hieu-lenh', 'phu', 'tren-cao-toc'
  TextColumn get name      => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl  => text().nullable()();

  @override
  Set<Column> get primaryKey => {signId};
}