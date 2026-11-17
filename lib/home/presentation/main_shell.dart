import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../alerting/data/alert_api.dart';
import '../../alerting/presentation/alerts_controller.dart';
import '../../alerting/presentation/alerts_page.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/session/session_notifier.dart';
import '../../monitoring/data/device_api.dart';
import '../../monitoring/presentation/devices_controller.dart';
import '../../monitoring/presentation/devices_page.dart';
import 'dashboard_page.dart';
import 'placeholder_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final session = context.watch<SessionNotifier>().session;
    if (session == null) return const SizedBox.shrink();

    final pages = <Widget>[
      DashboardPage(
        greeting: s.t('dashboardGreeting').replaceFirst('{name}', session.fullName),
      ),
      const DevicesPage(),
      const AlertsPage(),
      PlaceholderPage(title: s.t('navReports')),
      ProfilePage(session: session),
    ];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DevicesController>(
          create: (ctx) =>
          DevicesController(ctx.read<DeviceApi>(), session.accountId)..load(),
        ),
        ChangeNotifierProvider<AlertsController>(
          create: (ctx) =>
          AlertsController(ctx.read<AlertApi>(), session.accountId)..load(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(child: IndexedStack(index: _index, children: pages)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: s.t('navDashboard'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.sensors_outlined),
              selectedIcon: const Icon(Icons.sensors),
              label: s.t('navDevices'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined),
              selectedIcon: const Icon(Icons.notifications),
              label: s.t('navAlerts'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: s.t('navReports'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: s.t('navProfile'),
            ),
          ],
        ),
      ),
    );
  }
}