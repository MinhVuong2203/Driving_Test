import 'package:flutter/material.dart';
import 'register_header.dart';

/// Section nhập + gửi OTP gồm nút "Gửi OTP" và ô nhập mã.
class OtpSection extends StatelessWidget {
  const OtpSection({
    super.key,
    required this.otpController,
    required this.otpSent,
    required this.isLoading,
    required this.onSendOtp,
    required this.validator,
  });

  final TextEditingController otpController;
  final bool otpSent;
  final bool isLoading;
  final VoidCallback onSendOtp;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // ── Nút gửi OTP ──────────────────────────────────────────────────────
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onSendOtp,
            icon: Icon(
              otpSent ? Icons.refresh_rounded : Icons.send_rounded,
              size: 18,
            ),
            label: Text(otpSent ? 'Gửi lại OTP' : 'Gửi mã OTP đến email'),
            style: OutlinedButton.styleFrom(
              foregroundColor: kNavy,
              side: BorderSide(
                color: otpSent ? kGreen : kAmber,
                width: 1.8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        // ── Status gửi OTP ────────────────────────────────────────────────────
        if (otpSent) ...<Widget>[
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const Icon(Icons.check_circle_outline_rounded, color: kGreen, size: 14),
              const SizedBox(width: 6),
              Text(
                'Mã OTP đã gửi — kiểm tra hộp thư email của bạn.',
                style: TextStyle(color: kGreen, fontSize: 11),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),

        // ── Label ─────────────────────────────────────────────────────────────
        const Text(
          'Mã OTP',
          style: TextStyle(
            color: kNavy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),

        // ── Input OTP ─────────────────────────────────────────────────────────
        TextFormField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: validator,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kNavy,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 12,
          ),
          decoration: InputDecoration(
            hintText: '------',
            hintStyle: TextStyle(
              color: kGrey.withOpacity(0.4),
              fontSize: 22,
              letterSpacing: 12,
            ),
            counterText: '',
            filled: true,
            fillColor: kInputBg,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            suffixIcon: otpSent
                ? const Icon(Icons.verified_rounded, color: kGreen, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: otpSent ? kGreen.withOpacity(0.4) : Colors.transparent,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kAmber, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kError, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kError, width: 2),
            ),
            errorStyle: const TextStyle(color: kError, fontSize: 11),
          ),
        ),
      ],
    );
  }
}