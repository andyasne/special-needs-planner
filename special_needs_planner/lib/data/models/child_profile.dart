class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.weightKg,
    this.notes,
  });

  final String id;
  final String name;
  final DateTime birthDate;
  final double weightKg;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'weightKg': weightKg,
      'notes': notes,
    };
  }

  static ChildProfile fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      weightKg: (json['weightKg'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}
