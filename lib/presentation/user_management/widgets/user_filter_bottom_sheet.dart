import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class UserFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const UserFilterBottomSheet({
    super.key,
    required this.activeFilters,
    required this.onFiltersApplied,
  });

  @override
  State<UserFilterBottomSheet> createState() => _UserFilterBottomSheetState();
}

class _UserFilterBottomSheetState extends State<UserFilterBottomSheet> {
  late Map<String, dynamic> _tempFilters;

  final List<String> _membershipStatuses = [
    'All',
    'Active',
    'Expired',
    'Suspended'
  ];
  final List<String> _membershipPlans = ['All', 'Basic', 'Standard', 'Premium'];
  final List<String> _paymentStatuses = ['All', 'Paid', 'Overdue', 'Pending'];
  final List<String> _activityLevels = ['All', 'Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);

    // Set default values if not present
    _tempFilters['membershipStatus'] ??= 'All';
    _tempFilters['membershipPlan'] ??= 'All';
    _tempFilters['paymentStatus'] ??= 'All';
    _tempFilters['activityLevel'] ??= 'All';
  }

  void _applyFilters() {
    // Remove 'All' filters before applying
    Map<String, dynamic> cleanFilters = {};
    _tempFilters.forEach((key, value) {
      if (value != 'All') {
        cleanFilters[key] = value;
      }
    });

    widget.onFiltersApplied(cleanFilters);
    Navigator.pop(context);
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters = {
        'membershipStatus': 'All',
        'membershipPlan': 'All',
        'paymentStatus': 'All',
        'activityLevel': 'All',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withAlpha(77),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Users',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Membership Status',
                    'membershipStatus',
                    _membershipStatuses,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Membership Plan',
                    'membershipPlan',
                    _membershipPlans,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Payment Status',
                    'paymentStatus',
                    _paymentStatuses,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Activity Level',
                    'activityLevel',
                    _activityLevels,
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, String filterKey, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            bool isSelected = _tempFilters[filterKey] == option;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _tempFilters[filterKey] = option;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
