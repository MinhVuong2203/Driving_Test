class VipPackageModel {
  final String id;
  final String vipName;
  final double vipPrice;
  final double? priceInline;
  final bool isPeriod;
  final int? vipTime;
  final List<String> descript;
  final String colorTheme;

  const VipPackageModel({
    required this.id,
    required this.vipName,
    required this.vipPrice,
    required this.isPeriod,
    required this.descript,
    required this.colorTheme,
    this.priceInline,
    this.vipTime,
  });

  factory VipPackageModel.fromJson(Map<String, dynamic> json) {
    return VipPackageModel(
      id: json['id']?.toString() ?? '',
      vipName: (json['vipName'] ?? json['vip_name'])?.toString() ?? '',
      vipPrice: ((json['vipPrice'] ?? json['vip_price']) as num?)?.toDouble() ?? 0,
      priceInline: ((json['priceInline'] ?? json['price_inline']) as num?)?.toDouble(),
      isPeriod: (json['isPeriod'] ?? json['is_period']) == true,
      vipTime: ((json['vipTime'] ?? json['vip_time']) as num?)?.toInt(),
      descript: (json['descript'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      colorTheme: (json['colorTheme'] ?? json['color_theme'])?.toString() ?? 'blue',
    );
  }

  String get durationLabel {
    if (isPeriod) return 'Vĩnh viễn';
    final days = vipTime ?? 0;
    return days > 0 ? '$days ngày' : 'Theo thời hạn';
  }
}
