import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/l10n/app_strings.dart';
import 'core/session/session_notifier.dart';
import 'core/theme/app_theme.dart';
import 'home/presentation/main_shell.dart';
import 'iam/presentation/sign_in_page.dart';

class QlicApp extends StatelessWidget {
  const QlicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qlic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // The first locale is the fallback: English by default.
      supportedLocales: AppStrings.supportedLocales,
      home: Consumer<SessionNotifier>(
        builder: (_, session, __) =>
        session.isSignedIn ? const MainShell() : const SignInPage(),
      ),
    );
  }
}