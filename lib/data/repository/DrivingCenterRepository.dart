import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/driving_centers_dao.dart';
import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/services/firebase/driving_center_api_service.dart';

class DrivingCenterRepository {
  final DrivingCenterApiService _apiService;
  final DrivingCentersDao _dao;

  DrivingCenterRepository({
    DrivingCenterApiService? apiService,
    DrivingCentersDao? dao,
  }) : _apiService = apiService ?? DrivingCenterApiService(),
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

    if (cached != null) return cached;

    final result = await _apiService.fetchByProvince(
      province,
      page: page,
      pageSize: pageSize,
    );
    final normalizedResult = _normalizePage(
      result,
      requestedPage: page,
      requestedPageSize: pageSize,
    );

    await _dao.savePage(province: province, result: normalizedResult);

    return normalizedResult;
  }

  Future<List<DrivingCenter>> getAllCenters() {
    return _apiService.fetchAll();
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
