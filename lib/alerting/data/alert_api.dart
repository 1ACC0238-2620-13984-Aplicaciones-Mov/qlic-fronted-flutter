import '../../core/network/api_client.dart';
import 'alert_dto.dart';

class AlertApi {
  AlertApi(this._api);

  final ApiClient _api;

  Future<List<AlertDto>> getAlerts(String accountId) async {
    final json = await _api.get(
      '/api/v1/alerts',
      query: {'accountId': accountId},
    ) as List<dynamic>;
    return json
        .map((e) => AlertDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}