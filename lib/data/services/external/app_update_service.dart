import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.versionName,
    required this.versionCode,
    required this.apkUrl,
    required this.apkSizeBytes,
    required this.forceUpdate,
    required this.releaseNotes,
  });

  final String versionName;
  final int versionCode;
  final String apkUrl;
  final int? apkSizeBytes;
  final bool forceUpdate;
  final List<String> releaseNotes;

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    return AppUpdateInfo(
      versionName: (json['versionName'] as String?)?.trim() ?? '',
      versionCode: json['versionCode'] is int
          ? json['versionCode'] as int
          : int.tryParse('${json['versionCode']}') ?? 0,
      apkUrl: _resolveDownloadUrl((json['apkUrl'] as String?)?.trim()),
      apkSizeBytes: _parseOptionalInt(json['apkSizeBytes']),
      forceUpdate: json['forceUpdate'] == true,
      releaseNotes:
          (json['releaseNotes'] as List<dynamic>?)
              ?.map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  static int? _parseOptionalInt(dynamic value) {
    final parsed = value is int ? value : int.tryParse('$value');
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  static String _resolveDownloadUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) {
      return AppConfig.appUpdateApkUrl;
    }

    final uri = Uri.tryParse(rawUrl);
    if (uri != null && uri.hasScheme) {
      return rawUrl;
    }

    return Uri.parse(AppConfig.publicPageBaseUrl).resolve(rawUrl).toString();
  }
}

class AppUpdateService {
  AppUpdateService({http.Client? client}) : _client = client ?? http.Client();

  static const MethodChannel _channel = MethodChannel(
    'driving_test_prep/app_update',
  );

  final http.Client _client;

  Future<AppUpdateInfo?> checkForUpdate() async {
    if (!Platform.isAndroid) return null;

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    final manifestUri = Uri.parse(AppConfig.appUpdateManifestUrl);

    debugPrint('AppUpdate: kiểm tra cập nhật từ $manifestUri');
    debugPrint(
      'AppUpdate: phiên bản hiện tại ${packageInfo.version}+$currentVersionCode',
    );

    final response = await _client
        .get(manifestUri, headers: const {'Cache-Control': 'no-cache'})
        .timeout(const Duration(seconds: 8));

    debugPrint('AppUpdate: manifest statusCode=${response.statusCode}');
    debugPrint('AppUpdate: manifest body=${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Không thể kiểm tra bản cập nhật (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('File cập nhật không đúng định dạng.');
    }

    final updateInfo = AppUpdateInfo.fromJson(decoded);
    debugPrint(
      'AppUpdate: phiên bản server ${updateInfo.versionName}+${updateInfo.versionCode}, '
      'apk=${updateInfo.apkUrl}, size=${updateInfo.apkSizeBytes ?? 'không có'} bytes, '
      'forceUpdate=${updateInfo.forceUpdate}',
    );

    if (updateInfo.versionCode <= currentVersionCode) return null;

    debugPrint('AppUpdate: có bản cập nhật mới.');
    return updateInfo;
  }

  Future<File> downloadApk(
    AppUpdateInfo updateInfo, {
    void Function(int receivedBytes, int? totalBytes)? onProgress,
  }) async {
    final request = http.Request('GET', Uri.parse(updateInfo.apkUrl));
    final response = await _client
        .send(request)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('Không thể tải APK (${response.statusCode}).');
    }

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/driving_test_update_${updateInfo.versionCode}.apk',
    );

    final sink = file.openWrite();
    var receivedBytes = 0;

    try {
      await for (final chunk in response.stream) {
        receivedBytes += chunk.length;
        sink.add(chunk);
        onProgress?.call(receivedBytes, response.contentLength);
      }
    } finally {
      await sink.flush();
      await sink.close();
    }

    return file;
  }

  Future<void> installApk(File apkFile) async {
    await _channel.invokeMethod<void>('installApk', {'path': apkFile.path});
  }
}
