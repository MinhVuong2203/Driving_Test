import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/services/firebase/driving_center_api_service.dart';

class DrivingCenterRepository {
  DrivingCenterApiService _apiService;
  DrivingCenterRepository({DrivingCenterApiService? apiService,
  }) : _apiService = apiService ?? DrivingCenterApiService();

  Future<List<DrivingCenter>> getCentersByProvince(String province) {
    return _apiService.fetchByProvince(province);
  }

  Future<List<DrivingCenter>> getAllCenters() {
    return _apiService.fetchAll();
  }
}