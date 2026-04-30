import 'package:flutter/material.dart';
import 'register_header.dart';

/// Hộp hiển thị thông báo lỗi với icons cảnh báo.
class ErrorBox extends StatelessWidget {
  const ErrorBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: kError.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kError.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.error_outline_rounded, color: kError, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: kError, fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}