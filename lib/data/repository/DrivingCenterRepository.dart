import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/services/firebase/driving_center_api_service.dart';

class DrivingCenterRepository {
  DrivingCenterApiService _apiService;
  DrivingCenterRepository({DrivingCenterApiService? apiService,
  }) : _apiService = apiService ?? DrivingCenterApiService();

  Future<DrivingCenterPage> getCentersByProvince(
    String province, {
    int page = 1,
    int pageSize = 10,
  }) {
    return _apiService.fetchByProvince(
      province,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<DrivingCenter>> getAllCenters() {
    return _apiService.fetchAll();
  }
}
