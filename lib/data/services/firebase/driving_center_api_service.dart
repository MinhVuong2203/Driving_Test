import 'dart:convert';

import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;
class DrivingCenterApiService {
  static final String baseUrl = AppConfig.baseUrl;

  Future<DrivingCenterPage> fetchByProvince(
    String keyword, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/api/DrivingCenters/search').replace(
      queryParameters: {
        'keyword': keyword,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    print('--------------- [ $uri ] ---------------');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return DrivingCenterPage.fromJson(body);
    }

    throw Exception(
      'Không thể tải danh sách trung tâm. Status: ${response.statusCode}',
    );
  }

  Future<List<DrivingCenter>> fetchAll() async {
    final uri = Uri.parse('$baseUrl/api/DrivingCenters');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List data = body['data'] ?? [];

      return data
          .map((item) => DrivingCenter.fromJson(item))
          .toList();
    }

    throw Exception(
      'Không thể tải danh sách trung tâm. Status: ${response.statusCode}',
    );
  }
}
