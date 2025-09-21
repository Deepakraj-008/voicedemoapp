import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CreateAccountButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;
  final Function(String) onVoiceFeedback;

  const CreateAccountButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
    required this.onVoiceFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading
            ? () {
                onVoiceFeedback('Creating your account');
                onPressed();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          elevation: isEnabled ? 2 : 0,
          shadowColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Creating Account...',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: isEnabled
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }
}
