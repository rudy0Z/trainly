import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_money_bottom_sheet.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/transaction_history_widget.dart';
import './widgets/wallet_balance_widget.dart';

class DigitalWallet extends StatefulWidget {
  const DigitalWallet({Key? key}) : super(key: key);

  @override
  State<DigitalWallet> createState() => _DigitalWalletState();
}

class _DigitalWalletState extends State<DigitalWallet>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int _currentIndex = 4; // Digital Wallet tab index
  bool _isBalanceVisible = true;
  String _selectedFilter = 'All';
  String _selectedDateRange = 'All Time';

  // Mock wallet data
  final Map<String, dynamic> walletData = {
    "balance": 2450.75,
    "currency": "USD",
    "lastUpdated": "2024-01-15T10:30:00Z",
    "autoReload": {"enabled": true, "threshold": 100.0, "amount": 500.0}
  };

  // Mock transaction data
  final List<Map<String, dynamic>> transactions = [
    {
      "id": "txn_001",
      "type": "credit",
      "amount": 50.0,
      "description": "Cashback from membership renewal",
      "merchant": "Trainly Premium",
      "date": "2024-01-15T09:15:00Z",
      "status": "completed",
      "category": "cashback",
      "icon": "card_giftcard"
    },
    {
      "id": "txn_002",
      "type": "debit",
      "amount": 25.0,
      "description": "Personal training session",
      "merchant": "John Smith - Trainer",
      "date": "2024-01-14T16:30:00Z",
      "status": "completed",
      "category": "training",
      "icon": "fitness_center"
    },
    {
      "id": "txn_003",
      "type": "credit",
      "amount": 100.0,
      "description": "Wallet top-up via UPI",
      "merchant": "UPI Payment",
      "date": "2024-01-14T14:20:00Z",
      "status": "completed",
      "category": "topup",
      "icon": "account_balance_wallet"
    },
    {
      "id": "txn_004",
      "type": "debit",
      "amount": 15.0,
      "description": "Protein shake purchase",
      "merchant": "Fitness Cafe",
      "date": "2024-01-13T12:45:00Z",
      "status": "completed",
      "category": "food",
      "icon": "local_cafe"
    },
    {
      "id": "txn_005",
      "type": "credit",
      "amount": 200.0,
      "description": "Referral bonus",
      "merchant": "Trainly Rewards",
      "date": "2024-01-12T11:00:00Z",
      "status": "completed",
      "category": "referral",
      "icon": "people"
    },
    {
      "id": "txn_006",
      "type": "debit",
      "amount": 75.0,
      "description": "Monthly membership fee",
      "merchant": "Trainly Premium",
      "date": "2024-01-10T08:00:00Z",
      "status": "completed",
      "category": "membership",
      "icon": "card_membership"
    }
  ];

  // Mock cashback data
  final List<Map<String, dynamic>> cashbackRewards = [
    {
      "id": "cb_001",
      "amount": 25.0,
      "source": "Membership renewal",
      "earnedDate": "2024-01-15T09:15:00Z",
      "expiryDate": "2024-04-15T23:59:59Z",
      "status": "active"
    },
    {
      "id": "cb_002",
      "amount": 15.0,
      "source": "Friend referral",
      "earnedDate": "2024-01-12T11:00:00Z",
      "expiryDate": "2024-04-12T23:59:59Z",
      "status": "active"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      WalletBalanceWidget(
                        balance: walletData["balance"] as double,
                        currency: walletData["currency"] as String,
                        isVisible: _isBalanceVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                      ),
                      SizedBox(height: 2.h),
                      QuickActionsWidget(
                        onAddMoney: _showAddMoneyBottomSheet,
                        onSendToFriend: _handleSendToFriend,
                      ),
                      SizedBox(height: 3.h),
                      TransactionHistoryWidget(
                        transactions: _getFilteredTransactions(),
                        cashbackRewards: cashbackRewards,
                        onTransactionTap: _handleTransactionTap,
                      ),
                      SizedBox(height: 10.h), // Bottom padding for navigation
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Digital Wallet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: _showNotifications,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'event',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Classes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'bookmark',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'card_membership',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Plans',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Wallet',
        ),
      ],
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/class-booking');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/my-bookings');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/membership-plans');
        break;
      case 4:
        // Already on wallet screen
        break;
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Refresh wallet data and transactions
      walletData["lastUpdated"] = DateTime.now().toIso8601String();
    });
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    List<Map<String, dynamic>> filtered = List.from(transactions);

    if (_selectedFilter != 'All') {
      filtered = filtered.where((transaction) {
        switch (_selectedFilter) {
          case 'Credits':
            return transaction['type'] == 'credit';
          case 'Debits':
            return transaction['type'] == 'debit';
          case 'Cashback':
            return transaction['category'] == 'cashback';
          case 'Membership':
            return transaction['category'] == 'membership';
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  void _showAddMoneyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMoneyBottomSheet(
        onAddMoney: _handleAddMoney,
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedFilter: _selectedFilter,
        selectedDateRange: _selectedDateRange,
        onFilterChanged: (filter, dateRange) {
          setState(() {
            _selectedFilter = filter;
            _selectedDateRange = dateRange;
          });
        },
      ),
    );
  }

  void _handleAddMoney(double amount, String paymentMethod) {
    // Simulate payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Adding \$${amount.toStringAsFixed(2)} via $paymentMethod'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );

    // Update balance after successful payment
    setState(() {
      walletData["balance"] = (walletData["balance"] as double) + amount;
    });
  }

  void _handleSendToFriend() {
    Navigator.pushNamed(context, '/qr-code-scanner');
  }

  void _handleTransactionTap(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Amount: \$${(transaction["amount"] as double).toStringAsFixed(2)}'),
            SizedBox(height: 1.h),
            Text('Type: ${transaction["type"]}'),
            SizedBox(height: 1.h),
            Text('Merchant: ${transaction["merchant"]}'),
            SizedBox(height: 1.h),
            Text(
                'Date: ${DateTime.parse(transaction["date"]).toString().split('.')[0]}'),
            SizedBox(height: 1.h),
            Text('Status: ${transaction["status"]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No new notifications'),
        backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }
}
