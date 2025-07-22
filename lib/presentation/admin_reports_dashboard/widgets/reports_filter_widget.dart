import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsFilterWidget extends StatefulWidget {
  const ReportsFilterWidget({super.key});

  @override
  State<ReportsFilterWidget> createState() => _ReportsFilterWidgetState();
}

class _ReportsFilterWidgetState extends State<ReportsFilterWidget> {
  String selectedTimeRange = 'This Month';
  String selectedMetric = 'Revenue';
  List<String> selectedCategories = [];

  final List<String> timeRanges = [
    'Today',
    'This Week',
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
    'Custom Range'
  ];

  final List<String> metrics = [
    'Revenue',
    'Members',
    'Classes',
    'Bookings',
    'Cancellations',
    'Attendance'
  ];

  final List<String> categories = [
    'Membership Plans',
    'Class Types',
    'Trainers',
    'Equipment',
    'Facilities',
    'Payments'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Reports',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // Time Range Selection
          _buildFilterSection(
            title: 'Time Range',
            child: _buildTimeRangeSelection(),
          ),

          const SizedBox(height: 20),

          // Metrics Selection
          _buildFilterSection(
            title: 'Primary Metric',
            child: _buildMetricSelection(),
          ),

          const SizedBox(height: 20),

          // Categories Selection
          _buildFilterSection(
            title: 'Categories',
            child: _buildCategorySelection(),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // Apply filters
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTimeRangeSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButton<String>(
        value: selectedTimeRange,
        isExpanded: true,
        underline: const SizedBox(),
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        items: timeRanges.map((String range) {
          return DropdownMenuItem<String>(
            value: range,
            child: Text(range),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedTimeRange = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildMetricSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButton<String>(
        value: selectedMetric,
        isExpanded: true,
        underline: const SizedBox(),
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        items: metrics.map((String metric) {
          return DropdownMenuItem<String>(
            value: metric,
            child: Text(metric),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedMetric = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      children: categories.map((category) {
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            category,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          value: selectedCategories.contains(category),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedCategories.add(category);
              } else {
                selectedCategories.remove(category);
              }
            });
          },
          activeColor: Colors.black,
          checkColor: Colors.white,
        );
      }).toList(),
    );
  }
}
