import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {
  final bool isLoading;
  final String? errorText;
  final Future<void> Function(String email, String password) onSignIn;
  final Future<void> Function(String email, String password) onRegister;
  final Future<void> Function(String email) onSendEmailLink;

  const AuthFormWidget({
    super.key,
    required this.isLoading,
    required this.errorText,
    required this.onSignIn,
    required this.onRegister,
    required this.onSendEmailLink,
  });

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSignIn(_emailCtrl.text, _passCtrl.text);
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onRegister(_emailCtrl.text, _passCtrl.text);
  }

  Future<void> _submitEmailLink() async {
    final String email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    await widget.onSendEmailLink(email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String? v) {
              if (v == null || v.trim().isEmpty) return 'Nhap email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mat khau'),
            validator: (String? v) {
              if (v == null || v.isEmpty) return 'Nhap mat khau';
              if (v.length < 6) return 'Mat khau toi thieu 6 ky tu';
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (widget.errorText != null)
            Text(widget.errorText!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _submitSignIn,
                  child: widget.isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Dang nhap'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.isLoading ? null : _submitRegister,
                  child: const Text('Dang ky'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: widget.isLoading ? null : _submitEmailLink,
              child: const Text('Gui link dang nhap qua Email'),
            ),
          ),
        ],
      ),
    );
  }
}
