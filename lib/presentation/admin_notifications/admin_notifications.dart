import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/bulk_actions_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_composer_widget.dart';
import './widgets/notification_filter_widget.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  final TextEditingController _searchController = TextEditingController();
  List<NotificationData> _notifications = [];
  List<NotificationData> _filteredNotifications = [];
  String _selectedFilter = 'All';
  String _selectedPriority = 'All';
  bool _isLoading = false;
  Set<String> _selectedNotifications = <String>{};
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _generateNotifications();
    _filteredNotifications = _notifications;
  }

  void _generateNotifications() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with mock data
    Future.delayed(const Duration(seconds: 1), () {
      final List<NotificationData> mockNotifications = [
        NotificationData(
          id: '1',
          title: 'Class Schedule Update',
          content: 'Yoga class moved from 9 AM to 10 AM tomorrow',
          status: NotificationStatus.sent,
          priority: NotificationPriority.high,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          recipientCount: 45,
          deliveredCount: 42,
          readCount: 38,
        ),
        NotificationData(
          id: '2',
          title: 'New Membership Plan Available',
          content: 'Check out our premium membership with exclusive benefits',
          status: NotificationStatus.draft,
          priority: NotificationPriority.normal,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          recipientCount: 150,
          deliveredCount: 0,
          readCount: 0,
        ),
        NotificationData(
          id: '3',
          title: 'Maintenance Notice',
          content: 'The gym will be closed for maintenance on Sunday',
          status: NotificationStatus.scheduled,
          priority: NotificationPriority.high,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          recipientCount: 200,
          deliveredCount: 0,
          readCount: 0,
        ),
        NotificationData(
          id: '4',
          title: 'Welcome New Members',
          content: 'Join us for the new member orientation session',
          status: NotificationStatus.sent,
          priority: NotificationPriority.normal,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          recipientCount: 25,
          deliveredCount: 25,
          readCount: 18,
        ),
        NotificationData(
          id: '5',
          title: 'Payment Reminder',
          content: 'Your membership payment is due in 3 days',
          status: NotificationStatus.sent,
          priority: NotificationPriority.high,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          recipientCount: 75,
          deliveredCount: 73,
          readCount: 65,
        ),
      ];

      setState(() {
        _notifications = mockNotifications;
        _filteredNotifications = mockNotifications;
        _isLoading = false;
      });
    });
  }

  void _filterNotifications() {
    setState(() {
      _filteredNotifications = _notifications.where((notification) {
        final matchesSearch = notification.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            notification.content
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesFilter = _selectedFilter == 'All' ||
            notification.status.name == _selectedFilter.toLowerCase();

        final matchesPriority = _selectedPriority == 'All' ||
            notification.priority.name == _selectedPriority.toLowerCase();

        return matchesSearch && matchesFilter && matchesPriority;
      }).toList();
    });
  }

  void _toggleNotificationSelection(String id) {
    setState(() {
      if (_selectedNotifications.contains(id)) {
        _selectedNotifications.remove(id);
      } else {
        _selectedNotifications.add(id);
      }
    });
  }

  void _selectAllNotifications() {
    setState(() {
      _selectedNotifications = _filteredNotifications.map((n) => n.id).toSet();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedNotifications.clear();
    });
  }

  void _bulkDelete() {
    setState(() {
      _notifications.removeWhere((n) => _selectedNotifications.contains(n.id));
      _filteredNotifications
          .removeWhere((n) => _selectedNotifications.contains(n.id));
      _selectedNotifications.clear();
    });
  }

  void _bulkSend() {
    setState(() {
      for (final notification in _notifications) {
        if (_selectedNotifications.contains(notification.id) &&
            notification.status == NotificationStatus.draft) {
          notification.status = NotificationStatus.sent;
          notification.deliveredCount = notification.recipientCount;
        }
      }
      _selectedNotifications.clear();
    });
  }

  void _showComposer() {
    setState(() {
      _isComposing = true;
    });
  }

  void _hideComposer() {
    setState(() {
      _isComposing = false;
    });
  }

  void _createNotification(NotificationData notification) {
    setState(() {
      _notifications.insert(0, notification);
      _filteredNotifications.insert(0, notification);
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Admin Notifications',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search and Filter Header
              Container(
                padding: EdgeInsets.all(16.sp),
                color: Colors.black,
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _filterNotifications(),
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search notifications...',
                          hintStyle: GoogleFonts.inter(
                            color: const Color(0xFF666666),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    // Filter Row
                    NotificationFilterWidget(
                      selectedFilter: _selectedFilter,
                      selectedPriority: _selectedPriority,
                      onFilterChanged: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                          _filterNotifications();
                        });
                      },
                      onPriorityChanged: (priority) {
                        setState(() {
                          _selectedPriority = priority;
                          _filterNotifications();
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Bulk Actions Bar
              if (_selectedNotifications.isNotEmpty)
                BulkActionsWidget(
                  selectedCount: _selectedNotifications.length,
                  onSelectAll: _selectAllNotifications,
                  onClearSelection: _clearSelection,
                  onBulkDelete: _bulkDelete,
                  onBulkSend: _bulkSend,
                ),
              // Notifications List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : _filteredNotifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 64.sp,
                                  color: const Color(0xFF666666),
                                ),
                                SizedBox(height: 16.sp),
                                Text(
                                  'No notifications found',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.sp),
                                Text(
                                  'Try adjusting your filters or create a new notification',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF666666),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16.sp),
                            itemCount: _filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final notification =
                                  _filteredNotifications[index];
                              return NotificationCardWidget(
                                notification: notification,
                                isSelected: _selectedNotifications
                                    .contains(notification.id),
                                onSelectionChanged:
                                    _toggleNotificationSelection,
                                onEdit: (id) {
                                  // Handle edit action
                                },
                                onSend: (id) {
                                  setState(() {
                                    final notificationToSend = _notifications
                                        .firstWhere((n) => n.id == id);
                                    notificationToSend.status =
                                        NotificationStatus.sent;
                                    notificationToSend.deliveredCount =
                                        notificationToSend.recipientCount;
                                  });
                                },
                                onDelete: (id) {
                                  setState(() {
                                    _notifications
                                        .removeWhere((n) => n.id == id);
                                    _filteredNotifications
                                        .removeWhere((n) => n.id == id);
                                  });
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
          // Notification Composer Overlay
          if (_isComposing)
            NotificationComposerWidget(
              onClose: _hideComposer,
              onCreate: _createNotification,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showComposer,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Data Models
class NotificationData {
  String id;
  String title;
  String content;
  NotificationStatus status;
  NotificationPriority priority;
  DateTime timestamp;
  int recipientCount;
  int deliveredCount;
  int readCount;

  NotificationData({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.priority,
    required this.timestamp,
    required this.recipientCount,
    required this.deliveredCount,
    required this.readCount,
  });
}

enum NotificationStatus { draft, sent, scheduled, failed }

enum NotificationPriority { high, normal, low }
