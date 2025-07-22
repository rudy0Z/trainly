import 'package:flutter/material.dart';
import '../presentation/trainly_homepage/trainly_homepage.dart';
import '../presentation/chat_with_trainly/chat_with_trainly.dart';
import '../presentation/planner_view/planner_view.dart';
import '../presentation/profile_setup/profile_setup.dart';
// Removed import for home_dashboard - no longer needed for Trainly
import '../presentation/profile_settings/profile_settings.dart';

class AppRoutes {
  static const String initial = '/';
  static const String trainlyHomepage = '/trainly-homepage';
  static const String chatWithTrainly = '/chat-with-trainly';
  static const String plannerView = '/planner-view';
  static const String profileSetup = '/profile-setup';
  // Removed homeDashboard route - old My Fitness Hub functionality
  static const String profileSettings = '/profile-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const TrainlyHomepage(),
    trainlyHomepage: (context) => const TrainlyHomepage(),
    chatWithTrainly: (context) => const ChatWithTrainly(),
    plannerView: (context) => const PlannerView(),
    profileSetup: (context) => const ProfileSetup(),
    // Removed homeDashboard route mapping
    profileSettings: (context) => const ProfileSettings(),
  };
}
