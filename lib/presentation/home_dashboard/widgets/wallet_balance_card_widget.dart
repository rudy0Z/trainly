import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WalletBalanceCardWidget extends StatelessWidget {
  const WalletBalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock wallet data
    final Map<String, dynamic> walletData = {
      "balance": 245.50,
      "currency": "\$",
      "lastTransaction": "Class booking payment",
      "lastTransactionAmount": -15.00,
      "lastTransactionDate": "Today, 2:30 PM",
    };

    // Mock recent transactions
    final List<Map<String, dynamic>> recentTransactions = [
      {
        "id": 1,
        "type": "debit",
        "description": "Yoga Class Booking",
        "amount": -15.00,
        "date": "Today, 2:30 PM",
        "icon": "sports_gymnastics"
      },
      {
        "id": 2,
        "type": "credit",
        "description": "Wallet Top-up",
        "amount": 100.00,
        "date": "Yesterday, 10:15 AM",
        "icon": "add_circle"
      },
      {
        "id": 3,
        "type": "debit",
        "description": "HIIT Training",
        "amount": -20.00,
        "date": "Dec 28, 6:00 PM",
        "icon": "flash_on"
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wallet Balance',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/digital-wallet');
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Balance Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.getSuccessColor(true),
                    AppTheme.getSuccessColor(true).withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${walletData["currency"]}${walletData["balance"].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: walletData["lastTransactionAmount"] > 0
                            ? 'trending_up'
                            : 'trending_down',
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Last: ${walletData["currency"]}${walletData["lastTransactionAmount"].abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // Recent Transactions
            Text(
              'Recent Transactions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ...recentTransactions.take(3).map(
                (transaction) => _buildTransactionItem(context, transaction)),
            SizedBox(height: 1.h),
            // Add Money Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/digital-wallet');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Add Money'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Map<String, dynamic> transaction) {
    final bool isCredit = transaction["type"] == "credit";
    final Color amountColor = isCredit
        ? AppTheme.getSuccessColor(true)
        : AppTheme.lightTheme.colorScheme.error;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Transaction Icon
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: transaction["icon"] ?? "receipt",
              color: amountColor,
              size: 18,
            ),
          ),
          SizedBox(width: 3.w),
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction["description"] ?? "",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  transaction["date"] ?? "",
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Transaction Amount
          Text(
            '${isCredit ? '+' : ''}\$${transaction["amount"].abs().toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
