class TherapyProtocol {
  const TherapyProtocol({
    required this.id,
    required this.title,
    required this.category,
    required this.steps,
    this.defaultDurationMinutes,
    this.mediaHint,
  });

  final String id;
  final String title;
  final String category;
  final List<String> steps;
  final int? defaultDurationMinutes;
  final String? mediaHint;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'steps': steps,
      'defaultDurationMinutes': defaultDurationMinutes,
      'mediaHint': mediaHint,
    };
  }

  static TherapyProtocol fromJson(Map<String, dynamic> json) {
    return TherapyProtocol(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      steps: List<String>.from(json['steps'] as List<dynamic>),
      defaultDurationMinutes: json['defaultDurationMinutes'] as int?,
      mediaHint: json['mediaHint'] as String?,
    );
  }
}
