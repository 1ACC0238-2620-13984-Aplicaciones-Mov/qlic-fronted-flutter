import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../alerting/presentation/alerts_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/widgets/error_view.dart';
import '../../monitoring/presentation/devices_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final alerts = context.watch<AlertsController>();
    final devices = context.watch<DevicesController>();

    final alertsEmpty = alerts.alerts.isEmpty;
    final devicesEmpty = devices.devices.isEmpty;
    final loading = (alerts.loading && alertsEmpty) || (devices.loading && devicesEmpty);
    final failed = (alerts.hasError && alertsEmpty) || (devices.hasError && devicesEmpty);

    final Widget content;
    if (loading) {
      content = const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (failed) {
      content = ErrorView(
        message: alerts.hasError ? alerts.errorMessage(s) : devices.errorMessage(s),
        retryLabel: s.t('retry'),
        onRetry: () {
          alerts.load();
          devices.load();
        },
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.sensors,
                  value: '${devices.devices.length}',
                  label: s.t('navDevices'),
                  caption: '${devices.onlineCount} ${s.t('statusONLINE')}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.notifications_active_outlined,
                  value: '${alerts.activeCount}',
                  label: s.t('summaryActive'),
                  caption: '${alerts.criticalCount} ${s.t('summaryCritical')}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            icon: Icons.water_drop_outlined,
            value: 'S/ ${alerts.activeCost.toStringAsFixed(2)}',
            label: s.t('estimatedLoss'),
            caption: '${alerts.activeVolume.toStringAsFixed(1)} L',
          ),
          if (alerts.criticalCount > 0) ...[
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: theme.colorScheme.onErrorContainer,
                ),
                title: Text(
                  s.t('criticalBanner'),
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: () => Future.wait([alerts.load(), devices.load()]),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            greeting,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    this.caption,
  });

  final IconData icon;
  final String value;
  final String label;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: theme.textTheme.titleSmall),
            if (caption != null) Text(caption!, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}