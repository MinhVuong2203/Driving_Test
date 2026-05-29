import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdMobConfig {
  final String appId;
  final String bannerId;
  final String interstitialId;
  final String rewardedId;

  AdMobConfig({
    required this.appId,
    required this.bannerId,
    required this.interstitialId,
    required this.rewardedId,
  });

  factory AdMobConfig.fromJson(Map<String, dynamic> json) => AdMobConfig(
    appId:          json['appId'] ?? '',
    bannerId:       json['bannerId'] ?? '',
    interstitialId: json['interstitialId'] ?? '',
    rewardedId:     json['rewardedId'] ?? '',
  );

  // Dùng khi API lỗi hoặc chưa có backend
  factory AdMobConfig.testDefault() => AdMobConfig(
    appId:          'ca-app-pub-3940256099942544~3347511713',
    bannerId:       'ca-app-pub-3940256099942544/6300978111',
    interstitialId: 'ca-app-pub-3940256099942544/1033173712',
    rewardedId:     'ca-app-pub-3940256099942544/5224354917',
  );
}

class AdMobConfigRepository {
  // Đổi URL này khi deploy backend thật
  static const _baseUrl = 'https://10.0.2.2:7211/api/AdMobConfig';

  Future<AdMobConfig> getConfig() async {
    try {
      final res = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        debugPrint('✅ AdMob config loaded from API');
        return AdMobConfig.fromJson(jsonDecode(res.body));
      }

      debugPrint('⚠️ API lỗi ${res.statusCode}, dùng Test ID');
      return AdMobConfig.testDefault();
    } catch (e) {
      debugPrint('⚠️ Không kết nối được backend: $e, dùng Test ID');
      return AdMobConfig.testDefault();
    }
  }
}