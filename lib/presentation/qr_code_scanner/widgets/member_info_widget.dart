import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemberInfoWidget extends StatelessWidget {
  final Map<String, dynamic> memberData;

  const MemberInfoWidget({
    super.key,
    required this.memberData,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> todayClasses =
        memberData["todayClasses"] as List? ?? [];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Member header
          Row(
            children: [
              // Avatar
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: memberData["avatar"] as String? ?? "",
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberData["name"] as String? ?? "Unknown Member",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getSuccessColor(true)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.getSuccessColor(true),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        memberData["membershipStatus"] as String? ??
                            "Unknown Status",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.getSuccessColor(true),
                size: 6.w,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Membership expiry
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: Colors.white.withValues(alpha: 0.7),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Expires: ${memberData["membershipExpiry"] as String? ?? "N/A"}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          if (todayClasses.isNotEmpty) ...[
            SizedBox(height: 2.h),

            // Today's classes header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'today',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Today\'s Classes',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Classes list
            ...todayClasses.map<Widget>((classData) {
              final Map<String, dynamic> classMap =
                  classData as Map<String, dynamic>;
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classMap["className"] as String? ?? "Unknown Class",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                classMap["time"] as String? ?? "N/A",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              CustomIconWidget(
                                iconName: 'person',
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Flexible(
                                child: Text(
                                  classMap["trainer"] as String? ?? "N/A",
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        classMap["status"] as String? ?? "Unknown",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
