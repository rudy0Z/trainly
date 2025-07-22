import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsExportWidget extends StatefulWidget {
  const ReportsExportWidget({super.key});

  @override
  State<ReportsExportWidget> createState() => _ReportsExportWidgetState();
}

class _ReportsExportWidgetState extends State<ReportsExportWidget> {
  bool isExporting = false;
  bool exportSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Reports',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (isExporting) ...[
            _buildExportProgress(),
          ] else if (exportSuccess) ...[
            _buildExportSuccess(),
          ] else ...[
            _buildExportOptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildExportOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildExportButton(
                icon: Icons.picture_as_pdf,
                label: 'Export as PDF',
                onPressed: () => _startExport('PDF'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportButton(
                icon: Icons.table_chart,
                label: 'Export as CSV',
                onPressed: () => _startExport('CSV'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildExportButton(
                icon: Icons.insert_chart,
                label: 'Export as Excel',
                onPressed: () => _startExport('Excel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportButton(
                icon: Icons.email,
                label: 'Email Report',
                onPressed: () => _startExport('Email'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportProgress() {
    return Column(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(2),
          ),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Generating report...',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildExportSuccess() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Report exported successfully!',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            setState(() {
              exportSuccess = false;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Color(0xFFE0E0E0)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Export Another',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _startExport(String format) {
    setState(() {
      isExporting = true;
      exportSuccess = false;
    });

    // Simulate export process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isExporting = false;
        exportSuccess = true;
      });
    });
  }
}
