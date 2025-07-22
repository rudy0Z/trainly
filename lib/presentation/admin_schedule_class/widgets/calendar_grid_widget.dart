import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './class_schedule_card_widget.dart';

class CalendarGridWidget extends StatelessWidget {
  final DateTime selectedDate;
  final String currentView;
  final List<Map<String, dynamic>> scheduledClasses;
  final Function(DateTime) onDateSelected;
  final Function(String, DateTime, String) onClassMoved;

  const CalendarGridWidget({
    super.key,
    required this.selectedDate,
    required this.currentView,
    required this.scheduledClasses,
    required this.onDateSelected,
    required this.onClassMoved,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case 'daily':
        return _buildDailyView();
      case 'weekly':
        return _buildWeeklyView();
      case 'monthly':
      default:
        return _buildMonthlyView();
    }
  }

  Widget _buildDailyView() {
    final todayClasses = scheduledClasses.where((classData) {
      final classDate = classData['date'] as DateTime;
      return classDate.day == selectedDate.day &&
          classDate.month == selectedDate.month &&
          classDate.year == selectedDate.year;
    }).toList();

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Classes for ${_formatDate(selectedDate)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: todayClasses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No classes scheduled',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: todayClasses.length,
                    itemBuilder: (context, index) {
                      return ClassScheduleCardWidget(
                        classData: todayClasses[index],
                        onMoved: onClassMoved,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final weekDays =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays
                .map((day) => Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          children: [
                            Text(
                              _getDayName(day.weekday),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),

          SizedBox(height: 2.h),

          // Time slots
          Expanded(
            child: ListView.builder(
              itemCount: 12, // 7 AM to 7 PM
              itemBuilder: (context, index) {
                final hour = 7 + index;
                final timeSlot = '${hour.toString().padLeft(2, '0')}:00';

                return Container(
                  height: 8.h,
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      // Time label
                      Container(
                        width: 15.w,
                        alignment: Alignment.center,
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Week days
                      Expanded(
                        child: Row(
                          children: weekDays.map((day) {
                            final dayClasses =
                                scheduledClasses.where((classData) {
                              final classDate = classData['date'] as DateTime;
                              final classTime = classData['time'] as String;
                              return classDate.day == day.day &&
                                  classDate.month == day.month &&
                                  classDate.year == day.year &&
                                  classTime
                                      .startsWith(timeSlot.substring(0, 2));
                            }).toList();

                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 1.w),
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: dayClasses.isNotEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          dayClasses.first['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyView() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Days of week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 1.h),

          // Calendar grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: 42, // 6 weeks
              itemBuilder: (context, index) {
                final dayIndex = index - firstDayWeekday + 2;
                final isCurrentMonth = dayIndex > 0 && dayIndex <= daysInMonth;
                final date = isCurrentMonth
                    ? DateTime(selectedDate.year, selectedDate.month, dayIndex)
                    : DateTime(selectedDate.year, selectedDate.month, dayIndex);

                final dayClasses = scheduledClasses.where((classData) {
                  final classDate = classData['date'] as DateTime;
                  return classDate.day == dayIndex &&
                      classDate.month == selectedDate.month &&
                      classDate.year == selectedDate.year;
                }).toList();

                return GestureDetector(
                  onTap: isCurrentMonth ? () => onDateSelected(date) : null,
                  child: Container(
                    margin: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isCurrentMonth
                          ? (dayIndex == selectedDate.day
                              ? Colors.black
                              : Colors.white)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCurrentMonth)
                          Text(
                            dayIndex.toString(),
                            style: TextStyle(
                              color: dayIndex == selectedDate.day
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (dayClasses.isNotEmpty)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: dayIndex == selectedDate.day
                                  ? Colors.white
                                  : Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return '$dayName, $monthName ${date.day}';
  }

  String _getDayName(int weekday) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[weekday - 1];
  }
}
