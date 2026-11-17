import 'package:flutter/foundation.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/network/api_exception.dart';
import '../data/alert_api.dart';
import '../data/alert_dto.dart';

class AlertsController extends ChangeNotifier {
  AlertsController(this._api, this._accountId);

  final AlertApi _api;
  final String _accountId;

  static const _rank = {'CRITICAL': 0, 'MODERATE': 1, 'INFORMATIONAL': 2};

  List<AlertDto> alerts = const [];
  bool loading = false;
  String? errorKey;
  String? errorText;
  bool _disposed = false;

  bool get hasError => errorKey != null || errorText != null;

  String errorMessage(AppStrings s) => errorText ?? s.t(errorKey ?? 'errGeneric');

  Iterable<AlertDto> get _active => alerts.where((a) => a.state == 'ACTIVE');

  int get activeCount => _active.length;

  int get criticalCount => _active.where((a) => a.urgency == 'CRITICAL').length;

  double get activeVolume =>
      _active.fold<double>(0, (sum, a) => sum + a.estimatedVolumeLiters);

  double get activeCost =>
      _active.fold<double>(0, (sum, a) => sum + a.estimatedCostSoles);

  Future<void> load() async {
    loading = true;
    errorKey = null;
    errorText = null;
    notifyListeners();
    try {
      final list = await _api.getAlerts(_accountId);
      list.sort((a, b) {
        final byUrgency =
        (_rank[a.urgency] ?? 3).compareTo(_rank[b.urgency] ?? 3);
        return byUrgency != 0 ? byUrgency : b.detectedAt.compareTo(a.detectedAt);
      });
      alerts = list;
    } on ApiException catch (e) {
      errorText = e.message;
    } on NetworkException {
      errorKey = 'errNetwork';
    } catch (_) {
      errorKey = 'errGeneric';
    }
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}