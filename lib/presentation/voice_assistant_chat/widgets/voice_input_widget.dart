import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final TextEditingController textController;
  final bool isListening;
  final bool isProcessing;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;
  final VoidCallback onSendMessage;
  final Function(String) onTextChanged;

  const VoiceInputWidget({
    Key? key,
    required this.textController,
    required this.isListening,
    required this.isProcessing,
    required this.onStartListening,
    required this.onStopListening,
    required this.onSendMessage,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showTextInput = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showTextInput) _buildTextInput(),
            if (_showTextInput) SizedBox(height: 2.h),
            _buildVoiceControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.textController,
              focusNode: _focusNode,
              onChanged: widget.onTextChanged,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: 3,
              minLines: 1,
            ),
          ),
          if (widget.textController.text.isNotEmpty)
            GestureDetector(
              onTap: widget.onSendMessage,
              child: Container(
                margin: EdgeInsets.only(right: 2.w),
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Text input toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _showTextInput = !_showTextInput;
              if (_showTextInput) {
                _focusNode.requestFocus();
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _showTextInput
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: CustomIconWidget(
              iconName: 'keyboard',
              color: _showTextInput
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 6.w,
            ),
          ),
        ),

        // Main voice button
        GestureDetector(
          onTap: widget.isListening
              ? widget.onStopListening
              : widget.onStartListening,
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: widget.isListening
                    ? [
                        AppTheme.lightTheme.colorScheme.error,
                        AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.8),
                      ]
                    : [
                        AppTheme.lightTheme.primaryColor,
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.isListening
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.primaryColor)
                      .withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isListening)
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                  ),
                CustomIconWidget(
                  iconName: widget.isProcessing
                      ? 'hourglass_empty'
                      : widget.isListening
                          ? 'stop'
                          : 'mic',
                  color: Colors.white,
                  size: 8.w,
                ),
              ],
            ),
          ),
        ),

        // Wake word status
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Hello Sweety',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
