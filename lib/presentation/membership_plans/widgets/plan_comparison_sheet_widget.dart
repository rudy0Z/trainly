import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlanComparisonSheetWidget extends StatelessWidget {
  final List<Map<String, dynamic>> plans;
  final String currentPlan;
  final Function(String) onPlanSelect;

  const PlanComparisonSheetWidget({
    Key? key,
    required this.plans,
    required this.currentPlan,
    required this.onPlanSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Compare Plans',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Comparison table
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  // Price comparison
                  _buildComparisonSection(
                    title: 'Pricing',
                    rows: [
                      _buildComparisonRow(
                        label: 'Monthly Cost',
                        values: plans
                            .map((plan) => plan['price'] as String)
                            .toList(),
                      ),
                      _buildComparisonRow(
                        label: 'Duration',
                        values: plans
                            .map((plan) => plan['duration'] as String)
                            .toList(),
                      ),
                      _buildComparisonRow(
                        label: 'Savings',
                        values: plans
                            .map((plan) =>
                                (plan['savings'] as String?) ?? 'None')
                            .toList(),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Features comparison
                  _buildComparisonSection(
                    title: 'Features',
                    rows: [
                      _buildComparisonRow(
                        label: 'Gym Access',
                        values: ['Unlimited', 'Unlimited', 'Unlimited'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Group Classes',
                        values: ['✓', '✓', '✓'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Personal Training',
                        values: ['✗', '1 session', '4 sessions'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Nutrition Planning',
                        values: ['Basic', 'Advanced', 'Custom'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Guest Passes',
                        values: ['✗', '2/month', '4/month'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Spa Access',
                        values: ['✗', '✗', '✓'],
                        isFeature: true,
                      ),
                      _buildComparisonRow(
                        label: 'Priority Booking',
                        values: ['✗', '✗', '✓'],
                        isFeature: true,
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Recommendations
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'lightbulb',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Our Recommendation',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Based on your usage patterns, the Quarterly Plan offers the best value with personal training sessions and advanced nutrition planning.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: plans.asMap().entries.map((entry) {
                  final index = entry.key;
                  final plan = entry.value;
                  final isCurrent = currentPlan == plan['id'];
                  final isRecommended = plan['isPopular'] as bool? ?? false;

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: index == 0 ? 0 : 1.w),
                      child: ElevatedButton(
                        onPressed: isCurrent
                            ? null
                            : () {
                                Navigator.pop(context);
                                onPlanSelect(plan['id'] as String);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRecommended && !isCurrent
                              ? AppTheme.lightTheme.colorScheme.primary
                              : null,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                        child: Text(
                          isCurrent ? 'Current' : 'Select',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection({
    required String title,
    required List<Widget> rows,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildComparisonRow({
    required String label,
    required List<String> values,
    bool isFeature = false,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final plan = plans[index];
            final isCurrent = currentPlan == plan['id'];
            final isPopular = plan['isPopular'] as bool? ?? false;

            return Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Column(
                  children: [
                    if (index == 0 && isPopular)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 0.2.h),
                        margin: EdgeInsets.only(bottom: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'POPULAR',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 0.2.h),
                        margin: EdgeInsets.only(bottom: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getSuccessColor(true),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'CURRENT',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    Text(
                      value,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isFeature && value == '✓'
                            ? AppTheme.getSuccessColor(true)
                            : isFeature && value == '✗'
                                ? AppTheme.lightTheme.colorScheme.error
                                : null,
                        fontWeight: isCurrent ? FontWeight.w600 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
