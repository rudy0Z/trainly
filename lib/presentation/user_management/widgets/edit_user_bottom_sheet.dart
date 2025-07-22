import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditUserBottomSheet extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onUserUpdated;

  const EditUserBottomSheet({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<EditUserBottomSheet> createState() => _EditUserBottomSheetState();
}

class _EditUserBottomSheetState extends State<EditUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyContactController;

  // Form values
  late String _selectedGender;
  late String _selectedMembershipPlan;
  late String _selectedMembershipStatus;
  late String _selectedPaymentStatus;
  late String _selectedTrainer;
  late String _selectedActivityLevel;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _membershipPlans = ['Basic', 'Standard', 'Premium'];
  final List<String> _membershipStatuses = ['Active', 'Expired', 'Suspended'];
  final List<String> _paymentStatuses = ['Paid', 'Overdue', 'Pending'];
  final List<String> _trainers = [
    'None',
    'Mike Johnson',
    'Lisa Chen',
    'Alex Rodriguez'
  ];
  final List<String> _activityLevels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
    _phoneController = TextEditingController(text: widget.user['phone']);
    _ageController = TextEditingController(text: widget.user['age'].toString());
    _addressController = TextEditingController(text: widget.user['address']);
    _emergencyContactController =
        TextEditingController(text: widget.user['emergencyContact']);

    _selectedGender = widget.user['gender'];
    _selectedMembershipPlan = widget.user['membershipPlan'];
    _selectedMembershipStatus = widget.user['membershipStatus'];
    _selectedPaymentStatus = widget.user['paymentStatus'];
    _selectedTrainer = widget.user['trainerAssigned'];
    _selectedActivityLevel = widget.user['activityLevel'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_validatePersonalDetails()) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitForm();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validatePersonalDetails() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter a name');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter an email');
      return false;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      _showError('Please enter a valid email');
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter a phone number');
      return false;
    }
    if (_ageController.text.trim().isEmpty) {
      _showError('Please enter an age');
      return false;
    }
    int? age = int.tryParse(_ageController.text.trim());
    if (age == null || age < 16 || age > 100) {
      _showError('Please enter a valid age (16-100)');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _submitForm() {
    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter an address');
      return;
    }

    Map<String, dynamic> updatedUser = Map.from(widget.user);
    updatedUser.addAll({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'age': int.parse(_ageController.text.trim()),
      'gender': _selectedGender,
      'address': _addressController.text.trim(),
      'membershipPlan': _selectedMembershipPlan,
      'membershipStatus': _selectedMembershipStatus,
      'emergencyContact': _emergencyContactController.text.trim(),
      'paymentStatus': _selectedPaymentStatus,
      'trainerAssigned': _selectedTrainer,
      'activityLevel': _selectedActivityLevel,
    });

    // Update expiry date if plan changed
    if (_selectedMembershipPlan != widget.user['membershipPlan']) {
      updatedUser['membershipExpiry'] = _calculateExpiryDate();
    }

    widget.onUserUpdated(updatedUser);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User updated successfully'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  String _calculateExpiryDate() {
    DateTime now = DateTime.now();
    int months = _selectedMembershipPlan == 'Basic'
        ? 1
        : _selectedMembershipPlan == 'Standard'
            ? 6
            : 12;
    DateTime expiry = DateTime(now.year, now.month + months, now.day);
    return '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withAlpha(77),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                if (_currentPage > 0)
                  IconButton(
                    onPressed: _previousPage,
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                Expanded(
                  child: Text(
                    'Edit User',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign:
                        _currentPage > 0 ? TextAlign.center : TextAlign.left,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Progress Indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 2,
              backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withAlpha(51),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary),
            ),
          ),

          Divider(height: 1),

          // Form Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPersonalDetailsPage(),
                _buildMembershipDetailsPage(),
              ],
            ),
          ),

          // Action Buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == 0 ? 'Next' : 'Update User',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter full name',
              icon: 'person',
              required: true,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: 'email',
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter phone number',
              icon: 'phone',
              keyboardType: TextInputType.phone,
              required: true,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    hint: 'Age',
                    icon: 'cake',
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Gender',
                    value: _selectedGender,
                    items: _genders,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipDetailsPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Membership & Additional Details',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter full address',
            icon: 'location_on',
            maxLines: 2,
            required: true,
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _emergencyContactController,
            label: 'Emergency Contact',
            hint: 'Name - Phone Number',
            icon: 'contact_emergency',
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Membership Plan',
                  value: _selectedMembershipPlan,
                  items: _membershipPlans,
                  onChanged: (value) {
                    setState(() {
                      _selectedMembershipPlan = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDropdownField(
                  label: 'Status',
                  value: _selectedMembershipStatus,
                  items: _membershipStatuses,
                  onChanged: (value) {
                    setState(() {
                      _selectedMembershipStatus = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Payment Status',
                  value: _selectedPaymentStatus,
                  items: _paymentStatuses,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentStatus = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDropdownField(
                  label: 'Activity Level',
                  value: _selectedActivityLevel,
                  items: _activityLevels,
                  onChanged: (value) {
                    setState(() {
                      _selectedActivityLevel = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildDropdownField(
            label: 'Assigned Trainer',
            value: _selectedTrainer,
            items: _trainers,
            onChanged: (value) {
              setState(() {
                _selectedTrainer = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.error),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
