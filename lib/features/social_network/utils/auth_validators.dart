class AuthValidators {
  const AuthValidators._();

  static String? email(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Vui lòng nhập email';
    if (!v.contains('@') || !v.contains('.')) return 'Email không hợp lệ';
    return null;
  }

  static String? password(
      String? value, {
        int minLength = 6,
      }) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < minLength) return 'Mật khẩu tối thiểu $minLength ký tự';
    return null;
  }

  /// Xác nhận mật khẩu khớp với [original].
  /// Dùng: validator: (v) => AuthValidators.confirmPassword(v, _passwordCtrl.text)
  static String? confirmPassword(String? value, String original) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (v != original) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  static String? displayName(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Vui lòng nhập tên hiển thị';
    return null;
  }
}