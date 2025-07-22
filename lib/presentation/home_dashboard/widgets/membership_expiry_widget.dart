import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MembershipExpiryWidget extends StatelessWidget {
  final String? expiryDate;

  const MembershipExpiryWidget({
    super.key,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    if (expiryDate == null) return const SizedBox.shrink();

    final DateTime expiry = DateTime.parse(expiryDate!);
    final DateTime now = DateTime.now();
    final int daysLeft = expiry.difference(now).inDays;

    // Only show if expiring within 30 days
    if (daysLeft > 30) return const SizedBox.shrink();

    final bool isExpiringSoon = daysLeft <= 7;
    final bool isExpired = daysLeft < 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isExpired
                ? [
                    AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.05),
                  ]
                : isExpiringSoon
                    ? [
                        AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                        AppTheme.getWarningColor(true).withValues(alpha: 0.05),
                      ]
                    : [
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.05),
                      ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(isExpired, isExpiringSoon),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: isExpired
                        ? 'error'
                        : isExpiringSoon
                            ? 'warning'
                            : 'info',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(isExpired, isExpiringSoon),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(isExpired, isExpiringSoon),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getStatusMessage(isExpired, isExpiringSoon, daysLeft),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Expiry Details
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(isExpired, isExpiringSoon)
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Membership Expires',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _formatDate(expiry),
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(isExpired, isExpiringSoon)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isExpired ? 'Expired' : '$daysLeft days left',
                      style: TextStyle(
                        color: _getStatusColor(isExpired, isExpiringSoon),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/membership-plans');
                },
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  isExpired ? 'Renew Membership' : 'Extend Membership',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(isExpired, isExpiringSoon),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool isExpired, bool isExpiringSoon) {
    if (isExpired) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (isExpiringSoon) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getStatusTitle(bool isExpired, bool isExpiringSoon) {
    if (isExpired) {
      return 'Membership Expired';
    } else if (isExpiringSoon) {
      return 'Membership Expiring Soon';
    } else {
      return 'Membership Reminder';
    }
  }

  String _getStatusMessage(bool isExpired, bool isExpiringSoon, int daysLeft) {
    if (isExpired) {
      return 'Your membership has expired. Renew now to continue enjoying all benefits.';
    } else if (isExpiringSoon) {
      return 'Your membership expires in $daysLeft days. Renew now to avoid interruption.';
    } else {
      return 'Your membership expires in $daysLeft days. Consider renewing early.';
    }
  }

  String _formatDate(DateTime date) {
    final List<String> months = [
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
