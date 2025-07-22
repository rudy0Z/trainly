import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayClassesCardWidget extends StatelessWidget {
  const TodayClassesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock today's classes data
    final List<Map<String, dynamic>> todayClasses = [
      {
        "id": 1,
        "className": "Morning Yoga",
        "time": "07:00 AM",
        "duration": "60 min",
        "trainer": "Emma Wilson",
        "trainerImage":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "capacity": 15,
        "booked": 12,
        "status": "confirmed",
        "type": "yoga"
      },
      {
        "id": 2,
        "className": "HIIT Training",
        "time": "06:00 PM",
        "duration": "45 min",
        "trainer": "Mike Johnson",
        "trainerImage":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "capacity": 20,
        "booked": 18,
        "status": "confirmed",
        "type": "hiit"
      }
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Classes',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/my-bookings');
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Classes List
            todayClasses.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    children: todayClasses
                        .map((classData) => _buildClassItem(context, classData))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, Map<String, dynamic> classData) {
    return GestureDetector(
      onTap: () {
        // Navigate to class details
      },
      onLongPress: () {
        _showQuickActions(context, classData);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Class Type Icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getClassTypeColor(classData["type"])
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _getClassTypeIcon(classData["type"]),
                color: _getClassTypeColor(classData["type"]),
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            // Class Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classData["className"] ?? "",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${classData["time"]} • ${classData["duration"]}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        classData["trainer"] ?? "",
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Trainer Image & Status
            Column(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: classData["trainerImage"] ?? "",
                      width: 10.w,
                      height: 10.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Confirmed',
                    style: TextStyle(
                      color: AppTheme.getSuccessColor(true),
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No classes booked for today',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Book your first class and start your fitness journey!',
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/class-booking');
            },
            child: Text('Book Your First Class'),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> classData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              classData["className"] ?? "",
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cancel',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Cancel Booking'),
              onTap: () {
                Navigator.pop(context);
                // Handle cancel booking
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Reschedule'),
              onTap: () {
                Navigator.pop(context);
                // Handle reschedule
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                // Handle view details
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getClassTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'yoga':
        return const Color(0xFF8E24AA);
      case 'hiit':
        return const Color(0xFFD32F2F);
      case 'cardio':
        return const Color(0xFF1976D2);
      case 'strength':
        return const Color(0xFF388E3C);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getClassTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'yoga':
        return 'self_improvement';
      case 'hiit':
        return 'flash_on';
      case 'cardio':
        return 'favorite';
      case 'strength':
        return 'fitness_center';
      default:
        return 'sports_gymnastics';
    }
  }
}
