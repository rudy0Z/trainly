import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/emergency_contact_widget.dart';
import './widgets/membership_plan_selector_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/user_form_widget.dart';

class AdminAddUser extends StatefulWidget {
  const AdminAddUser({super.key});

  @override
  State<AdminAddUser> createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _generatedMemberId;

  // Form Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _emergencyRelationController =
      TextEditingController();

  // Form Data
  DateTime? _dateOfBirth;
  String? _gender;
  String? _selectedMembershipPlan;
  String? _paymentMethod;
  String? _profilePhotoPath;
  bool _hasHealthConditions = false;
  final TextEditingController _healthConditionsController =
      TextEditingController();

  final List<String> _membershipPlans = [
    'Basic Monthly - \$29.99',
    'Premium Monthly - \$49.99',
    'Elite Monthly - \$79.99',
    'Basic Annual - \$299.99',
    'Premium Annual - \$499.99',
    'Elite Annual - \$799.99',
  ];

  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'PayPal',
    'Cash',
  ];

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Add New Member',
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
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 4,
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
                'Step ${_currentStep + 1} of 4',
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
                _buildMembershipStep(),
                _buildEmergencyContactStep(),
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
              // Next/Create Button
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
                            _currentStep == 3 ? 'Create Member' : 'Next',
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
          PhotoUploadWidget(
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
                child: UserFormWidget(
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
                child: UserFormWidget(
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
          UserFormWidget(
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
          UserFormWidget(
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
          UserFormWidget(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: 16.sp),
          // Health Conditions
          Row(
            children: [
              Checkbox(
                value: _hasHealthConditions,
                onChanged: (value) {
                  setState(() {
                    _hasHealthConditions = value ?? false;
                  });
                },
                activeColor: Colors.black,
                checkColor: Colors.white,
              ),
              Expanded(
                child: Text(
                  'I have health conditions to declare',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          if (_hasHealthConditions) ...[
            SizedBox(height: 12.sp),
            UserFormWidget(
              label: 'Health Conditions',
              controller: _healthConditionsController,
              maxLines: 3,
              validator: (value) {
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembershipStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Membership Details',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Membership Plan Selector
          MembershipPlanSelectorWidget(
            plans: _membershipPlans,
            selectedPlan: _selectedMembershipPlan,
            onPlanSelected: (plan) {
              setState(() {
                _selectedMembershipPlan = plan;
              });
            },
          ),
          SizedBox(height: 24.sp),
          // Payment Method
          Text(
            'Payment Method',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.sp),
          ..._paymentMethods.map((method) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _paymentMethod = method;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8.sp),
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: _paymentMethod == method
                      ? const Color(0xFFF5F5F5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _paymentMethod == method
                        ? Colors.black
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.sp,
                      height: 20.sp,
                      decoration: BoxDecoration(
                        color: _paymentMethod == method
                            ? Colors.black
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: _paymentMethod == method
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14.sp,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.sp),
                    Text(
                      method,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Emergency Contact',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.sp),
          // Emergency Contact Widget
          EmergencyContactWidget(
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
              if (_addressController.text.isNotEmpty)
                'Address: ${_addressController.text}',
            ],
          ),
          SizedBox(height: 16.sp),
          _buildReviewCard(
            'Membership Details',
            [
              if (_selectedMembershipPlan != null)
                'Plan: $_selectedMembershipPlan',
              if (_paymentMethod != null) 'Payment Method: $_paymentMethod',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 24.sp),
          Text(
            'Member Created Successfully!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.sp),
          if (_generatedMemberId != null) ...[
            Text(
              'Member ID: $_generatedMemberId',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
            SizedBox(height: 24.sp),
          ],
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
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
        return 'Membership';
      case 2:
        return 'Emergency Contact';
      case 3:
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
            _dateOfBirth != null;
      case 1:
        return _selectedMembershipPlan != null && _paymentMethod != null;
      case 2:
        return true; // Emergency contact is optional
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
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
      _createMember();
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

  void _createMember() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _generatedMemberId = 'MEM${DateTime.now().millisecondsSinceEpoch}';
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
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _healthConditionsController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
