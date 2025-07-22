import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RateSettingWidget extends StatefulWidget {
  final double hourlyRate;
  final double sessionRate;
  final double monthlyRate;
  final Function(double, double, double) onRateChanged;

  const RateSettingWidget({
    super.key,
    required this.hourlyRate,
    required this.sessionRate,
    required this.monthlyRate,
    required this.onRateChanged,
  });

  @override
  State<RateSettingWidget> createState() => _RateSettingWidgetState();
}

class _RateSettingWidgetState extends State<RateSettingWidget> {
  final TextEditingController _hourlyController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _monthlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hourlyController.text =
        widget.hourlyRate > 0 ? widget.hourlyRate.toStringAsFixed(2) : '';
    _sessionController.text =
        widget.sessionRate > 0 ? widget.sessionRate.toStringAsFixed(2) : '';
    _monthlyController.text =
        widget.monthlyRate > 0 ? widget.monthlyRate.toStringAsFixed(2) : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set your training rates (at least one rate is required)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 16.sp),
        // Hourly Rate
        _buildRateField(
          label: 'Hourly Rate',
          controller: _hourlyController,
          description: 'Rate per hour of training',
          onChanged: (value) {
            final rate = double.tryParse(value) ?? 0.0;
            widget.onRateChanged(rate, widget.sessionRate, widget.monthlyRate);
          },
        ),
        SizedBox(height: 16.sp),
        // Session Rate
        _buildRateField(
          label: 'Session Rate',
          controller: _sessionController,
          description: 'Rate per training session (typically 45-60 minutes)',
          onChanged: (value) {
            final rate = double.tryParse(value) ?? 0.0;
            widget.onRateChanged(widget.hourlyRate, rate, widget.monthlyRate);
          },
        ),
        SizedBox(height: 16.sp),
        // Monthly Rate
        _buildRateField(
          label: 'Monthly Rate',
          controller: _monthlyController,
          description: 'Monthly package rate for unlimited training',
          onChanged: (value) {
            final rate = double.tryParse(value) ?? 0.0;
            widget.onRateChanged(widget.hourlyRate, widget.sessionRate, rate);
          },
        ),
        SizedBox(height: 16.sp),
        // Rate Guidelines
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
                'Rate Guidelines',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.sp),
              _buildGuideline('Hourly rates typically range from \$25-\$100'),
              _buildGuideline(
                  'Session rates are usually 80-90% of hourly rate'),
              _buildGuideline('Monthly rates should offer 15-20% discount'),
              _buildGuideline('Consider your experience and specializations'),
            ],
          ),
        ),
        SizedBox(height: 16.sp),
        // Rate Validation
        if (_hasValidationErrors()) ...[
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      'Rate Validation',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.sp),
                ...getValidationErrors()
                    .map((error) => Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: Text(
                            '• $error',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.red.shade700,
                            ),
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

  Widget _buildRateField({
    required String label,
    required TextEditingController controller,
    required String description,
    required Function(String) onChanged,
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '0.00',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(12.sp),
              child: Text(
                '\$',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
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
          onChanged: onChanged,
        ),
        SizedBox(height: 4.sp),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.sp,
            height: 4.sp,
            margin: EdgeInsets.only(top: 6.sp, right: 8.sp),
            decoration: const BoxDecoration(
              color: Color(0xFF666666),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasValidationErrors() {
    return getValidationErrors().isNotEmpty;
  }

  List<String> getValidationErrors() {
    final errors = <String>[];

    if (widget.hourlyRate <= 0 &&
        widget.sessionRate <= 0 &&
        widget.monthlyRate <= 0) {
      errors.add('At least one rate must be set');
    }

    if (widget.hourlyRate > 0 && widget.hourlyRate < 10) {
      errors.add('Hourly rate should be at least \$10');
    }

    if (widget.sessionRate > 0 && widget.sessionRate < 15) {
      errors.add('Session rate should be at least \$15');
    }

    if (widget.monthlyRate > 0 && widget.monthlyRate < 100) {
      errors.add('Monthly rate should be at least \$100');
    }

    if (widget.hourlyRate > 200) {
      errors.add('Hourly rate seems too high (max recommended: \$200)');
    }

    return errors;
  }

  @override
  void dispose() {
    _hourlyController.dispose();
    _sessionController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }
}
