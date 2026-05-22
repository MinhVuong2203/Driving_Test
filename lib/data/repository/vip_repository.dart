import 'package:driving_test_prep/data/services/firebase/vip_firebase_service.dart';
import 'package:driving_test_prep/data/models/payos_payment_model.dart';
import 'package:driving_test_prep/data/models/vip_package_model.dart';

class VipRepository {
  final VipFirebaseService _vipFirebaseService;
  VipRepository(this._vipFirebaseService);

  Future<List<VipPackageModel>> getActiveVipPackages() {
    return _vipFirebaseService.getActiveVipPackages();
  }

  Future<PayOsPaymentModel> createPayOsPayment({
    required String userId,
    required String packageId,
  }) {
    return _vipFirebaseService.createPayOsPayment(
      userId: userId,
      packageId: packageId,
    );
  }

  Future<bool> syncPayOsStatus(int orderCode) {
    return _vipFirebaseService.syncPayOsStatus(orderCode);
  }
}
