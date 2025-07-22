import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/membership_expiry_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/today_classes_card_widget.dart';
import './widgets/wallet_balance_card_widget.dart';
import './widgets/welcome_banner_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _currentIndex = 0;
  bool _isLoading = false;
  String _selectedGymLocation = "Trainly Fitness Center";
  int _notificationCount = 3;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Sarah Johnson",
    "membershipStatus": "Premium Active",
    "membershipExpiry": "2024-03-15",
    "profileImage":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
  };

  // Mock gym locations
  final List<String> _gymLocations = [
    "Trainly Fitness Center",
    "Trainly Downtown",
    "Trainly Westside",
    "Trainly Northgate"
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
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
    await _loadDashboardData();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/class-booking');
        break;
      case 2:
        Navigator.pushNamed(context, '/my-bookings');
        break;
      case 3:
        Navigator.pushNamed(context, '/digital-wallet');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile-settings');
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
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Gym Location',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ..._gymLocations.map((location) => ListTile(
                  leading: CustomIconWidget(
                    iconName: 'location_on',
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
              // Sticky Header
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 2,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                expandedHeight: 12.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        // Gym Logo
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'fitness_center',
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
                                Text(
                                  'Trainly',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                // Handle notification tap
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
                    // Welcome Banner
                    WelcomeBannerWidget(userData: _userData),
                    SizedBox(height: 2.h),
                    // Today's Classes
                    TodayClassesCardWidget(),
                    SizedBox(height: 2.h),
                    // Quick Actions
                    QuickActionsWidget(),
                    SizedBox(height: 2.h),
                    // Wallet Balance
                    WalletBalanceCardWidget(),
                    SizedBox(height: 2.h),
                    // Membership Expiry
                    MembershipExpiryWidget(
                      expiryDate: _userData["membershipExpiry"],
                    ),
                    SizedBox(height: 10.h), // Bottom padding for FAB
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
              iconName: 'home_outlined',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today_outlined',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'bookmark_border',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'bookmark',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet_outlined',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/class-booking');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Book Now',
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
