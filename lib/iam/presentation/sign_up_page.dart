import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../domain/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final AuthController _controller;
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = AuthController(context.read<AuthRepository>());
  }

  @override
  void dispose() {
    _controller.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.signUp(
      fullName: _fullName.text,
      email: _email.text,
      password: _password.text,
      phone: _phone.text,
      acceptTerms: _acceptTerms,
    );
    if (ok && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => AuthScaffold(
        title: s.t('signUpTitle'),
        children: [
          TextField(
            controller: _fullName,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: s.t('fieldFullName')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: s.t('fieldEmail')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: s.t('fieldPhoneOptional')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: s.t('fieldPassword'),
              helperText: s.t('passwordHint'),
            ),
          ),
          CheckboxListTile(
            value: _acceptTerms,
            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
            title: Text(s.t('acceptTerms')),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          AuthError(controller: _controller),
          PrimaryButton(
            label: s.t('signUpButton'),
            loading: _controller.loading,
            onPressed: _submit,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.t('goToSignIn')),
          ),
        ],
      ),
    );
  }
}