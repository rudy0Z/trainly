import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> plan;
  final Function(Map<String, dynamic>) onPaymentComplete;

  const PaymentBottomSheetWidget({
    Key? key,
    required this.plan,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<PaymentBottomSheetWidget> createState() =>
      _PaymentBottomSheetWidgetState();
}

class _PaymentBottomSheetWidgetState extends State<PaymentBottomSheetWidget> {
  String selectedPaymentMethod = 'wallet';
  bool autoRenewal = true;
  bool isProcessing = false;

  late final List<Map<String, dynamic>> paymentMethods;

  @override
  void initState() {
    super.initState();
    paymentMethods = [
      {
        'id': 'wallet',
        'title': 'Digital Wallet',
        'subtitle': 'Balance: \$150.00',
        'icon': 'account_balance_wallet',
        'available': true,
      },
      {
        'id': 'upi',
        'title': 'UPI Payment',
        'subtitle': 'Pay via UPI apps',
        'icon': 'qr_code_scanner',
        'available': true,
      },
      {
        'id': 'card',
        'title': 'Credit/Debit Card',
        'subtitle': 'Visa, Mastercard, etc.',
        'icon': 'credit_card',
        'available': true,
      },
      {
        'id': 'netbanking',
        'title': 'Net Banking',
        'subtitle': 'All major banks',
        'icon': 'account_balance',
        'available': true,
      },
      {
        'id': 'apple_pay',
        'title': 'Apple Pay',
        'subtitle': 'Touch ID or Face ID',
        'icon': 'phone_iphone',
        'available': Theme.of(context).platform == TargetPlatform.iOS,
      },
      {
        'id': 'google_pay',
        'title': 'Google Pay',
        'subtitle': 'Quick & secure',
        'icon': 'android',
        'available': Theme.of(context).platform == TargetPlatform.android,
      },
    ];
  }

  void _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    // Mock payment result
    final result = {
      'success': true,
      'receiptId': 'RCP${DateTime.now().millisecondsSinceEpoch}',
      'paymentMethod': selectedPaymentMethod,
      'amount': widget.plan['price'],
      'planId': widget.plan['id'],
      'autoRenewal': autoRenewal,
      'timestamp': DateTime.now().toIso8601String(),
    };

    Navigator.pop(context);
    widget.onPaymentComplete(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
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
                    'Complete Payment',
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
                  // Plan summary
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
                        Text(
                          widget.plan['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Plan Price:',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              widget.plan['price'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (widget.plan['savings'] != null) ...[
                          SizedBox(height: 0.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'You Save:',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              Text(
                                widget.plan['savings'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.getSuccessColor(true),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Auto-renewal toggle
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'autorenew',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'Auto-Renewal',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Switch(
                              value: autoRenewal,
                              onChanged: (value) {
                                setState(() {
                                  autoRenewal = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Automatically renew your membership before expiry. You can disable this anytime from settings.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Payment methods
                  Text(
                    'Select Payment Method',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  ...paymentMethods
                      .where((method) => method['available'] as bool)
                      .map((method) {
                    final isSelected = selectedPaymentMethod == method['id'];
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = method['id'] as String;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: method['icon'] as String,
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  size: 24,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method['title'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        method['subtitle'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 3.h),

                  // Security badges
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'security',
                          color: AppTheme.getSuccessColor(true),
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Payment',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: AppTheme.getSuccessColor(true),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'SSL encrypted • PCI-DSS compliant',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.getSuccessColor(true),
                                ),
                              ),
                            ],
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

          // Payment button
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
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                child: isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text('Processing...'),
                        ],
                      )
                    : Text('Pay ${widget.plan['price']}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
