import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewToggleWidget extends StatelessWidget {
  final String currentView;
  final Function(String) onViewChanged;

  const ViewToggleWidget({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('Daily', 'daily'),
          SizedBox(width: 2.w),
          _buildToggleButton('Weekly', 'weekly'),
          SizedBox(width: 2.w),
          _buildToggleButton('Monthly', 'monthly'),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, String value) {
    final isSelected = currentView == value;

    return GestureDetector(
      onTap: () => onViewChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
