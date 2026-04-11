
import 'package:driving_test_prep/data/datasource/firebase/service/usage_service.dart';

class UsageRepository{
  final UsageService _usageService;
  UsageRepository(this._usageService);

  Future<bool> canUseRecognition() {
    return _usageService.canUseRecognition();
  }
  Future<int> getRemainingRecognition() {
    return _usageService.getRemainingRecognition();
  }
}