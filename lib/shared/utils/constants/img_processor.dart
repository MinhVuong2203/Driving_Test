import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessor {
  /// Process and encode image to base64
  static String processImage(File file, {int maxWidth = 512, int quality = 85}) {
    try {
      final bytes = file.readAsBytesSync();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) return "";

      // Resize để tối ưu size và giữ chất lượng
      image = img.copyResize(image, width: maxWidth);

      // Encode sang JPEG với quality được chỉ định
      final encoded = img.encodeJpg(image, quality: quality);

      return base64Encode(encoded);
    } catch (e) {
      throw Exception("Lỗi xử lý ảnh: $e");
    }
  }

  /// Get image file size in KB
  static double getFileSizeKB(File file) {
    final bytes = file.lengthSync();
    return bytes / 1024;
  }

  /// Check if image size is valid
  static bool isValidSize(File file, {double maxSizeMB = 10}) {
    final sizeKB = getFileSizeKB(file);
    return sizeKB <= (maxSizeMB * 1024);
  }
}
