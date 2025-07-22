import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TrainerEmergencyContactWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController relationController;

  const TrainerEmergencyContactWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.relationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency contact information (optional)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 16.sp),
        // Emergency Contact Name
        _buildFormField(
          label: 'Full Name',
          controller: nameController,
          hint: 'Enter emergency contact name',
        ),
        SizedBox(height: 16.sp),
        // Emergency Contact Phone
        _buildFormField(
          label: 'Phone Number',
          controller: phoneController,
          hint: 'Enter emergency contact phone',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.sp),
        // Relationship
        _buildFormField(
          label: 'Relationship',
          controller: relationController,
          hint: 'e.g., Spouse, Parent, Sibling',
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
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
        SizedBox(height: 8.sp),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.all(12.sp),
          ),
        ),
      ],
    );
  }
}
