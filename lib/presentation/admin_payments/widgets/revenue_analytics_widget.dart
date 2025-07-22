import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueAnalyticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> payments;

  const RevenueAnalyticsWidget({
    super.key,
    required this.payments,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Overview
          _buildRevenueOverview(),

          SizedBox(height: 3.h),

          // Payment Methods Chart
          _buildPaymentMethodsChart(),

          SizedBox(height: 3.h),

          // Revenue Trend Chart
          _buildRevenueTrendChart(),

          SizedBox(height: 3.h),

          // Status Distribution
          _buildStatusDistribution(),
        ],
      ),
    );
  }

  Widget _buildRevenueOverview() {
    final totalRevenue = payments
        .where((p) => p['status'] == 'completed')
        .fold<double>(0, (sum, p) => sum + p['amount']);

    final pendingRevenue = payments
        .where((p) => p['status'] == 'pending')
        .fold<double>(0, (sum, p) => sum + p['amount']);

    final refundedAmount = payments
        .where((p) => p['status'] == 'refunded')
        .fold<double>(0, (sum, p) => sum + p['amount']);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Overview',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Revenue',
                  '\$${totalRevenue.toStringAsFixed(2)}',
                  Icons.trending_up,
                  Colors.black,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Pending',
                  '\$${pendingRevenue.toStringAsFixed(2)}',
                  Icons.pending,
                  const Color(0xFF666666),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Refunded',
                  '\$${refundedAmount.toStringAsFixed(2)}',
                  Icons.undo,
                  const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsChart() {
    final methodCounts = <String, int>{};
    for (final payment in payments) {
      final method = payment['paymentMethod'] as String;
      methodCounts[method] = (methodCounts[method] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: PieChart(
              PieChartData(
                sections: methodCounts.entries.map((entry) {
                  final color = _getMethodColor(entry.key);
                  return PieChartSectionData(
                    color: color,
                    value: entry.value.toDouble(),
                    title: '${entry.value}',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                centerSpaceRadius: 40,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 4.w,
            runSpacing: 1.h,
            children: methodCounts.entries.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getMethodColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getMethodName(entry.key),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrendChart() {
    final dailyRevenue = <DateTime, double>{};
    for (final payment in payments) {
      if (payment['status'] == 'completed') {
        final date = payment['date'] as DateTime;
        final dateKey = DateTime(date.year, date.month, date.day);
        dailyRevenue[dateKey] =
            (dailyRevenue[dateKey] ?? 0) + payment['amount'];
      }
    }

    final sortedDates = dailyRevenue.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), dailyRevenue[entry.value]!);
    }).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFE0E0E0),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFE0E0E0),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < sortedDates.length) {
                          final date = sortedDates[value.toInt()];
                          return Text(
                            '${date.day}/${date.month}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.black,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.black.withAlpha(26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDistribution() {
    final statusCounts = <String, int>{};
    for (final payment in payments) {
      final status = payment['status'] as String;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Status Distribution',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...statusCounts.entries.map((entry) {
            final percentage = (entry.value / payments.length * 100).toInt();
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${entry.value} ($percentage%)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(entry.key),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'credit_card':
        return Colors.black;
      case 'paypal':
        return const Color(0xFF666666);
      case 'bank_transfer':
        return const Color(0xFF999999);
      case 'digital_wallet':
        return const Color(0xFFCCCCCC);
      default:
        return Colors.grey;
    }
  }

  String _getMethodName(String method) {
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
        return method;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.black;
      case 'pending':
        return const Color(0xFF666666);
      case 'failed':
        return const Color(0xFF999999);
      case 'refunded':
        return const Color(0xFFCCCCCC);
      default:
        return Colors.grey;
    }
  }
}
