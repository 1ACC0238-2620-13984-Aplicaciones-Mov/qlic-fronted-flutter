import 'package:flutter/foundation.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/network/api_exception.dart';
import '../data/device_api.dart';
import '../data/device_dto.dart';

class DevicesController extends ChangeNotifier {
  DevicesController(this._api, this._accountId);

  final DeviceApi _api;
  final String _accountId;

  List<DeviceDto> devices = const [];
  bool loading = false;
  String? errorKey;
  String? errorText;
  bool _disposed = false;

  bool get hasError => errorKey != null || errorText != null;

  String errorMessage(AppStrings s) => errorText ?? s.t(errorKey ?? 'errGeneric');

  int get onlineCount => devices.where((d) => d.status == 'ONLINE').length;

  Future<void> load() async {
    loading = true;
    errorKey = null;
    errorText = null;
    notifyListeners();
    try {
      devices = await _api.getDevices(_accountId);
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