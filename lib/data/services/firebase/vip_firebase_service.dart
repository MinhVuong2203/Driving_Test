import 'dart:convert';

import 'package:driving_test_prep/data/models/payos_payment_model.dart';
import 'package:driving_test_prep/data/models/vip_package_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;
import 'auth_api_headers.dart';

class VipFirebaseService {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<VipPackageModel>> getActiveVipPackages() async {
    final response = await http.get(Uri.parse('$baseUrl/api/VipPackage/active'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => VipPackageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Không thể tải danh sách gói VIP. Status: ${response.statusCode}');
  }

  Future<PayOsPaymentModel> createPayOsPayment({
    required String userId,
    required String packageId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Payment/payos/create'),
      headers: await AuthApiHeaders.json(),
      body: jsonEncode({
        'userId': userId,
        'packageId': packageId,
      }),
    );

    if (response.statusCode == 200) {
      return PayOsPaymentModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Không thể tạo thanh toán PayOS. Status: ${response.statusCode}');
  }

  Future<bool> syncPayOsStatus(int orderCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Payment/payos-status/$orderCode'),
      headers: await AuthApiHeaders.bearer(),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['paid'] == true;
    }

    return false;
  }
}
