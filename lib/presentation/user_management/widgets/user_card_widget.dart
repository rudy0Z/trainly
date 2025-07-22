import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserCardWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const UserCardWidget({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.getSuccessColor(true);
      case 'expired':
        return AppTheme.lightTheme.colorScheme.error;
      case 'suspended':
        return AppTheme.getWarningColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getPlanColor(String plan) {
    switch (plan.toLowerCase()) {
      case 'premium':
        return AppTheme.getAccentColor(true);
      case 'standard':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'basic':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(bottom: 2.h),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
            tilePadding: EdgeInsets.all(4.w),
            childrenPadding:
                EdgeInsets.only(left: 4.w, right: 4.w, bottom: 3.h),
            leading: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.lightTheme.colorScheme.primaryContainer
                        .withAlpha(26)),
                child: user['profileImage'] != null &&
                        user['profileImage'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                            imageUrl: user['profileImage'],
                            fit: BoxFit.cover,
                            width: 12.w,
                            height: 12.w))
                    : CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24)),
            title: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(user['name'],
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 0.5.h),
                    Text(user['email'],
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis),
                  ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                        color: _getStatusColor(user['membershipStatus'])
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(user['membershipStatus'],
                        style: TextStyle(
                            color: _getStatusColor(user['membershipStatus']),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600))),
                SizedBox(height: 0.5.h),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                        color:
                            _getPlanColor(user['membershipPlan']).withAlpha(26),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(user['membershipPlan'],
                        style: TextStyle(
                            color: _getPlanColor(user['membershipPlan']),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500))),
              ]),
            ]),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Row(children: [
                  CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16),
                  SizedBox(width: 1.w),
                  Text(user['phone'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant)),
                  Spacer(),
                  Text('Expires: ${user['membershipExpiry']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant)),
                ])),
            children: [
              // Detailed Information
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Divider(color: AppTheme.lightTheme.dividerColor),
                SizedBox(height: 2.h),

                // Personal Details
                Row(children: [
                  Expanded(
                      child: _buildDetailItem('Age', '${user['age']} years')),
                  Expanded(child: _buildDetailItem('Gender', user['gender'])),
                ]),
                SizedBox(height: 2.h),

                _buildDetailItem('Address', user['address']),
                SizedBox(height: 2.h),

                _buildDetailItem('Emergency Contact', user['emergencyContact']),
                SizedBox(height: 2.h),

                // Membership Details
                Row(children: [
                  Expanded(
                      child: _buildDetailItem('Join Date', user['joinDate'])),
                  Expanded(
                      child:
                          _buildDetailItem('Payment', user['paymentStatus'])),
                ]),
                SizedBox(height: 2.h),

                Row(children: [
                  Expanded(
                      child:
                          _buildDetailItem('Trainer', user['trainerAssigned'])),
                  Expanded(
                      child:
                          _buildDetailItem('Activity', user['activityLevel'])),
                ]),
                SizedBox(height: 2.h),

                _buildDetailItem('Last Visit', user['lastVisit']),
                SizedBox(height: 3.h),

                // Action Buttons
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: OutlinedButton.icon(
                              onPressed: onView,
                              icon: CustomIconWidget(
                                  iconName: 'visibility',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 18),
                              label: Text('View'),
                              style: OutlinedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h)))),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: ElevatedButton.icon(
                              onPressed: onEdit,
                              icon: CustomIconWidget(
                                  iconName: 'edit',
                                  color: Colors.white,
                                  size: 18),
                              label: Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h)))),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: OutlinedButton.icon(
                              onPressed: onDelete,
                              icon: CustomIconWidget(
                                  iconName: 'delete',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 18),
                              label: Text('Delete'),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: AppTheme
                                          .lightTheme.colorScheme.error),
                                  foregroundColor:
                                      AppTheme.lightTheme.colorScheme.error,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h)))),
                    ]),
              ]),
            ]));
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500)),
      SizedBox(height: 0.5.h),
      Text(value,
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500)),
    ]);
  }
}
