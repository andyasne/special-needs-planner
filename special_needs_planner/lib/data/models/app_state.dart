import 'package:special_needs_planner/data/models/child_profile.dart';
import 'package:special_needs_planner/data/models/supplement_log.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/data/models/therapy_session.dart';

class AppState {
  const AppState({
    required this.version,
    this.childProfile,
    this.supplementPlans = const [],
    this.supplementLogs = const [],
    this.therapyProtocols = const [],
    this.therapySessions = const [],
    this.preferredTherapyTime = '16:00',
    this.themeMode = 'light',
    this.accountEmail,
  });

  final int version;
  final ChildProfile? childProfile;
  final List<SupplementPlan> supplementPlans;
  final List<SupplementLog> supplementLogs;
  final List<TherapyProtocol> therapyProtocols;
  final List<TherapySession> therapySessions;
  final String preferredTherapyTime;
  final String themeMode;
  final String? accountEmail;

  AppState copyWith({
    ChildProfile? childProfile,
    List<SupplementPlan>? supplementPlans,
    List<SupplementLog>? supplementLogs,
    List<TherapyProtocol>? therapyProtocols,
    List<TherapySession>? therapySessions,
    String? preferredTherapyTime,
    String? themeMode,
    String? accountEmail,
  }) {
    return AppState(
      version: version,
      childProfile: childProfile ?? this.childProfile,
      supplementPlans: supplementPlans ?? this.supplementPlans,
      supplementLogs: supplementLogs ?? this.supplementLogs,
      therapyProtocols: therapyProtocols ?? this.therapyProtocols,
      therapySessions: therapySessions ?? this.therapySessions,
      preferredTherapyTime: preferredTherapyTime ?? this.preferredTherapyTime,
      themeMode: themeMode ?? this.themeMode,
      accountEmail: accountEmail ?? this.accountEmail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'childProfile': childProfile?.toJson(),
      'supplementPlans': supplementPlans.map((plan) => plan.toJson()).toList(),
      'supplementLogs': supplementLogs.map((log) => log.toJson()).toList(),
      'therapyProtocols':
          therapyProtocols.map((protocol) => protocol.toJson()).toList(),
      'therapySessions':
          therapySessions.map((session) => session.toJson()).toList(),
      'preferredTherapyTime': preferredTherapyTime,
      'themeMode': themeMode,
      'accountEmail': accountEmail,
    };
  }

  static AppState fromJson(Map<String, dynamic> json) {
    return AppState(
      version: json['version'] as int,
      childProfile: json['childProfile'] == null
          ? null
          : ChildProfile.fromJson(
              json['childProfile'] as Map<String, dynamic>,
            ),
      supplementPlans: (json['supplementPlans'] as List<dynamic>)
          .map((plan) =>
              SupplementPlan.fromJson(plan as Map<String, dynamic>))
          .toList(),
      supplementLogs: (json['supplementLogs'] as List<dynamic>)
          .map(
              (log) => SupplementLog.fromJson(log as Map<String, dynamic>))
          .toList(),
      therapyProtocols: (json['therapyProtocols'] as List<dynamic>)
          .map((protocol) =>
              TherapyProtocol.fromJson(protocol as Map<String, dynamic>))
          .toList(),
      therapySessions: (json['therapySessions'] as List<dynamic>)
          .map((session) =>
              TherapySession.fromJson(session as Map<String, dynamic>))
          .toList(),
      preferredTherapyTime: json['preferredTherapyTime'] as String? ?? '16:00',
      themeMode: json['themeMode'] as String? ?? 'light',
      accountEmail: json['accountEmail'] as String?,
    );
  }
}
