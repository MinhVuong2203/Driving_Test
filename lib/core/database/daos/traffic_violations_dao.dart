import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/data/models/traffic_violation_model.dart';

class TrafficViolationsDao {
  final AppDatabase db;
  TrafficViolationsDao(this.db);

  Future<int> count() async {
    final countExpression = db.trafficViolationRecords.id.count();
    final query = db.selectOnly(db.trafficViolationRecords);
    query.addColumns([countExpression]);
    final result = await query.getSingle();
    return result.read(countExpression) ?? 0;
  }

  Future<void> replaceAll(List<TrafficViolation> violations) async {
    await db.transaction(() async {
      await db.delete(db.trafficViolationRecords).go();
      await db.batch((batch) {
        batch.insertAll(
          db.trafficViolationRecords,
          violations.map(_toCompanion).toList(),
        );
      });
    });
  }

  Future<List<TrafficViolation>> getAllActive() async {
    final records = await (db.select(db.trafficViolationRecords)
          ..where((table) => table.status.equals('active'))
          ..orderBy([
            (table) => OrderingTerm.asc(table.fineMin),
            (table) => OrderingTerm.asc(table.title),
          ]))
        .get();

    return records.map(_fromRecord).toList();
  }

  Future<TrafficViolation?> getById(String id) async {
    final record = await (db.select(db.trafficViolationRecords)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return record == null ? null : _fromRecord(record);
  }

  TrafficViolationRecordsCompanion _toCompanion(TrafficViolation violation) {
    return TrafficViolationRecordsCompanion.insert(
      id: violation.id,
      title: violation.title,
      vehicleTypesJson: jsonEncode(violation.vehicleTypes),
      subjectText: violation.subjectText,
      penaltyText: violation.penaltyText,
      penaltyLegalBasis: violation.penaltyLegalBasis,
      additionalPenaltyText: violation.additionalPenaltyText,
      additionalPenaltyLegalBasis: violation.additionalPenaltyLegalBasis,
      fineMin: Value(violation.fineMin),
      fineMax: Value(violation.fineMax),
      aliasesJson: jsonEncode(violation.aliases),
      keywordsJson: jsonEncode(violation.keywords),
      searchText: violation.searchText,
      relatedViolationIdsJson: jsonEncode(violation.relatedViolationIds),
      status: Value(violation.status),
    );
  }

  TrafficViolation _fromRecord(TrafficViolationRecord record) {
    return TrafficViolation(
      id: record.id,
      title: record.title,
      vehicleTypes: _readStringList(record.vehicleTypesJson),
      subjectText: record.subjectText,
      penaltyText: record.penaltyText,
      penaltyLegalBasis: record.penaltyLegalBasis,
      additionalPenaltyText: record.additionalPenaltyText,
      additionalPenaltyLegalBasis: record.additionalPenaltyLegalBasis,
      fineMin: record.fineMin,
      fineMax: record.fineMax,
      aliases: _readStringList(record.aliasesJson),
      keywords: _readStringList(record.keywordsJson),
      searchText: record.searchText,
      relatedViolationIds: _readStringList(record.relatedViolationIdsJson),
      status: record.status,
    );
  }

  List<String> _readStringList(String value) {
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded.map((item) => item.toString()).toList();
    }
    return [];
  }
}
