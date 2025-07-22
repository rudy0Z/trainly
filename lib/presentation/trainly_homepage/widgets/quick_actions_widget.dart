import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Generate New Workout',
                  'auto_fix_high',
                  () {
                    Navigator.pushNamed(context, '/chat-with-trainly');
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'View Progress',
                  'analytics',
                  () {
                    Navigator.pushNamed(context, '/home-dashboard');
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: _buildActionButton(
            'Settings',
            'settings',
            () {
              Navigator.pushNamed(context, '/profile-settings');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    String iconName,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 6.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: Colors.black,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
