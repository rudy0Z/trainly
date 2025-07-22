import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemAlertsWidget extends StatelessWidget {
  const SystemAlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        'title': 'Server Maintenance',
        'subtitle': 'Scheduled maintenance tomorrow at 2:00 AM',
        'type': 'warning',
        'icon': 'settings',
        'action': 'Schedule',
      },
      {
        'title': 'Low Equipment Stock',
        'subtitle': 'Yoga mats and dumbbells running low',
        'type': 'error',
        'icon': 'inventory',
        'action': 'Reorder',
      },
      {
        'title': 'Membership Renewals',
        'subtitle': '45 memberships expiring this week',
        'type': 'info',
        'icon': 'card_membership',
        'action': 'Notify',
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
                'System Alerts',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${alerts.length} alerts',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertItem(
                context,
                title: alert['title'],
                subtitle: alert['subtitle'],
                type: alert['type'],
                icon: alert['icon'],
                action: alert['action'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String type,
    required String icon,
    required String action,
  }) {
    Color getAlertColor() {
      switch (type) {
        case 'warning':
          return AppTheme.getWarningColor(true);
        case 'error':
          return AppTheme.lightTheme.colorScheme.error;
        case 'info':
          return AppTheme.lightTheme.colorScheme.primary;
        default:
          return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      }
    }

    final alertColor = getAlertColor();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: alertColor,
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
          OutlinedButton(
            onPressed: () {
              // Handle action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$action action for $title'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: alertColor,
              side: BorderSide(color: alertColor),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              minimumSize: Size.zero,
            ),
            child: Text(
              action,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
