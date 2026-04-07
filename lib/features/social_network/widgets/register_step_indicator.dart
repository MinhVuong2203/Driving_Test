import 'package:flutter/material.dart';
import 'register_header.dart';

/// Thanh tiến trình 2 bước: Điền thông tin → Xác thực OTP.
class RegisterStepIndicator extends StatelessWidget {
  const RegisterStepIndicator({super.key, required this.otpSent});

  final bool otpSent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _Step(
          number: '1',
          label: 'Thông tin',
          active: !otpSent,
          done: otpSent,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: otpSent ? kAmber : kGrey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        _Step(
          number: '2',
          label: 'Xác thực OTP',
          active: otpSent,
          done: false,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.label,
    required this.active,
    required this.done,
  });

  final String number;
  final String label;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final Color circleColor = done
        ? kAmber
        : active
        ? kNavy
        : kGrey.withOpacity(0.3);

    final Color textColor = active || done ? kNavy : kGrey;

    return Column(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded, color: kNavy, size: 15)
                : Text(
              number,
              style: TextStyle(
                color: active ? kWhite : kGrey,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}