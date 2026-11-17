import '../../core/network/api_client.dart';
import 'device_dto.dart';

class DeviceApi {
  DeviceApi(this._api);

  final ApiClient _api;

  Future<List<DeviceDto>> getDevices(String accountId) async {
    final json = await _api.get(
      '/api/v1/devices',
      query: {'accountId': accountId},
    ) as List<dynamic>;
    return json
        .map((e) => DeviceDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}