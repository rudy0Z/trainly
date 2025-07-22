import 'package:flutter/material.dart';
import '../../../models/workout_plan.dart';

class AddExerciseModal extends StatefulWidget {
  final Function(Exercise) onAddExercise;
  final Exercise? initialExercise;
  final bool isEditing;

  const AddExerciseModal({
    super.key,
    required this.onAddExercise,
    this.initialExercise,
    this.isEditing = false,
  });

  @override
  State<AddExerciseModal> createState() => _AddExerciseModalState();
}

class _AddExerciseModalState extends State<AddExerciseModal> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSetsBased = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialExercise != null) {
      final exercise = widget.initialExercise!;
      _exerciseController.text = exercise.exercise;
      _setsController.text = exercise.sets?.toString() ?? '';
      _repsController.text = exercise.reps?.toString() ?? '';
      _durationController.text = exercise.duration ?? '';
      _notesController.text = exercise.notes ?? '';
      _isSetsBased = exercise.sets != null;
    }
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final exercise = Exercise(
        exercise: _exerciseController.text,
        sets: _isSetsBased && _setsController.text.isNotEmpty
            ? int.tryParse(_setsController.text)
            : null,
        reps: _isSetsBased && _repsController.text.isNotEmpty
            ? int.tryParse(_repsController.text)
            : null,
        duration: !_isSetsBased && _durationController.text.isNotEmpty
            ? _durationController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      widget.onAddExercise(exercise);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEditing ? 'Edit Exercise' : 'Add Exercise',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Exercise name
                TextFormField(
                  controller: _exerciseController,
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    hintText: 'e.g., Push-ups, Running',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter an exercise name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Exercise type toggle
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Sets & Reps'),
                        selected: _isSetsBased,
                        onSelected: (selected) {
                          setState(() {
                            _isSetsBased = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Duration'),
                        selected: !_isSetsBased,
                        onSelected: (selected) {
                          setState(() {
                            _isSetsBased = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Sets and reps or duration
                if (_isSetsBased) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _setsController,
                          decoration: InputDecoration(
                            labelText: 'Sets',
                            hintText: '3',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _repsController,
                          decoration: InputDecoration(
                            labelText: 'Reps',
                            hintText: '15',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      hintText: 'e.g., 30 min, 5 km, 60 seconds',
                    ),
                  ),
                ],
                SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Any additional notes...',
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveExercise,
                    child: Text(
                        widget.isEditing ? 'Update Exercise' : 'Add Exercise'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
