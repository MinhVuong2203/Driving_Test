class AppConfig {
  // static String get baseUrl => "http://10.0.2.2:7211";
  static String get baseUrl =>
      "https://drivingtestadmin-production.up.railway.app";
  // static String get baseUrl => "http://10.163.22.223:7211";
  // static String get baseUrl => "http://10.163.22.74:7211";

  static const publicPageBaseUrl =
      "https://drivingtestadminfe-production.up.railway.app";

  static const termsOfUseUrl = "$publicPageBaseUrl/terms-of-use";
  static const developmentTeamUrl = "$publicPageBaseUrl/development-team";
  static const privacyPolicyUrl = "$publicPageBaseUrl/privacy-policy";
  static const downloadAppUrl = "$publicPageBaseUrl/download-app";
  static const downloadQrAsset = "assets/images/qr/qrcode.svg";
}
