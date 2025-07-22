import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './widgets/class_card_widget.dart';
import './widgets/class_filter_widget.dart';
import './widgets/class_details_modal.dart';
import './widgets/add_class_modal.dart';
import './widgets/date_selector_widget.dart';

class AdminClassesManagement extends StatefulWidget {
  const AdminClassesManagement({super.key});

  @override
  State<AdminClassesManagement> createState() => _AdminClassesManagementState();
}

class _AdminClassesManagementState extends State<AdminClassesManagement> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  bool _showBulkActions = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  List<String> _selectedClasses = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _classes = [
        {
          'id': '1',
          'name': 'Morning Yoga',
          'description': 'Start your day with a peaceful yoga session',
          'instructor': 'Sarah Johnson',
          'instructorImage':
              'https://images.unsplash.com/photo-1594736797933-d0401ba0ea65?w=400',
          'time': '08:00 AM',
          'duration': '60 min',
          'capacity': 20,
          'enrolled': 18,
          'waitlist': 3,
          'status': 'Available',
          'date': '2025-07-11',
          'location': 'Studio A',
          'category': 'Yoga',
          'difficulty': 'Beginner',
          'price': 25.0,
          'equipment': ['Yoga Mat', 'Blocks'],
        },
        {
          'id': '2',
          'name': 'HIIT Training',
          'description': 'High-intensity interval training for maximum results',
          'instructor': 'Mike Davis',
          'instructorImage':
              'https://images.unsplash.com/photo-1567013127542-490d757e51cd?w=400',
          'time': '07:00 PM',
          'duration': '45 min',
          'capacity': 15,
          'enrolled': 15,
          'waitlist': 8,
          'status': 'Full',
          'date': '2025-07-11',
          'location': 'Gym Floor',
          'category': 'HIIT',
          'difficulty': 'Advanced',
          'price': 35.0,
          'equipment': ['Dumbbells', 'Kettlebells'],
        },
        {
          'id': '3',
          'name': 'Strength Training',
          'description': 'Build muscle and increase strength',
          'instructor': 'John Smith',
          'instructorImage':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'time': '06:00 PM',
          'duration': '90 min',
          'capacity': 12,
          'enrolled': 8,
          'waitlist': 0,
          'status': 'Available',
          'date': '2025-07-11',
          'location': 'Weight Room',
          'category': 'Strength',
          'difficulty': 'Intermediate',
          'price': 40.0,
          'equipment': ['Barbells', 'Dumbbells', 'Benches'],
        },
        {
          'id': '4',
          'name': 'Dance Fitness',
          'description': 'Fun dance workout for all levels',
          'instructor': 'Emily Wilson',
          'instructorImage':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'time': '05:30 PM',
          'duration': '60 min',
          'capacity': 25,
          'enrolled': 12,
          'waitlist': 0,
          'status': 'Available',
          'date': '2025-07-11',
          'location': 'Studio B',
          'category': 'Dance',
          'difficulty': 'Beginner',
          'price': 30.0,
          'equipment': ['Sound System'],
        },
      ];
      _filteredClasses = List.from(_classes);
      _isLoading = false;
    });
  }

  void _filterClasses() {
    setState(() {
      _filteredClasses = _classes.where((classItem) {
        final filterMatch =
            _selectedFilter == 'All' || classItem['status'] == _selectedFilter;
        final dateMatch =
            classItem['date'] == _selectedDate.toString().split(' ')[0];
        return filterMatch && dateMatch;
      }).toList();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _filterClasses();
    });
  }

  void _toggleClassSelection(String classId) {
    setState(() {
      if (_selectedClasses.contains(classId)) {
        _selectedClasses.remove(classId);
      } else {
        _selectedClasses.add(classId);
      }
      _showBulkActions = _selectedClasses.isNotEmpty;
    });
  }

  void _showClassDetails(Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (context) => ClassDetailsModal(classData: classData),
    );
  }

  void _showAddClassModal() {
    showDialog(
      context: context,
      builder: (context) => AddClassModal(
        onClassAdded: (Map<String, dynamic> newClass) {
          setState(() {
            _classes.add(newClass);
            _filterClasses();
          });
          Fluttertoast.showToast(
            msg: "Class added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClassFilterWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (String filter) {
          setState(() {
            _selectedFilter = filter;
            _filterClasses();
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Classes Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Selector
          Container(
            color: Colors.white,
            child: DateSelectorWidget(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
          ),
          // Bulk Actions Toolbar
          if (_showBulkActions)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Text(
                    '${_selectedClasses.length} selected',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedClasses.clear();
                        _showBulkActions = false;
                      });
                    },
                    child: Text(
                      'Duplicate',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedClasses.clear();
                        _showBulkActions = false;
                      });
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Classes Grid
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _onRefresh,
              color: Colors.black,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : _filteredClasses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No classes found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(4.w),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3.w,
                              mainAxisSpacing: 3.w,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredClasses.length,
                            itemBuilder: (context, index) {
                              final classData = _filteredClasses[index];
                              return ClassCardWidget(
                                classData: classData,
                                isSelected:
                                    _selectedClasses.contains(classData['id']),
                                onToggleSelection: () =>
                                    _toggleClassSelection(classData['id']),
                                onTap: () => _showClassDetails(classData),
                                backgroundColor: index % 2 == 0
                                    ? Colors.white
                                    : const Color(0xFFF8F8F8),
                              );
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassModal,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
