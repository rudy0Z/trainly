import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BulkPaymentActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onExportSelected;

  const BulkPaymentActionsWidget({
    super.key,
    required this.selectedCount,
    required this.onClearSelection,
    required this.onExportSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedCount payment${selectedCount == 1 ? '' : 's'} selected',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: onExportSelected,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.file_download, size: 16),
                    SizedBox(width: 1.w),
                    const Text('Export'),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              TextButton(
                onPressed: onClearSelection,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
