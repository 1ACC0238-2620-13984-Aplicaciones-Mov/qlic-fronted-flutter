import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../domain/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_widgets.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final AuthController _controller;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AuthController(context.read<AuthRepository>());
  }

  @override
  void dispose() {
    _controller.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => AuthScaffold(
        title: s.t('signInTitle'),
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: s.t('fieldEmail')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(labelText: s.t('fieldPassword')),
          ),
          const SizedBox(height: 12),
          AuthError(controller: _controller),
          PrimaryButton(
            label: s.t('signInButton'),
            loading: _controller.loading,
            onPressed: () => _controller.signIn(_email.text, _password.text),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
            ),
            child: Text(s.t('goToSignUp')),
          ),
        ],
      ),
    );
  }
}