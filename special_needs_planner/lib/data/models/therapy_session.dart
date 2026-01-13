class TherapySession {
  const TherapySession({
    required this.id,
    required this.protocolId,
    required this.startedAt,
    required this.durationMinutes,
    this.rating,
    this.notes,
    this.completedChecklist,
  });

  final String id;
  final String protocolId;
  final DateTime startedAt;
  final int durationMinutes;
  final int? rating;
  final String? notes;
  final List<String>? completedChecklist;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocolId': protocolId,
      'startedAt': startedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'rating': rating,
      'notes': notes,
      'completedChecklist': completedChecklist,
    };
  }

  static TherapySession fromJson(Map<String, dynamic> json) {
    return TherapySession(
      id: json['id'] as String,
      protocolId: json['protocolId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      durationMinutes: json['durationMinutes'] as int,
      rating: json['rating'] as int?,
      notes: json['notes'] as String?,
      completedChecklist: json['completedChecklist'] == null
          ? null
          : List<String>.from(json['completedChecklist'] as List<dynamic>),
    );
  }
}
