enum SupplementLogStatus {
  taken,
  skipped,
  rescheduled,
  missed,
}

class SupplementLog {
  const SupplementLog({
    required this.id,
    required this.planId,
    required this.scheduledAt,
    required this.status,
    this.recordedAt,
    this.notes,
  });

  final String id;
  final String planId;
  final DateTime scheduledAt;
  final SupplementLogStatus status;
  final DateTime? recordedAt;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status.name,
      'recordedAt': recordedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  static SupplementLog fromJson(Map<String, dynamic> json) {
    return SupplementLog(
      id: json['id'] as String,
      planId: json['planId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      status: SupplementLogStatus.values.firstWhere(
        (value) => value.name == json['status'],
      ),
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.parse(json['recordedAt'] as String),
      notes: json['notes'] as String?,
    );
  }
}
