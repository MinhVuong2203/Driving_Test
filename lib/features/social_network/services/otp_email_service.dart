import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

/// Service gửi OTP qua email dùng Gmail SMTP (App Password)
class OtpEmailService {
  static const String _senderEmail = 'tailscaleedu123@gmail.com';
  static const String _appPassword = 'eqbz eswr pxoi rpom';

  /// Sinh mã OTP ngẫu nhiên [digits] chữ số (mặc định 6)
  static String generateOtp({int digits = 6}) {
    final random = Random.secure();
    final otp = List.generate(digits, (_) => random.nextInt(10)).join();
    return otp;
  }

  static Future<String> sendOtp({
    required String recipientEmail,
    String subject = 'Mã OTP xác nhận đăng ký tài khoản',
    String? customBody, // Nếu null sẽ dùng template mặc định
    int otpDigits = 6,
    int expiryMinutes = 5,
  }) async {
    final otp = generateOtp(digits: otpDigits);

    final body = customBody ?? _buildDefaultBody(otp, expiryMinutes);

    final smtpServer = gmail(_senderEmail, _appPassword);

    final message = Message()
      ..from = Address(_senderEmail, 'Your App Name')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = body;

    try {
      await send(message, smtpServer);
      return otp; // Trả về OTP để lưu vào state/DB và so sánh sau
    } on MailerException catch (e) {
      throw Exception('Gửi email thất bại: ${e.message}');
    }
  }

  /// Template HTML mặc định cho email OTP đăng ký
  static String _buildDefaultBody(String otp, int expiryMinutes) {
    return '''
<!DOCTYPE html>
<html>
<body style="font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px;">
  <div style="max-width: 480px; margin: auto; background: #ffffff;
              border-radius: 8px; padding: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
    <h2 style="color: #333; text-align: center;">Xác nhận đăng ký tài khoản</h2>
    <p style="color: #555;">Xin chào,</p>
    <p style="color: #555;">Mã OTP của bạn để hoàn tất đăng ký là:</p>
    <div style="text-align: center; margin: 24px 0;">
      <span style="font-size: 36px; font-weight: bold; letter-spacing: 10px;
                   color: #1a73e8; background: #e8f0fe; padding: 12px 24px;
                   border-radius: 8px;">$otp</span>
    </div>
    <p style="color: #777; font-size: 13px;">
      Mã này có hiệu lực trong <strong>$expiryMinutes phút</strong>.
      Vui lòng không chia sẻ mã này với bất kỳ ai.
    </p>
    <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
    <p style="color: #aaa; font-size: 12px; text-align: center;">
      Nếu bạn không yêu cầu mã này, hãy bỏ qua email này.
    </p>
  </div>
</body>
</html>
''';
  }
}