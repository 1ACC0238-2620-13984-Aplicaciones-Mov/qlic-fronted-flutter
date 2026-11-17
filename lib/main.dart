import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alerting/data/alert_api.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'core/session/session_notifier.dart';
import 'core/session/session_store.dart';
import 'iam/data/auth_repository_impl.dart';
import 'iam/domain/auth_repository.dart';
import 'monitoring/data/device_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionNotifier = SessionNotifier(SessionStore());
  await sessionNotifier.load();
  final apiClient = ApiClient(sessionNotifier);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionNotifier>.value(value: sessionNotifier),
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthRepository>.value(
          value: AuthRepositoryImpl(apiClient, sessionNotifier),
        ),
        Provider<AlertApi>.value(value: AlertApi(apiClient)),
        Provider<DeviceApi>.value(value: DeviceApi(apiClient)),
      ],
      child: const QlicApp(),
    ),
  );
}