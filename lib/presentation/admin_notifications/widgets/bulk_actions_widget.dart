import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;
  final VoidCallback onBulkDelete;
  final VoidCallback onBulkSend;

  const BulkActionsWidget({
    super.key,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onBulkDelete,
    required this.onBulkSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Column(
        children: [
          // Selection Summary
          Row(
            children: [
              Text(
                '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSelectAll,
                child: Text(
                  'Select All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(width: 16.sp),
              GestureDetector(
                onTap: onClearSelection,
                child: Text(
                  'Clear',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          // Action Buttons
          Row(
            children: [
              // Send Button
              Expanded(
                child: GestureDetector(
                  onTap: onBulkSend,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          'Send',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.sp),
              // Delete Button
              Expanded(
                child: GestureDetector(
                  onTap: onBulkDelete,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          size: 18.sp,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          'Delete',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
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
  }
}
