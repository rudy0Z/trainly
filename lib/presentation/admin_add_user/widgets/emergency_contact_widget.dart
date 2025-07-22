import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './user_form_widget.dart';

class EmergencyContactWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController relationController;

  const EmergencyContactWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.relationController,
  });

  @override
  Widget build(BuildContext context) {
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
            'Emergency Contact Information',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            'This information will be used in case of emergency',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 16.sp),
          UserFormWidget(
            label: 'Contact Name',
            controller: nameController,
            hintText: 'Enter emergency contact name',
            validator: (value) {
              return null; // Optional field
            },
          ),
          SizedBox(height: 16.sp),
          UserFormWidget(
            label: 'Contact Phone',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            hintText: 'Enter emergency contact phone',
            validator: (value) {
              return null; // Optional field
            },
          ),
          SizedBox(height: 16.sp),
          UserFormWidget(
            label: 'Relationship',
            controller: relationController,
            hintText: 'e.g., Parent, Spouse, Friend',
            validator: (value) {
              return null; // Optional field
            },
          ),
        ],
      ),
    );
  }
}
