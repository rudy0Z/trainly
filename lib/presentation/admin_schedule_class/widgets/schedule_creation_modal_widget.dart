import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScheduleCreationModalWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Map<String, dynamic>) onClassScheduled;

  const ScheduleCreationModalWidget({
    super.key,
    required this.selectedDate,
    required this.onClassScheduled,
  });

  @override
  State<ScheduleCreationModalWidget> createState() =>
      _ScheduleCreationModalWidgetState();
}

class _ScheduleCreationModalWidgetState
    extends State<ScheduleCreationModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _durationController = TextEditingController();

  String? _selectedTrainer;
  String? _selectedRoom;
  String? _selectedTime;
  DateTime? _selectedDate;
  bool _isRecurring = false;
  String _recurringPattern = 'weekly';
  bool _isLoading = false;

  final List<Map<String, String>> _trainers = [
    {
      'id': 'trainer_1',
      'name': 'Sarah Johnson',
      'image':
          'https://images.unsplash.com/photo-1494790108755-2616b79dced0?w=150&h=150&fit=crop&crop=face'
    },
    {
      'id': 'trainer_2',
      'name': 'Mike Chen',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'
    },
    {
      'id': 'trainer_3',
      'name': 'Emma Wilson',
      'image':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face'
    },
  ];

  final List<String> _rooms = [
    'Studio A',
    'Studio B',
    'Gym Floor',
    'Outdoor Area'
  ];
  final List<String> _timeSlots = [
    '06:00 AM',
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _capacityController.text = '15';
    _durationController.text = '60';
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _capacityController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Class',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class name
                    _buildSectionTitle('Class Name'),
                    TextFormField(
                      controller: _classNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter class name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter class name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Trainer selection
                    _buildSectionTitle('Select Trainer'),
                    DropdownButtonFormField<String>(
                      value: _selectedTrainer,
                      decoration: const InputDecoration(
                        hintText: 'Choose trainer',
                        border: OutlineInputBorder(),
                      ),
                      items: _trainers.map((trainer) {
                        return DropdownMenuItem<String>(
                          value: trainer['id'],
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(trainer['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                trainer['name']!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTrainer = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a trainer';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Date and time
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Date'),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedDate != null
                                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                            : 'Select date',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Time'),
                              DropdownButtonFormField<String>(
                                value: _selectedTime,
                                decoration: const InputDecoration(
                                  hintText: 'Select time',
                                  border: OutlineInputBorder(),
                                ),
                                items: _timeSlots.map((time) {
                                  return DropdownMenuItem<String>(
                                    value: time,
                                    child: Text(
                                      time,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select time';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Room and capacity
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Room'),
                              DropdownButtonFormField<String>(
                                value: _selectedRoom,
                                decoration: const InputDecoration(
                                  hintText: 'Select room',
                                  border: OutlineInputBorder(),
                                ),
                                items: _rooms.map((room) {
                                  return DropdownMenuItem<String>(
                                    value: room,
                                    child: Text(
                                      room,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRoom = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select room';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Capacity'),
                              TextFormField(
                                controller: _capacityController,
                                decoration: const InputDecoration(
                                  hintText: 'Max participants',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter capacity';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter valid number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Duration
                    _buildSectionTitle('Duration (minutes)'),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        hintText: 'Class duration',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recurring options
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recurring Class',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRecurring = !_isRecurring;
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _isRecurring
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: _isRecurring
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          if (_isRecurring) ...[
                            SizedBox(height: 2.h),
                            DropdownButtonFormField<String>(
                              value: _recurringPattern,
                              decoration: const InputDecoration(
                                labelText: 'Repeat pattern',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: 'weekly',
                                  child: Text('Weekly',
                                      style: TextStyle(color: Colors.black)),
                                ),
                                const DropdownMenuItem<String>(
                                  value: 'daily',
                                  child: Text('Daily',
                                      style: TextStyle(color: Colors.black)),
                                ),
                                const DropdownMenuItem<String>(
                                  value: 'monthly',
                                  child: Text('Monthly',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _recurringPattern = value!;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Create button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createClass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Create Class',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _createClass() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final selectedTrainerData = _trainers.firstWhere(
      (trainer) => trainer['id'] == _selectedTrainer,
    );

    final classData = {
      'id': 'class_${DateTime.now().millisecondsSinceEpoch}',
      'name': _classNameController.text,
      'trainer': selectedTrainerData['name'],
      'trainerImage': selectedTrainerData['image'],
      'time': _selectedTime,
      'duration': '${_durationController.text} min',
      'date': _selectedDate,
      'capacity': int.parse(_capacityController.text),
      'enrolled': 0,
      'room': _selectedRoom,
      'status': 'scheduled',
      'isRecurring': _isRecurring,
      'recurringPattern': _recurringPattern,
    };

    widget.onClassScheduled(classData);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Class created successfully',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
