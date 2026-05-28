import 'package:flutter/material.dart';
import 'register_header.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.textColor = kNavy,
    this.subTextColor = kGrey,
    this.inputBg = kInputBg,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Color textColor;
  final Color subTextColor;
  final Color inputBg;

  @override
  Widget build(BuildContext context) {
    final bgColor = readOnly
        ? inputBg.withValues(alpha: 0.65)
        : inputBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
          readOnly: readOnly,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: subTextColor.withValues(alpha: 0.65),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: subTextColor,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            counterText: '',
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: subTextColor.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: kAmber,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: kError,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: kError,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(
              color: kError,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}