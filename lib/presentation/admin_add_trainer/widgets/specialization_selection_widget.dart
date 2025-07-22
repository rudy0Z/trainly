import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SpecializationSelectionWidget extends StatefulWidget {
  final List<String> specializations;
  final List<String> selectedSpecializations;
  final Function(List<String>) onSpecializationChanged;

  const SpecializationSelectionWidget({
    super.key,
    required this.specializations,
    required this.selectedSpecializations,
    required this.onSpecializationChanged,
  });

  @override
  State<SpecializationSelectionWidget> createState() =>
      _SpecializationSelectionWidgetState();
}

class _SpecializationSelectionWidgetState
    extends State<SpecializationSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select your areas of expertise (minimum 1 required)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 16.sp),
        Wrap(
          spacing: 8.sp,
          runSpacing: 8.sp,
          children: widget.specializations.map((specialization) {
            final isSelected =
                widget.selectedSpecializations.contains(specialization);
            return GestureDetector(
              onTap: () => _toggleSpecialization(specialization),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
                  ),
                ),
                child: Text(
                  specialization,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.sp),
        if (widget.selectedSpecializations.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Specializations (${widget.selectedSpecializations.length})',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.sp),
                ...widget.selectedSpecializations
                    .map((spec) => Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: Row(
                            children: [
                              Container(
                                width: 4.sp,
                                height: 4.sp,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8.sp),
                              Text(
                                spec,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _toggleSpecialization(String specialization) {
    final updatedSpecializations =
        List<String>.from(widget.selectedSpecializations);

    if (updatedSpecializations.contains(specialization)) {
      updatedSpecializations.remove(specialization);
    } else {
      updatedSpecializations.add(specialization);
    }

    widget.onSpecializationChanged(updatedSpecializations);
  }
}
