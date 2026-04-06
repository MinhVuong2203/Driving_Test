import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    required this.navy,
    required this.grey,
    required this.inputBg,
    required this.amber,
    required this.error,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  final Color navy;
  final Color grey;
  final Color inputBg;
  final Color amber;
  final Color error;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: navy, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: grey.withOpacity(0.6), fontSize: 14),
        prefixIcon: Icon(icon, color: grey, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: amber, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 2),
        ),
        errorStyle: TextStyle(color: error, fontSize: 11),
      ),
    );
  }
}
