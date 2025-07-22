import 'package:flutter/material.dart';

import './widgets/calendar_header_widget.dart';
import './widgets/calendar_grid_widget.dart';
import './widgets/schedule_creation_modal_widget.dart';
import './widgets/view_toggle_widget.dart';

class AdminScheduleClass extends StatefulWidget {
  const AdminScheduleClass({super.key});

  @override
  State<AdminScheduleClass> createState() => _AdminScheduleClassState();
}

class _AdminScheduleClassState extends State<AdminScheduleClass> {
  DateTime _selectedDate = DateTime.now();
  String _currentView = 'monthly'; // daily, weekly, monthly
  bool _isLoading = false;
  List<Map<String, dynamic>> _scheduledClasses = [];
  Map<String, dynamic>? _draggedClass;

  @override
  void initState() {
    super.initState();
    _loadScheduledClasses();
  }

  Future<void> _loadScheduledClasses() async {
    setState(() {
      _isLoading = true;
    });

    // Mock data for scheduled classes
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _scheduledClasses = [
        {
          'id': 'class_1',
          'name': 'Morning Yoga',
          'trainer': 'Sarah Johnson',
          'trainerImage':
              'https://images.unsplash.com/photo-1494790108755-2616b79dced0?w=150&h=150&fit=crop&crop=face',
          'time': '09:00 AM',
          'duration': '60 min',
          'date': DateTime.now().add(const Duration(days: 1)),
          'capacity': 15,
          'enrolled': 12,
          'room': 'Studio A',
          'status': 'scheduled'
        },
        {
          'id': 'class_2',
          'name': 'HIIT Training',
          'trainer': 'Mike Chen',
          'trainerImage':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          'time': '06:00 PM',
          'duration': '45 min',
          'date': DateTime.now(),
          'capacity': 20,
          'enrolled': 18,
          'room': 'Gym Floor',
          'status': 'scheduled'
        },
        {
          'id': 'class_3',
          'name': 'Pilates',
          'trainer': 'Emma Wilson',
          'trainerImage':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          'time': '11:30 AM',
          'duration': '50 min',
          'date': DateTime.now().add(const Duration(days: 2)),
          'capacity': 12,
          'enrolled': 10,
          'room': 'Studio B',
          'status': 'scheduled'
        },
      ];
      _isLoading = false;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onViewChanged(String view) {
    setState(() {
      _currentView = view;
    });
  }

  void _showScheduleCreationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScheduleCreationModalWidget(
        selectedDate: _selectedDate,
        onClassScheduled: (classData) {
          setState(() {
            _scheduledClasses.add(classData);
          });
        },
      ),
    );
  }

  void _onClassMoved(String classId, DateTime newDate, String newTime) {
    setState(() {
      final classIndex =
          _scheduledClasses.indexWhere((c) => c['id'] == classId);
      if (classIndex != -1) {
        _scheduledClasses[classIndex]['date'] = newDate;
        _scheduledClasses[classIndex]['time'] = newTime;
      }
    });

    // Show success confirmation
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
              'Class moved successfully',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Schedule Class',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadScheduledClasses,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Header
          CalendarHeaderWidget(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
          ),

          // View Toggle
          ViewToggleWidget(
            currentView: _currentView,
            onViewChanged: _onViewChanged,
          ),

          // Calendar Grid
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : CalendarGridWidget(
                    selectedDate: _selectedDate,
                    currentView: _currentView,
                    scheduledClasses: _scheduledClasses,
                    onDateSelected: _onDateSelected,
                    onClassMoved: _onClassMoved,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showScheduleCreationModal,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
