import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/empty_bookings_widget.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 2; // Bookings tab active
  int _selectedSegment = 0; // 0 for Upcoming, 1 for History

  final List<Map<String, dynamic>> upcomingBookings = [
    {
      "id": 1,
      "className": "HIIT Training",
      "classType": "fitness_center",
      "date": "2024-01-15",
      "time": "09:00 AM",
      "duration": 60,
      "trainer": {
        "name": "Sarah Johnson",
        "photo":
            "https://images.pexels.com/photos/3768916/pexels-photo-3768916.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.8
      },
      "gymLocation": "Downtown Branch",
      "status": "Confirmed",
      "spotsLeft": 3,
      "totalSpots": 15,
      "bookingId": "BK001",
      "canCancel": true,
      "canReschedule": true,
      "countdownHours": 18
    },
    {
      "id": 2,
      "className": "Yoga Flow",
      "classType": "self_improvement",
      "date": "2024-01-16",
      "time": "07:30 AM",
      "duration": 75,
      "trainer": {
        "name": "Michael Chen",
        "photo":
            "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.9
      },
      "gymLocation": "Uptown Branch",
      "status": "Waitlisted",
      "spotsLeft": 0,
      "totalSpots": 12,
      "bookingId": "BK002",
      "canCancel": true,
      "canReschedule": false,
      "countdownHours": 42,
      "waitlistPosition": 2
    },
    {
      "id": 3,
      "className": "Strength Training",
      "classType": "fitness_center",
      "date": "2024-01-17",
      "time": "06:00 PM",
      "duration": 90,
      "trainer": {
        "name": "Emma Rodriguez",
        "photo":
            "https://images.pexels.com/photos/3823488/pexels-photo-3823488.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.7
      },
      "gymLocation": "Downtown Branch",
      "status": "Confirmed",
      "spotsLeft": 8,
      "totalSpots": 20,
      "bookingId": "BK003",
      "canCancel": true,
      "canReschedule": true,
      "countdownHours": 66
    }
  ];

  final List<Map<String, dynamic>> historyBookings = [
    {
      "id": 4,
      "className": "Cardio Blast",
      "classType": "fitness_center",
      "date": "2024-01-10",
      "time": "08:00 AM",
      "duration": 45,
      "trainer": {
        "name": "David Wilson",
        "photo":
            "https://images.pexels.com/photos/1547248/pexels-photo-1547248.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.6
      },
      "gymLocation": "Downtown Branch",
      "status": "Completed",
      "attendanceStatus": "Present",
      "bookingId": "BK004",
      "userRating": null,
      "canRate": true
    },
    {
      "id": 5,
      "className": "Pilates Core",
      "classType": "self_improvement",
      "date": "2024-01-08",
      "time": "10:00 AM",
      "duration": 60,
      "trainer": {
        "name": "Lisa Thompson",
        "photo":
            "https://images.pexels.com/photos/3768916/pexels-photo-3768916.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.8
      },
      "gymLocation": "Uptown Branch",
      "status": "Completed",
      "attendanceStatus": "Present",
      "bookingId": "BK005",
      "userRating": 5,
      "canRate": false
    },
    {
      "id": 6,
      "className": "Boxing Fundamentals",
      "classType": "sports_martial_arts",
      "date": "2024-01-05",
      "time": "07:00 PM",
      "duration": 75,
      "trainer": {
        "name": "Marcus Johnson",
        "photo":
            "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.9
      },
      "gymLocation": "Downtown Branch",
      "status": "Cancelled",
      "attendanceStatus": "Cancelled",
      "bookingId": "BK006",
      "userRating": null,
      "canRate": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSegmentedControl(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUpcomingBookings(),
                  _buildHistoryBookings(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'book',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            'My Bookings',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _showFilterOptions(),
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            _selectedSegment = index;
          });
        },
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface,
        labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelLarge,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    if (upcomingBookings.isEmpty) {
      return EmptyBookingsWidget(
        title: 'No Upcoming Bookings',
        message: 'Book your next fitness class and start your journey!',
        actionText: 'Browse Classes',
        onActionPressed: () => Navigator.pushNamed(context, '/class-booking'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: upcomingBookings.length,
        itemBuilder: (context, index) {
          final booking = upcomingBookings[index];
          return BookingCardWidget(
            booking: booking,
            isUpcoming: true,
            onCancel: () => _showCancelDialog(booking),
            onReschedule: () => _showRescheduleDialog(booking),
            onAddToCalendar: () => _addToCalendar(booking),
            onShare: () => _shareBooking(booking),
            onTap: () => _showBookingDetails(booking),
          );
        },
      ),
    );
  }

  Widget _buildHistoryBookings() {
    if (historyBookings.isEmpty) {
      return EmptyBookingsWidget(
        title: 'No Booking History',
        message: 'Your completed classes will appear here.',
        actionText: 'Book a Class',
        onActionPressed: () => Navigator.pushNamed(context, '/class-booking'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: historyBookings.length,
        itemBuilder: (context, index) {
          final booking = historyBookings[index];
          return BookingCardWidget(
            booking: booking,
            isUpcoming: false,
            onRate: booking['canRate'] == true
                ? () => _showRatingDialog(booking)
                : null,
            onFeedback: () => _showFeedbackDialog(booking),
            onTap: () => _showBookingDetails(booking),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomIndex,
      onTap: (index) {
        setState(() {
          _currentBottomIndex = index;
        });
        _navigateToTab(index);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor:
          AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentBottomIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'event',
            color: _currentBottomIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Classes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'book',
            color: _currentBottomIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentBottomIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentBottomIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/class-booking');
        break;
      case 2:
        // Current screen
        break;
      case 3:
        Navigator.pushNamed(context, '/digital-wallet');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  Future<void> _refreshBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate API call to refresh bookings
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bookings refreshed'),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Bookings',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'date_range',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Sort by Date'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Filter by Class Type'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Filter by Trainer'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your booking for ${booking['className']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(booking);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Booking'),
        content: Text(
          'Would you like to reschedule your ${booking['className']} class?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/class-booking');
            },
            child: const Text('Find New Time'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> booking) {
    int rating = 5;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Rate ${booking['className']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'How was your experience with ${booking['trainer']['name']}?'),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => rating = index + 1),
                    icon: CustomIconWidget(
                      iconName: index < rating ? 'star' : 'star_border',
                      color: AppTheme.getWarningColor(true),
                      size: 32,
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitRating(booking, rating);
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(Map<String, dynamic> booking) {
    final TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Feedback for ${booking['className']}'),
        content: TextField(
          controller: feedbackController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Share your experience...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitFeedback(booking, feedbackController.text);
            },
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                booking['className'],
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 2.h),
              _buildDetailRow('Date', booking['date']),
              _buildDetailRow('Time', booking['time']),
              _buildDetailRow('Duration', '${booking['duration']} minutes'),
              _buildDetailRow('Trainer', booking['trainer']['name']),
              _buildDetailRow('Location', booking['gymLocation']),
              _buildDetailRow('Status', booking['status']),
              _buildDetailRow('Booking ID', booking['bookingId']),
              if (booking['status'] == 'Confirmed') ...[
                SizedBox(height: 3.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Show QR Code at Gym',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking for ${booking['className']} cancelled'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _addToCalendar(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${booking['className']} added to calendar'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _shareBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${booking['className']} booking'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _submitRating(Map<String, dynamic> booking, int rating) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rating submitted for ${booking['className']}'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _submitFeedback(Map<String, dynamic> booking, String feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback submitted for ${booking['className']}'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }
}
