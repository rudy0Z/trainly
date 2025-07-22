class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final List<String> fitnessGoals;
  final List<String> availableWorkoutDays;
  final List<String> preferredWorkoutTypes;

  UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.fitnessGoals,
    required this.availableWorkoutDays,
    required this.preferredWorkoutTypes,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      height: (json['height'] ?? 0.0).toDouble(),
      weight: (json['weight'] ?? 0.0).toDouble(),
      fitnessGoals: List<String>.from(json['fitnessGoals'] ?? []),
      availableWorkoutDays:
          List<String>.from(json['availableWorkoutDays'] ?? []),
      preferredWorkoutTypes:
          List<String>.from(json['preferredWorkoutTypes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'fitnessGoals': fitnessGoals,
      'availableWorkoutDays': availableWorkoutDays,
      'preferredWorkoutTypes': preferredWorkoutTypes,
    };
  }

  String get profileSummary {
    return 'Name: $name, Age: $age, Goals: ${fitnessGoals.join(", ")}, '
        'Workout Days: ${availableWorkoutDays.join(", ")}, '
        'Preferred Types: ${preferredWorkoutTypes.join(", ")}';
  }
}
