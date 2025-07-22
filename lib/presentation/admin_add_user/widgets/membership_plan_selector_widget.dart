import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MembershipPlanSelectorWidget extends StatelessWidget {
  final List<String> plans;
  final String? selectedPlan;
  final Function(String) onPlanSelected;

  const MembershipPlanSelectorWidget({
    super.key,
    required this.plans,
    this.selectedPlan,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Membership Plan',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.sp),
        ...plans.map((plan) {
          final isSelected = selectedPlan == plan;
          final isEvenIndex = plans.indexOf(plan) % 2 == 0;
          final backgroundColor = isSelected
              ? Colors.black
              : isEvenIndex
                  ? Colors.white
                  : const Color(0xFFF5F5F5);

          return GestureDetector(
            onTap: () => onPlanSelected(plan),
            child: Container(
              margin: EdgeInsets.only(bottom: 8.sp),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Plan Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPlanName(plan),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          _getPlanPrice(plan),
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          _getPlanDescription(plan),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  // Selection Indicator
                  Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.black,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 16.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _getPlanName(String plan) {
    return plan.split(' - ')[0];
  }

  String _getPlanPrice(String plan) {
    return plan.split(' - ')[1];
  }

  String _getPlanDescription(String plan) {
    final name = _getPlanName(plan).toLowerCase();
    if (name.contains('basic')) {
      return 'Access to gym equipment and basic facilities';
    } else if (name.contains('premium')) {
      return 'Includes group classes and personal training sessions';
    } else if (name.contains('elite')) {
      return 'All-inclusive with premium amenities and services';
    }
    return 'Membership plan with various benefits';
  }
}
