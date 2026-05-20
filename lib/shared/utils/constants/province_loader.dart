import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ProvinceLoader {
  ProvinceLoader._();

  static const String _provinceJsonPath =
      'assets/json/province/34_tinh_thanh.json';

  static Future<List<String>> loadProvinceNames({
    bool useDisplayName = false,
  }) async {
    try {
      debugPrint('📂 Đang đọc file JSON tỉnh/thành: $_provinceJsonPath');

      final jsonString = await rootBundle.loadString(_provinceJsonPath);

      debugPrint('✅ Đọc file JSON tỉnh/thành thành công');
      debugPrint('📦 Kích thước JSON: ${jsonString.length} ký tự');

      final decoded = jsonDecode(jsonString);

      debugPrint('✅ Decode JSON thành công');
      debugPrint('🔎 Kiểu dữ liệu JSON gốc: ${decoded.runtimeType}');

      final List<dynamic> provinceList = _extractProvinceList(decoded);

      final provinces = provinceList
          .map<String>((item) {
        if (item is Map<String, dynamic>) {
          final name = item['name'];
          final displayName = item['displayName'];

          if (useDisplayName) {
            if (displayName is String && displayName.trim().isNotEmpty) {
              return displayName.trim();
            }

            if (name is String && name.trim().isNotEmpty) {
              return name.trim();
            }
          } else {
            if (name is String && name.trim().isNotEmpty) {
              return name.trim();
            }

            if (displayName is String && displayName.trim().isNotEmpty) {
              return displayName.trim();
            }
          }
        }

        if (item is String && item.trim().isNotEmpty) {
          return item.trim();
        }

        return '';
      })
          .where((name) => name.isNotEmpty)
          .toList();

      debugPrint('✅ Parse tỉnh/thành thành công');
      debugPrint('📌 Tổng số tỉnh/thành: ${provinces.length}');
      debugPrint('📋 Danh sách tỉnh/thành: $provinces');

      return provinces;
    } catch (e, stackTrace) {
      debugPrint('❌ Lỗi khi load JSON tỉnh/thành');
      debugPrint('❌ Error: $e');
      debugPrint('📍 StackTrace: $stackTrace');

      return [];
    }
  }

  static List<dynamic> _extractProvinceList(dynamic decoded) {
    if (decoded is List) {
      debugPrint('📌 JSON dạng List trực tiếp');
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];

      if (data is List) {
        debugPrint('📌 JSON dạng Object, đã lấy danh sách từ key "data"');
        return data;
      }

      debugPrint('❌ Không tìm thấy key "data" dạng List trong JSON');
      return [];
    }

    debugPrint('❌ JSON không đúng định dạng mong muốn');
    return [];
  }
}