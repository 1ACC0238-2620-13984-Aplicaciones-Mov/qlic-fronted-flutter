import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/session/session.dart';
import '../../core/session/session_notifier.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(session.fullName,
                style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(session.email, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: () => context.read<SessionNotifier>().signOut(),
              child: Text(AppStrings.of(context).t('signOut')),
            ),
          ],
        ),
      ),
    );
  }
}