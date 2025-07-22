import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingWorkoutsWidget extends StatelessWidget {
  const UpcomingWorkoutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upcomingWorkouts = [
      {
        'title': 'Cardio Blast',
        'time': '9:00 AM',
        'date': 'Tomorrow',
        'duration': '30 min',
        'icon': 'directions_run',
      },
      {
        'title': 'Yoga Flow',
        'time': '6:30 PM',
        'date': 'Tomorrow',
        'duration': '45 min',
        'icon': 'self_improvement',
      },
      {
        'title': 'Strength Training',
        'time': '8:00 AM',
        'date': 'Wed',
        'duration': '50 min',
        'icon': 'fitness_center',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Upcoming Workouts',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        upcomingWorkouts.isEmpty
            ? _buildEmptyState()
            : SizedBox(
                height: 20.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: upcomingWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = upcomingWorkouts[index];
                    return _buildWorkoutCard(
                      workout['title'],
                      workout['time'],
                      workout['date'],
                      workout['duration'],
                      workout['icon'],
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String time,
    String date,
    String duration,
    String iconName,
  ) {
    return Container(
      width: 60.w,
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: Colors.black.withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '$time • $date',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: Colors.black.withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                duration,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'calendar_today',
            color: Colors.black.withValues(alpha: 0.4),
            size: 40,
          ),
          SizedBox(height: 2.h),
          Text(
            'No upcoming workouts',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Generate your next AI workout to get started',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to workout generation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Generate Workout',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
