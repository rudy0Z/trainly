import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/ai_insights_widget.dart';
import './widgets/hero_workout_card_widget.dart';
import './widgets/progress_dashboard_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/trainly_header_widget.dart';
import './widgets/upcoming_workouts_widget.dart';

class TrainlyHomepage extends StatefulWidget {
  const TrainlyHomepage({super.key});

  @override
  State<TrainlyHomepage> createState() => _TrainlyHomepageState();
}

class _TrainlyHomepageState extends State<TrainlyHomepage> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate AI workout data loading
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadWorkoutData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : RefreshIndicator(
                onRefresh: _refreshData,
                backgroundColor: Colors.white,
                color: Colors.black,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo and profile
                      const TrainlyHeaderWidget(),

                      SizedBox(height: 3.h),

                      // Hero workout section
                      const HeroWorkoutCardWidget(),

                      SizedBox(height: 3.h),

                      // Progress dashboard
                      const ProgressDashboardWidget(),

                      SizedBox(height: 3.h),

                      // AI insights section
                      const AiInsightsWidget(),

                      SizedBox(height: 3.h),

                      // Quick actions
                      const QuickActionsWidget(),

                      SizedBox(height: 3.h),

                      // Upcoming workouts
                      const UpcomingWorkoutsWidget(),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Loading your AI workout plan...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
