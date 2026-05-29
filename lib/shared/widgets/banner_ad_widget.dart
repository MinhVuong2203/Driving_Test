import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../data/repository/admob_config_repository.dart';


class BannerAdWidget extends StatefulWidget {
  final String adUnitId; // ← nhận từ bên ngoài, không hardcode

  const BannerAdWidget({
    super.key,
    required this.adUnitId,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: widget.adUnitId, // ← dùng ID được truyền vào
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          _ad = ad as BannerAd;
          _loaded = true;
        }),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner lỗi: $error');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}