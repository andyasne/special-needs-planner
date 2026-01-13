import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:special_needs_planner/data/models/app_state.dart';

class LocalStorage {
  LocalStorage({required SharedPreferences preferences})
      : _preferences = preferences;

  static const String _stateKey = 'app_state_v1';

  final SharedPreferences _preferences;

  Future<AppState?> loadState() async {
    final payload = _preferences.getString(_stateKey);
    if (payload == null || payload.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(payload) as Map<String, dynamic>;
    return AppState.fromJson(decoded);
  }

  Future<void> saveState(AppState state) async {
    final encoded = jsonEncode(state.toJson());
    await _preferences.setString(_stateKey, encoded);
  }
}
