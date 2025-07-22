import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/availability_scheduling_widget.dart';
import './widgets/certification_management_widget.dart';
import './widgets/rate_setting_widget.dart';
import './widgets/specialization_selection_widget.dart';
import './widgets/trainer_emergency_contact_widget.dart';
import './widgets/trainer_form_widget.dart';
import './widgets/trainer_photo_upload_widget.dart';

class AdminAddTrainer extends StatefulWidget {
  const AdminAddTrainer({super.key});

  @override
  State<AdminAddTrainer> createState() => _AdminAddTrainerState();
}

class _AdminAddTrainerState extends State<AdminAddTrainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _generatedTrainerId;

  // Form Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _emergencyRelationController =
      TextEditingController();

  // Form Data
  DateTime? _dateOfBirth;
  String? _gender;
  String? _profilePhotoPath;
  List<Map<String, dynamic>> _certificates = [];
  List<String> _selectedSpecializations = [];
  Map<String, List<TimeSlot>> _availability = {};
  double _hourlyRate = 0.0;
  double _sessionRate = 0.0;
  double _monthlyRate = 0.0;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  final List<String> _specializationOptions = [
    'Personal Training',
    'Group Fitness',
    'Yoga',
    'Pilates',
    'CrossFit',
    'Cardio Training',
    'Strength Training',
    'Nutrition Coaching',
    'Rehabilitation',
    'Sports Performance',
    'Weight Loss',
    'Flexibility Training',
    'Functional Training',
    'Boxing',
    'Dance Fitness',
    'Martial Arts',
    'Swimming',
    'Cycling',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Add New Trainer',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.sp),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Row(
              children: List.generate(6, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 5 ? 4.sp : 0),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? Colors.black
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: _isSuccess ? _buildSuccessScreen() : _buildFormScreen(),
    );
  }

  Widget _buildFormScreen() {
    return Column(
      children: [
        // Progress Header
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Step ${_currentStep + 1} of 6',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              const Spacer(),
              Text(
                _getStepTitle(_currentStep),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        // Form Content
        Expanded(
          child: Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildPersonalInfoStep(),
                _buildCertificationStep(),
                _buildSpecializationStep(),
                _buildAvailabilityStep(),
                _buildRateSettingStep(),
                _buildReviewStep(),
              ],
            ),
          ),
        ),
        // Action Buttons
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          child: Row(
            children: [
              // Previous Button
              if (_currentStep > 0)
                Expanded(
                  child: GestureDetector(
                    onTap: _previousStep,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        'Previous',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (_currentStep > 0) SizedBox(width: 12.sp),
              // Next/Save Button
              Expanded(
                flex: _currentStep == 0 ? 1 : 1,
                child: GestureDetector(
                  onTap: _isLoading ? null : _nextStep,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.sp),
                    decoration: BoxDecoration(
                      color: _canProceed()
                          ? Colors.black
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20.sp,
                            width: 20.sp,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == 5 ? 'Save Trainer' : 'Next',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _canProceed()
                                  ? Colors.white
                                  : const Color(0xFF666666),
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Personal Information',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Photo Upload
          TrainerPhotoUploadWidget(
            onPhotoSelected: (path) {
              setState(() {
                _profilePhotoPath = path;
              });
            },
          ),
          SizedBox(height: 24.sp),
          // Name Fields
          Row(
            children: [
              Expanded(
                child: TrainerFormWidget(
                  label: 'First Name',
                  controller: _firstNameController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: TrainerFormWidget(
                  label: 'Last Name',
                  controller: _lastNameController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          // Email
          TrainerFormWidget(
            label: 'Email Address',
            controller: _emailController,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.sp),
          // Phone
          TrainerFormWidget(
            label: 'Phone Number',
            controller: _phoneController,
            isRequired: true,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.sp),
          // Date of Birth
          GestureDetector(
            onTap: _selectDateOfBirth,
            child: Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date of Birth *',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          _dateOfBirth != null
                              ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                              : 'Select date of birth',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: _dateOfBirth != null
                                ? Colors.black
                                : const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          // Gender
          _buildDropdownField(
            label: 'Gender',
            value: _gender,
            items: _genderOptions,
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          SizedBox(height: 16.sp),
          // Address
          TrainerFormWidget(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: 16.sp),
          // Years of Experience
          TrainerFormWidget(
            label: 'Years of Experience',
            controller: _experienceController,
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Experience is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.sp),
          // Bio
          TrainerFormWidget(
            label: 'Professional Bio',
            controller: _bioController,
            maxLines: 5,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: 8.sp),
          // Character count
          Text(
            '${_bioController.text.length}/500',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Certifications',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Certification Management
          CertificationManagementWidget(
            certificates: _certificates,
            onCertificatesChanged: (certificates) {
              setState(() {
                _certificates = certificates;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Specializations',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Specialization Selection
          SpecializationSelectionWidget(
            specializations: _specializationOptions,
            selectedSpecializations: _selectedSpecializations,
            onSpecializationChanged: (specializations) {
              setState(() {
                _selectedSpecializations = specializations;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Availability',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Availability Scheduling
          AvailabilitySchedulingWidget(
            availability: _availability,
            onAvailabilityChanged: (availability) {
              setState(() {
                _availability = availability;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRateSettingStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Rate Setting',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Rate Setting
          RateSettingWidget(
            hourlyRate: _hourlyRate,
            sessionRate: _sessionRate,
            monthlyRate: _monthlyRate,
            onRateChanged: (hourly, session, monthly) {
              setState(() {
                _hourlyRate = hourly;
                _sessionRate = session;
                _monthlyRate = monthly;
              });
            },
          ),
          SizedBox(height: 24.sp),
          // Emergency Contact
          Text(
            'Emergency Contact',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          TrainerEmergencyContactWidget(
            nameController: _emergencyNameController,
            phoneController: _emergencyPhoneController,
            relationController: _emergencyRelationController,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Review & Confirm',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Review Cards
          _buildReviewCard(
            'Personal Information',
            [
              'Name: ${_firstNameController.text} ${_lastNameController.text}',
              'Email: ${_emailController.text}',
              'Phone: ${_phoneController.text}',
              if (_dateOfBirth != null)
                'Date of Birth: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              if (_gender != null) 'Gender: $_gender',
              if (_experienceController.text.isNotEmpty)
                'Experience: ${_experienceController.text} years',
            ],
          ),
          SizedBox(height: 16.sp),
          _buildReviewCard(
            'Certifications',
            _certificates.isNotEmpty
                ? _certificates.map((cert) => '• ${cert['name']}').toList()
                : ['No certifications added'],
          ),
          SizedBox(height: 16.sp),
          _buildReviewCard(
            'Specializations',
            _selectedSpecializations.isNotEmpty
                ? _selectedSpecializations.map((spec) => '• $spec').toList()
                : ['No specializations selected'],
          ),
          SizedBox(height: 16.sp),
          _buildReviewCard(
            'Rates',
            [
              if (_hourlyRate > 0)
                'Hourly Rate: \$${_hourlyRate.toStringAsFixed(2)}',
              if (_sessionRate > 0)
                'Session Rate: \$${_sessionRate.toStringAsFixed(2)}',
              if (_monthlyRate > 0)
                'Monthly Rate: \$${_monthlyRate.toStringAsFixed(2)}',
            ],
          ),
          SizedBox(height: 16.sp),
          _buildReviewCard(
            'Emergency Contact',
            [
              if (_emergencyNameController.text.isNotEmpty)
                'Name: ${_emergencyNameController.text}',
              if (_emergencyPhoneController.text.isNotEmpty)
                'Phone: ${_emergencyPhoneController.text}',
              if (_emergencyRelationController.text.isNotEmpty)
                'Relation: ${_emergencyRelationController.text}',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, List<String> details) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.sp),
          ...details
              .map((detail) => Padding(
                    padding: EdgeInsets.only(bottom: 4.sp),
                    child: Text(
                      detail,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.sp,
              height: 80.sp,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 24.sp),
            Text(
              'Trainer Created Successfully!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.sp),
            if (_generatedTrainerId != null) ...[
              Text(
                'Trainer ID: $_generatedTrainerId',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.sp),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
              ),
              child: Text(
                'Back to Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.sp),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            hint: Text(
              'Select $label',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Personal Info';
      case 1:
        return 'Certifications';
      case 2:
        return 'Specializations';
      case 3:
        return 'Availability';
      case 4:
        return 'Rates & Emergency';
      case 5:
        return 'Review';
      default:
        return '';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _dateOfBirth != null &&
            _experienceController.text.isNotEmpty;
      case 1:
        return true; // Certifications are optional
      case 2:
        return _selectedSpecializations.isNotEmpty;
      case 3:
        return _availability.isNotEmpty;
      case 4:
        return _hourlyRate > 0 || _sessionRate > 0 || _monthlyRate > 0;
      case 5:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 5) {
      if (_formKey.currentState!.validate() && _canProceed()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _createTrainer();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createTrainer() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _generatedTrainerId = 'TRN${DateTime.now().millisecondsSinceEpoch}';
      });
    });
  }

  void _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate:
          DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });
}
