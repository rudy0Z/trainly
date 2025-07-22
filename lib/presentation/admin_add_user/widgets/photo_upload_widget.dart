import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PhotoUploadWidget extends StatefulWidget {
  final Function(String) onPhotoSelected;

  const PhotoUploadWidget({
    super.key,
    required this.onPhotoSelected,
  });

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
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
              width: 120.sp,
              height: 120.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: _selectedPhotoPath != null
                  ? ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                        fit: BoxFit.cover,
                        width: 120.sp,
                        height: 120.sp,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 32.sp,
                          color: Colors.black,
                        ),
                        SizedBox(height: 8.sp),
                        Text(
                          'Add Photo',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        SizedBox(height: 8.sp),
        Center(
          child: Text(
            'Tap to ${_selectedPhotoPath != null ? 'change' : 'add'} photo',
            style: GoogleFonts.inter(
              fontSize: 12,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Photo',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.sp),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPhotoPath = 'camera_photo.jpg';
                        });
                        widget.onPhotoSelected(_selectedPhotoPath!);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 32.sp,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8.sp),
                            Text(
                              'Camera',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPhotoPath = 'gallery_photo.jpg';
                        });
                        widget.onPhotoSelected(_selectedPhotoPath!);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 32.sp,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8.sp),
                            Text(
                              'Gallery',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
