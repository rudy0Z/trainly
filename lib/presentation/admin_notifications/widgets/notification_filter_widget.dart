import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class NotificationFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final String selectedPriority;
  final Function(String) onFilterChanged;
  final Function(String) onPriorityChanged;

  const NotificationFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedPriority,
    required this.onFilterChanged,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Status Filter
        Expanded(
          child: _buildDropdown(
            label: 'Status',
            value: selectedFilter,
            items: const ['All', 'Draft', 'Sent', 'Scheduled', 'Failed'],
            onChanged: onFilterChanged,
          ),
        ),
        SizedBox(width: 12.sp),
        // Priority Filter
        Expanded(
          child: _buildDropdown(
            label: 'Priority',
            value: selectedPriority,
            items: const ['All', 'High', 'Normal', 'Low'],
            onChanged: onPriorityChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
