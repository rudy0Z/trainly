import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/login_redirect_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/social_registration_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String _selectedCountryCode = '+1';

  // Validation states
  String? _fullNameError;
  String? _emailError;
  String? _mobileError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    _fullNameController.addListener(() => _validateFullName());
    _emailController.addListener(() => _validateEmail());
    _mobileController.addListener(() => _validateMobile());
    _passwordController.addListener(() {
      _validatePassword();
      _calculatePasswordStrength();
    });
    _confirmPasswordController.addListener(() => _validateConfirmPassword());
  }

  void _validateFullName() {
    setState(() {
      if (_fullNameController.text.isEmpty) {
        _fullNameError = 'Full name is required';
      } else if (_fullNameController.text.length < 2) {
        _fullNameError = 'Name must be at least 2 characters';
      } else {
        _fullNameError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      final email = _emailController.text;
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validateMobile() {
    setState(() {
      final mobile = _mobileController.text;
      if (mobile.isEmpty) {
        _mobileError = 'Mobile number is required';
      } else if (mobile.length < 10) {
        _mobileError = 'Please enter a valid mobile number';
      } else {
        _mobileError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      final confirmPassword = _confirmPasswordController.text;
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (confirmPassword != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _calculatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;

    if (password.length >= 8) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    setState(() {
      _passwordStrength = strength;
      if (strength <= 0.2) {
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = AppTheme.lightTheme.colorScheme.error;
      } else if (strength <= 0.6) {
        _passwordStrengthText = 'Medium';
        _passwordStrengthColor = AppTheme.getWarningColor(true);
      } else {
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = AppTheme.getSuccessColor(true);
      }
    });
  }

  bool _isFormValid() {
    return _fullNameError == null &&
        _emailError == null &&
        _mobileError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _acceptTerms;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate different error scenarios
      final email = _emailController.text.toLowerCase();
      if (email == 'test@duplicate.com') {
        throw Exception('An account with this email already exists');
      }

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to OTP verification (simulated)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Registration successful! OTP sent to ${_selectedCountryCode}${_mobileController.text}'),
            backgroundColor: AppTheme.getSuccessColor(true),
          ),
        );

        // Navigate to login screen for demo
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCountryCodePicker() {
    final List<Map<String, String>> countryCodes = [
      {'code': '+1', 'country': 'United States'},
      {'code': '+44', 'country': 'United Kingdom'},
      {'code': '+91', 'country': 'India'},
      {'code': '+86', 'country': 'China'},
      {'code': '+49', 'country': 'Germany'},
      {'code': '+33', 'country': 'France'},
      {'code': '+81', 'country': 'Japan'},
      {'code': '+61', 'country': 'Australia'},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Country Code',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: countryCodes.length,
                itemBuilder: (context, index) {
                  final country = countryCodes[index];
                  return ListTile(
                    title: Text('${country['country']} (${country['code']})'),
                    onTap: () {
                      setState(() {
                        _selectedCountryCode = country['code']!;
                      });
                      Navigator.pop(context);
                    },
                    trailing: _selectedCountryCode == country['code']
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTermsAndPrivacy(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type == 'terms' ? 'Terms of Service' : 'Privacy Policy'),
        content: SizedBox(
          width: 80.w,
          height: 40.h,
          child: SingleChildScrollView(
            child: Text(
              type == 'terms'
                  ? 'Terms of Service content would be displayed here...'
                  : 'Privacy Policy content would be displayed here...',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),

                // Gym Logo
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomIconWidget(
                    iconName: 'fitness_center',
                    color: Colors.white,
                    size: 10.w,
                  ),
                ),

                SizedBox(height: 3.h),

                // Create Account Headline
                Text(
                  'Create Account',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'Join our fitness community today',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 4.h),

                // Registration Form
                RegistrationFormWidget(
                  formKey: _formKey,
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  mobileController: _mobileController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  fullNameFocus: _fullNameFocus,
                  emailFocus: _emailFocus,
                  mobileFocus: _mobileFocus,
                  passwordFocus: _passwordFocus,
                  confirmPasswordFocus: _confirmPasswordFocus,
                  isPasswordVisible: _isPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,
                  selectedCountryCode: _selectedCountryCode,
                  fullNameError: _fullNameError,
                  emailError: _emailError,
                  mobileError: _mobileError,
                  passwordError: _passwordError,
                  confirmPasswordError: _confirmPasswordError,
                  passwordStrength: _passwordStrength,
                  passwordStrengthText: _passwordStrengthText,
                  passwordStrengthColor: _passwordStrengthColor,
                  onPasswordVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onConfirmPasswordVisibilityToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  onCountryCodeTap: _showCountryCodePicker,
                ),

                SizedBox(height: 3.h),

                // Terms and Privacy Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.w),
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              children: [
                                TextSpan(text: 'I agree to the '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => _openTermsAndPrivacy('terms'),
                                    child: Text(
                                      'Terms of Service',
                                      style: TextStyle(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _openTermsAndPrivacy('privacy'),
                                    child: Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isFormValid() && !_isLoading
                        ? _handleRegistration
                        : null,
                    child: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Create Account'),
                  ),
                ),

                SizedBox(height: 3.h),

                // Social Registration
                SocialRegistrationWidget(
                  onGoogleSignUp: () async {
                    // Simulate Google sign up
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Google sign up not implemented in demo')),
                    );
                  },
                  onAppleSignUp: () async {
                    // Simulate Apple sign up
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Apple sign up not implemented in demo')),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // Login Redirect
                LoginRedirectWidget(
                  onLoginTap: () {
                    Navigator.pushReplacementNamed(context, '/login-screen');
                  },
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
