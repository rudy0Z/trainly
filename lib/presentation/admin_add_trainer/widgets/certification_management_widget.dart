import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CertificationManagementWidget extends StatefulWidget {
  final List<Map<String, dynamic>> certificates;
  final Function(List<Map<String, dynamic>>) onCertificatesChanged;

  const CertificationManagementWidget({
    super.key,
    required this.certificates,
    required this.onCertificatesChanged,
  });

  @override
  State<CertificationManagementWidget> createState() =>
      _CertificationManagementWidgetState();
}

class _CertificationManagementWidgetState
    extends State<CertificationManagementWidget> {
  final TextEditingController _certNameController = TextEditingController();
  final TextEditingController _certIssuerController = TextEditingController();
  DateTime? _certExpiryDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Certificate Button
        GestureDetector(
          onTap: _showAddCertificateDialog,
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 20.sp,
                  color: Colors.black,
                ),
                SizedBox(width: 8.sp),
                Text(
                  'Add Certificate',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.sp),
        // Certificate List
        if (widget.certificates.isNotEmpty) ...[
          Text(
            'Added Certificates',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.sp),
          ...widget.certificates
              .map((cert) => _buildCertificateCard(cert))
              .toList(),
        ] else ...[
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.workspace_premium,
                  size: 32.sp,
                  color: const Color(0xFF666666),
                ),
                SizedBox(height: 8.sp),
                Text(
                  'No certificates added yet',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert['name'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.sp),
                Text(
                  cert['issuer'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
                if (cert['expiryDate'] != null) ...[
                  SizedBox(height: 4.sp),
                  Text(
                    'Expires: ${_formatDate(cert['expiryDate'])}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeCertificate(cert),
            child: Icon(
              Icons.delete_outline,
              size: 20.sp,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCertificateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Certificate',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _certNameController,
              decoration: InputDecoration(
                labelText: 'Certificate Name',
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16.sp),
            TextField(
              controller: _certIssuerController,
              decoration: InputDecoration(
                labelText: 'Issuing Organization',
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16.sp),
            GestureDetector(
              onTap: _selectExpiryDate,
              child: Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _certExpiryDate != null
                            ? 'Expires: ${_formatDate(_certExpiryDate!)}'
                            : 'Select expiry date (optional)',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: _certExpiryDate != null
                              ? Colors.black
                              : const Color(0xFF666666),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addCertificate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Add',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCertificate() {
    if (_certNameController.text.isNotEmpty &&
        _certIssuerController.text.isNotEmpty) {
      final newCert = {
        'name': _certNameController.text,
        'issuer': _certIssuerController.text,
        'expiryDate': _certExpiryDate,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final updatedCerts = List<Map<String, dynamic>>.from(widget.certificates);
      updatedCerts.add(newCert);

      widget.onCertificatesChanged(updatedCerts);

      // Clear form
      _certNameController.clear();
      _certIssuerController.clear();
      _certExpiryDate = null;

      Navigator.pop(context);
    }
  }

  void _removeCertificate(Map<String, dynamic> cert) {
    final updatedCerts = List<Map<String, dynamic>>.from(widget.certificates);
    updatedCerts.remove(cert);
    widget.onCertificatesChanged(updatedCerts);
  }

  void _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );
    if (picked != null) {
      setState(() {
        _certExpiryDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _certNameController.dispose();
    _certIssuerController.dispose();
    super.dispose();
  }
}
