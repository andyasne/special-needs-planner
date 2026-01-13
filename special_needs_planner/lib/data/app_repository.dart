import 'package:shared_preferences/shared_preferences.dart';
import 'package:special_needs_planner/data/models/app_state.dart';
import 'package:special_needs_planner/data/models/supplement_log.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/data/models/therapy_session.dart';
import 'package:special_needs_planner/data/storage/local_storage.dart';

class AppRepository {
  AppRepository({required LocalStorage storage}) : _storage = storage;

  static const int _currentVersion = 1;

  final LocalStorage _storage;

  Future<AppState> load() async {
    final stored = await _storage.loadState();
    return stored ?? const AppState(version: _currentVersion);
  }

  Future<void> save(AppState state) async {
    await _storage.saveState(state);
  }

  Future<AppState> addSupplementPlan(
    AppState state,
    SupplementPlan plan,
  ) async {
    final updated = state.copyWith(
      supplementPlans: [...state.supplementPlans, plan],
    );
    await save(updated);
    return updated;
  }

  Future<AppState> logSupplement(
    AppState state,
    SupplementLog log,
  ) async {
    final updated = state.copyWith(
      supplementLogs: [...state.supplementLogs, log],
    );
    await save(updated);
    return updated;
  }

  Future<AppState> addTherapyProtocol(
    AppState state,
    TherapyProtocol protocol,
  ) async {
    final updated = state.copyWith(
      therapyProtocols: [...state.therapyProtocols, protocol],
    );
    await save(updated);
    return updated;
  }

  Future<AppState> logTherapySession(
    AppState state,
    TherapySession session,
  ) async {
    final updated = state.copyWith(
      therapySessions: [...state.therapySessions, session],
    );
    await save(updated);
    return updated;
  }

  static Future<AppRepository> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return AppRepository(
      storage: LocalStorage(preferences: preferences),
    );
  }
}
