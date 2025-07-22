import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../admin_add_trainer.dart';

class AvailabilitySchedulingWidget extends StatefulWidget {
  final Map<String, List<TimeSlot>> availability;
  final Function(Map<String, List<TimeSlot>>) onAvailabilityChanged;

  const AvailabilitySchedulingWidget({
    super.key,
    required this.availability,
    required this.onAvailabilityChanged,
  });

  @override
  State<AvailabilitySchedulingWidget> createState() =>
      _AvailabilitySchedulingWidgetState();
}

class _AvailabilitySchedulingWidgetState
    extends State<AvailabilitySchedulingWidget> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> _timeSlots = [
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAvailability();
  }

  void _initializeAvailability() {
    if (widget.availability.isEmpty) {
      final Map<String, List<TimeSlot>> initialAvailability = {};
      for (String day in _days) {
        initialAvailability[day] = [];
      }
      widget.onAvailabilityChanged(initialAvailability);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select your available time slots for each day',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 16.sp),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 80.sp),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _timeSlots
                            .take(6)
                            .map((time) => SizedBox(
                                  width: 40.sp,
                                  child: Text(
                                    time,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // Days and time slots
              ...List.generate(_days.length, (dayIndex) {
                final day = _days[dayIndex];
                return Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: dayIndex < _days.length - 1
                            ? const Color(0xFFE0E0E0)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.sp,
                        child: Text(
                          day,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _timeSlots.map((time) {
                              final isSelected = _isTimeSlotSelected(day, time);
                              return GestureDetector(
                                onTap: () => _toggleTimeSlot(day, time),
                                child: Container(
                                  width: 40.sp,
                                  height: 32.sp,
                                  margin: EdgeInsets.only(right: 4.sp),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black
                                          : const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      time.substring(0, 2),
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.sp),
        // Quick Actions
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectWeekdaySchedule,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    'Weekdays 9-5',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.sp),
            Expanded(
              child: GestureDetector(
                onTap: _selectEveningSchedule,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    'Evenings 6-10',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.sp),
            Expanded(
              child: GestureDetector(
                onTap: _clearAllSchedule,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        // Summary
        if (_getSelectedSlotsCount() > 0) ...[
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability Summary',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.sp),
                Text(
                  'Total slots selected: ${_getSelectedSlotsCount()}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
                Text(
                  'Available hours per week: ${_getSelectedSlotsCount()} hours',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  bool _isTimeSlotSelected(String day, String time) {
    final daySlots = widget.availability[day] ?? [];
    return daySlots.any((slot) => slot.startTime == time && slot.isAvailable);
  }

  void _toggleTimeSlot(String day, String time) {
    final updatedAvailability =
        Map<String, List<TimeSlot>>.from(widget.availability);
    final daySlots = List<TimeSlot>.from(updatedAvailability[day] ?? []);

    final existingSlotIndex =
        daySlots.indexWhere((slot) => slot.startTime == time);

    if (existingSlotIndex != -1) {
      daySlots.removeAt(existingSlotIndex);
    } else {
      daySlots.add(TimeSlot(
        startTime: time,
        endTime: _getNextHour(time),
        isAvailable: true,
      ));
    }

    updatedAvailability[day] = daySlots;
    widget.onAvailabilityChanged(updatedAvailability);
  }

  String _getNextHour(String time) {
    final hour = int.parse(time.split(':')[0]);
    final nextHour = hour + 1;
    return '${nextHour.toString().padLeft(2, '0')}:00';
  }

  void _selectWeekdaySchedule() {
    final updatedAvailability =
        Map<String, List<TimeSlot>>.from(widget.availability);
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final workingHours = [
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00'
    ];

    for (String day in weekdays) {
      updatedAvailability[day] = workingHours
          .map((time) => TimeSlot(
                startTime: time,
                endTime: _getNextHour(time),
                isAvailable: true,
              ))
          .toList();
    }

    widget.onAvailabilityChanged(updatedAvailability);
  }

  void _selectEveningSchedule() {
    final updatedAvailability =
        Map<String, List<TimeSlot>>.from(widget.availability);
    final eveningHours = ['18:00', '19:00', '20:00', '21:00'];

    for (String day in _days) {
      updatedAvailability[day] = eveningHours
          .map((time) => TimeSlot(
                startTime: time,
                endTime: _getNextHour(time),
                isAvailable: true,
              ))
          .toList();
    }

    widget.onAvailabilityChanged(updatedAvailability);
  }

  void _clearAllSchedule() {
    final updatedAvailability =
        Map<String, List<TimeSlot>>.from(widget.availability);
    for (String day in _days) {
      updatedAvailability[day] = [];
    }
    widget.onAvailabilityChanged(updatedAvailability);
  }

  int _getSelectedSlotsCount() {
    int count = 0;
    widget.availability.forEach((day, slots) {
      count += slots.where((slot) => slot.isAvailable).length;
    });
    return count;
  }
}
