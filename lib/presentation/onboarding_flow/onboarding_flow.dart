import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Book Classes Instantly",
      "description":
          "Browse live schedules and book your favorite fitness classes with just a few taps. Never miss a workout again!",
      "imageUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "calendar_today",
    },
    {
      "title": "QR Code Gym Access",
      "description":
          "Skip the hassle! Simply scan your QR code at the gym entrance for seamless check-in and access to all facilities.",
      "imageUrl":
          "https://images.pexels.com/photos/4386321/pexels-photo-4386321.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "iconName": "qr_code_scanner",
    },
    {
      "title": "Digital Wallet Benefits",
      "description":
          "Load your wallet, earn cashback, and pay for memberships effortlessly. Your fitness payments made simple and secure.",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2017/03/29/04/47/payment-2184073_1280.jpg",
      "iconName": "account_balance_wallet",
    },
    {
      "title": "Flexible Membership Plans",
      "description":
          "Choose from monthly, quarterly, or yearly plans that fit your lifestyle. Upgrade or downgrade anytime with ease.",
      "imageUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "card_membership",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRegistration();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _navigateToRegistration();
  }

  void _navigateToRegistration() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    title: _onboardingData[index]["title"] as String,
                    description:
                        _onboardingData[index]["description"] as String,
                    imageUrl: _onboardingData[index]["imageUrl"] as String,
                    iconName: _onboardingData[index]["iconName"] as String,
                  );
                },
              ),
            ),

            // Page indicator and navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: _currentPage == index ? 8.w : 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Progress indicator
                  Container(
                    width: double.infinity,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentPage + 1) / _onboardingData.length,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(0.5.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Navigation button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_currentPage < _onboardingData.length - 1) ...[
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'arrow_forward',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
