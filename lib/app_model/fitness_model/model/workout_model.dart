// lib/models/workout.dart

class Workout {
  final int? id;
  final String type;
  final int duration; // Duration in minutes
  final int calories;
  final DateTime date;

  Workout({
    this.id,
    required this.type,
    required this.duration,
    required this.calories,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      type: map['type'],
      duration: map['duration'],
      calories: map['calories'],
      date: DateTime.parse(map['date']),
    );
  }
}