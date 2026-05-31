import 'dart:convert';

import 'package:driving_test_prep/data/services/firebase/auth_api_headers.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String baseUrl = AppConfig.baseUrl;

  Future<String> recognizeTrafficSign(
    String base64Image, {
    int retry = 0,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final response = await http.post(
        Uri.parse('$baseUrl/api/TrafficSignRecognition/recognize'),
        headers: await AuthApiHeaders.json(),
        body: jsonEncode({
          'base64Image': base64Image,
          'mimeType': 'image/jpeg',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result']?.toString() ?? 'Không nhận diện được biển báo';
      }

      if (response.statusCode == 503 && retry < 3) {
        await Future.delayed(const Duration(seconds: 2));
        return recognizeTrafficSign(base64Image, retry: retry + 1);
      }

      if (response.statusCode == 429) {
        return 'Vượt quá hạn mức sử dụng API. Vui lòng thử lại sau.';
      }

      final data = jsonDecode(response.body);
      final message = data['message']?.toString() ?? 'Unknown error';
      return 'Lỗi: $message';
    } catch (e) {
      return 'Lỗi kết nối: $e';
    }
  }
}
