import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/data/models/driving_center_model.dart';

class DrivingCentersDao {
  final AppDatabase db;
  DrivingCentersDao(this.db);

  Future<DrivingCenterPage?> getPage({
    required String province,
    required int page,
    required int pageSize,
  }) async {
    final cache =
        await (db.select(db.drivingCenterPageCaches)..where(
              (table) =>
                  table.province.equals(province) & table.page.equals(page),
            ))
            .getSingleOrNull();

    if (cache == null || cache.pageSize != pageSize) return null;

    final records =
        await (db.select(db.drivingCenterRecords)
              ..where(
                (table) =>
                    table.province.equals(province) &
                    table.cachedPage.equals(page) &
                    table.pageSize.equals(pageSize),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
            .get();

    return DrivingCenterPage(
      items: records.map(_fromRecord).toList(),
      total: cache.total,
      page: cache.page,
      pageSize: cache.pageSize,
      hasMore: cache.hasMore,
    );
  }

  Future<void> savePage({
    required String province,
    required DrivingCenterPage result,
  }) async {
    await db.transaction(() async {
      await (db.delete(db.drivingCenterRecords)..where(
            (table) =>
                table.province.equals(province) &
                table.cachedPage.equals(result.page) &
                table.pageSize.equals(result.pageSize),
          ))
          .go();

      await db
          .into(db.drivingCenterPageCaches)
          .insertOnConflictUpdate(_toPageCache(province, result));

      if (result.items.isEmpty) return;

      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.drivingCenterRecords,
          result.items
              .asMap()
              .entries
              .map(
                (entry) => _toRecord(
                  province: province,
                  center: entry.value,
                  page: result.page,
                  pageSize: result.pageSize,
                  sortOrder: entry.key,
                ),
              )
              .toList(),
        );
      });
    });
  }

  DrivingCenterRecordsCompanion _toRecord({
    required String province,
    required DrivingCenter center,
    required int page,
    required int pageSize,
    required int sortOrder,
  }) {
    return DrivingCenterRecordsCompanion.insert(
      id: center.id,
      province: province,
      name: center.name,
      phoneNumber: center.phoneNumber,
      photoUrl: center.photoUrl,
      website: center.website,
      rating: Value(center.rating),
      reviewCount: Value(center.reviewCount),
      businessStatus: center.businessStatus,
      address: center.address,
      district: center.district,
      city: center.city,
      openingStatus: center.openingStatus,
      searchQuery: center.searchQuery,
      createdAt: center.createdAt,
      updatedAt: center.updatedAt,
      cachedPage: page,
      pageSize: pageSize,
      sortOrder: sortOrder,
    );
  }

  DrivingCenterPageCachesCompanion _toPageCache(
    String province,
    DrivingCenterPage result,
  ) {
    return DrivingCenterPageCachesCompanion.insert(
      province: province,
      page: result.page,
      pageSize: result.pageSize,
      total: Value(result.total),
      hasMore: Value(result.hasMore),
    );
  }

  DrivingCenter _fromRecord(DrivingCenterRecord record) {
    return DrivingCenter(
      id: record.id,
      name: record.name,
      phoneNumber: record.phoneNumber,
      photoUrl: record.photoUrl,
      website: record.website,
      rating: record.rating,
      reviewCount: record.reviewCount,
      businessStatus: record.businessStatus,
      address: record.address,
      district: record.district,
      city: record.city,
      openingStatus: record.openingStatus,
      searchQuery: record.searchQuery,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }
}
