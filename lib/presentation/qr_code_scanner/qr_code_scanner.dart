import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/member_info_widget.dart';
import './widgets/scan_result_widget.dart';
import './widgets/scanner_overlay_widget.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner>
    with TickerProviderStateMixin {
  bool _isFlashOn = false;
  bool _isScanning = true;
  bool _showManualEntry = false;
  String? _scannedCode;
  late AnimationController _scanAnimationController;
  late AnimationController _successAnimationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _successAnimation;
  final TextEditingController _manualCodeController = TextEditingController();

  // Mock member data
  final Map<String, dynamic> _memberData = {
    "name": "Sarah Johnson",
    "membershipStatus": "Active Premium",
    "membershipExpiry": "2024-12-31",
    "todayClasses": [
      {
        "className": "Morning Yoga",
        "time": "07:00 AM",
        "trainer": "Emma Wilson",
        "status": "Booked"
      },
      {
        "className": "HIIT Training",
        "time": "06:00 PM",
        "trainer": "Mike Rodriguez",
        "status": "Booked"
      }
    ],
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face"
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));

    _scanAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _successAnimationController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    HapticFeedback.lightImpact();
  }

  void _simulateQrScan() {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
      _scannedCode = "GYM_ENTRY_${DateTime.now().millisecondsSinceEpoch}";
    });

    _scanAnimationController.stop();
    _successAnimationController.forward();
    HapticFeedback.heavyImpact();

    // Simulate successful scan
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScanResultWidget(
        memberData: _memberData,
        scannedCode: _scannedCode!,
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _toggleManualEntry() {
    setState(() {
      _showManualEntry = !_showManualEntry;
    });
  }

  void _processManualCode() {
    if (_manualCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid QR code'),
        ),
      );
      return;
    }

    setState(() {
      _scannedCode = _manualCodeController.text.trim();
      _isScanning = false;
    });

    _showSuccessDialog();
  }

  void _resetScanner() {
    setState(() {
      _isScanning = true;
      _scannedCode = null;
      _showManualEntry = false;
    });
    _manualCodeController.clear();
    _scanAnimationController.repeat(reverse: true);
    _successAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera viewfinder simulation
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A1A),
                    Color(0xFF2D2D2D),
                    Color(0xFF1A1A1A),
                  ],
                ),
              ),
              child: CustomImageWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=800&fit=crop",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Dark overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.3),
            ),

            // Top section with logo and instructions
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: Colors.white,
                              size: 6.w,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleFlash,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: _isFlashOn
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: _isFlashOn ? 'flash_on' : 'flash_off',
                              color: Colors.white,
                              size: 6.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Gym logo
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'fitness_center',
                        color: Colors.white,
                        size: 10.w,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Scan to Enter',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Position QR code within the frame',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scanner overlay
            Center(
              child: ScannerOverlayWidget(
                isScanning: _isScanning,
                scanAnimation: _scanAnimation,
                successAnimation: _successAnimation,
                onTap: _simulateQrScan,
              ),
            ),

            // Bottom section with member info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Member info card
                    MemberInfoWidget(memberData: _memberData),

                    SizedBox(height: 2.h),

                    // Manual entry section
                    if (_showManualEntry) ...[
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _manualCodeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter QR code manually',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _processManualCode,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Submit'),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _toggleManualEntry,
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.white),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _toggleManualEntry,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                              ),
                              icon: CustomIconWidget(
                                iconName: 'keyboard',
                                color: Colors.white,
                                size: 5.w,
                              ),
                              label: const Text('Manual Entry'),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isScanning ? null : _resetScanner,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                              ),
                              icon: CustomIconWidget(
                                iconName: 'refresh',
                                color: Colors.white,
                                size: 5.w,
                              ),
                              label: const Text('Scan Again'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
