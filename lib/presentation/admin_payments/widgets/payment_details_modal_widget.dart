import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentDetailsModalWidget extends StatelessWidget {
  final Map<String, dynamic> payment;
  final Function(String) onRefund;
  final Function(String) onSendReceipt;

  const PaymentDetailsModalWidget({
    super.key,
    required this.payment,
    required this.onRefund,
    required this.onSendReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Member Information
                  _buildSection(
                    title: 'Member Information',
                    child: Row(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(payment['memberImage']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment['memberName'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                payment['memberEmail'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Plan: ${payment['planType']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Payment Information
                  _buildSection(
                    title: 'Payment Information',
                    child: Column(
                      children: [
                        _buildDetailRow('Amount',
                            '\$${payment['amount'].toStringAsFixed(2)}'),
                        _buildDetailRow('Description', payment['description']),
                        _buildDetailRow(
                            'Status', _getStatusText(payment['status'])),
                        _buildDetailRow('Payment Method',
                            _getPaymentMethodName(payment['paymentMethod'])),
                        _buildDetailRow(
                            'Transaction ID', payment['transactionId']),
                        _buildDetailRow('Date', _formatDate(payment['date'])),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Payment History
                  _buildSection(
                    title: 'Payment History',
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildHistoryItem(
                            'Payment Initiated',
                            _formatDate(payment['date']),
                            Icons.payment,
                          ),
                          if (payment['status'] == 'completed') ...[
                            SizedBox(height: 2.h),
                            _buildHistoryItem(
                              'Payment Completed',
                              _formatDate(payment['date']),
                              Icons.check_circle,
                            ),
                          ],
                          if (payment['status'] == 'failed') ...[
                            SizedBox(height: 2.h),
                            _buildHistoryItem(
                              'Payment Failed',
                              _formatDate(payment['date']),
                              Icons.error,
                            ),
                          ],
                          if (payment['status'] == 'refunded') ...[
                            SizedBox(height: 2.h),
                            _buildHistoryItem(
                              'Refund Processed',
                              _formatDate(payment['date']),
                              Icons.undo,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onSendReceipt(payment['id']);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: const Text('Send Receipt'),
                  ),
                ),
                SizedBox(width: 4.w),
                if (payment['status'] == 'completed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showRefundDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: const Text('Process Refund'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date, IconData icon) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status.toUpperCase();
    }
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

  String _formatDate(DateTime date) {
    const months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showRefundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Process Refund',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to process a refund for this payment of \$${payment['amount'].toStringAsFixed(2)}?',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onRefund(payment['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Process Refund'),
          ),
        ],
      ),
    );
  }
}
