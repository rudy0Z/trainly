import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/reports_chart_widget.dart';
import './widgets/reports_data_table_widget.dart';
import './widgets/reports_export_widget.dart';
import './widgets/reports_filter_widget.dart';
import './widgets/reports_metrics_card_widget.dart';

class AdminReportsDashboard extends StatefulWidget {
  const AdminReportsDashboard({super.key});

  @override
  State<AdminReportsDashboard> createState() => _AdminReportsDashboardState();
}

class _AdminReportsDashboardState extends State<AdminReportsDashboard> {
  bool isLoading = false;
  String selectedTimeRange = 'This Month';
  String selectedMetric = 'Revenue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Reports & Analytics',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Selector
                  _buildDateRangeSelector(),
                  const SizedBox(height: 24),

                  // Key Metrics Cards
                  _buildMetricsGrid(),
                  const SizedBox(height: 24),

                  // Charts Section
                  _buildChartsSection(),
                  const SizedBox(height: 24),

                  // Data Table Section
                  _buildDataTableSection(),
                  const SizedBox(height: 24),

                  // Export Section
                  const ReportsExportWidget(),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Reports...',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: const Color(0xFF666666),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'July 01, 2025 - July 11, 2025',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedTimeRange,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: const Color(0xFF666666),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        ReportsMetricsCardWidget(
          title: 'Total Revenue',
          value: '\$12,485',
          subtitle: '+12% from last month',
          backgroundColor: Colors.white,
          isPositive: true,
        ),
        ReportsMetricsCardWidget(
          title: 'Active Members',
          value: '1,247',
          subtitle: '+8% from last month',
          backgroundColor: const Color(0xFFF5F5F5),
          isPositive: true,
        ),
        ReportsMetricsCardWidget(
          title: 'Classes Booked',
          value: '3,641',
          subtitle: '+15% from last month',
          backgroundColor: const Color(0xFFF5F5F5),
          isPositive: true,
        ),
        ReportsMetricsCardWidget(
          title: 'Cancellations',
          value: '127',
          subtitle: '-5% from last month',
          backgroundColor: Colors.white,
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Analytics',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Revenue Trend Chart
        ReportsChartWidget(
          title: 'Revenue Trends',
          chartType: 'line',
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 16),

        // Member Analytics Chart
        ReportsChartWidget(
          title: 'Member Analytics',
          chartType: 'bar',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildDataTableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detailed Reports',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () => _showFilterDialog(),
              icon: Icon(
                Icons.sort,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const ReportsDataTableWidget(),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const ReportsFilterWidget(),
      ),
    );
  }
}
