import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_confirmation_sheet.dart';
import './widgets/class_card_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/filter_chips_widget.dart';

class ClassBooking extends StatefulWidget {
  const ClassBooking({Key? key}) : super(key: key);

  @override
  State<ClassBooking> createState() => _ClassBookingState();
}

class _ClassBookingState extends State<ClassBooking>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<String> activeFilters = [];
  bool isLoading = false;
  String selectedClassType = '';
  String selectedTrainer = '';
  String selectedTime = '';

  final List<Map<String, dynamic>> fitnessClasses = [
    {
      "id": 1,
      "name": "Morning Yoga Flow",
      "type": "Yoga",
      "typeIcon": "self_improvement",
      "trainer": {
        "name": "Sarah Johnson",
        "photo":
            "https://images.pexels.com/photos/3768916/pexels-photo-3768916.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Certified yoga instructor with 8 years of experience in Hatha and Vinyasa yoga."
      },
      "time": "07:00 AM",
      "duration": "60 min",
      "availableSpots": 8,
      "totalCapacity": 15,
      "difficulty": "Beginner",
      "description":
          "Start your day with gentle yoga flows designed to energize your body and calm your mind. Perfect for all fitness levels.",
      "reviews": [
        {
          "member": "John D.",
          "rating": 5,
          "comment": "Amazing class! Sarah is an excellent instructor."
        },
        {
          "member": "Lisa M.",
          "rating": 4,
          "comment": "Great way to start the morning. Very relaxing."
        }
      ],
      "price": "\$25"
    },
    {
      "id": 2,
      "name": "HIIT Cardio Blast",
      "type": "HIIT",
      "typeIcon": "fitness_center",
      "trainer": {
        "name": "Mike Rodriguez",
        "photo":
            "https://images.pexels.com/photos/1431282/pexels-photo-1431282.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Personal trainer specializing in high-intensity workouts and strength training for 6 years."
      },
      "time": "06:00 PM",
      "duration": "45 min",
      "availableSpots": 0,
      "totalCapacity": 12,
      "difficulty": "Advanced",
      "description":
          "High-intensity interval training designed to burn calories and build endurance. Bring your energy!",
      "reviews": [
        {
          "member": "Alex K.",
          "rating": 5,
          "comment": "Intense workout! Mike pushes you to your limits."
        },
        {
          "member": "Emma S.",
          "rating": 5,
          "comment": "Best HIIT class in the gym. Highly recommend!"
        }
      ],
      "price": "\$30"
    },
    {
      "id": 3,
      "name": "Strength Training",
      "type": "Strength",
      "typeIcon": "fitness_center",
      "trainer": {
        "name": "David Chen",
        "photo":
            "https://images.pexels.com/photos/1552106/pexels-photo-1552106.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Certified strength and conditioning coach with expertise in powerlifting and functional training."
      },
      "time": "05:30 PM",
      "duration": "75 min",
      "availableSpots": 5,
      "totalCapacity": 10,
      "difficulty": "Intermediate",
      "description":
          "Build muscle and increase strength with compound movements and progressive overload techniques.",
      "reviews": [
        {
          "member": "Tom R.",
          "rating": 5,
          "comment": "David knows his stuff. Great form corrections."
        },
        {
          "member": "Maria L.",
          "rating": 4,
          "comment": "Challenging but rewarding. Seeing great results!"
        }
      ],
      "price": "\$35"
    },
    {
      "id": 4,
      "name": "Pilates Core",
      "type": "Pilates",
      "typeIcon": "self_improvement",
      "trainer": {
        "name": "Jennifer Adams",
        "photo":
            "https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Mat and reformer Pilates instructor focused on core strength and body alignment for 5 years."
      },
      "time": "12:00 PM",
      "duration": "50 min",
      "availableSpots": 12,
      "totalCapacity": 15,
      "difficulty": "Beginner",
      "description":
          "Focus on core strength, flexibility, and body awareness through controlled movements and breathing.",
      "reviews": [
        {
          "member": "Sophie W.",
          "rating": 5,
          "comment": "Jennifer's cues are so helpful. Love this class!"
        },
        {
          "member": "Ryan B.",
          "rating": 4,
          "comment": "Great for core strength. Feeling stronger already."
        }
      ],
      "price": "\$28"
    },
    {
      "id": 5,
      "name": "Spin Cycle",
      "type": "Cycling",
      "typeIcon": "directions_bike",
      "trainer": {
        "name": "Amanda Foster",
        "photo":
            "https://images.pexels.com/photos/3768916/pexels-photo-3768916.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Indoor cycling instructor with high-energy classes that combine cardio with motivational coaching."
      },
      "time": "07:30 AM",
      "duration": "45 min",
      "availableSpots": 3,
      "totalCapacity": 20,
      "difficulty": "Intermediate",
      "description":
          "High-energy cycling class with motivating music and challenging intervals to boost your cardio fitness.",
      "reviews": [
        {
          "member": "Chris P.",
          "rating": 5,
          "comment": "Amanda's energy is contagious! Great workout."
        },
        {
          "member": "Kelly T.",
          "rating": 5,
          "comment": "Love the music and the challenging intervals."
        }
      ],
      "price": "\$25"
    },
    {
      "id": 6,
      "name": "Zumba Dance",
      "type": "Dance",
      "typeIcon": "music_note",
      "trainer": {
        "name": "Carlos Martinez",
        "photo":
            "https://images.pexels.com/photos/1431282/pexels-photo-1431282.jpeg?auto=compress&cs=tinysrgb&w=400",
        "bio":
            "Professional dance instructor specializing in Latin dance styles and fitness choreography."
      },
      "time": "06:30 PM",
      "duration": "60 min",
      "availableSpots": 18,
      "totalCapacity": 25,
      "difficulty": "Beginner",
      "description":
          "Fun dance fitness class combining Latin rhythms with easy-to-follow choreography. No dance experience needed!",
      "reviews": [
        {
          "member": "Nina H.",
          "rating": 5,
          "comment": "So much fun! Carlos makes everyone feel welcome."
        },
        {
          "member": "Mark J.",
          "rating": 4,
          "comment": "Great workout disguised as a dance party!"
        }
      ],
      "price": "\$22"
    }
  ];

  List<Map<String, dynamic>> get filteredClasses {
    return fitnessClasses.where((classItem) {
      bool matchesType = selectedClassType.isEmpty ||
          (classItem["type"] as String).toLowerCase() ==
              selectedClassType.toLowerCase();
      bool matchesTrainer = selectedTrainer.isEmpty ||
          ((classItem["trainer"] as Map<String, dynamic>)["name"] as String)
              .toLowerCase()
              .contains(selectedTrainer.toLowerCase());
      bool matchesTime = selectedTime.isEmpty ||
          (classItem["time"] as String).contains(selectedTime);

      return matchesType && matchesTrainer && matchesTime;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            DatePickerWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            if (activeFilters.isNotEmpty)
              FilterChipsWidget(
                activeFilters: activeFilters,
                onFilterRemoved: _removeFilter,
              ),
            Expanded(
              child: _buildClassList(),
            ),
          ],
        ),
      ),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Book a Class',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassList() {
    if (isLoading) {
      return _buildLoadingSkeletons();
    }

    return RefreshIndicator(
      onRefresh: _refreshClasses,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: filteredClasses.length,
        itemBuilder: (context, index) {
          final classItem = filteredClasses[index];
          return ClassCardWidget(
            classData: classItem,
            onBookNow: () => _showBookingConfirmation(classItem),
            onCardTap: () => _showClassDetails(classItem),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeletons() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: 25.w,
                          height: 1.5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Classes',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(
                        'Class Type',
                        [
                          'Yoga',
                          'HIIT',
                          'Strength',
                          'Pilates',
                          'Cycling',
                          'Dance'
                        ],
                        selectedClassType, (value) {
                      setState(() {
                        selectedClassType = value;
                        _updateActiveFilters();
                      });
                    }),
                    SizedBox(height: 3.h),
                    _buildFilterSection(
                        'Time',
                        [
                          'Morning (6-12 PM)',
                          'Afternoon (12-6 PM)',
                          'Evening (6-10 PM)'
                        ],
                        selectedTime, (value) {
                      setState(() {
                        selectedTime = value;
                        _updateActiveFilters();
                      });
                    }),
                    SizedBox(height: 3.h),
                    _buildTrainerFilter(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? '' : option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTrainerFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trainer',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search trainer name...',
            prefixIcon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedTrainer = value;
              _updateActiveFilters();
            });
          },
        ),
      ],
    );
  }

  void _updateActiveFilters() {
    activeFilters.clear();
    if (selectedClassType.isNotEmpty) {
      activeFilters.add('Type: $selectedClassType');
    }
    if (selectedTime.isNotEmpty) {
      activeFilters.add('Time: $selectedTime');
    }
    if (selectedTrainer.isNotEmpty) {
      activeFilters.add('Trainer: $selectedTrainer');
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      if (filter.startsWith('Type:')) {
        selectedClassType = '';
      } else if (filter.startsWith('Time:')) {
        selectedTime = '';
      } else if (filter.startsWith('Trainer:')) {
        selectedTrainer = '';
      }
      activeFilters.remove(filter);
    });
  }

  void _clearAllFilters() {
    setState(() {
      selectedClassType = '';
      selectedTime = '';
      selectedTrainer = '';
      activeFilters.clear();
    });
  }

  Future<void> _refreshClasses() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  void _showBookingConfirmation(Map<String, dynamic> classData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingConfirmationSheet(
        classData: classData,
        selectedDate: selectedDate,
        onConfirmBooking: _confirmBooking,
      ),
    );
  }

  void _showClassDetails(Map<String, dynamic> classData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ClassDetailsScreen(classData: classData),
      ),
    );
  }

  void _confirmBooking(Map<String, dynamic> classData) {
    // Show success animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getSuccessColor(true),
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'Booking Confirmed!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'You have successfully booked ${classData["name"]}',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-bookings');
            },
            child: const Text('View Bookings'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ClassDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> classData;

  const _ClassDetailsScreen({Key? key, required this.classData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainer = classData["trainer"] as Map<String, dynamic>;
    final reviews = classData["reviews"] as List;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClassInfo(),
                    SizedBox(height: 3.h),
                    _buildTrainerInfo(trainer),
                    SizedBox(height: 3.h),
                    _buildDescription(),
                    SizedBox(height: 3.h),
                    _buildReviews(reviews),
                  ],
                ),
              ),
            ),
            _buildBookingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Class Details',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: classData["typeIcon"] as String,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  classData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildInfoChip('Time', classData["time"] as String),
              SizedBox(width: 2.w),
              _buildInfoChip('Duration', classData["duration"] as String),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildInfoChip('Difficulty', classData["difficulty"] as String),
              SizedBox(width: 2.w),
              _buildInfoChip('Price', classData["price"] as String),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTrainerInfo(Map<String, dynamic> trainer) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trainer',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: trainer["photo"] as String,
                  width: 15.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainer["name"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      trainer["bio"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            classData["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(List reviews) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...reviews
              .map((review) => _buildReviewItem(review as Map<String, dynamic>))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review["member"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < (review["rating"] as int)
                        ? 'star'
                        : 'star_border',
                    color: AppTheme.getWarningColor(true),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            review["comment"] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    final availableSpots = classData["availableSpots"] as int;
    final isAvailable = availableSpots > 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isAvailable ? () => Navigator.pop(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.getWarningColor(true),
          ),
          child: Text(isAvailable ? 'Book Now' : 'Join Waitlist'),
        ),
      ),
    );
  }
}
