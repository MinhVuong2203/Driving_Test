import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/driving_centers_dao.dart';
import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/services/external/driving_center_rapid_api_service.dart';
import 'package:driving_test_prep/data/services/firebase/driving_center_api_service.dart';
import 'package:flutter/foundation.dart';

class DrivingCenterRepository {
  final DrivingCenterApiService _backendApiService;
  final DrivingCenterRapidApiService _rapidApiService;
  final DrivingCentersDao _dao;

  DrivingCenterRepository({
    DrivingCenterApiService? apiService,
    DrivingCenterRapidApiService? rapidApiService,
    DrivingCentersDao? dao,
  }) : _backendApiService = apiService ?? DrivingCenterApiService(),
       _rapidApiService = rapidApiService ?? DrivingCenterRapidApiService(),
       _dao = dao ?? DrivingCentersDao(DBProvider().db);

  Future<DrivingCenterPage> getCentersByProvince(
    String province, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final cached = await _dao.getPage(
      province: province,
      page: page,
      pageSize: pageSize,
    );

    if (cached != null) {
      _logLoadedCenters(
        source: 'SQLite',
        selectedProvince: province,
        page: page,
        pageSize: pageSize,
        items: cached.items,
      );
      return cached;
    }

    DrivingCenterPage result;
    try {
      debugPrint(
        '[DrivingCenters] SQLite chua co cache, goi RapidAPI | province=$province | page=$page | pageSize=$pageSize',
      );
      result = await _rapidApiService.fetchByProvince(
        province,
        page: page,
        pageSize: pageSize,
      );
      _logLoadedCenters(
        source: 'RapidAPI',
        selectedProvince: province,
        page: page,
        pageSize: pageSize,
        items: result.items,
      );
    } catch (error) {
      debugPrint(
        '[DrivingCenters] RapidAPI loi/het han, backend fallback dang TAM TAT | selectedProvince=$province | page=$page | pageSize=$pageSize | error=$error',
      );
      rethrow;
    }

    final normalizedResult = _normalizePage(
      result,
      requestedPage: page,
      requestedPageSize: pageSize,
    );

    await _dao.savePage(province: province, result: normalizedResult);
    _logLoadedCenters(
      source: 'SQLite saved',
      selectedProvince: province,
      page: normalizedResult.page,
      pageSize: normalizedResult.pageSize,
      items: normalizedResult.items,
    );

    return normalizedResult;
  }

  void _logLoadedCenters({
    required String source,
    required String selectedProvince,
    required int page,
    required int pageSize,
    required List<DrivingCenter> items,
  }) {
    final centers = items
        .take(pageSize)
        .map((center) {
          final city = center.city.trim().isEmpty
              ? selectedProvince
              : center.city;
          return '${center.name} - $city';
        })
        .join(' | ');

    debugPrint(
      '[DrivingCenters] Load 5 DrivingCenter tu $source | selectedProvince=$selectedProvince | page=$page | pageSize=$pageSize | count=${items.length} | centers=[$centers]',
    );
  }

  Future<List<DrivingCenter>> getAllCenters() {
    return _backendApiService.fetchAll();
  }

  DrivingCenterPage _normalizePage(
    DrivingCenterPage result, {
    required int requestedPage,
    required int requestedPageSize,
  }) {
    final page = result.page > 0 ? result.page : requestedPage;
    final pageSize = result.pageSize > 0 ? result.pageSize : requestedPageSize;
    final total = result.total > 0 ? result.total : result.items.length;

    return DrivingCenterPage(
      items: result.items,
      total: total,
      page: page,
      pageSize: pageSize,
      hasMore: result.hasMore,
    );
  }
}
