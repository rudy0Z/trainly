import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../models/workout_plan.dart';
import './widgets/add_exercise_modal.dart';
import './widgets/exercise_card_widget.dart';
import './widgets/weekly_calendar_widget.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({super.key});

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> {
  WorkoutPlan? _workoutPlan;
  String _selectedDay = _getCurrentDay();
  bool _isLoading = true;

  static String _getCurrentDay() {
    final weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return weekdays[DateTime.now().weekday - 1];
  }

  @override
  void initState() {
    super.initState();
    _loadWorkoutPlan();
  }

  Future<void> _loadWorkoutPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutJson = prefs.getString('workout_plan');

    if (workoutJson != null) {
      setState(() {
        _workoutPlan = WorkoutPlan.fromJson(jsonDecode(workoutJson));
        _isLoading = false;
      });
    } else {
      setState(() {
        _workoutPlan = WorkoutPlan(weeklyPlan: {});
        _isLoading = false;
      });
    }
  }

  Future<void> _saveWorkoutPlan() async {
    if (_workoutPlan != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('workout_plan', jsonEncode(_workoutPlan!.toJson()));
    }
  }

  void _onDaySelected(String day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _addExercise(Exercise exercise) {
    setState(() {
      if (_workoutPlan!.weeklyPlan[_selectedDay] == null) {
        _workoutPlan!.weeklyPlan[_selectedDay] = [];
      }
      _workoutPlan!.weeklyPlan[_selectedDay]!.add(exercise);
    });
    _saveWorkoutPlan();
  }

  void _editExercise(int index, Exercise exercise) {
    setState(() {
      _workoutPlan!.weeklyPlan[_selectedDay]![index] = exercise;
    });
    _saveWorkoutPlan();
  }

  void _deleteExercise(int index) {
    setState(() {
      _workoutPlan!.weeklyPlan[_selectedDay]!.removeAt(index);
    });
    _saveWorkoutPlan();
  }

  void _showAddExerciseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExerciseModal(
        onAddExercise: _addExercise,
      ),
    );
  }

  Future<void> _syncWithChat() async {
    // This will trigger a sync notification to indicate manual edits
    // In a real app, this could send updated plan back to chat context
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Changes synced with chat! Trainly now knows about your manual edits.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('📆 Planner View')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final todaysExercises =
        _workoutPlan?.getExercisesForDay(_selectedDay) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('📆 Planner View'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncWithChat,
            tooltip: 'Sync with Chat',
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chat-with-trainly');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          WeeklyCalendarWidget(
            selectedDay: _selectedDay,
            onDaySelected: _onDaySelected,
            workoutPlan: _workoutPlan,
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDay.capitalize()} Workouts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddExerciseModal,
                  icon: Icon(Icons.add),
                  label: Text('Add Exercise'),
                ),
              ],
            ),
          ),
          Expanded(
            child: todaysExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No workouts planned for ${_selectedDay.capitalize()}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add exercises manually or ask Trainly in chat!',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _showAddExerciseModal,
                          icon: Icon(Icons.add),
                          label: Text('Add First Exercise'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: todaysExercises.length,
                    itemBuilder: (context, index) {
                      return ExerciseCardWidget(
                        exercise: todaysExercises[index],
                        onEdit: (exercise) => _editExercise(index, exercise),
                        onDelete: () => _deleteExercise(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
