class WorkoutPlan {
  final Map<String, List<Exercise>> weeklyPlan;

  WorkoutPlan({required this.weeklyPlan});

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    Map<String, List<Exercise>> plan = {};

    json.forEach((day, exercises) {
      if (exercises is List) {
        plan[day] = exercises.map((e) => Exercise.fromJson(e)).toList();
      }
    });

    return WorkoutPlan(weeklyPlan: plan);
  }

  Map<String, dynamic> toJson() {
    return weeklyPlan.map((day, exercises) =>
        MapEntry(day, exercises.map((e) => e.toJson()).toList()));
  }

  List<Exercise> getExercisesForDay(String day) {
    return weeklyPlan[day.toLowerCase()] ?? [];
  }
}

class Exercise {
  final String exercise;
  final int? sets;
  final int? reps;
  final String? duration;
  final String? notes;

  Exercise({
    required this.exercise,
    this.sets,
    this.reps,
    this.duration,
    this.notes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exercise: json['exercise'] ?? '',
      sets: json['sets'],
      reps: json['reps'],
      duration: json['duration'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'exercise': exercise};
    if (sets != null) data['sets'] = sets;
    if (reps != null) data['reps'] = reps;
    if (duration != null) data['duration'] = duration;
    if (notes != null) data['notes'] = notes;
    return data;
  }

  String get displayText {
    if (sets != null && reps != null) {
      return '$exercise: $sets sets x $reps reps';
    } else if (duration != null) {
      return '$exercise: $duration';
    } else {
      return exercise;
    }
  }
}
