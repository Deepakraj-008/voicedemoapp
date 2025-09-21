import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:highlight/languages/dart.dart' as highlight_dart;
import 'package:highlight/languages/python.dart' as highlight_python;
import 'package:highlight/languages/javascript.dart' as highlight_javascript;
import 'package:highlight/languages/java.dart' as highlight_java;
import 'package:highlight/languages/cpp.dart' as highlight_cpp;

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LessonContentWidget extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final Function(String) onVoiceCommand;
  final bool isVoiceActive;

  const LessonContentWidget({
    Key? key,
    required this.lesson,
    required this.onVoiceCommand,
    required this.isVoiceActive,
  }) : super(key: key);

  @override
  State<LessonContentWidget> createState() => _LessonContentWidgetState();
}

class _LessonContentWidgetState extends State<LessonContentWidget> {
  VideoPlayerController? _videoController;
  CodeController? _codeController;
  int _currentQuizIndex = 0;
  String? _selectedAnswer;
  bool _showQuizResult = false;

  @override
  void initState() {
    super.initState();
    _initializeContent();
  }

  void _initializeContent() {
    final lessonType = widget.lesson['type'] as String;

    if (lessonType == 'video' && widget.lesson['videoUrl'] != null) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.lesson['videoUrl'] as String),
      );
      _videoController!.initialize().then((_) {
        setState(() {});
      });
    } else if (lessonType == 'coding' && widget.lesson['code'] != null) {
      _codeController = CodeController(
        text: widget.lesson['code'] as String,
        language: _getLanguageFromType(
            widget.lesson['language'] as String? ?? 'dart'),
      );
    }
  }

  Language _getLanguageFromType(String type) {
    switch (type.toLowerCase()) {
      case 'python':
        return Language.python;
      case 'javascript':
        return Language.javascript;
      case 'java':
        return Language.java;
      case 'cpp':
      case 'c++':
        return Language.cpp;
      default:
        return Language.dart;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonType = widget.lesson['type'] as String;

    switch (lessonType) {
      case 'video':
        return _buildVideoContent();
      case 'coding':
        return _buildCodingContent();
      case 'quiz':
        return _buildQuizContent();
      default:
        return _buildTextContent();
    }
  }

  Widget _buildVideoContent() {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _videoController?.value.isInitialized == true
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading video...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCodingContent() {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'code',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  widget.lesson['title'] as String? ?? 'Code Exercise',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                if (widget.isVoiceActive)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Voice Active',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _codeController != null
                ? CodeTheme(
                    data: CodeThemeData(styles: {
                      'root': TextStyle(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.surface,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    }),
                    child: CodeField(
                      controller: _codeController!,
                      textStyle: AppTheme.getMonospaceStyle(
                        isLight: true,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Loading code editor...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _runCode(),
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text('Run Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 3.w),
                OutlinedButton.icon(
                  onPressed: () => _resetCode(),
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  label: Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    final questions = widget.lesson['questions'] as List<dynamic>? ?? [];
    if (questions.isEmpty) return _buildTextContent();

    final currentQuestion =
        questions[_currentQuizIndex] as Map<String, dynamic>;
    final options = currentQuestion['options'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Question ${_currentQuizIndex + 1} of ${questions.length}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              if (widget.isVoiceActive)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getSemanticColor('success', isLight: true)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'mic',
                        color:
                            AppTheme.getSemanticColor('success', isLight: true),
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Say your answer',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getSemanticColor('success',
                              isLight: true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            currentQuestion['question'] as String? ?? '',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final option = options[index] as String;
                final isSelected = _selectedAnswer == option;
                final isCorrect = _showQuizResult &&
                    option == currentQuestion['correctAnswer'];
                final isWrong = _showQuizResult &&
                    isSelected &&
                    option != currentQuestion['correctAnswer'];

                return GestureDetector(
                  onTap: _showQuizResult ? null : () => _selectAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? AppTheme.getSemanticColor('success', isLight: true)
                              .withValues(alpha: 0.1)
                          : isWrong
                              ? AppTheme.getSemanticColor('error',
                                      isLight: true)
                                  .withValues(alpha: 0.1)
                              : isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect
                            ? AppTheme.getSemanticColor('success',
                                isLight: true)
                            : isWrong
                                ? AppTheme.getSemanticColor('error',
                                    isLight: true)
                                : isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                        width: isSelected || isCorrect || isWrong ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCorrect
                                ? AppTheme.getSemanticColor('success',
                                    isLight: true)
                                : isWrong
                                    ? AppTheme.getSemanticColor('error',
                                        isLight: true)
                                    : isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : Colors.transparent,
                            border: Border.all(
                              color: isCorrect
                                  ? AppTheme.getSemanticColor('success',
                                      isLight: true)
                                  : isWrong
                                      ? AppTheme.getSemanticColor('error',
                                          isLight: true)
                                      : isSelected
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                          ),
                          child: isCorrect
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 16,
                                )
                              : isWrong
                                  ? CustomIconWidget(
                                      iconName: 'close',
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isCorrect
                                  ? AppTheme.getSemanticColor('success',
                                      isLight: true)
                                  : isWrong
                                      ? AppTheme.getSemanticColor('error',
                                          isLight: true)
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedAnswer != null && !_showQuizResult)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 2.h),
              child: ElevatedButton(
                onPressed: _submitAnswer,
                child: Text('Submit Answer'),
              ),
            ),
          if (_showQuizResult)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 2.h),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(_currentQuizIndex < questions.length - 1
                    ? 'Next Question'
                    : 'Complete Quiz'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Container(
      width: double.infinity,
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson['title'] as String? ?? 'Lesson Content',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              widget.lesson['content'] as String? ?? 'No content available.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runCode() {
    // Simulate code execution
    widget.onVoiceCommand('Code executed successfully');
  }

  void _resetCode() {
    if (_codeController != null) {
      _codeController!.text = widget.lesson['code'] as String? ?? '';
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _submitAnswer() {
    setState(() {
      _showQuizResult = true;
    });

    final questions = widget.lesson['questions'] as List<dynamic>;
    final currentQuestion =
        questions[_currentQuizIndex] as Map<String, dynamic>;
    final isCorrect = _selectedAnswer == currentQuestion['correctAnswer'];

    widget.onVoiceCommand(isCorrect
        ? 'Correct! Well done.'
        : 'Incorrect. The correct answer is ${currentQuestion['correctAnswer']}.');
  }

  void _nextQuestion() {
    final questions = widget.lesson['questions'] as List<dynamic>;
    if (_currentQuizIndex < questions.length - 1) {
      setState(() {
        _currentQuizIndex++;
        _selectedAnswer = null;
        _showQuizResult = false;
      });
    } else {
      widget.onVoiceCommand('Quiz completed! Great job!');
    }
  }
}