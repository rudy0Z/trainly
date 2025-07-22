import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TrainerPhotoUploadWidget extends StatefulWidget {
  final Function(String?) onPhotoSelected;

  const TrainerPhotoUploadWidget({
    super.key,
    required this.onPhotoSelected,
  });

  @override
  State<TrainerPhotoUploadWidget> createState() =>
      _TrainerPhotoUploadWidgetState();
}

class _TrainerPhotoUploadWidgetState extends State<TrainerPhotoUploadWidget> {
  String? _selectedPhotoPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.sp),
        Center(
          child: GestureDetector(
            onTap: _selectPhoto,
            child: Container(
              width: 100.sp,
              height: 100.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
              ),
              child: _selectedPhotoPath != null
                  ? ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop&crop=face',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.camera_alt,
                      size: 32.sp,
                      color: Colors.black,
                    ),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Center(
          child: Text(
            _selectedPhotoPath != null
                ? 'Tap to change photo'
                : 'Tap to add photo',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }

  void _selectPhoto() {
    // Simulate photo selection
    setState(() {
      _selectedPhotoPath =
          'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    widget.onPhotoSelected(_selectedPhotoPath);
  }
}
