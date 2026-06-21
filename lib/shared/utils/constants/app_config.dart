class AppConfig {
  static const _productionBaseUrl =
      "https://drivingtestadmin-production.up.railway.app";

  static String get baseUrl {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    return _productionBaseUrl;
  }

  static const publicPageBaseUrl =
      "https://drivingtestadminfe-production.up.railway.app";

  static const termsOfUseUrl = "$publicPageBaseUrl/terms-of-use";
  static const developmentTeamUrl = "$publicPageBaseUrl/development-team";
  static const privacyPolicyUrl = "$publicPageBaseUrl/privacy-policy";
  static const downloadAppUrl = "$publicPageBaseUrl/download-app";
  static const appUpdateManifestUrl =
      "$publicPageBaseUrl/downloads/app-update.json";
  static const appUpdateApkUrl = "$publicPageBaseUrl/downloads/app-release.apk";
  static const downloadQrAsset = "assets/images/qr/qrcode.svg";
}
