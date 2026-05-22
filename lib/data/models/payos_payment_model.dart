class PayOsPaymentModel {
  final int orderCode;
  final String paymentLinkId;
  final String checkoutUrl;
  final String status;
  final int amount;
  final String packageId;
  final String packageName;

  const PayOsPaymentModel({
    required this.orderCode,
    required this.paymentLinkId,
    required this.checkoutUrl,
    required this.status,
    required this.amount,
    required this.packageId,
    required this.packageName,
  });

  factory PayOsPaymentModel.fromJson(Map<String, dynamic> json) {
    return PayOsPaymentModel(
      orderCode: (json['orderCode'] as num?)?.toInt() ?? 0,
      paymentLinkId: json['paymentLinkId']?.toString() ?? '',
      checkoutUrl: json['checkoutUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      packageId: json['packageId']?.toString() ?? '',
      packageName: json['packageName']?.toString() ?? '',
    );
  }
}
