import 'dart:convert';

import 'package:driving_test_prep/data/models/traffic_violation_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;

class TrafficViolationApiService {
  String get baseUrl => AppConfig.baseUrl;

  Future<List<TrafficViolation>> fetchAll() async {
    final result = await search(keyword: '');
    return result.data;
  }

  Future<TrafficViolationSearchResult> search({
    required String keyword,
    String? vehicleType,
  }) async {
    final query = <String, String>{};
    final trimmedKeyword = keyword.trim();
    final trimmedVehicleType = vehicleType?.trim();

    if (trimmedKeyword.isNotEmpty) {
      query['keyword'] = trimmedKeyword;
    }
    if (trimmedVehicleType != null && trimmedVehicleType.isNotEmpty) {
      query['vehicleType'] = trimmedVehicleType;
    }

    final uri = Uri.parse('$baseUrl/api/TrafficViolations/search').replace(
      queryParameters: query.isEmpty ? null : query,
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    final body = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return TrafficViolationSearchResult.fromJson(
        Map<String, dynamic>.from(body as Map),
      );
    }

    final message = body is Map
        ? body['message']?.toString()
        : null;
    throw Exception(message ?? 'Không thể tra cứu lỗi vi phạm.');
  }

  Future<TrafficViolation> getById(String id) async {
    final uri = Uri.parse('$baseUrl/api/TrafficViolations/$id');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    final body = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200 && body is Map) {
      return TrafficViolation.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
    }

    final message = body is Map
        ? body['message']?.toString()
        : null;
    throw Exception(message ?? 'Không thể lấy chi tiết lỗi vi phạm.');
  }
}
