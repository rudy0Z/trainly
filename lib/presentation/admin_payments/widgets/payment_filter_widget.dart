import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentFilterWidget extends StatelessWidget {
  final String selectedPaymentType;
  final String selectedStatus;
  final String selectedDateRange;
  final Function(String) onPaymentTypeChanged;
  final Function(String) onStatusChanged;
  final Function(String) onDateRangeChanged;

  const PaymentFilterWidget({
    super.key,
    required this.selectedPaymentType,
    required this.selectedStatus,
    required this.selectedDateRange,
    required this.onPaymentTypeChanged,
    required this.onStatusChanged,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            label: 'Payment Type',
            value: selectedPaymentType,
            items: const [
              {'value': 'all', 'label': 'All Types'},
              {'value': 'credit_card', 'label': 'Credit Card'},
              {'value': 'paypal', 'label': 'PayPal'},
              {'value': 'bank_transfer', 'label': 'Bank Transfer'},
              {'value': 'digital_wallet', 'label': 'Digital Wallet'},
            ],
            onChanged: onPaymentTypeChanged,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildFilterDropdown(
            label: 'Status',
            value: selectedStatus,
            items: const [
              {'value': 'all', 'label': 'All Status'},
              {'value': 'completed', 'label': 'Completed'},
              {'value': 'pending', 'label': 'Pending'},
              {'value': 'failed', 'label': 'Failed'},
              {'value': 'refunded', 'label': 'Refunded'},
            ],
            onChanged: onStatusChanged,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildFilterDropdown(
            label: 'Date Range',
            value: selectedDateRange,
            items: const [
              {'value': 'all', 'label': 'All Dates'},
              {'value': 'today', 'label': 'Today'},
              {'value': 'week', 'label': 'This Week'},
              {'value': 'month', 'label': 'This Month'},
            ],
            onChanged: onDateRangeChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(
                  item['label']!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
