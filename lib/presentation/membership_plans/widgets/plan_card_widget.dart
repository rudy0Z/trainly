import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlanCardWidget extends StatelessWidget {
  final Map<String, dynamic> plan;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onExpandTap;

  const PlanCardWidget({
    Key? key,
    required this.plan,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
    required this.onExpandTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPopular = plan['isPopular'] as bool? ?? false;

    return Container(
      width: 75.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? AppTheme.getSuccessColor(true)
                    : isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                width: isCurrent || isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with popular badge
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                        : isPopular
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.transparent,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(true),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'CURRENT PLAN',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (isPopular)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'MOST POPULAR',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      SizedBox(height: isCurrent || isPopular ? 2.h : 0),
                      Text(
                        plan['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            plan['price'] as String,
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          if (plan['originalPrice'] != null)
                            Text(
                              plan['originalPrice'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        plan['duration'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (plan['savings'] != null) ...[
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(true),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            plan['savings'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Benefits list
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Key Benefits:',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Expanded(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (plan['benefits'] as List).length > 5
                                ? 5
                                : (plan['benefits'] as List).length,
                            itemBuilder: (context, index) {
                              final benefit =
                                  (plan['benefits'] as List)[index] as String;
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme.getSuccessColor(true),
                                      size: 16,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        benefit,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if ((plan['benefits'] as List).length > 5)
                          TextButton(
                            onPressed: onExpandTap,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'View all benefits',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Action button
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isCurrent ? null : onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCurrent
                            ? AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3)
                            : null,
                        foregroundColor: isCurrent
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                      child: Text(
                        isCurrent ? 'Current Plan' : 'Select Plan',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expand button
          Positioned(
            top: 2.h,
            right: 2.w,
            child: IconButton(
              onPressed: onExpandTap,
              icon: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
