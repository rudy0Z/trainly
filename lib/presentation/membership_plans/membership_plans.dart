import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/comparison_button_widget.dart';
import './widgets/payment_bottom_sheet_widget.dart';
import './widgets/plan_card_widget.dart';
import './widgets/plan_comparison_sheet_widget.dart';

class MembershipPlans extends StatefulWidget {
  const MembershipPlans({Key? key}) : super(key: key);

  @override
  State<MembershipPlans> createState() => _MembershipPlansState();
}

class _MembershipPlansState extends State<MembershipPlans> {
  String selectedPlanId = '';
  bool isLoading = false;

  final List<Map<String, dynamic>> membershipPlans = [
    {
      "id": "monthly",
      "title": "Monthly Plan",
      "duration": "1 Month",
      "price": "\$29.99",
      "originalPrice": "\$39.99",
      "savings": "25% OFF",
      "isPopular": false,
      "benefits": [
        "Unlimited gym access",
        "Group fitness classes",
        "Locker facility",
        "Basic nutrition guidance",
        "Mobile app access"
      ],
      "description": "Perfect for trying out our facilities",
      "testimonials": [
        {
          "name": "Sarah Johnson",
          "rating": 5,
          "comment": "Great way to start my fitness journey!"
        }
      ]
    },
    {
      "id": "quarterly",
      "title": "Quarterly Plan",
      "duration": "3 Months",
      "price": "\$79.99",
      "originalPrice": "\$119.97",
      "savings": "33% OFF",
      "isPopular": true,
      "benefits": [
        "Unlimited gym access",
        "Group fitness classes",
        "Locker facility",
        "Personal trainer consultation",
        "Nutrition meal planning",
        "Mobile app access",
        "Guest pass (2 per month)"
      ],
      "description": "Most popular choice for serious fitness goals",
      "testimonials": [
        {
          "name": "Mike Rodriguez",
          "rating": 5,
          "comment": "Best value for money! Achieved my goals in 3 months."
        }
      ]
    },
    {
      "id": "yearly",
      "title": "Yearly Plan",
      "duration": "12 Months",
      "price": "\$299.99",
      "originalPrice": "\$479.88",
      "savings": "38% OFF",
      "isPopular": false,
      "benefits": [
        "Unlimited gym access",
        "Group fitness classes",
        "Locker facility",
        "Personal trainer sessions (4 per month)",
        "Custom nutrition meal planning",
        "Mobile app access",
        "Guest pass (4 per month)",
        "Spa & wellness access",
        "Priority class booking",
        "Free fitness assessment"
      ],
      "description": "Ultimate fitness package with maximum savings",
      "testimonials": [
        {
          "name": "Emily Chen",
          "rating": 5,
          "comment":
              "Amazing value! The personal training sessions are incredible."
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> familyPlans = [
    {
      "id": "family_monthly",
      "title": "Family Monthly",
      "duration": "1 Month (Up to 4 members)",
      "price": "\$89.99",
      "originalPrice": "\$119.96",
      "savings": "25% OFF",
      "isPopular": false,
      "benefits": [
        "Unlimited gym access for all members",
        "Group fitness classes",
        "Locker facility",
        "Family nutrition guidance",
        "Mobile app access",
        "Kids zone access"
      ],
      "description": "Perfect for active families",
      "testimonials": []
    }
  ];

  String currentPlan = "quarterly"; // Mock current plan

  void _selectPlan(String planId) {
    setState(() {
      selectedPlanId = planId;
    });
    _showPaymentBottomSheet(planId);
  }

  void _showPaymentBottomSheet(String planId) {
    final selectedPlan = membershipPlans.firstWhere(
      (plan) => plan['id'] == planId,
      orElse: () => familyPlans.firstWhere((plan) => plan['id'] == planId),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentBottomSheetWidget(
        plan: selectedPlan,
        onPaymentComplete: _handlePaymentComplete,
      ),
    );
  }

  void _showComparisonSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlanComparisonSheetWidget(
        plans: membershipPlans,
        currentPlan: currentPlan,
        onPlanSelect: _selectPlan,
      ),
    );
  }

  void _handlePaymentComplete(Map<String, dynamic> paymentResult) {
    setState(() {
      isLoading = false;
    });

    if (paymentResult['success'] == true) {
      _showSuccessDialog(paymentResult);
    } else {
      _showErrorDialog(paymentResult['error'] ?? 'Payment failed');
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getSuccessColor(true),
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your membership plan has been activated successfully!'),
            SizedBox(height: 2.h),
            Text(
              'Receipt ID: ${result['receiptId']}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              'A confirmation email has been sent to your registered email address.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/home-dashboard');
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Payment Failed'),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Membership Plans'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-settings'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Free Trial Banner
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.tertiary,
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_fire_department',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Free 7-Day Trial Available!',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Try any plan risk-free',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '6d 23h left',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Current Plan Status
            if (currentPlan.isNotEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.getSuccessColor(true),
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Current Plan: Quarterly Plan (Expires: Dec 15, 2024)',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 2.h),

            // Plans Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Individual Plans
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Individual Plans',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    SizedBox(
                      height: 45.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemCount: membershipPlans.length,
                        itemBuilder: (context, index) {
                          final plan = membershipPlans[index];
                          return PlanCardWidget(
                            plan: plan,
                            isSelected: selectedPlanId == plan['id'],
                            isCurrent: currentPlan == plan['id'],
                            onTap: () => _selectPlan(plan['id'] as String),
                            onExpandTap: () => _showPlanDetails(plan),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Family Plans
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Family Plans',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    SizedBox(
                      height: 45.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemCount: familyPlans.length,
                        itemBuilder: (context, index) {
                          final plan = familyPlans[index];
                          return PlanCardWidget(
                            plan: plan,
                            isSelected: selectedPlanId == plan['id'],
                            isCurrent: false,
                            onTap: () => _selectPlan(plan['id'] as String),
                            onExpandTap: () => _showPlanDetails(plan),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Corporate Code Section
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'business',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Corporate Membership',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Have a corporate membership code? Enter it below for special pricing.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter corporate code',
                                    prefixIcon: Icon(Icons.code),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.5.h,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              ElevatedButton(
                                onPressed: () {
                                  // Validate corporate code
                                },
                                child: Text('Validate'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for sticky button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: ComparisonButtonWidget(
        onTap: _showComparisonSheet,
      ),
    );
  }

  void _showPlanDetails(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
                      plan['title'] as String,
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

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            plan['price'] as String,
                            style: AppTheme.lightTheme.textTheme.displaySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            plan['duration'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (plan['savings'] != null) ...[
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.5.h),
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

                    SizedBox(height: 3.h),

                    // Description
                    Text(
                      'Plan Description',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      plan['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),

                    SizedBox(height: 3.h),

                    // Benefits
                    Text(
                      'What\'s Included',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(plan['benefits'] as List)
                        .map((benefit) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.getSuccessColor(true),
                                    size: 20,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      benefit as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),

                    SizedBox(height: 3.h),

                    // Testimonials
                    if ((plan['testimonials'] as List).isNotEmpty) ...[
                      Text(
                        'Member Reviews',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...(plan['testimonials'] as List)
                          .map((testimonial) => Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          testimonial['name'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: List.generate(
                                            testimonial['rating'] as int,
                                            (index) => CustomIconWidget(
                                              iconName: 'star',
                                              color: AppTheme.getWarningColor(
                                                  true),
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      testimonial['comment'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Select button
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
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _selectPlan(plan['id'] as String);
                },
                child: Text('Select This Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
