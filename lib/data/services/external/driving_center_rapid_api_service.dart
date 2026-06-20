import 'dart:convert';

import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;

class DrivingCenterRapidApiService {
  static final String baseUrl = AppConfig.baseUrl;

  Future<DrivingCenterPage> fetchByProvince(
    String keyword, {
    int page = 1,
    int pageSize = 5,
  }) async {
    final uri = Uri.parse('$baseUrl/api/DrivingCenters/rapid-search').replace(
      queryParameters: {
        'keyword': keyword,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return DrivingCenterPage.fromJson(body);
    }

    throw Exception(
      'Khong the tai danh sach trung tam tu RapidAPI. Status: ${response.statusCode}',
    );
  }
}
