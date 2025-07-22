import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/activity_card_widget.dart';
import './widgets/activity_detail_modal.dart';
import './widgets/activity_filter_widget.dart';
import './widgets/activity_search_widget.dart';
import './widgets/activity_stats_widget.dart';

class AdminActivities extends StatefulWidget {
  const AdminActivities({super.key});

  @override
  State<AdminActivities> createState() => _AdminActivitiesState();
}

class _AdminActivitiesState extends State<AdminActivities> {
  String _selectedFilter = 'All';
  String _selectedDateRange = 'Today';
  String _selectedUserRole = 'All Users';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isExporting = false;

  final List<String> _filterTypes = [
    'All',
    'Member Activity',
    'Payment',
    'Class Booking',
    'Membership',
    'System',
    'Error',
  ];

  final List<String> _dateRanges = [
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'This Month',
    'Custom Range',
  ];

  final List<String> _userRoles = [
    'All Users',
    'Members',
    'Trainers',
    'Admins',
    'System',
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'id': '1',
      'type': 'Member Activity',
      'title': 'Member Joined',
      'description': 'Sarah Johnson joined the gym',
      'user': 'Sarah Johnson',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'icon': Icons.person_add,
      'priority': 'normal',
      'details': {
        'member_id': 'M001',
        'membership_type': 'Premium',
        'payment_method': 'Credit Card',
      },
    },
    {
      'id': '2',
      'type': 'Payment',
      'title': 'Payment Failed',
      'description': 'Payment failed for John Smith membership renewal',
      'user': 'John Smith',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'icon': Icons.payment,
      'priority': 'high',
      'details': {
        'member_id': 'M002',
        'amount': '\$99.99',
        'reason': 'Insufficient funds',
      },
    },
    {
      'id': '3',
      'type': 'Class Booking',
      'title': 'Class Booked',
      'description': 'Mike Brown booked Yoga class for tomorrow',
      'user': 'Mike Brown',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'icon': Icons.fitness_center,
      'priority': 'normal',
      'details': {
        'member_id': 'M003',
        'class_name': 'Yoga',
        'date': 'Tomorrow 10:00 AM',
      },
    },
    {
      'id': '4',
      'type': 'Member Activity',
      'title': 'Member Cancelled',
      'description': 'Emily Davis cancelled her membership',
      'user': 'Emily Davis',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.person_remove,
      'priority': 'high',
      'details': {
        'member_id': 'M004',
        'reason': 'Relocation',
        'refund_amount': '\$150.00',
      },
    },
    {
      'id': '5',
      'type': 'System',
      'title': 'System Update',
      'description': 'Backup completed successfully',
      'user': 'System',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.backup,
      'priority': 'normal',
      'details': {
        'backup_size': '2.5 GB',
        'duration': '45 minutes',
        'status': 'Success',
      },
    },
  ];

  List<Map<String, dynamic>> get _filteredActivities {
    return _activities.where((activity) {
      bool matchesFilter =
          _selectedFilter == 'All' || activity['type'] == _selectedFilter;
      bool matchesSearch = _searchQuery.isEmpty ||
          activity['title']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          activity['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          activity['user'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _refreshActivities() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _exportActivities() {
    setState(() {
      _isExporting = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isExporting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity report exported successfully')),
      );
    });
  }

  void _showActivityDetail(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => ActivityDetailModal(activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Activity Log',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshActivities,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: _exportActivities,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          ActivitySearchWidget(
            searchQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),

          // Filter Controls
          ActivityFilterWidget(
            selectedFilter: _selectedFilter,
            selectedDateRange: _selectedDateRange,
            selectedUserRole: _selectedUserRole,
            filterTypes: _filterTypes,
            dateRanges: _dateRanges,
            userRoles: _userRoles,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            onDateRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
            },
            onUserRoleChanged: (role) {
              setState(() {
                _selectedUserRole = role;
              });
            },
          ),

          // Activity Stats
          ActivityStatsWidget(
            totalActivities: _filteredActivities.length,
            todayActivities: _filteredActivities
                .where((a) =>
                    DateTime.now().difference(a['timestamp']).inDays == 0)
                .length,
            highPriorityCount: _filteredActivities
                .where((a) => a['priority'] == 'high')
                .length,
          ),

          // Activity List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : _filteredActivities.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = _filteredActivities[index];
                          final isOdd = index % 2 == 1;

                          return ActivityCardWidget(
                            activity: activity,
                            backgroundColor:
                                isOdd ? const Color(0xFFF8F8F8) : Colors.white,
                            onTap: () => _showActivityDetail(activity),
                          );
                        },
                      ),
          ),
        ],
      ),

      // Export Widget
      floatingActionButton: _isExporting
          ? const FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.black,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.history,
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Activities Found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshActivities,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Refresh',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
