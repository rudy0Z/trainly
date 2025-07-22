import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScannerOverlayWidget extends StatelessWidget {
  final bool isScanning;
  final Animation<double> scanAnimation;
  final Animation<double> successAnimation;
  final VoidCallback onTap;

  const ScannerOverlayWidget({
    super.key,
    required this.isScanning,
    required this.scanAnimation,
    required this.successAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Scanning frame
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isScanning
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.getSuccessColor(true),
                  width: 3,
                ),
              ),
            ),

            // Corner indicators
            ...List.generate(4, (index) {
              return Positioned(
                top: index < 2 ? 0 : null,
                bottom: index >= 2 ? 0 : null,
                left: index % 2 == 0 ? 0 : null,
                right: index % 2 == 1 ? 0 : null,
                child: AnimatedBuilder(
                  animation: scanAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: isScanning
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(
                                    alpha: 0.3 + (scanAnimation.value * 0.7))
                            : AppTheme.getSuccessColor(true),
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0
                              ? const Radius.circular(16)
                              : Radius.zero,
                          topRight: index == 1
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomLeft: index == 2
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomRight: index == 3
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // Scanning line animation
            if (isScanning)
              AnimatedBuilder(
                animation: scanAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: scanAnimation.value * (70.w - 4),
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppTheme.lightTheme.colorScheme.primary,
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),

            // Success checkmark
            if (!isScanning)
              Center(
                child: AnimatedBuilder(
                  animation: successAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: successAnimation.value,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.getSuccessColor(true),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 10.w,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Center instruction
            if (isScanning)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tap to simulate scan',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
