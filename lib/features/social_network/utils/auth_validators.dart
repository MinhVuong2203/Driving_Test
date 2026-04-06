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

  static String? displayName(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Vui lòng nhập tên hiển thị';
    return null;
  }
}
