import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String iconName;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main illustration
          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: imageUrl,
                    width: 70.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    width: 70.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                  // Icon overlay
                  Positioned(
                    bottom: 4.h,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          SizedBox(height: 2.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Feature highlights
          _buildFeatureHighlights(),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    List<Map<String, String>> features = [];

    switch (iconName) {
      case 'calendar_today':
        features = [
          {"icon": "schedule", "text": "Real-time availability"},
          {"icon": "notifications", "text": "Instant confirmations"},
          {"icon": "event_available", "text": "Easy rescheduling"},
        ];
        break;
      case 'qr_code_scanner':
        features = [
          {"icon": "flash_on", "text": "Quick access"},
          {"icon": "security", "text": "Secure entry"},
          {"icon": "mobile_friendly", "text": "Contactless check-in"},
        ];
        break;
      case 'account_balance_wallet':
        features = [
          {"icon": "savings", "text": "Earn cashback"},
          {"icon": "payment", "text": "Multiple payment options"},
          {"icon": "account_balance", "text": "Secure transactions"},
        ];
        break;
      case 'card_membership':
        features = [
          {"icon": "autorenew", "text": "Auto-renewal"},
          {"icon": "trending_up", "text": "Flexible upgrades"},
          {"icon": "local_offer", "text": "Special discounts"},
        ];
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features
          .map((feature) => _buildFeatureItem(
                feature["icon"] ?? "",
                feature["text"] ?? "",
              ))
          .toList(),
    );
  }

  Widget _buildFeatureItem(String iconName, String text) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
