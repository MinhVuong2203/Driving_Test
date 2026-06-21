class VideoUploadResult {
  final String videoUrl;
  final String videoPublicId;
  final double duration;
  final int bytes;
  final String format;
  final int width;
  final int height;

  const VideoUploadResult({
    required this.videoUrl,
    required this.videoPublicId,
    required this.duration,
    required this.bytes,
    required this.format,
    required this.width,
    required this.height,
  });

  factory VideoUploadResult.fromJson(Map<String, dynamic> json) {
    return VideoUploadResult(
      videoUrl: json['videoUrl']?.toString() ?? '',
      videoPublicId: json['videoPublicId']?.toString() ?? '',
      duration: _toDouble(json['duration']),
      bytes: _toInt(json['bytes']),
      format: json['format']?.toString() ?? '',
      width: _toInt(json['width']),
      height: _toInt(json['height']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}