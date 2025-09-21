import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final Function(String) onVoiceFeedback;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    required this.onVoiceFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    // Provide voice feedback when strength changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (password.isNotEmpty) {
        onVoiceFeedback('Password strength: $strengthText');
      }
    });

    return password.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: strength / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: strengthColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    strengthText,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: strengthColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              ..._getPasswordRequirements(password),
            ],
          );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;

    // Uppercase check
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Lowercase check
    if (password.contains(RegExp(r'[a-z]'))) strength++;

    // Number check
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Special character check
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength > 4 ? 4 : strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppTheme.lightTheme.colorScheme.error;
      case 2:
        return AppTheme.warningLight;
      case 3:
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 4:
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  List<Widget> _getPasswordRequirements(String password) {
    final requirements = [
      _RequirementItem(
        text: 'At least 8 characters',
        isMet: password.length >= 8,
      ),
      _RequirementItem(
        text: 'One uppercase letter',
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      _RequirementItem(
        text: 'One lowercase letter',
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      _RequirementItem(
        text: 'One number',
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      _RequirementItem(
        text: 'One special character',
        isMet: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];

    return requirements
        .map((req) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        req.isMet ? 'check_circle' : 'radio_button_unchecked',
                    color: req.isMet
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    req.text,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: req.isMet
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

class _RequirementItem {
  final String text;
  final bool isMet;

  _RequirementItem({
    required this.text,
    required this.isMet,
  });
}
