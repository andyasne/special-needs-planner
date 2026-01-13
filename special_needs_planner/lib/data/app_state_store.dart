import 'package:flutter/material.dart';
import 'package:special_needs_planner/data/app_repository.dart';
import 'package:special_needs_planner/data/models/app_state.dart';
import 'package:special_needs_planner/data/models/child_profile.dart';
import 'package:special_needs_planner/data/models/supplement_log.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/data/models/therapy_session.dart';

class AppStateStore extends ChangeNotifier {
  AppStateStore({required AppRepository repository}) : _repository = repository;

  final AppRepository _repository;
  AppState _state = const AppState(version: 1);

  AppState get state => _state;
  ThemeMode get themeMode =>
      _state.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  bool get isSignedIn => _state.accountEmail != null;
  String? get accountEmail => _state.accountEmail;

  Future<void> load() async {
    _state = await _repository.load();
    if (_state.supplementPlans.isEmpty && _state.therapyProtocols.isEmpty) {
      _state = _state.copyWith(
        childProfile: ChildProfile(
          id: 'child-1',
          name: 'Care profile',
          birthDate: DateTime(2020, 6, 10),
          weightKg: 20.5,
          notes: 'Primary profile',
        ),
        supplementPlans: [
          const SupplementPlan(
            id: 'supp-1',
            name: 'Magnesium',
            doseUnit: 'mg',
            baseDose: 150,
            frequencyPerDay: 3,
            scheduleTimes: ['08:00', '12:30', '18:30'],
            notes: 'Keep with food',
          ),
        ],
        therapyProtocols: [
          const TherapyProtocol(
            id: 'ther-1',
            title: 'Speech practice',
            category: 'Communication',
            steps: [
              'Set a calm space with minimal distractions.',
              'Model a short sound and wait for imitation.',
              'Repeat for 3 rounds, praise small wins.',
            ],
            defaultDurationMinutes: 20,
            mediaHint: 'Soft chime background',
          ),
          const TherapyProtocol(
            id: 'ther-2',
            title: 'Fine motor routine',
            category: 'Motor skills',
            steps: [
              'Prepare simple objects for grasping.',
              'Guide hand movements for 5 minutes.',
              'Encourage independent attempts.',
            ],
            defaultDurationMinutes: 15,
          ),
        ],
      );
      await _repository.save(_state);
    }
    notifyListeners();
  }

  void toggleThemeMode() {
    final updatedMode = themeMode == ThemeMode.dark ? 'light' : 'dark';
    _state = _state.copyWith(themeMode: updatedMode);
    _repository.save(_state);
    notifyListeners();
  }

  Future<void> updatePreferredTherapyTime(String time) async {
    _state = _state.copyWith(preferredTherapyTime: time);
    await _repository.save(_state);
    notifyListeners();
  }

  Future<void> signIn(String email) async {
    _state = _state.copyWith(accountEmail: email);
    await _repository.save(_state);
    notifyListeners();
  }

  Future<void> signOut() async {
    _state = _state.copyWith(accountEmail: null);
    await _repository.save(_state);
    notifyListeners();
  }

  Future<void> addSupplementPlan(SupplementPlan plan) async {
    _state = await _repository.addSupplementPlan(_state, plan);
    notifyListeners();
  }

  Future<void> updateSupplementPlan(SupplementPlan plan) async {
    final updatedPlans = _state.supplementPlans
        .map((item) => item.id == plan.id ? plan : item)
        .toList();
    _state = _state.copyWith(supplementPlans: updatedPlans);
    await _repository.save(_state);
    notifyListeners();
  }

  Future<void> logSupplement(SupplementLog log) async {
    _state = await _repository.logSupplement(_state, log);
    notifyListeners();
  }

  Future<void> addTherapyProtocol(TherapyProtocol protocol) async {
    _state = await _repository.addTherapyProtocol(_state, protocol);
    notifyListeners();
  }

  Future<void> logTherapySession(TherapySession session) async {
    _state = await _repository.logTherapySession(_state, session);
    notifyListeners();
  }
}
