import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentCardWidget extends StatelessWidget {
  final Map<String, dynamic> payment;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleSelection;

  const PaymentCardWidget({
    super.key,
    required this.payment,
    required this.isSelected,
    required this.onTap,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? const Color(0xFFF5F5F5) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with member info and selection
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(payment['memberImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['memberName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        payment['memberEmail'],
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onToggleSelection,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Payment amount and method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${payment['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      payment['description'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildPaymentMethodIcon(payment['paymentMethod']),
                    SizedBox(height: 0.5.h),
                    Text(
                      _getPaymentMethodName(payment['paymentMethod']),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Status and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(payment['status']),
                Text(
                  _formatDate(payment['date']),
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Transaction ID
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction ID',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    payment['transactionId'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon(String method) {
    IconData iconData;
    switch (method) {
      case 'credit_card':
        iconData = Icons.credit_card;
        break;
      case 'paypal':
        iconData = Icons.account_balance_wallet;
        break;
      case 'bank_transfer':
        iconData = Icons.account_balance;
        break;
      case 'digital_wallet':
        iconData = Icons.wallet;
        break;
      default:
        iconData = Icons.payment;
    }

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Icon(
        iconData,
        color: Colors.black,
        size: 20,
      ),
    );
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'credit_card':
        return 'Credit Card';
      case 'paypal':
        return 'PayPal';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'digital_wallet':
        return 'Digital Wallet';
      default:
        return 'Payment';
    }
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusText;
    FontWeight fontWeight;

    switch (status) {
      case 'completed':
        statusColor = Colors.black;
        statusText = 'Completed';
        fontWeight = FontWeight.bold;
        break;
      case 'pending':
        statusColor = const Color(0xFF666666);
        statusText = 'Pending';
        fontWeight = FontWeight.w400;
        break;
      case 'failed':
        statusColor = Colors.black;
        statusText = 'Failed';
        fontWeight = FontWeight.w400;
        break;
      case 'refunded':
        statusColor = const Color(0xFF666666);
        statusText = 'Refunded';
        fontWeight = FontWeight.w400;
        break;
      default:
        statusColor = Colors.black;
        statusText = status.toUpperCase();
        fontWeight = FontWeight.w400;
    }

    return Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontSize: 12.sp,
        fontWeight: fontWeight,
        decoration: status == 'failed' ? TextDecoration.lineThrough : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
