import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrainerDetailsModal extends StatelessWidget {
  final Map<String, dynamic> trainer;

  const TrainerDetailsModal({
    super.key,
    required this.trainer,
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
                  'Trainer Details',
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
            // Profile Section
            Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(trainer['profileImage'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer['name'] ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        trainer['email'] ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            color: Colors.black,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${trainer['rating']} (${trainer['totalReviews']} reviews)',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Details Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Experience', trainer['experience'] ?? ''),
                    _buildDetailRow('Phone', trainer['phone'] ?? ''),
                    _buildDetailRow('Join Date', trainer['joinDate'] ?? ''),
                    _buildDetailRow('Total Classes',
                        trainer['totalClasses']?.toString() ?? ''),
                    _buildDetailRow('Total Members',
                        trainer['totalMembers']?.toString() ?? ''),
                    _buildDetailRow('Status', trainer['status'] ?? ''),
                    SizedBox(height: 2.h),
                    // Specializations
                    Text(
                      'Specializations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (trainer['specialization'] as List<String>)
                          .map((spec) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  spec,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                    // Certifications
                    Text(
                      'Certifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(trainer['certifications'] as List<String>)
                        .map((cert) => Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Text(
                                '• $cert',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            )),
                    SizedBox(height: 2.h),
                    // Bio
                    Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      trainer['bio'] ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
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
            width: 30.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
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
