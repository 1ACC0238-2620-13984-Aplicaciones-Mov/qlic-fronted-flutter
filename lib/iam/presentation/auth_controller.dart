import 'package:flutter/foundation.dart';

import '../../core/network/api_exception.dart';
import '../domain/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool loading = false;
  String? errorKey;
  String? errorText;
  bool _disposed = false;

  Future<bool> signIn(String email, String password) {
    if (!_isValidEmail(email)) return _fail('errInvalidEmail');
    if (password.isEmpty) return _fail('errPasswordRequired');
    return _run(() => _repository.signIn(email: email, password: password));
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required bool acceptTerms,
  }) {
    if (fullName.trim().isEmpty) return _fail('errNameRequired');
    if (!_isValidEmail(email)) return _fail('errInvalidEmail');
    if (password.length < 8) return _fail('errPasswordShort');
    if (!acceptTerms) return _fail('errTermsRequired');
    return _run(
          () => _repository.signUp(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        acceptTerms: acceptTerms,
      ),
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  Future<bool> _fail(String key) async {
    loading = false;
    errorKey = key;
    errorText = null;
    notifyListeners();
    return false;
  }

  Future<bool> _run(Future<void> Function() action) async {
    loading = true;
    errorKey = null;
    errorText = null;
    notifyListeners();
    try {
      await action();
      loading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorText = e.message;
    } on NetworkException {
      errorKey = 'errNetwork';
    } catch (_) {
      errorKey = 'errGeneric';
    }
    loading = false;
    notifyListeners();
    return false;
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