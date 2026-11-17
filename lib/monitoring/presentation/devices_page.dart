import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/util/format.dart';
import '../../core/widgets/error_view.dart';
import '../data/device_dto.dart';
import 'devices_controller.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final c = context.watch<DevicesController>();

    final Widget body;
    if (c.loading && c.devices.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (c.hasError && c.devices.isEmpty) {
      body = ErrorView(
        message: c.errorMessage(s),
        retryLabel: s.t('retry'),
        onRetry: c.load,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: c.load,
        child: c.devices.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Center(child: Text(s.t('noDevices'), textAlign: TextAlign.center)),
          ],
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: c.devices.length,
          itemBuilder: (_, i) => _DeviceCard(device: c.devices[i]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.t('navDevices'))),
      body: body,
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device});

  final DeviceDto device;

  Color _statusColor() {
    switch (device.status) {
      case 'ONLINE':
        return Colors.green.shade700;
      case 'LOW_BATTERY':
        return Colors.orange.shade800;
      case 'CALIBRATING':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _batteryIcon() {
    final level = device.batteryPercentage;
    if (level <= 15) return Icons.battery_alert;
    if (level <= 60) return Icons.battery_3_bar;
    return Icons.battery_full;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final key = 'status${device.status}';
    final label = s.t(key) == key ? device.status : s.t(key);
    final color = _statusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.serialNumber, style: theme.textTheme.titleMedium),
                      Text(device.model, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(_batteryIcon(), size: 18),
                const SizedBox(width: 6),
                Text('${s.t('battery')}: ${device.batteryPercentage}%'),
              ],
            ),
            const SizedBox(height: 4),
            Text('${s.t('lastSync')}: ${formatDateTime(device.lastSyncAt)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.water_drop_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    device.waterPointId == null
                        ? s.t('unassigned')
                        : '${s.t('waterPointLabel')}: ${device.waterPointId}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}