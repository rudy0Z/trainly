import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassCardWidget extends StatelessWidget {
  final Map<String, dynamic> classData;
  final VoidCallback onBookNow;
  final VoidCallback onCardTap;

  const ClassCardWidget({
    Key? key,
    required this.classData,
    required this.onBookNow,
    required this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainer = classData["trainer"] as Map<String, dynamic>;
    final availableSpots = classData["availableSpots"] as int;
    final totalCapacity = classData["totalCapacity"] as int;
    final isAvailable = availableSpots > 0;

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassHeader(),
            SizedBox(height: 2.h),
            _buildTrainerInfo(trainer),
            SizedBox(height: 2.h),
            _buildClassDetails(),
            SizedBox(height: 2.h),
            _buildAvailabilityAndBooking(
                isAvailable, availableSpots, totalCapacity),
          ],
        ),
      ),
    );
  }

  Widget _buildClassHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: classData["typeIcon"] as String,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classData["name"] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                classData["type"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildDifficultyBadge(),
      ],
    );
  }

  Widget _buildDifficultyBadge() {
    final difficulty = classData["difficulty"] as String;
    Color badgeColor;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        badgeColor = AppTheme.getSuccessColor(true);
        break;
      case 'intermediate':
        badgeColor = AppTheme.getWarningColor(true);
        break;
      case 'advanced':
        badgeColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        difficulty,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTrainerInfo(Map<String, dynamic> trainer) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CustomImageWidget(
            imageUrl: trainer["photo"] as String,
            width: 10.w,
            height: 10.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trainer["name"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Trainer',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassDetails() {
    return Row(
      children: [
        _buildDetailItem('schedule', classData["time"] as String),
        SizedBox(width: 4.w),
        _buildDetailItem('timer', classData["duration"] as String),
        SizedBox(width: 4.w),
        _buildDetailItem('attach_money', classData["price"] as String),
      ],
    );
  }

  Widget _buildDetailItem(String iconName, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityAndBooking(
      bool isAvailable, int availableSpots, int totalCapacity) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAvailable ? '$availableSpots spots available' : 'Class full',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isAvailable
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              _buildCapacityIndicator(availableSpots, totalCapacity),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        SizedBox(
          width: 25.w,
          child: ElevatedButton(
            onPressed: onBookNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: isAvailable
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.getWarningColor(true),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isAvailable ? 'Book' : 'Waitlist',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityIndicator(int availableSpots, int totalCapacity) {
    final bookedSpots = totalCapacity - availableSpots;
    final fillPercentage = bookedSpots / totalCapacity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fillPercentage,
            child: Container(
              decoration: BoxDecoration(
                color: fillPercentage >= 0.8
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          '$bookedSpots/$totalCapacity booked',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
