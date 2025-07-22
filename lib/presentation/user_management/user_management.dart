import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_user_bottom_sheet.dart';
import './widgets/edit_user_bottom_sheet.dart';
import './widgets/user_card_widget.dart';
import './widgets/user_filter_bottom_sheet.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};

  // Mock user data
  List<Map<String, dynamic>> _allUsers = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '+1234567890',
      'age': 28,
      'gender': 'Male',
      'address': '123 Main St, City, State',
      'profileImage':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'membershipPlan': 'Premium',
      'membershipStatus': 'Active',
      'membershipExpiry': '2024-12-31',
      'joinDate': '2024-01-15',
      'emergencyContact': 'Jane Doe - +1234567891',
      'paymentStatus': 'Paid',
      'trainerAssigned': 'Mike Johnson',
      'activityLevel': 'High',
      'lastVisit': '2024-01-20 10:30 AM',
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'email': 'sarah.smith@email.com',
      'phone': '+1234567892',
      'age': 32,
      'gender': 'Female',
      'address': '456 Oak Ave, City, State',
      'profileImage':
          'https://images.unsplash.com/photo-1494790108755-2616b612b217?w=150&h=150&fit=crop&crop=face',
      'membershipPlan': 'Basic',
      'membershipStatus': 'Active',
      'membershipExpiry': '2024-06-30',
      'joinDate': '2023-08-20',
      'emergencyContact': 'Robert Smith - +1234567893',
      'paymentStatus': 'Paid',
      'trainerAssigned': 'Lisa Chen',
      'activityLevel': 'Medium',
      'lastVisit': '2024-01-19 02:15 PM',
    },
    {
      'id': '3',
      'name': 'Michael Brown',
      'email': 'michael.brown@email.com',
      'phone': '+1234567894',
      'age': 25,
      'gender': 'Male',
      'address': '789 Pine Rd, City, State',
      'profileImage':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'membershipPlan': 'Premium',
      'membershipStatus': 'Expired',
      'membershipExpiry': '2023-12-31',
      'joinDate': '2023-01-10',
      'emergencyContact': 'Emma Brown - +1234567895',
      'paymentStatus': 'Overdue',
      'trainerAssigned': 'None',
      'activityLevel': 'Low',
      'lastVisit': '2023-12-28 09:45 AM',
    },
    {
      'id': '4',
      'name': 'Emily Davis',
      'email': 'emily.davis@email.com',
      'phone': '+1234567896',
      'age': 29,
      'gender': 'Female',
      'address': '321 Elm St, City, State',
      'profileImage':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'membershipPlan': 'Standard',
      'membershipStatus': 'Active',
      'membershipExpiry': '2024-09-15',
      'joinDate': '2023-09-15',
      'emergencyContact': 'Tom Davis - +1234567897',
      'paymentStatus': 'Paid',
      'trainerAssigned': 'Alex Rodriguez',
      'activityLevel': 'High',
      'lastVisit': '2024-01-20 07:30 AM',
    },
    {
      'id': '5',
      'name': 'David Wilson',
      'email': 'david.wilson@email.com',
      'phone': '+1234567898',
      'age': 35,
      'gender': 'Male',
      'address': '654 Maple Dr, City, State',
      'profileImage':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      'membershipPlan': 'Premium',
      'membershipStatus': 'Suspended',
      'membershipExpiry': '2024-08-20',
      'joinDate': '2022-08-20',
      'emergencyContact': 'Linda Wilson - +1234567899',
      'paymentStatus': 'Overdue',
      'trainerAssigned': 'Mike Johnson',
      'activityLevel': 'Medium',
      'lastVisit': '2024-01-05 06:00 PM',
    },
  ];

  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _filteredUsers = List.from(_allUsers);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreUsers();
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _currentPage++;
      // In real implementation, you would fetch more data here
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = _allUsers.where((user) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['phone'].contains(_searchQuery);

      // Other filters
      bool matchesFilters = true;

      if (_activeFilters['membershipStatus'] != null &&
          _activeFilters['membershipStatus'] != 'All') {
        matchesFilters &=
            user['membershipStatus'] == _activeFilters['membershipStatus'];
      }

      if (_activeFilters['membershipPlan'] != null &&
          _activeFilters['membershipPlan'] != 'All') {
        matchesFilters &=
            user['membershipPlan'] == _activeFilters['membershipPlan'];
      }

      if (_activeFilters['paymentStatus'] != null &&
          _activeFilters['paymentStatus'] != 'All') {
        matchesFilters &=
            user['paymentStatus'] == _activeFilters['paymentStatus'];
      }

      return matchesSearch && matchesFilters;
    }).toList();

    setState(() {
      _filteredUsers = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserFilterBottomSheet(
        activeFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showAddUserBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddUserBottomSheet(
        onUserAdded: (userData) {
          setState(() {
            _allUsers.insert(0, {
              ...userData,
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'joinDate': DateTime.now().toString().split(' ')[0],
              'lastVisit': 'Never',
            });
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showEditUserBottomSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditUserBottomSheet(
        user: user,
        onUserUpdated: (updatedUser) {
          setState(() {
            int index = _allUsers.indexWhere((u) => u['id'] == user['id']);
            if (index != -1) {
              _allUsers[index] = updatedUser;
            }
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showUserDetailBottomSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserDetailBottomSheet(user),
    );
  }

  Widget _buildUserDetailBottomSheet(Map<String, dynamic> user) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('User Details: ${user['name']}'),
          // Add more user details as needed
        ],
      ),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text(
            'Are you sure you want to delete ${user['name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allUsers.removeWhere((u) => u['id'] == user['id']);
              });
              _applyFilters();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} deleted successfully'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _allUsers.add(user);
                      });
                      _applyFilters();
                    },
                  ),
                ),
              );
            },
            child: Text('Delete',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _currentPage = 1;
      _hasMoreData = true;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                if (_activeFilters.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by name, email, or phone...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // Results Summary
          if (_activeFilters.isNotEmpty || _searchQuery.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withAlpha(26),
              child: Text(
                '${_filteredUsers.length} users found',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),

          // User List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: _filteredUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'people_outline',
                            size: 64,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No users found',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                                ? 'Try adjusting your search or filters'
                                : 'Add your first user to get started',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.h),
                          ElevatedButton.icon(
                            onPressed: _searchQuery.isNotEmpty ||
                                    _activeFilters.isNotEmpty
                                ? () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _activeFilters.clear();
                                    });
                                    _applyFilters();
                                  }
                                : _showAddUserBottomSheet,
                            icon: CustomIconWidget(
                              iconName: _searchQuery.isNotEmpty ||
                                      _activeFilters.isNotEmpty
                                  ? 'clear'
                                  : 'add',
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(_searchQuery.isNotEmpty ||
                                    _activeFilters.isNotEmpty
                                ? 'Clear Filters'
                                : 'Add User'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      itemCount: _filteredUsers.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredUsers.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(2.h),
                              child: CircularProgressIndicator(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          );
                        }

                        final user = _filteredUsers[index];
                        return UserCardWidget(
                          user: user,
                          onEdit: () => _showEditUserBottomSheet(user),
                          onDelete: () => _deleteUser(user),
                          onView: () => _showUserDetailBottomSheet(user),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserBottomSheet,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Add User',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
