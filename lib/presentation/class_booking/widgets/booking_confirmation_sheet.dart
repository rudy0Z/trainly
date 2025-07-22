import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingConfirmationSheet extends StatefulWidget {
  final Map<String, dynamic> classData;
  final DateTime selectedDate;
  final Function(Map<String, dynamic>) onConfirmBooking;

  const BookingConfirmationSheet({
    Key? key,
    required this.classData,
    required this.selectedDate,
    required this.onConfirmBooking,
  }) : super(key: key);

  @override
  State<BookingConfirmationSheet> createState() =>
      _BookingConfirmationSheetState();
}

class _BookingConfirmationSheetState extends State<BookingConfirmationSheet> {
  bool acceptTerms = false;
  String selectedPaymentMethod = 'wallet';

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "wallet",
      "name": "Digital Wallet",
      "icon": "account_balance_wallet",
      "balance": "\$125.50"
    },
    {
      "id": "card",
      "name": "Credit Card",
      "icon": "credit_card",
      "details": "**** 1234"
    },
    {
      "id": "upi",
      "name": "UPI Payment",
      "icon": "payment",
      "details": "john@upi"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final trainer = widget.classData["trainer"] as Map<String, dynamic>;
    final availableSpots = widget.classData["availableSpots"] as int;
    final isAvailable = availableSpots > 0;

    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(isAvailable),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassSummary(trainer),
                  SizedBox(height: 3.h),
                  _buildDateTimeInfo(),
                  SizedBox(height: 3.h),
                  _buildPaymentMethods(),
                  SizedBox(height: 3.h),
                  _buildTermsAndConditions(),
                  SizedBox(height: 3.h),
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),
          _buildConfirmButton(isAvailable),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 12.w,
      height: 0.5.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(bool isAvailable) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isAvailable ? 'Confirm Booking' : 'Join Waitlist',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSummary(Map<String, dynamic> trainer) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: widget.classData["typeIcon"] as String,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  widget.classData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomImageWidget(
                  imageUrl: trainer["photo"] as String,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainer["name"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Trainer',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Class Schedule',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildScheduleItem(
                  'calendar_today', _formatDate(widget.selectedDate)),
              SizedBox(width: 6.w),
              _buildScheduleItem(
                  'schedule', widget.classData["time"] as String),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildScheduleItem(
                  'timer', widget.classData["duration"] as String),
              SizedBox(width: 6.w),
              _buildScheduleItem(
                  'fitness_center', widget.classData["difficulty"] as String),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String iconName, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...paymentMethods
            .map((method) => _buildPaymentMethodItem(method))
            .toList(),
      ],
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    final isSelected = selectedPaymentMethod == method["id"];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method["id"] as String;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
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
              iconName: method["icon"] as String,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method["name"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (method["balance"] != null || method["details"] != null)
                    Text(
                      (method["balance"] ?? method["details"]) as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: acceptTerms,
          onChanged: (value) {
            setState(() {
              acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                acceptTerms = !acceptTerms;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Cancellation Policy',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final price = widget.classData["price"] as String;
    final numericPrice = double.tryParse(price.replaceAll('\$', '')) ?? 0.0;
    final tax = numericPrice * 0.1; // 10% tax
    final total = numericPrice + tax;

    return Container(
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Price Breakdown',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPriceRow('Class Fee', price),
          _buildPriceRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
          Divider(height: 2.h),
          _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isTotal ? AppTheme.lightTheme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool isAvailable) {
    final canConfirm = acceptTerms;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canConfirm
              ? () {
                  Navigator.pop(context);
                  widget.onConfirmBooking(widget.classData);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.getWarningColor(true),
            padding: EdgeInsets.symmetric(vertical: 2.h),
          ),
          child: Text(
            isAvailable ? 'Confirm Booking' : 'Join Waitlist',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
