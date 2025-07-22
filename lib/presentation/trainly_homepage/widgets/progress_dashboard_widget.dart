import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressDashboardWidget extends StatelessWidget {
  const ProgressDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Your Progress',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            children: [
              _buildProgressCard(
                'Weekly Stats',
                '4/5 Workouts',
                '80% Complete',
                'trending_up',
                Colors.white,
              ),
              _buildProgressCard(
                'Streak Counter',
                '12 Days',
                'Personal Best!',
                'local_fire_department',
                Colors.grey.shade100,
              ),
              _buildProgressCard(
                'Achievement',
                'Consistency King',
                'Earned Today',
                'emoji_events',
                Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    String title,
    String value,
    String subtitle,
    String iconName,
    Color cardColor,
  ) {
    return Container(
      width: 45.w,
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: cardColor,
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
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
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
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
