import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/util/format.dart';
import '../../core/widgets/error_view.dart';
import '../data/alert_dto.dart';
import 'alerts_controller.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final c = context.watch<AlertsController>();

    final Widget body;
    if (c.loading && c.alerts.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (c.hasError && c.alerts.isEmpty) {
      body = ErrorView(
        message: c.errorMessage(s),
        retryLabel: s.t('retry'),
        onRetry: c.load,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: c.load,
        child: c.alerts.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Center(child: Text(s.t('noAlerts'), textAlign: TextAlign.center)),
          ],
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: c.alerts.length,
          itemBuilder: (_, i) => _AlertCard(alert: c.alerts[i]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.t('navAlerts'))),
      body: body,
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final AlertDto alert;

  Color _urgencyColor() {
    switch (alert.urgency) {
      case 'CRITICAL':
        return Colors.red.shade700;
      case 'MODERATE':
        return Colors.orange.shade800;
      default:
        return Colors.blue.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final key = 'urgency${alert.urgency}';
    final label = s.t(key) == key ? alert.urgency : s.t(key);
    final color = _urgencyColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(formatDateTime(alert.detectedAt), style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            Text(s.t('recommendedAction'), style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(alert.recommendedAction),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${s.t('estimatedVolume')}: '
                        '${alert.estimatedVolumeLiters.toStringAsFixed(1)} L',
                  ),
                ),
                Text(
                  '${s.t('estimatedCost')}: '
                      'S/ ${alert.estimatedCostSoles.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}