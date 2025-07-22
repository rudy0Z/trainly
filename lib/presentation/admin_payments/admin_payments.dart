import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/payment_search_widget.dart';
import './widgets/payment_filter_widget.dart';
import './widgets/payment_card_widget.dart';
import './widgets/payment_details_modal_widget.dart';
import './widgets/revenue_analytics_widget.dart';
import './widgets/bulk_payment_actions_widget.dart';

class AdminPayments extends StatefulWidget {
  const AdminPayments({super.key});

  @override
  State<AdminPayments> createState() => _AdminPaymentsState();
}

class _AdminPaymentsState extends State<AdminPayments> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _filteredPayments = [];
  String _selectedPaymentType = 'all';
  String _selectedStatus = 'all';
  String _selectedDateRange = 'all';
  bool _showAnalytics = false;
  List<String> _selectedPaymentIds = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
    });

    // Mock payment data
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _payments = [
        {
          'id': 'pay_001',
          'memberName': 'John Anderson',
          'memberImage':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          'amount': 89.99,
          'currency': 'USD',
          'paymentMethod': 'credit_card',
          'status': 'completed',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'description': 'Monthly Membership Fee',
          'transactionId': 'TXN_20240711_001',
          'memberEmail': 'john.anderson@email.com',
          'planType': 'Premium',
        },
        {
          'id': 'pay_002',
          'memberName': 'Sarah Williams',
          'memberImage':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          'amount': 15.00,
          'currency': 'USD',
          'paymentMethod': 'paypal',
          'status': 'pending',
          'date': DateTime.now().subtract(const Duration(hours: 3)),
          'description': 'Personal Training Session',
          'transactionId': 'TXN_20240711_002',
          'memberEmail': 'sarah.williams@email.com',
          'planType': 'Basic',
        },
        {
          'id': 'pay_003',
          'memberName': 'Mike Johnson',
          'memberImage':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          'amount': 129.99,
          'currency': 'USD',
          'paymentMethod': 'bank_transfer',
          'status': 'failed',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'description': 'Annual Membership Fee',
          'transactionId': 'TXN_20240710_001',
          'memberEmail': 'mike.johnson@email.com',
          'planType': 'Premium Plus',
        },
        {
          'id': 'pay_004',
          'memberName': 'Emma Davis',
          'memberImage':
              'https://images.unsplash.com/photo-1494790108755-2616b79dced0?w=150&h=150&fit=crop&crop=face',
          'amount': 49.99,
          'currency': 'USD',
          'paymentMethod': 'credit_card',
          'status': 'completed',
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'description': 'Quarterly Membership Fee',
          'transactionId': 'TXN_20240709_001',
          'memberEmail': 'emma.davis@email.com',
          'planType': 'Standard',
        },
        {
          'id': 'pay_005',
          'memberName': 'David Brown',
          'memberImage':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
          'amount': 25.00,
          'currency': 'USD',
          'paymentMethod': 'digital_wallet',
          'status': 'completed',
          'date': DateTime.now().subtract(const Duration(hours: 12)),
          'description': 'Group Class Package',
          'transactionId': 'TXN_20240710_002',
          'memberEmail': 'david.brown@email.com',
          'planType': 'Basic',
        },
      ];
      _filteredPayments = List.from(_payments);
      _isLoading = false;
    });
  }

  void _filterPayments() {
    setState(() {
      _filteredPayments = _payments.where((payment) {
        // Search filter
        final matchesSearch = payment['memberName']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            payment['transactionId']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        // Payment type filter
        final matchesPaymentType = _selectedPaymentType == 'all' ||
            payment['paymentMethod'] == _selectedPaymentType;

        // Status filter
        final matchesStatus =
            _selectedStatus == 'all' || payment['status'] == _selectedStatus;

        // Date range filter
        final matchesDateRange = _selectedDateRange == 'all' ||
            _checkDateRange(payment['date'] as DateTime);

        return matchesSearch &&
            matchesPaymentType &&
            matchesStatus &&
            matchesDateRange;
      }).toList();
    });
  }

  bool _checkDateRange(DateTime paymentDate) {
    final now = DateTime.now();
    switch (_selectedDateRange) {
      case 'today':
        return paymentDate.day == now.day &&
            paymentDate.month == now.month &&
            paymentDate.year == now.year;
      case 'week':
        return paymentDate.isAfter(now.subtract(const Duration(days: 7)));
      case 'month':
        return paymentDate.isAfter(now.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  void _showPaymentDetails(Map<String, dynamic> payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentDetailsModalWidget(
        payment: payment,
        onRefund: _processRefund,
        onSendReceipt: _sendReceipt,
      ),
    );
  }

  void _processRefund(String paymentId) {
    setState(() {
      final paymentIndex = _payments.indexWhere((p) => p['id'] == paymentId);
      if (paymentIndex != -1) {
        _payments[paymentIndex]['status'] = 'refunded';
      }
    });
    _filterPayments();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Refund processed successfully',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _sendReceipt(String paymentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Receipt sent successfully',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _togglePaymentSelection(String paymentId) {
    setState(() {
      if (_selectedPaymentIds.contains(paymentId)) {
        _selectedPaymentIds.remove(paymentId);
      } else {
        _selectedPaymentIds.add(paymentId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPaymentIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Payment Management',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showAnalytics = !_showAnalytics;
              });
            },
            icon: Icon(
              _showAnalytics ? Icons.list : Icons.analytics,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: _loadPayments,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                PaymentSearchWidget(
                  controller: _searchController,
                  onSearchChanged: (value) => _filterPayments(),
                ),
                SizedBox(height: 2.h),
                PaymentFilterWidget(
                  selectedPaymentType: _selectedPaymentType,
                  selectedStatus: _selectedStatus,
                  selectedDateRange: _selectedDateRange,
                  onPaymentTypeChanged: (value) {
                    setState(() {
                      _selectedPaymentType = value;
                    });
                    _filterPayments();
                  },
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _filterPayments();
                  },
                  onDateRangeChanged: (value) {
                    setState(() {
                      _selectedDateRange = value;
                    });
                    _filterPayments();
                  },
                ),
              ],
            ),
          ),

          // Selected payments action bar
          if (_selectedPaymentIds.isNotEmpty)
            BulkPaymentActionsWidget(
              selectedCount: _selectedPaymentIds.length,
              onClearSelection: _clearSelection,
              onExportSelected: () {
                // Export functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Export functionality would be implemented here'),
                  ),
                );
              },
            ),

          // Analytics or Payment List
          Expanded(
            child: _showAnalytics
                ? RevenueAnalyticsWidget(payments: _payments)
                : _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : _filteredPayments.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: EdgeInsets.all(4.w),
                            itemCount: _filteredPayments.length,
                            itemBuilder: (context, index) {
                              final payment = _filteredPayments[index];
                              final isSelected =
                                  _selectedPaymentIds.contains(payment['id']);

                              return PaymentCardWidget(
                                payment: payment,
                                isSelected: isSelected,
                                onTap: () => _showPaymentDetails(payment),
                                onToggleSelection: () =>
                                    _togglePaymentSelection(payment['id']),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          Text(
            'No payments found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filter criteria',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
