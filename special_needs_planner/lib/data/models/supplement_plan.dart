class SupplementPlan {
  const SupplementPlan({
    required this.id,
    required this.name,
    required this.doseUnit,
    required this.baseDose,
    required this.frequencyPerDay,
    required this.scheduleTimes,
    this.dosePerKg,
    this.rampUpSteps,
    this.notes,
  });

  final String id;
  final String name;
  final String doseUnit;
  final double baseDose;
  final int frequencyPerDay;
  final List<String> scheduleTimes;
  final double? dosePerKg;
  final List<double>? rampUpSteps;
  final String? notes;

  SupplementPlan copyWith({
    String? name,
    String? doseUnit,
    double? baseDose,
    int? frequencyPerDay,
    List<String>? scheduleTimes,
    double? dosePerKg,
    List<double>? rampUpSteps,
    String? notes,
  }) {
    return SupplementPlan(
      id: id,
      name: name ?? this.name,
      doseUnit: doseUnit ?? this.doseUnit,
      baseDose: baseDose ?? this.baseDose,
      frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      dosePerKg: dosePerKg ?? this.dosePerKg,
      rampUpSteps: rampUpSteps ?? this.rampUpSteps,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'doseUnit': doseUnit,
      'baseDose': baseDose,
      'frequencyPerDay': frequencyPerDay,
      'scheduleTimes': scheduleTimes,
      'dosePerKg': dosePerKg,
      'rampUpSteps': rampUpSteps,
      'notes': notes,
    };
  }

  static SupplementPlan fromJson(Map<String, dynamic> json) {
    return SupplementPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      doseUnit: json['doseUnit'] as String,
      baseDose: (json['baseDose'] as num).toDouble(),
      frequencyPerDay: json['frequencyPerDay'] as int,
      scheduleTimes: List<String>.from(json['scheduleTimes'] as List<dynamic>),
      dosePerKg: json['dosePerKg'] == null
          ? null
          : (json['dosePerKg'] as num).toDouble(),
      rampUpSteps: json['rampUpSteps'] == null
          ? null
          : (json['rampUpSteps'] as List<dynamic>)
              .map((value) => (value as num).toDouble())
              .toList(),
      notes: json['notes'] as String?,
    );
  }
}
