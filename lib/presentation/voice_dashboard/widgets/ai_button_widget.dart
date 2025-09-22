import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../ai_assistant_chat/voice_ai_assistant_chat.dart';

class AIButtonWidget extends StatelessWidget {
  const AIButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 6.w,
      bottom: 8.h,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VoiceAIAssistantChat(),
            ),
          );
        },
        child: Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.smart_toy,
            size: 8.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
