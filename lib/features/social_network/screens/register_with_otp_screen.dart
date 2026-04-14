import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/otp_email_repository.dart';
import '../utils/auth_validators.dart';

import '../widgets/otp_section.dart';
import '../widgets/register_text_field.dart';
import '../widgets/register_header.dart';
import '../widgets/error_box.dart';
import '../widgets/register_submit_button.dart';

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
  final OtpEmailRepository _otpRepo = OtpEmailRepository.instance;

  final TextEditingController _displayNameCtrl = TextEditingController();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _sentOtp;
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
    _confirmPasswordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final String email = _emailCtrl.text.trim();
    final String displayName = _displayNameCtrl.text.trim();
    final String password = _passwordCtrl.text;

    if (AuthValidators.email(email) != null) {
      setState(() => _error = 'Email không hợp lệ.');
      return;
    }
    if (displayName.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tên hiển thị.');
      return;
    }
    if (AuthValidators.password(password) != null) {
      setState(() => _error = 'Mật khẩu tối thiểu 6 ký tự.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final String otp = await _otpRepo.sendOtp(
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
        SnackBar(
          content: const Row(
            children: <Widget>[
              Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Đã gửi OTP về email của bạn.'),
            ],
          ),
          backgroundColor: const Color(0xFF1DB954),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      setState(() => _error = 'Gửi OTP thất bại: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtpAndRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_otpSent || _sentOtp == null) {
      setState(() => _error = 'Vui lòng gửi OTP trước khi xác thực.');
      return;
    }

    final String otp = _otpCtrl.text.trim();
    if (otp != _sentOtp) {
      setState(() => _error = 'OTP không đúng hoặc đã hết hạn.');
      return;
    }

    final String email = _emailCtrl.text.trim();
    final String password = _passwordCtrl.text;
    final String displayName = _displayNameCtrl.text.trim();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
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
        SnackBar(
          content: const Row(
            children: <Widget>[
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Đăng ký thành công! Chào mừng bạn 🎉'),
            ],
          ),
          backgroundColor: const Color(0xFF1DB954),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
      setState(() => _error = 'Lưu user thất bại: ${e.message ?? e.code}');
    } catch (_) {
      setState(() => _error = 'Đăng ký thất bại, vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNavy,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
                padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
              ),
            ),
            const RegisterHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 28),
                        RegisterTextField(
                          controller: _displayNameCtrl,
                          label: 'User name',
                          hint: 'Nguyễn Văn A',
                          icon: Icons.person_outline_rounded,
                          validator: AuthValidators.displayName,
                        ),
                        const SizedBox(height: 18),
                        if (!_hasFixedEmail)
                          RegisterTextField(
                            controller: _emailCtrl,
                            label: 'Email',
                            hint: 'example@gmail.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: AuthValidators.email,
                          )
                        else
                          RegisterTextField(
                            controller: _emailCtrl,
                            label: 'Email',
                            hint: '',
                            icon: Icons.email_outlined,
                            readOnly: true,
                          ),
                        const SizedBox(height: 18),
                        if (!_hasFixedPassword)
                          RegisterTextField(
                            controller: _passwordCtrl,
                            label: 'Mật khẩu',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            validator: AuthValidators.password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: kGrey,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          )
                        else
                          RegisterTextField(
                            controller: _passwordCtrl,
                            label: 'Mật khẩu',
                            hint: '',
                            icon: Icons.lock_outline_rounded,
                            readOnly: true,
                          ),
                        const SizedBox(height: 24),
                        RegisterTextField(
                          controller: _confirmPasswordCtrl,
                          label: 'Xác nhận mật khẩu',
                          hint: '••••••••',
                          icon: Icons.lock_reset_rounded,
                          obscureText: _obscureConfirmPassword,
                          validator: (String? v) =>
                              AuthValidators.confirmPassword(v, _passwordCtrl.text),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: kGrey,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(color: kGrey.withOpacity(0.18)),
                        const SizedBox(height: 20),
                        OtpSection(
                          otpController: _otpCtrl,
                          otpSent: _otpSent,
                          isLoading: _isLoading,
                          onSendOtp: _sendOtp,
                          validator: (String? v) {
                            final String value = (v ?? '').trim();
                            if (value.isEmpty) return 'Nhập OTP';
                            if (value.length < 6) return 'OTP phải đủ 6 chữ số';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_error != null) ...<Widget>[
                          ErrorBox(message: _error!),
                          const SizedBox(height: 16),
                        ],
                        RegisterSubmitButton(
                          label: 'Xác thực OTP & Đăng ký',
                          isLoading: _isLoading,
                          onPressed: _verifyOtpAndRegister,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Bằng cách đăng ký, bạn đồng ý với\nChính sách & Điều khoản sử dụng.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kGrey.withOpacity(0.7),
                              fontSize: 11,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
