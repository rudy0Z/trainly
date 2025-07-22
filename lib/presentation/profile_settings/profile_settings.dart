import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool isDarkMode = false;
  bool biometricEnabled = true;
  bool classReminders = true;
  bool promotionalOffers = false;
  bool paymentAlerts = true;
  String selectedLanguage = 'English';

  final List<Map<String, dynamic>> mockUserData = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b9e0e4b0?w=400&h=400&fit=crop&crop=face",
      "membership": "Premium Annual",
      "memberSince": "January 2023",
      "emergencyContacts": [
        {
          "name": "John Johnson",
          "relationship": "Spouse",
          "phone": "+1 (555) 987-6543"
        },
        {
          "name": "Mary Johnson",
          "relationship": "Mother",
          "phone": "+1 (555) 456-7890"
        }
      ],
      "medicalConditions": ["Asthma", "Previous knee injury"],
      "fitnessGoals": [
        "Weight loss",
        "Muscle building",
        "Cardiovascular health"
      ]
    }
  ];

  final List<String> languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    final userData = mockUserData.first;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeaderWidget(
                      userData: userData,
                      onEditProfile: () => _showEditProfileDialog(),
                    ),
                    SizedBox(height: 2.h),
                    _buildSettingsSections(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Profile Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSections() {
    return Column(
      children: [
        SettingsSectionWidget(
          title: 'Personal Information',
          children: [
            SettingsItemWidget(
              icon: 'person',
              title: 'Full Name',
              subtitle: mockUserData.first['name'] as String,
              onTap: () => _showEditDialog('name'),
            ),
            SettingsItemWidget(
              icon: 'email',
              title: 'Email Address',
              subtitle: mockUserData.first['email'] as String,
              onTap: () => _showEditDialog('email'),
            ),
            SettingsItemWidget(
              icon: 'phone',
              title: 'Phone Number',
              subtitle: mockUserData.first['phone'] as String,
              onTap: () => _showEditDialog('phone'),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SettingsSectionWidget(
          title: 'Health Profile',
          children: [
            SettingsItemWidget(
              icon: 'medical_services',
              title: 'Medical Conditions',
              subtitle:
                  (mockUserData.first['medicalConditions'] as List).join(', '),
              onTap: () => _showMedicalConditionsDialog(),
            ),
            SettingsItemWidget(
              icon: 'fitness_center',
              title: 'Fitness Goals',
              subtitle: (mockUserData.first['fitnessGoals'] as List).join(', '),
              onTap: () => _showFitnessGoalsDialog(),
            ),
            SettingsItemWidget(
              icon: 'emergency',
              title: 'Emergency Contacts',
              subtitle:
                  '${(mockUserData.first['emergencyContacts'] as List).length} contacts',
              onTap: () => _showEmergencyContactsDialog(),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SettingsSectionWidget(
          title: 'App Preferences',
          children: [
            SettingsItemWidget(
              icon: 'dark_mode',
              title: 'Theme',
              subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            ),
            SettingsItemWidget(
              icon: 'language',
              title: 'Language',
              subtitle: selectedLanguage,
              onTap: () => _showLanguageDialog(),
            ),
            SettingsItemWidget(
              icon: 'notifications',
              title: 'Notification Settings',
              subtitle: 'Manage your notifications',
              onTap: () => _showNotificationSettingsDialog(),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SettingsSectionWidget(
          title: 'Security',
          children: [
            SettingsItemWidget(
              icon: 'fingerprint',
              title: 'Biometric Authentication',
              subtitle: biometricEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    biometricEnabled = value;
                  });
                },
              ),
            ),
            SettingsItemWidget(
              icon: 'lock',
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => _showChangePasswordDialog(),
            ),
            SettingsItemWidget(
              icon: 'security',
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security',
              onTap: () => _showTwoFactorDialog(),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SettingsSectionWidget(
          title: 'Support',
          children: [
            SettingsItemWidget(
              icon: 'help',
              title: 'FAQ',
              subtitle: 'Frequently asked questions',
              onTap: () => _showFAQDialog(),
            ),
            SettingsItemWidget(
              icon: 'support_agent',
              title: 'Contact Support',
              subtitle: 'Get help from our team',
              onTap: () => _showContactSupportDialog(),
            ),
            SettingsItemWidget(
              icon: 'description',
              title: 'Terms & Privacy',
              subtitle: 'Legal information',
              onTap: () => _showTermsAndPrivacyDialog(),
            ),
            SettingsItemWidget(
              icon: 'download',
              title: 'Export Data',
              subtitle: 'Download your personal records',
              onTap: () => _showExportDataDialog(),
            ),
          ],
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('home', 'Home', false, '/home-dashboard'),
          _buildNavItem('event', 'Classes', false, '/class-booking'),
          _buildNavItem('bookmark', 'Bookings', false, '/my-bookings'),
          _buildNavItem(
              'account_balance_wallet', 'Wallet', false, '/digital-wallet'),
          _buildNavItem('person', 'Profile', true, '/profile-settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, bool isActive, String route) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content:
            Text('Profile editing functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${field.toUpperCase()}'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Enter new $field',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMedicalConditionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Medical Conditions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current conditions:'),
            SizedBox(height: 1.h),
            ...(mockUserData.first['medicalConditions'] as List).map(
              (condition) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8,
                    ),
                    SizedBox(width: 2.w),
                    Text(condition as String),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showFitnessGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fitness Goals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your current goals:'),
            SizedBox(height: 1.h),
            ...(mockUserData.first['fitnessGoals'] as List).map(
              (goal) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.getSuccessColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(goal as String),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Contacts'),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...(mockUserData.first['emergencyContacts'] as List).map(
                (contact) => Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (contact as Map<String, dynamic>)['name'] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        contact['relationship'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        contact['phone'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Manage'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages
              .map((language) => RadioListTile<String>(
                    title: Text(language),
                    value: language,
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Notification Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('Class Reminders'),
                subtitle: Text('Get notified before your classes'),
                value: classReminders,
                onChanged: (value) {
                  setDialogState(() {
                    classReminders = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Promotional Offers'),
                subtitle: Text('Receive special offers and deals'),
                value: promotionalOffers,
                onChanged: (value) {
                  setDialogState(() {
                    promotionalOffers = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Payment Alerts'),
                subtitle: Text('Payment confirmations and receipts'),
                value: paymentAlerts,
                onChanged: (value) {
                  setDialogState(() {
                    paymentAlerts = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Two-Factor Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose your preferred method:'),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'sms',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('SMS Authentication'),
              subtitle: Text('Receive codes via text message'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'smartphone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Authenticator App'),
              subtitle: Text('Use Google Authenticator or similar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog() {
    final List<Map<String, String>> faqItems = [
      {
        "question": "How do I cancel a class booking?",
        "answer":
            "You can cancel your booking up to 2 hours before the class starts from the My Bookings section."
      },
      {
        "question": "Can I freeze my membership?",
        "answer":
            "Yes, you can freeze your membership for up to 30 days per year. Contact support for assistance."
      },
      {
        "question": "How do I add money to my wallet?",
        "answer":
            "Go to the Digital Wallet section and tap 'Add Money' to load funds using various payment methods."
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Frequently Asked Questions'),
        content: SizedBox(
          width: 80.w,
          height: 40.h,
          child: ListView.builder(
            itemCount: faqItems.length,
            itemBuilder: (context, index) {
              final faq = faqItems[index];
              return ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Text(
                      faq['answer']!,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Live Chat'),
              subtitle: Text('Chat with our support team'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Email Support'),
              subtitle: Text('Send us an email'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Phone Support'),
              subtitle: Text('Call us at +1 (555) 123-4567'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Privacy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Terms of Service'),
              subtitle: Text('Read our terms and conditions'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Privacy Policy'),
              subtitle: Text('How we handle your data'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Personal Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate a PDF report containing:'),
            SizedBox(height: 1.h),
            Text('• Personal information'),
            Text('• Booking history'),
            Text('• Payment records'),
            Text('• Membership details'),
            Text('• Health profile'),
            SizedBox(height: 2.h),
            Text(
              'This may take a few minutes to generate.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Data export started. You will receive an email when ready.'),
                ),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }
}
