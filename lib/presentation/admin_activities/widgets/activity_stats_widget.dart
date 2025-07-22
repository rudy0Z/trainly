import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityStatsWidget extends StatelessWidget {
  final int totalActivities;
  final int todayActivities;
  final int highPriorityCount;

  const ActivityStatsWidget({
    super.key,
    required this.totalActivities,
    required this.todayActivities,
    required this.highPriorityCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Activities',
            totalActivities.toString(),
            Icons.list_alt,
            Colors.black,
          ),
          _buildStatItem(
            'Today',
            todayActivities.toString(),
            Icons.today,
            Colors.blue,
          ),
          _buildStatItem(
            'High Priority',
            highPriorityCount.toString(),
            Icons.priority_high,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
