import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/otp_email_service.dart';

class RegisterWithOtpScreen extends StatefulWidget {
  const RegisterWithOtpScreen({
    super.key,
    this.initialEmail = '',
    this.initialPassword = '',
  });

  final String initialEmail;
  final String initialPassword;

  @override
  State<RegisterWithOtpScreen> createState() => _RegisterWithOtpScreenState();
}

class _RegisterWithOtpScreenState extends State<RegisterWithOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _displayNameCtrl = TextEditingController();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  final TextEditingController _otpCtrl = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;
  String? _sentOtp;       // Lưu OTP đã gửi để so sánh
  String? _error;

  bool get _hasFixedEmail => widget.initialEmail.trim().isNotEmpty;
  bool get _hasFixedPassword => widget.initialPassword.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _passwordCtrl = TextEditingController(text: widget.initialPassword);
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  // ─── Validators ──────────────────────────────────────────────────────────────

  String? _validateEmail(String? v) {
    final String value = (v ?? '').trim();
    if (value.isEmpty) return 'Nhập email';
    if (!value.contains('@') || !value.contains('.')) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    final String value = v ?? '';
    if (value.isEmpty) return 'Nhập mật khẩu';
    if (value.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  // ─── Gửi OTP ─────────────────────────────────────────────────────────────────

  Future<void> _sendOtp() async {
    final String email = _emailCtrl.text.trim();
    final String displayName = _displayNameCtrl.text.trim();
    final String password = _passwordCtrl.text;

    // Validate trước khi gửi
    if (_validateEmail(email) != null) {
      setState(() => _error = 'Email không hợp lệ.');
      return;
    }
    if (displayName.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tên hiển thị.');
      return;
    }
    if (_validatePassword(password) != null) {
      setState(() => _error = 'Mật khẩu tối thiểu 6 ký tự.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Gửi OTP qua Gmail SMTP, nhận lại mã để lưu so sánh
      final String otp = await OtpEmailService.sendOtp(
        recipientEmail: email,
        subject: 'Mã OTP xác nhận đăng ký tài khoản',
        expiryMinutes: 5,
      );

      if (!mounted) return;

      setState(() {
        _sentOtp = otp;
        _otpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi OTP về email.')),
      );
    } catch (e) {
      setState(() => _error = 'Gửi OTP thất bại: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Xác thực OTP & Đăng ký ──────────────────────────────────────────────────

  Future<void> _verifyOtpAndRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_otpSent || _sentOtp == null) {
      setState(() => _error = 'Vui lòng gửi OTP trước khi xác thực.');
      return;
    }

    final String email = _emailCtrl.text.trim();
    final String password = _passwordCtrl.text;
    final String otp = _otpCtrl.text.trim();
    final String displayName = _displayNameCtrl.text.trim();

    // So sánh OTP
    if (otp != _sentOtp) {
      setState(() => _error = 'OTP không đúng hoặc đã hết hạn.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Tạo tài khoản Firebase
      final UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        setState(() => _error = 'Không tạo được tài khoản.');
        return;
      }

      await user.updateDisplayName(displayName);

      // Lưu thông tin user lên Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'displayName': displayName,
        'role': 'user',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = switch (e.code) {
          'email-already-in-use' => 'Email đã được sử dụng.',
          'weak-password' => 'Mật khẩu quá yếu.',
          'invalid-email' => 'Email không hợp lệ.',
          _ => 'Đăng ký thất bại: ${e.message ?? e.code}',
        };
      });
    } on FirebaseException catch (e) {
      setState(() => _error = 'Lưu user Firestore thất bại: ${e.message ?? e.code}');
    } catch (e) {
      setState(() => _error = 'Đăng ký thất bại, vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Tên hiển thị
              TextFormField(
                controller: _displayNameCtrl,
                decoration: const InputDecoration(labelText: 'Tên hiển thị'),
                validator: (String? v) {
                  if (v == null || v.trim().isEmpty) return 'Nhập tên hiển thị';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              if (!_hasFixedEmail)
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                )
              else
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_emailCtrl.text.trim()),
                ),
              const SizedBox(height: 12),

              // Mật khẩu
              if (!_hasFixedPassword)
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  validator: _validatePassword,
                )
              else
                const InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  child: Text('Đã nhập từ màn hình trước'),
                ),
              const SizedBox(height: 16),

              // Nút gửi OTP
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _sendOtp,
                  icon: const Icon(Icons.email_outlined),
                  label: Text(_otpSent ? 'Gửi lại OTP' : 'Gửi OTP'),
                ),
              ),
              const SizedBox(height: 12),

              // Nhập OTP
              TextFormField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Mã OTP',
                  hintText: 'Nhập mã 6 chữ số',
                  suffixIcon: _otpSent
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                validator: (String? v) {
                  final String value = (v ?? '').trim();
                  if (value.isEmpty) return 'Nhập OTP';
                  if (value.length < 6) return 'OTP phải đủ 6 chữ số';
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Thông báo lỗi
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              const SizedBox(height: 16),

              // Nút đăng ký
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtpAndRegister,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Xác thực OTP & Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}