import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCardWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ActivityCardWidget({
    super.key,
    required this.activity,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = activity['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);
    final isHighPriority = activity['priority'] == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighPriority
                  ? Colors.red.withAlpha(77)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: Colors.black,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Activity Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with timestamp
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity['title'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isHighPriority
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      activity['description'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Footer with user and type
                    Row(
                      children: [
                        // User Avatar
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFFF5F5F5),
                          child: Text(
                            activity['user'][0],
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          activity['user'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),

                        const Spacer(),

                        // Activity Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                _getTypeColor(activity['type']).withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activity['type'],
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: _getTypeColor(activity['type']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Priority Indicator
              if (isHighPriority) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Member Activity':
        return Colors.blue;
      case 'Payment':
        return Colors.green;
      case 'Class Booking':
        return Colors.purple;
      case 'Membership':
        return Colors.orange;
      case 'System':
        return Colors.grey;
      case 'Error':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
