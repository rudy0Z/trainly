import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './widgets/trainer_card_widget.dart';
import './widgets/trainer_filter_widget.dart';
import './widgets/trainer_details_modal.dart';
import './widgets/add_trainer_modal.dart';

class AdminTrainersManagement extends StatefulWidget {
  const AdminTrainersManagement({super.key});

  @override
  State<AdminTrainersManagement> createState() =>
      _AdminTrainersManagementState();
}

class _AdminTrainersManagementState extends State<AdminTrainersManagement> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  bool _showBulkActions = false;
  String _selectedFilter = 'All';
  List<String> _selectedTrainers = [];
  List<Map<String, dynamic>> _trainers = [];
  List<Map<String, dynamic>> _filteredTrainers = [];

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  Future<void> _loadTrainers() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _trainers = [
        {
          'id': '1',
          'name': 'John Smith',
          'email': 'john.smith@gym.com',
          'phone': '+1 234 567 8900',
          'specialization': ['Strength Training', 'Weight Loss'],
          'experience': '5 years',
          'rating': 4.8,
          'totalReviews': 127,
          'status': 'Active',
          'profileImage':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'certifications': ['NASM-CPT', 'ACE Personal Trainer'],
          'joinDate': '2023-01-15',
          'totalClasses': 342,
          'totalMembers': 89,
          'nextClass': '2025-07-11 14:00',
          'bio':
              'Passionate trainer specializing in strength training and body transformation.',
        },
        {
          'id': '2',
          'name': 'Sarah Johnson',
          'email': 'sarah.johnson@gym.com',
          'phone': '+1 234 567 8901',
          'specialization': ['Yoga', 'Pilates', 'Mindfulness'],
          'experience': '7 years',
          'rating': 4.9,
          'totalReviews': 203,
          'status': 'Active',
          'profileImage':
              'https://images.unsplash.com/photo-1594736797933-d0401ba0ea65?w=400',
          'certifications': ['RYT-500', 'Pilates Instructor'],
          'joinDate': '2022-08-10',
          'totalClasses': 456,
          'totalMembers': 124,
          'nextClass': '2025-07-11 16:30',
          'bio':
              'Certified yoga instructor focused on holistic wellness and mental health.',
        },
        {
          'id': '3',
          'name': 'Mike Davis',
          'email': 'mike.davis@gym.com',
          'phone': '+1 234 567 8902',
          'specialization': ['CrossFit', 'HIIT', 'Functional Training'],
          'experience': '4 years',
          'rating': 4.7,
          'totalReviews': 98,
          'status': 'Inactive',
          'profileImage':
              'https://images.unsplash.com/photo-1567013127542-490d757e51cd?w=400',
          'certifications': ['CrossFit L1', 'HIIT Certified'],
          'joinDate': '2023-03-22',
          'totalClasses': 234,
          'totalMembers': 67,
          'nextClass': null,
          'bio':
              'High-intensity trainer specializing in functional fitness and CrossFit.',
        },
        {
          'id': '4',
          'name': 'Emily Wilson',
          'email': 'emily.wilson@gym.com',
          'phone': '+1 234 567 8903',
          'specialization': ['Dance Fitness', 'Zumba', 'Aerobics'],
          'experience': '6 years',
          'rating': 4.6,
          'totalReviews': 156,
          'status': 'Active',
          'profileImage':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'certifications': ['Zumba Licensed', 'Dance Fitness Certified'],
          'joinDate': '2022-11-05',
          'totalClasses': 389,
          'totalMembers': 143,
          'nextClass': '2025-07-11 18:00',
          'bio':
              'Energetic dance fitness instructor bringing joy to every workout.',
        },
      ];
      _filteredTrainers = List.from(_trainers);
      _isLoading = false;
    });
  }

  void _filterTrainers() {
    setState(() {
      _filteredTrainers = _trainers.where((trainer) {
        final searchMatch = trainer['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final filterMatch =
            _selectedFilter == 'All' || trainer['status'] == _selectedFilter;
        return searchMatch && filterMatch;
      }).toList();
    });
  }

  void _toggleTrainerSelection(String trainerId) {
    setState(() {
      if (_selectedTrainers.contains(trainerId)) {
        _selectedTrainers.remove(trainerId);
      } else {
        _selectedTrainers.add(trainerId);
      }
      _showBulkActions = _selectedTrainers.isNotEmpty;
    });
  }

  void _showTrainerDetails(Map<String, dynamic> trainer) {
    showDialog(
      context: context,
      builder: (context) => TrainerDetailsModal(trainer: trainer),
    );
  }

  void _showAddTrainerModal() {
    showDialog(
      context: context,
      builder: (context) => AddTrainerModal(
        onTrainerAdded: (Map<String, dynamic> newTrainer) {
          setState(() {
            _trainers.add(newTrainer);
            _filterTrainers();
          });
          Fluttertoast.showToast(
            msg: "Trainer added successfully",
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
      builder: (context) => TrainerFilterWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (String filter) {
          setState(() {
            _selectedFilter = filter;
            _filterTrainers();
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadTrainers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Trainers Management',
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
          // Search Bar
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterTrainers(),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search trainers...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
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
                    '${_selectedTrainers.length} selected',
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
                        _selectedTrainers.clear();
                        _showBulkActions = false;
                      });
                    },
                    child: Text(
                      'Activate',
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
                        _selectedTrainers.clear();
                        _showBulkActions = false;
                      });
                    },
                    child: Text(
                      'Deactivate',
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
          // Trainers List
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
                  : _filteredTrainers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No trainers found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          itemCount: _filteredTrainers.length,
                          itemBuilder: (context, index) {
                            final trainer = _filteredTrainers[index];
                            return TrainerCardWidget(
                              trainer: trainer,
                              isSelected:
                                  _selectedTrainers.contains(trainer['id']),
                              onToggleSelection: () =>
                                  _toggleTrainerSelection(trainer['id']),
                              onTap: () => _showTrainerDetails(trainer),
                              backgroundColor: index % 2 == 0
                                  ? Colors.white
                                  : const Color(0xFFF5F5F5),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTrainerModal,
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
