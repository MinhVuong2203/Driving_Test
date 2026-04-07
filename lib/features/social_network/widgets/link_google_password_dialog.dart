import 'package:flutter/material.dart';

Future<String?> showLinkGooglePasswordDialog(
    BuildContext context, {
      required String email,
    }) async {
  final TextEditingController controller = TextEditingController();
  bool obscure = true;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Liên kết tài khoản'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Email $email đã được đăng ký bằng mật khẩu trước đó.\n'
                      'Nhập mật khẩu để liên kết Google vào đúng tài khoản cũ.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => obscure = !obscure);
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, null),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, controller.text.trim()),
                child: const Text('Liên kết'),
              ),
            ],
          );
        },
      );
    },
  );
}