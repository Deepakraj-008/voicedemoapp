import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PermissionRequestCard extends StatelessWidget {
  final VoidCallback onEnablePressed;
  final VoidCallback onSkipPressed;
  final bool isLoading;

  const PermissionRequestCard({
    super.key,
    required this.onEnablePressed,
    required this.onSkipPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Microphone icon with background
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            'Enable Voice Assistant',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.5.h),

          // Description
          Text(
            'Allow microphone access to use voice commands and get personalized learning assistance. Your voice data is processed securely and never stored.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Privacy features list
          _buildPrivacyFeature(
            icon: 'security',
            title: 'End-to-End Encryption',
            description: 'Voice data encrypted during processing',
          ),

          SizedBox(height: 1.h),

          _buildPrivacyFeature(
            icon: 'delete_forever',
            title: 'No Storage Policy',
            description: 'Voice recordings deleted immediately',
          ),

          SizedBox(height: 1.h),

          _buildPrivacyFeature(
            icon: 'offline_pin',
            title: 'Offline Processing',
            description: 'Works without internet connection',
          ),

          SizedBox(height: 4.h),

          // Enable button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onEnablePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: 2,
                shadowColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Enable Voice Assistant',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Skip button
          TextButton(
            onPressed: isLoading ? null : onSkipPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            ),
            child: Text(
              'Set Up Later',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyFeature({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondaryContainer
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 4.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
