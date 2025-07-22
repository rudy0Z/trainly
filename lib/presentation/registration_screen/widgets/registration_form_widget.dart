import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fullNameFocus;
  final FocusNode emailFocus;
  final FocusNode mobileFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String selectedCountryCode;
  final String? fullNameError;
  final String? emailError;
  final String? mobileError;
  final String? passwordError;
  final String? confirmPasswordError;
  final double passwordStrength;
  final String passwordStrengthText;
  final Color passwordStrengthColor;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final VoidCallback onCountryCodeTap;

  const RegistrationFormWidget({
    Key? key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocus,
    required this.emailFocus,
    required this.mobileFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.selectedCountryCode,
    this.fullNameError,
    this.emailError,
    this.mobileError,
    this.passwordError,
    this.confirmPasswordError,
    required this.passwordStrength,
    required this.passwordStrengthText,
    required this.passwordStrengthColor,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.onCountryCodeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          _buildInputField(
            controller: fullNameController,
            focusNode: fullNameFocus,
            nextFocusNode: emailFocus,
            label: 'Full Name',
            hintText: 'Enter your full name',
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            prefixIcon: 'person',
            errorText: fullNameError,
          ),

          SizedBox(height: 2.h),

          // Email Field
          _buildInputField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocusNode: mobileFocus,
            label: 'Email Address',
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: 'email',
            errorText: emailError,
          ),

          SizedBox(height: 2.h),

          // Mobile Number Field
          _buildMobileField(),

          SizedBox(height: 2.h),

          // Password Field
          _buildPasswordField(),

          SizedBox(height: 2.h),

          // Confirm Password Field
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    required String prefixIcon,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: prefixIcon,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: suffixIcon,
            errorText: null, // Handle error separately
          ),
          onFieldSubmitted: (value) {
            if (nextFocusNode != null) {
              FocusScope.of(focusNode.context!).requestFocus(nextFocusNode);
            }
          },
        ),
        if (errorText != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            errorText,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Country Code Selector
            GestureDetector(
              onTap: onCountryCodeTap,
              child: Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCountryCode,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Mobile Number Input
            Expanded(
              child: TextFormField(
                controller: mobileController,
                focusNode: mobileFocus,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
                onFieldSubmitted: (value) {
                  FocusScope.of(mobileFocus.context!)
                      .requestFocus(passwordFocus);
                },
              ),
            ),
          ],
        ),
        if (mobileError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            mobileError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: passwordController,
          focusNode: passwordFocus,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onPasswordVisibilityToggle,
              icon: CustomIconWidget(
                iconName: isPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          onFieldSubmitted: (value) {
            FocusScope.of(passwordFocus.context!)
                .requestFocus(confirmPasswordFocus);
          },
        ),

        // Password Strength Indicator
        if (passwordController.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: passwordStrength,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(passwordStrengthColor),
                  minHeight: 0.5.h,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                passwordStrengthText,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: passwordStrengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],

        if (passwordError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            passwordError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocus,
          obscureText: !isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onConfirmPasswordVisibilityToggle,
              icon: CustomIconWidget(
                iconName:
                    isConfirmPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
        ),
        if (confirmPasswordError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            confirmPasswordError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
