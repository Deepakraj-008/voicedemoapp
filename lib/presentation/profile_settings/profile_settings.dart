import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sweetyai_learning_assistant/presentation/profile_settings/privacy_controls_widget.dart' show PrivacyControlsWidget;

import '../../core/app_export.dart';
import './widgets/accessibility_settings_widget.dart';
import './widgets/account_settings_widget.dart';
import './widgets/learning_preferences_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/voice_settings_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "coursesCompleted": 12,
    "studyHours": 156,
    "streak": 28,
    "level": 5,
  };

  // Mock voice settings
  Map<String, dynamic> _voiceSettings = {
    "wakeWordSensitivity": 0.7,
    "voiceGender": "female",
    "speechRate": 1.0,
  };

  // Mock learning preferences
  Map<String, dynamic> _learningPreferences = {
    "preferredStudyTimes": ["morning", "evening"],
    "difficultyLevel": "intermediate",
    "studyReminders": true,
    "reminderTime": "9:00 AM",
    "reminderFrequency": "Daily",
    "learningStyle": "visual",
  };

  // Mock privacy settings
  Map<String, dynamic> _privacySettings = {
    "storeVoiceRecordings": true,
    "voiceAnalytics": true,
    "cloudVoiceProcessing": false,
    "voiceDataSize": 45.2,
    "voiceInteractions": 1247,
  };

  // Mock account info
  final Map<String, dynamic> _accountInfo = {
    "email": "sarah.johnson@email.com",
    "memberSince": "March 2024",
    "subscriptionPlan": "Premium",
    "nextBilling": "October 21, 2025",
  };

  // Mock accessibility settings
  Map<String, dynamic> _accessibilitySettings = {
    "voiceOnlyNavigation": false,
    "extendedVoiceFeedback": true,
    "voiceCommandConfirmation": false,
    "highContrastMode": false,
    "fontSize": 1.0,
    "reduceMotion": false,
    "screenReaderSupport": true,
    "largeTouchTargets": false,
    "gestureAlternatives": true,
    "voiceTimeout": 5.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showVoiceHelp,
            icon: CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Profile"),
            Tab(text: "System"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildSystemTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _activateVoiceAssistant,
        child: CustomIconWidget(
          iconName: 'mic',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProfileHeaderWidget(
            userProfile: _userProfile,
            onEditProfile: _editProfile,
            onChangeAvatar: _changeAvatar,
          ),
          SizedBox(height: 3.h),
          VoiceSettingsWidget(
            voiceSettings: _voiceSettings,
            onSettingChanged: _updateVoiceSetting,
          ),
          SizedBox(height: 3.h),
          LearningPreferencesWidget(
            learningPreferences: _learningPreferences,
            onPreferenceChanged: _updateLearningPreference,
          ),
          SizedBox(height: 3.h),
          PrivacyControlsWidget(
            privacySettings: _privacySettings,
            onPrivacySettingChanged: _updatePrivacySetting,
            onExportData: _exportUserData,
            onDeleteVoiceData: _deleteVoiceData,
          ),
          SizedBox(height: 10.h), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AccountSettingsWidget(
            accountInfo: _accountInfo,
            onChangePassword: _changePassword,
            onUpdateEmail: _updateEmail,
            onManageSubscription: _manageSubscription,
            onLogout: _logout,
          ),
          SizedBox(height: 3.h),
          AccessibilitySettingsWidget(
            accessibilitySettings: _accessibilitySettings,
            onAccessibilitySettingChanged: _updateAccessibilitySetting,
          ),
          SizedBox(height: 3.h),
          _buildLanguageSettings(),
          SizedBox(height: 3.h),
          _buildNotificationSettings(),
          SizedBox(height: 10.h), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildLanguageSettings() {
    final List<Map<String, String>> languages = [
      {"code": "en", "name": "English", "flag": "🇺🇸"},
      {"code": "es", "name": "Español", "flag": "🇪🇸"},
      {"code": "fr", "name": "Français", "flag": "🇫🇷"},
      {"code": "de", "name": "Deutsch", "flag": "🇩🇪"},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Language & Region",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "Voice command: 'Switch to Spanish' or 'Change language'",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ...languages.map((language) {
            final isSelected = language["code"] == "en";
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: ListTile(
                leading: Text(
                  language["flag"]!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  language["name"]!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      )
                    : null,
                onTap: () => _changeLanguage(language["code"]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                tileColor: isSelected
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05)
                    : null,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Notifications",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildNotificationToggle("Study Reminders",
              "Get notified about scheduled study sessions", true),
          SizedBox(height: 2.h),
          _buildNotificationToggle(
              "Voice Assistant Updates", "New features and improvements", true),
          SizedBox(height: 2.h),
          _buildNotificationToggle("Achievement Notifications",
              "Celebrate your learning milestones", false),
          SizedBox(height: 2.h),
          _buildNotificationToggle("Course Recommendations",
              "Personalized course suggestions", true),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
      String title, String description, bool value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            // Handle notification setting change
          },
        ),
      ],
    );
  }

  // Event handlers
  void _updateVoiceSetting(String key, dynamic value) {
    setState(() {
      _voiceSettings[key] = value;
    });
    _showVoiceConfirmation("Voice setting updated: $key");
  }

  void _updateLearningPreference(String key, dynamic value) {
    setState(() {
      _learningPreferences[key] = value;
    });
    _showVoiceConfirmation("Learning preference updated: $key");
  }

  void _updatePrivacySetting(String key, dynamic value) {
    setState(() {
      _privacySettings[key] = value;
    });
    _showVoiceConfirmation("Privacy setting updated: $key");
  }

  void _updateAccessibilitySetting(String key, dynamic value) {
    setState(() {
      _accessibilitySettings[key] = value;
    });
    _showVoiceConfirmation("Accessibility setting updated: $key");
  }

  void _editProfile() {
    _showVoiceConfirmation("Opening profile editor");
    // Navigate to profile edit screen
  }

  void _changeAvatar() {
    _showVoiceConfirmation("Opening avatar selection");
    // Show avatar selection dialog
  }

  void _exportUserData() {
    _showVoiceConfirmation("Exporting your data. This may take a moment.");
    // Export user data functionality
  }

  void _deleteVoiceData() {
    _showDialog(
      "Delete Voice Data",
      "Are you sure you want to delete all your voice recordings? This action cannot be undone.",
      () {
        _showVoiceConfirmation("Voice data has been deleted");
        setState(() {
          _privacySettings["voiceDataSize"] = 0.0;
          _privacySettings["voiceInteractions"] = 0;
        });
      },
    );
  }

  void _changePassword() {
    _showVoiceConfirmation("Opening password change form");
    // Navigate to password change screen
  }

  void _updateEmail() {
    _showVoiceConfirmation("Opening email update form");
    // Navigate to email update screen
  }

  void _manageSubscription() {
    _showVoiceConfirmation("Opening subscription management");
    // Navigate to subscription management
  }

  void _logout() {
    _showDialog(
      "Sign Out",
      "Are you sure you want to sign out? You'll need to sign in again to access your account.",
      () {
        _showVoiceConfirmation("Signing you out. Goodbye!");
        Navigator.pushNamedAndRemoveUntil(
            context, '/voice-onboarding', (route) => false);
      },
    );
  }

  void _changeLanguage(String languageCode) {
    _showVoiceConfirmation("Language changed successfully");
    // Implement language change logic
  }

  void _activateVoiceAssistant() {
    _showVoiceConfirmation(
        "Hello! I'm listening. How can I help you with your settings?");
    // Activate voice assistant for settings
  }

  void _showVoiceHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              "Voice Commands",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Available Commands:",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildVoiceCommand(
                  "'Update profile picture'", "Change your avatar"),
              _buildVoiceCommand(
                  "'Set study time to morning'", "Update study preferences"),
              _buildVoiceCommand("'Change my password'", "Security settings"),
              _buildVoiceCommand("'Export my data'", "Download your data"),
              _buildVoiceCommand("'Switch to Spanish'", "Change language"),
              _buildVoiceCommand("'Sign me out'", "Logout from account"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Got it",
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceCommand(String command, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'keyboard_voice',
            color: AppTheme.lightTheme.primaryColor,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  command,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVoiceConfirmation(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'volume_up',
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
      ),
    );
  }

  void _showDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text(
              "Confirm",
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
