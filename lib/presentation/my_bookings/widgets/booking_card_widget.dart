import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isUpcoming;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onAddToCalendar;
  final VoidCallback? onShare;
  final VoidCallback? onRate;
  final VoidCallback? onFeedback;
  final VoidCallback? onTap;

  const BookingCardWidget({
    Key? key,
    required this.booking,
    required this.isUpcoming,
    this.onCancel,
    this.onReschedule,
    this.onAddToCalendar,
    this.onShare,
    this.onRate,
    this.onFeedback,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key(booking['bookingId']),
        background: isUpcoming ? _buildLeftSwipeBackground() : null,
        secondaryBackground: isUpcoming ? _buildRightSwipeBackground() : null,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Left swipe - Cancel/Reschedule actions
            _showActionSheet(context, isCancel: true);
          } else if (direction == DismissDirection.endToStart) {
            // Right swipe - Calendar/Share actions
            _showActionSheet(context, isCancel: false);
          }
          return false; // Don't actually dismiss
        },
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 2.h),
                _buildClassInfo(),
                SizedBox(height: 2.h),
                _buildTrainerInfo(),
                SizedBox(height: 2.h),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSwipeBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'cancel',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'Cancel',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          CustomIconWidget(
            iconName: 'schedule',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'Reschedule',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Calendar',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 6.w),
          Text(
            'Share',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'share',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: _getClassTypeIcon(),
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking['className'],
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                booking['gymLocation'],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildClassInfo() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                '${booking['date']} • ${booking['time']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (isUpcoming && booking['countdownHours'] != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${booking['countdownHours']}h left',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrainerInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CustomImageWidget(
            imageUrl: booking['trainer']['photo'],
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking['trainer']['name'],
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.getWarningColor(true),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    booking['trainer']['rating'].toString(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isUpcoming && booking['status'] == 'Confirmed') ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'qr_code',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'QR Code',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    if (isUpcoming) {
      return Row(
        children: [
          CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            '${booking['spotsLeft']} spots left of ${booking['totalSpots']}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          if (booking['status'] == 'Waitlisted') ...[
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Position ${booking['waitlistPosition']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getWarningColor(true),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return Row(
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            '${booking['duration']} minutes',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          if (booking['canRate'] == true) ...[
            TextButton.icon(
              onPressed: onRate,
              icon: CustomIconWidget(
                iconName: 'star_border',
                color: AppTheme.getWarningColor(true),
                size: 16,
              ),
              label: Text(
                'Rate Class',
                style: TextStyle(
                  color: AppTheme.getWarningColor(true),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ] else if (booking['userRating'] != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.getWarningColor(true),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Rated ${booking['userRating']}/5',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getWarningColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }
  }

  Widget _buildStatusChip() {
    Color chipColor;
    Color textColor;

    switch (booking['status']) {
      case 'Confirmed':
        chipColor = AppTheme.getSuccessColor(true).withValues(alpha: 0.1);
        textColor = AppTheme.getSuccessColor(true);
        break;
      case 'Waitlisted':
        chipColor = AppTheme.getWarningColor(true).withValues(alpha: 0.1);
        textColor = AppTheme.getWarningColor(true);
        break;
      case 'Cancelled':
        chipColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'Completed':
        chipColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      default:
        chipColor =
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurface;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        booking['status'],
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getClassTypeIcon() {
    switch (booking['classType']) {
      case 'fitness_center':
        return 'fitness_center';
      case 'self_improvement':
        return 'self_improvement';
      case 'sports_martial_arts':
        return 'sports_martial_arts';
      default:
        return 'event';
    }
  }

  void _showActionSheet(BuildContext context, {required bool isCancel}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            if (isCancel) ...[
              if (booking['canCancel'] == true) ...[
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'cancel',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                  title: const Text('Cancel Booking'),
                  onTap: () {
                    Navigator.pop(context);
                    onCancel?.call();
                  },
                ),
              ],
              if (booking['canReschedule'] == true) ...[
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 24,
                  ),
                  title: const Text('Reschedule'),
                  onTap: () {
                    Navigator.pop(context);
                    onReschedule?.call();
                  },
                ),
              ],
            ] else ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'event',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Add to Calendar'),
                onTap: () {
                  Navigator.pop(context);
                  onAddToCalendar?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                title: const Text('Share Booking'),
                onTap: () {
                  Navigator.pop(context);
                  onShare?.call();
                },
              ),
            ],
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
