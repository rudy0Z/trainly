import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'New user registration',
        'subtitle': 'John Doe joined Premium membership',
        'time': '5 min ago',
        'icon': 'person_add',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'title': 'Class booking',
        'subtitle': 'Sarah booked Yoga class at 6:00 PM',
        'time': '12 min ago',
        'icon': 'schedule',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'title': 'Payment received',
        'subtitle': 'Monthly membership fee - ₹2,500',
        'time': '25 min ago',
        'icon': 'payments',
        'color': AppTheme.getSuccessColor(true),
      },
      {
        'title': 'Trainer added',
        'subtitle': 'Mike Johnson added as Fitness Trainer',
        'time': '1 hour ago',
        'icon': 'fitness_center',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        'title': 'Class cancelled',
        'subtitle': 'Evening Zumba class cancelled',
        'time': '2 hours ago',
        'icon': 'cancel',
        'color': AppTheme.lightTheme.colorScheme.error,
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
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
                'Recent Activities',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin-activities');
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(
                title: activity['title'],
                subtitle: activity['subtitle'],
                time: activity['time'],
                icon: activity['icon'],
                color: activity['color'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required String icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          time,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
