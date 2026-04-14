import '../datasource/firebase/service/otp_email_service.dart';

class OtpEmailRepository {
  OtpEmailRepository._();

  static final OtpEmailRepository instance = OtpEmailRepository._();

  String generateOtp({int digits = 6}) {
    return OtpEmailService.generateOtp(digits: digits);
  }

  Future<String> sendOtp({
    required String recipientEmail,
    String subject = 'Mã OTP xác nhận đăng ký tài khoản',
    String? customBody,
    int otpDigits = 6,
    int expiryMinutes = 5,
  }) {
    return OtpEmailService.sendOtp(
      recipientEmail: recipientEmail,
      subject: subject,
      customBody: customBody,
      otpDigits: otpDigits,
      expiryMinutes: expiryMinutes,
    );
  }
}
