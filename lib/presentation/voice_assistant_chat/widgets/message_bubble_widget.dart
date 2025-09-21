import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;
  final VoidCallback? onSpeakMessage;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.onSpeakMessage,
    this.onBookmark,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.primaryColor,
                    AppTheme.lightTheme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'S',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 75.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.w),
                      topRight: Radius.circular(4.w),
                      bottomLeft:
                          isUser ? Radius.circular(4.w) : Radius.circular(1.w),
                      bottomRight:
                          isUser ? Radius.circular(1.w) : Radius.circular(4.w),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isTyping
                      ? _buildTypingIndicator()
                      : _buildMessageContent(),
                ),
                SizedBox(height: 0.5.h),
                if (!isTyping) _buildMessageActions(),
              ],
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isUser
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _formatTimestamp(timestamp),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isUser
                ? Colors.white.withValues(alpha: 0.7)
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sweety is typing',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageActions() {
    if (isUser) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSpeakMessage != null)
          GestureDetector(
            onTap: onSpeakMessage,
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'volume_up',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 4.w,
              ),
            ),
          ),
        SizedBox(width: 2.w),
        if (onBookmark != null)
          GestureDetector(
            onTap: onBookmark,
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 4.w,
              ),
            ),
          ),
        SizedBox(width: 2.w),
        if (onShare != null)
          GestureDetector(
            onTap: onShare,
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 4.w,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}