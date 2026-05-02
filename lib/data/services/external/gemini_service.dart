import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // 🔑 API Configuration
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models";
  static const String _model = "gemini-3.1-flash-lite-preview";

  /// Nhận diện biển báo giao thông
  Future<String> recognizeTrafficSign(
      String base64Image, {
        int retry = 0,
      }) async {
    try {
      // Delay để tránh spam
      await Future.delayed(const Duration(milliseconds: 500));

      final url = Uri.parse("$_baseUrl/$_model:generateContent?key=$_apiKey");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": _buildPrompt(),
                },
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image,
                  }
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.4,
            "maxOutputTokens": 500,
          }
        }),
      );

      // ✅ Thành công
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? "Không nhận diện được";
      }

      // 🔁 Retry nếu server quá tải (503)
      else if (response.statusCode == 503 && retry < 3) {
        await Future.delayed(const Duration(seconds: 2));
        return recognizeTrafficSign(base64Image, retry: retry + 1);
      }

      // ⚠️ Rate limit
      else if (response.statusCode == 429) {
        return "Vượt giới hạn request. Vui lòng đợi 1 phút.";
      }

      // ❌ Lỗi khác
      else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['error']?['message'] ?? 'Unknown error';
        return "Lỗi API: $errorMessage";
      }
    } catch (e) {
      return "Lỗi kết nối: ${e.toString()}";
    }
  }

  String _buildPrompt() {
    return """
      Bạn là chuyên gia nhận diện biển báo giao thông Việt Nam.
      
      Phân tích ảnh biển báo và trả về thông tin theo format sau:
      
      🚦 TÊN BIỂN BÁO
      [Tên chính xác của biển báo theo quy chuẩn Việt Nam]
      
      📋 LOẠI BIỂN BÁO
      [Biển cấm / Biển nguy hiểm / Biển chỉ dẫn / Biển hiệu lệnh]
      
      💡 Ý NGHĨA
      [Giải thích ý nghĩa của biển báo]
      
      📊 THÔNG SỐ
      [Các số liệu nếu có: tốc độ, khoảng cách, trọng tải, v.v...]
      
      ⚠️ LƯU Ý
      [Ghi chú quan trọng nếu có]
      
      ---
      Nếu không nhận diện được hoặc không phải biển báo giao thông, chỉ trả về: "❌ Không nhận diện được biển báo"
      """;
  }
}
