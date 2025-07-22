import 'package:flutter/material.dart';
import '../../../models/workout_plan.dart';

class WeeklyCalendarWidget extends StatelessWidget {
  final String selectedDay;
  final Function(String) onDaySelected;
  final WorkoutPlan? workoutPlan;

  const WeeklyCalendarWidget({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.workoutPlan,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final fullDayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final dayDate = startOfWeek.add(Duration(days: index));
          final dayName = fullDayNames[index];
          final isSelected = selectedDay == dayName;
          final hasWorkout =
              workoutPlan?.getExercisesForDay(dayName).isNotEmpty ?? false;
          final isToday = dayDate.day == now.day && dayDate.month == now.month;

          return GestureDetector(
            onTap: () => onDaySelected(dayName),
            child: Container(
              width: 48,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdays[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dayDate.day.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  if (hasWorkout)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
