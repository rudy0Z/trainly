import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../admin_notifications.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationData notification;
  final bool isSelected;
  final Function(String) onSelectionChanged;
  final Function(String) onEdit;
  final Function(String) onSend;
  final Function(String) onDelete;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onEdit,
    required this.onSend,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEven = notification.id.hashCode % 2 == 0;
    final Color backgroundColor =
        isEven ? Colors.white : const Color(0xFFF5F5F5);

    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main Content
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Selection Checkbox
                    GestureDetector(
                      onTap: () => onSelectionChanged(notification.id),
                      child: Container(
                        width: 20.sp,
                        height: 20.sp,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16.sp,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    // Title and Priority
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.sp),
                          _buildPriorityBadge(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.sp),
                // Content Preview
                Text(
                  notification.content,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.sp),
                // Status and Timestamp Row
                Row(
                  children: [
                    _buildStatusBadge(),
                    SizedBox(width: 12.sp),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${notification.deliveredCount}/${notification.recipientCount}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.sp),
                // Delivery Stats
                if (notification.status == NotificationStatus.sent)
                  _buildDeliveryStats(),
              ],
            ),
          ),
          // Action Buttons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
            decoration: BoxDecoration(
              color: backgroundColor == Colors.white
                  ? const Color(0xFFF5F5F5)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Edit Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => onEdit(notification.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        'Edit',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.sp),
                // Send/Delete Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (notification.status == NotificationStatus.draft) {
                        onSend(notification.id);
                      } else {
                        onDelete(notification.id);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: notification.status == NotificationStatus.draft
                            ? Colors.black
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        notification.status == NotificationStatus.draft
                            ? 'Send Now'
                            : 'Delete',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    final bool isHighPriority =
        notification.priority == NotificationPriority.high;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: isHighPriority ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isHighPriority ? null : Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(
        notification.priority.name.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isHighPriority ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color textColor;
    FontWeight fontWeight;

    switch (notification.status) {
      case NotificationStatus.sent:
        textColor = Colors.black;
        fontWeight = FontWeight.w600;
        break;
      case NotificationStatus.draft:
        textColor = const Color(0xFF666666);
        fontWeight = FontWeight.w400;
        break;
      case NotificationStatus.scheduled:
        textColor = Colors.black;
        fontWeight = FontWeight.w500;
        break;
      case NotificationStatus.failed:
        textColor = Colors.red;
        fontWeight = FontWeight.w600;
        break;
    }

    return Text(
      notification.status.name.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }

  Widget _buildDeliveryStats() {
    final double deliveryRate = notification.recipientCount > 0
        ? notification.deliveredCount / notification.recipientCount
        : 0;
    final double readRate = notification.deliveredCount > 0
        ? notification.readCount / notification.deliveredCount
        : 0;

    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Delivery Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivered',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: 4.sp),
                LinearProgressIndicator(
                  value: deliveryRate,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  minHeight: 4,
                ),
                SizedBox(height: 2.sp),
                Text(
                  '${(deliveryRate * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.sp),
          // Read Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Read',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: 4.sp),
                LinearProgressIndicator(
                  value: readRate,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  minHeight: 4,
                ),
                SizedBox(height: 2.sp),
                Text(
                  '${(readRate * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
