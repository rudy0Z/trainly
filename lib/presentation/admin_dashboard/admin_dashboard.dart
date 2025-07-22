import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_quick_actions_widget.dart';
import './widgets/admin_stats_widget.dart';
import './widgets/recent_activities_widget.dart';
import './widgets/system_alerts_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _currentIndex = 0;
  bool _isLoading = false;
  String _selectedGymLocation = "All Locations";
  int _notificationCount = 8;

  // Mock admin data
  final Map<String, dynamic> _adminData = {
    "name": "Admin User",
    "role": "System Administrator",
    "lastLogin": "2024-01-15 09:30 AM",
    "profileImage":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
  };

  // Mock gym locations for admin
  final List<String> _gymLocations = [
    "All Locations",
    "Trainly Downtown",
    "Trainly Westside",
    "Trainly Northgate",
    "Trainly Southside"
  ];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadAdminData();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Admin Dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/admin-users');
        break;
      case 2:
        Navigator.pushNamed(context, '/admin-trainers');
        break;
      case 3:
        Navigator.pushNamed(context, '/admin-classes');
        break;
      case 4:
        Navigator.pushNamed(context, '/admin-reports');
        break;
    }
  }

  void _showLocationSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Location Filter',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ..._gymLocations.map((location) => ListTile(
                  leading: CustomIconWidget(
                    iconName: location == "All Locations"
                        ? 'dashboard'
                        : 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: Text(location),
                  trailing: _selectedGymLocation == location
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedGymLocation = location;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('user_email');

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Admin Header
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 2,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                expandedHeight: 14.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        // Admin Logo
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'admin_panel_settings',
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Location Selector
                        Expanded(
                          child: GestureDetector(
                            onTap: _showLocationSelector,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Admin Panel',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.tertiary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'ADMIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _selectedGymLocation,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    CustomIconWidget(
                                      iconName: 'keyboard_arrow_down',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Notification Bell
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/admin-notifications');
                              },
                              icon: CustomIconWidget(
                                iconName: 'notifications_outlined',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 28,
                              ),
                            ),
                            if (_notificationCount > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    _notificationCount > 99
                                        ? '99+'
                                        : _notificationCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // Logout Button
                        IconButton(
                          onPressed: _logout,
                          icon: CustomIconWidget(
                            iconName: 'logout',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Main Content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 2.h),
                    // Admin Stats
                    AdminStatsWidget(),
                    SizedBox(height: 2.h),
                    // Quick Actions
                    AdminQuickActionsWidget(),
                    SizedBox(height: 2.h),
                    // Recent Activities
                    RecentActivitiesWidget(),
                    SizedBox(height: 2.h),
                    // System Alerts
                    SystemAlertsWidget(),
                    SizedBox(height: 10.h), // Bottom padding
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard_outlined',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'people_outline',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'people',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fitness_center',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'fitness_center',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Trainers',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'schedule_outlined',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics_outlined',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/admin-add-user');
        },
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
