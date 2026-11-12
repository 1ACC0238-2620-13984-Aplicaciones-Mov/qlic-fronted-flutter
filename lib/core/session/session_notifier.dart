import 'package:flutter/foundation.dart';

import 'session.dart';
import 'session_store.dart';

class SessionNotifier extends ChangeNotifier {
  SessionNotifier(this._store);

  final SessionStore _store;
  Session? _session;

  Session? get session => _session;
  bool get isSignedIn => _session != null && !_session!.isExpired;

  Future<void> load() async {
    final stored = await _store.read();
    if (stored != null && !stored.isExpired) {
      _session = stored;
    } else if (stored != null) {
      await _store.clear();
    }
    notifyListeners();
  }

  Future<void> start(Session session) async {
    await _store.save(session);
    _session = session;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _store.clear();
    _session = null;
    notifyListeners();
  }
}