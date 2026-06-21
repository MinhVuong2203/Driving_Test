import 'dart:convert';

import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;

class SimulationSituationApiService {
  String get baseUrl => AppConfig.baseUrl;

  Future<List<SimulationSituation>> fetchAll() async {
    final uri = Uri.parse('$baseUrl/api/SimulationSituations');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    final body = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200 && body is Map) {
      final rawData = body['data'];
      if (rawData is List) {
        return rawData
            .map(
              (item) => SimulationSituation.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      }
    }

    final message = body is Map ? body['message']?.toString() : null;
    throw Exception(message ?? 'Không thể tải dữ liệu mô phỏng.');
  }
}
