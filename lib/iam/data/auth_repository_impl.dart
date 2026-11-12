import '../../core/network/api_client.dart';
import '../../core/session/session.dart';
import '../../core/session/session_notifier.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._session);

  final ApiClient _api;
  final SessionNotifier _session;

  @override
  Future<void> signIn({required String email, required String password}) async {
    final json = await _api.post(
      '/api/v1/authentication/sign-in',
      body: {'email': email.trim(), 'password': password},
    ) as Map<String, dynamic>;
    await _session.start(Session.fromJson(json));
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    required bool acceptTerms,
  }) async {
    await _api.post(
      '/api/v1/authentication/sign-up',
      body: {
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        'acceptTerms': acceptTerms,
      },
    );
    await signIn(email: email, password: password);
  }
}