import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ClassDetailsModal extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassDetailsModal({
    super.key,
    required this.classData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Class Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Class Info
            Text(
              classData['name'] ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              classData['description'] ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 3.h),
            // Details Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructor
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(
                                  classData['instructorImage'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instructor',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10.sp,
                              ),
                            ),
                            Text(
                              classData['instructor'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Class Details
                    _buildDetailRow('Time', classData['time'] ?? ''),
                    _buildDetailRow('Duration', classData['duration'] ?? ''),
                    _buildDetailRow('Location', classData['location'] ?? ''),
                    _buildDetailRow('Category', classData['category'] ?? ''),
                    _buildDetailRow(
                        'Difficulty', classData['difficulty'] ?? ''),
                    _buildDetailRow('Price', '\$${classData['price'] ?? ''}'),
                    _buildDetailRow(
                        'Capacity', '${classData['capacity'] ?? ''}'),
                    _buildDetailRow(
                        'Enrolled', '${classData['enrolled'] ?? ''}'),
                    _buildDetailRow(
                        'Waitlist', '${classData['waitlist'] ?? ''}'),
                    SizedBox(height: 2.h),
                    // Equipment
                    Text(
                      'Equipment Required',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(classData['equipment'] as List<String>)
                        .map((equipment) => Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Text(
                                '• $equipment',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            )),
                    SizedBox(height: 3.h),
                    // Member Management
                    Text(
                      'Member Management',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // View members functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'View Members',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Manage waitlist functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Waitlist',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
