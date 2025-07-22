import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdminQuickActionsWidget extends StatelessWidget {
  const AdminQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3.w,
            crossAxisSpacing: 3.w,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                context,
                title: 'Add User',
                icon: 'person_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: () => Navigator.pushNamed(context, '/admin-add-user'),
              ),
              _buildActionCard(
                context,
                title: 'Add Trainer',
                icon: 'fitness_center',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: () => Navigator.pushNamed(context, '/admin-add-trainer'),
              ),
              _buildActionCard(
                context,
                title: 'Schedule Class',
                icon: 'schedule',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                onTap: () =>
                    Navigator.pushNamed(context, '/admin-schedule-class'),
              ),
              _buildActionCard(
                context,
                title: 'View Reports',
                icon: 'analytics',
                color: AppTheme.getSuccessColor(true),
                onTap: () => Navigator.pushNamed(context, '/admin-reports'),
              ),
              _buildActionCard(
                context,
                title: 'Manage Payments',
                icon: 'payments',
                color: AppTheme.getWarningColor(true),
                onTap: () => Navigator.pushNamed(context, '/admin-payments'),
              ),
              _buildActionCard(
                context,
                title: 'Send Notification',
                icon: 'notifications',
                color: AppTheme.lightTheme.colorScheme.error,
                onTap: () =>
                    Navigator.pushNamed(context, '/admin-send-notification'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
