import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHelper {
  InterstitialAd? _ad;
  bool _isLoading = false;
  String? _adUnitId; // ← không hardcode, chờ nhận từ API

  // Gọi sau khi lấy config từ backend
  void setAdUnitId(String id) {
    _adUnitId = id;
  }

  void loadAd() {
    if (_adUnitId == null) {
      debugPrint('⚠️ Chưa có Ad Unit ID, chờ API trả về');
      return;
    }
    if (_isLoading || _ad != null) return;
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: _adUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
          debugPrint('✅ Interstitial loaded OK');
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _isLoading = false;
          debugPrint('❌ Interstitial failed: $error');
        },
      ),
    );
  }

  Future<bool> showAd() async {
    if (_ad == null) {
      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_ad != null) break;
      }
    }

    if (_ad == null) {
      debugPrint('⚠️ Ad not ready, skip');
      loadAd();
      return false;
    }

    final completer = Completer<bool>();
    final adToShow = _ad!;
    _ad = null;

    adToShow.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await adToShow.show();
    return completer.future;
  }

  void dispose() => _ad?.dispose();
}