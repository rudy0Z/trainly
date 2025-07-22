import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onAddMoney;
  final VoidCallback onSendToFriend;

  const QuickActionsWidget({
    Key? key,
    required this.onAddMoney,
    required this.onSendToFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: 'add',
              label: 'Add Money',
              onTap: onAddMoney,
              isPrimary: true,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: _buildActionButton(
              icon: 'send',
              label: 'Send to Friend',
              onTap: onSendToFriend,
              isPrimary: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.5,
                ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.shadow,
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color:
                    isPrimary ? Colors.white : AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isPrimary
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
