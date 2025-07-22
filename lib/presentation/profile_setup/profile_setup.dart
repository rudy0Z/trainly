import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'Male';
  List<String> _selectedGoals = [];
  List<String> _selectedDays = [];
  List<String> _selectedWorkoutTypes = [];

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _fitnessGoals = [
    'Weight Loss',
    'Strength',
    'Flexibility',
    'General Fitness'
  ];
  final List<String> _workoutDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> _workoutTypes = [
    'Yoga',
    'Calisthenics',
    'Cardio',
    'Strength Training'
  ];

  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('user_profile');

    if (profileJson != null) {
      final profile = UserProfile.fromJson(jsonDecode(profileJson));
      setState(() {
        _isFirstTime = false;
        _nameController.text = profile.name;
        _ageController.text = profile.age.toString();
        _heightController.text = profile.height.toString();
        _weightController.text = profile.weight.toString();
        _selectedGender = profile.gender;
        _selectedGoals = List.from(profile.fitnessGoals);
        _selectedDays = List.from(profile.availableWorkoutDays);
        _selectedWorkoutTypes = List.from(profile.preferredWorkoutTypes);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        fitnessGoals: _selectedGoals,
        availableWorkoutDays: _selectedDays,
        preferredWorkoutTypes: _selectedWorkoutTypes,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', jsonEncode(profile.toJson()));

      if (_isFirstTime) {
        Navigator.pushReplacementNamed(context, '/chat-with-trainly');
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isFirstTime ? '👤 Profile Setup' : '👤 Edit Profile'),
        automaticallyImplyLeading: !_isFirstTime,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPersonalInfoPage(),
                  _buildPhysicalInfoPage(),
                  _buildGoalsPage(),
                  _buildAvailabilityPage(),
                  _buildPreferencesPage(),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? OutlinedButton(
                        onPressed: _previousPage,
                        child: Text('Previous'),
                      )
                    : SizedBox(),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage == 4 ? 'Complete Setup' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Tell us about yourself to personalize your experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              hintText: 'Enter your age',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value!);
              if (age == null || age < 13 || age > 100) {
                return 'Please enter a valid age (13-100)';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
            ),
            items: _genderOptions.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfoPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Physical Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Help us calculate better recommendations',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'Enter your height',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your height';
              }
              final height = double.tryParse(value!);
              if (height == null || height < 100 || height > 250) {
                return 'Please enter a valid height (100-250 cm)';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Enter your weight',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your weight';
              }
              final weight = double.tryParse(value!);
              if (weight == null || weight < 30 || weight > 300) {
                return 'Please enter a valid weight (30-300 kg)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitness Goals',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'What do you want to achieve? (Select one or more)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _fitnessGoals.map((goal) {
              final isSelected = _selectedGoals.contains(goal);
              return FilterChip(
                label: Text(goal),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedGoals.add(goal);
                    } else {
                      _selectedGoals.remove(goal);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Schedule',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Which days are you available for workouts?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 24),
          Column(
            children: _workoutDays.map((day) {
              final isSelected = _selectedDays.contains(day);
              return CheckboxListTile(
                title: Text(day),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Preferences',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'What types of workouts do you enjoy?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _workoutTypes.map((type) {
              final isSelected = _selectedWorkoutTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedWorkoutTypes.add(type);
                    } else {
                      _selectedWorkoutTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          if (_isFirstTime)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Great! Once you complete setup, you can start chatting with Trainly to create your personalized workout plan.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
