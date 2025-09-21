import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/floating_controls_widget.dart';
import './widgets/lesson_content_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/voice_waveform_widget.dart';

class LearningSession extends StatefulWidget {
  const LearningSession({Key? key}) : super(key: key);

  @override
  State<LearningSession> createState() => _LearningSessionState();
}

class _LearningSessionState extends State<LearningSession>
    with TickerProviderStateMixin {
  // Voice and audio controllers
  final AudioRecorder _audioRecorder = AudioRecorder();
  RecorderController? _recorderController;
  PlayerController? _playerController;

  // Session state
  bool _isVoiceActive = false;
  bool _isListening = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  double _sessionProgress = 0.0;
  int _currentStep = 1;
  String _currentVoiceCommand = '';
  String _lastTTSMessage = '';

  // Current lesson data
  Map<String, dynamic> _currentLesson = {};
  int _currentLessonIndex = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock lesson data
  final List<Map<String, dynamic>> _lessons = [
    {
      "id": 1,
      "title": "Introduction to Flutter Widgets",
      "type": "video",
      "videoUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
      "duration": 300,
      "description":
          "Learn the fundamentals of Flutter widgets and how they work together to create beautiful UIs.",
      "milestones": [
        "Introduction",
        "Basic Widgets",
        "Layout Widgets",
        "Interactive Widgets",
        "Summary"
      ],
    },
    {
      "id": 2,
      "title": "Dart Programming Basics",
      "type": "coding",
      "language": "dart",
      "code":
          """void main() { // Welcome to Dart programming! print('Hello, Flutter!'); // Variables and data types String name = 'Flutter Developer'; int age = 25; double height = 5.9; bool isLearning = true; // Print user information print('Name: \$name'); print('Age: \$age'); print('Height: \$height ft'); print('Learning Flutter: \$isLearning'); }""",
      "description":
          "Practice Dart programming fundamentals with hands-on coding exercises.",
      "milestones": ["Setup", "Variables", "Functions", "Classes", "Testing"],
    },
    {
      "id": 3,
      "title": "Flutter State Management Quiz",
      "type": "quiz",
      "questions": [
        {
          "question": "What is the primary purpose of setState() in Flutter?",
          "options": [
            "To create new widgets",
            "To update the UI when data changes",
            "To handle user input",
            "To manage app navigation"
          ],
          "correctAnswer": "To update the UI when data changes"
        },
        {
          "question":
              "Which widget is used for managing state across multiple screens?",
          "options": [
            "StatefulWidget",
            "StatelessWidget",
            "InheritedWidget",
            "Container"
          ],
          "correctAnswer": "InheritedWidget"
        },
        {
          "question":
              "What does the 'build' method return in a Flutter widget?",
          "options": ["A String", "A Widget", "A Function", "A State object"],
          "correctAnswer": "A Widget"
        }
      ],
      "description":
          "Test your knowledge of Flutter state management concepts.",
      "milestones": [
        "Start Quiz",
        "Question 1",
        "Question 2",
        "Question 3",
        "Results"
      ],
    },
    {
      "id": 4,
      "title": "Understanding Flutter Architecture",
      "type": "text",
      "content":
          """Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. ## Key Concepts: ### 1. Everything is a Widget In Flutter, everything you see on the screen is a widget. Widgets are the basic building blocks of a Flutter app's user interface. ### 2. Widget Tree Flutter apps are built using a tree of widgets. Each widget can contain other widgets, creating a hierarchical structure. ### 3. State Management Flutter provides several ways to manage state: - StatefulWidget for local state - InheritedWidget for sharing state - Provider pattern for complex state management - Bloc pattern for reactive programming ### 4. Hot Reload One of Flutter's most powerful features is hot reload, which allows you to see changes instantly without losing app state. ### 5. Cross-Platform Development Write once, run anywhere - Flutter compiles to native code for each platform while maintaining consistent UI and behavior. This foundation will help you build robust, scalable Flutter applications.""",
      "description":
          "Comprehensive overview of Flutter's architecture and core principles.",
      "milestones": [
        "Introduction",
        "Widgets",
        "State",
        "Hot Reload",
        "Cross-Platform"
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _setupAnimations();
    _loadCurrentLesson();
  }

  void _initializeSession() async {
    // Initialize audio controllers
    _recorderController = RecorderController();
    _playerController = PlayerController();

    // Request permissions
    await _requestPermissions();

    // Set system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );

    // Keep screen on during learning session
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  void _loadCurrentLesson() {
    if (_currentLessonIndex < _lessons.length) {
      setState(() {
        _currentLesson = _lessons[_currentLessonIndex];
        _sessionProgress = (_currentLessonIndex + 1) / _lessons.length;
        _currentStep = _currentLessonIndex + 1;
      });
      _announceLesson();
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.speech.request();
  }

  void _announceLesson() {
    final announcement =
        "Starting lesson: ${_currentLesson['title']}. ${_currentLesson['description']}";
    _speakText(announcement);
  }

  void _speakText(String text) {
    setState(() {
      _lastTTSMessage = text;
    });
    // In a real implementation, this would use flutter_tts
    print("TTS: $text");
  }

  void _toggleVoiceActivation() async {
    if (_isVoiceActive) {
      await _stopVoiceListening();
    } else {
      await _startVoiceListening();
    }
  }

  Future<void> _startVoiceListening() async {
    if (await Permission.microphone.isGranted) {
      setState(() {
        _isVoiceActive = true;
        _isListening = true;
      });
      _speakText("Voice assistant activated. You can now give voice commands.");

      // Simulate voice recognition
      Future.delayed(Duration(seconds: 2), () {
        if (_isListening) {
          _processVoiceCommand("Hello Sweety");
        }
      });
    }
  }

  Future<void> _stopVoiceListening() async {
    setState(() {
      _isVoiceActive = false;
      _isListening = false;
      _isRecording = false;
    });
    _speakText("Voice assistant deactivated.");
  }

  void _processVoiceCommand(String command) {
    setState(() {
      _currentVoiceCommand = command;
      _isListening = false;
    });

    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('hello sweety')) {
      _speakText(
          "Hello! I'm here to help you learn. What would you like to do?");
    } else if (lowerCommand.contains('explain this concept')) {
      _explainCurrentConcept();
    } else if (lowerCommand.contains('repeat that section')) {
      _repeatSection();
    } else if (lowerCommand.contains('take notes')) {
      _takeNotes();
    } else if (lowerCommand.contains('next lesson')) {
      _nextLesson();
    } else if (lowerCommand.contains('previous lesson')) {
      _previousLesson();
    } else if (lowerCommand.contains('pause') ||
        lowerCommand.contains('stop')) {
      _pauseSession();
    } else if (lowerCommand.contains('play') ||
        lowerCommand.contains('resume')) {
      _resumeSession();
    } else if (lowerCommand.contains('speed up')) {
      _changePlaybackSpeed(_playbackSpeed + 0.25);
    } else if (lowerCommand.contains('slow down')) {
      _changePlaybackSpeed(_playbackSpeed - 0.25);
    } else if (lowerCommand.contains('run code')) {
      _runCode();
    } else if (lowerCommand.contains('reset code')) {
      _resetCode();
    } else {
      _speakText(
          "I didn't understand that command. Try saying 'explain this concept', 'next lesson', or 'take notes'.");
    }

    // Resume listening after processing command
    Future.delayed(Duration(seconds: 2), () {
      if (_isVoiceActive) {
        setState(() {
          _isListening = true;
        });
      }
    });
  }

  void _explainCurrentConcept() {
    final explanation =
        "Let me explain the current concept: ${_currentLesson['description']}";
    _speakText(explanation);
  }

  void _repeatSection() {
    _speakText("Repeating the current section. ${_currentLesson['title']}");
  }

  void _takeNotes() {
    _speakText(
        "Note taken for ${_currentLesson['title']}. You can review your notes later in the profile section.");
  }

  void _nextLesson() {
    if (_currentLessonIndex < _lessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
      });
      _loadCurrentLesson();
    } else {
      _speakText(
          "Congratulations! You've completed all lessons in this session.");
      _completeSession();
    }
  }

  void _previousLesson() {
    if (_currentLessonIndex > 0) {
      setState(() {
        _currentLessonIndex--;
      });
      _loadCurrentLesson();
    } else {
      _speakText("This is the first lesson in the session.");
    }
  }

  void _pauseSession() {
    setState(() {
      _isPlaying = false;
    });
    _speakText("Session paused. Say 'resume' to continue.");
  }

  void _resumeSession() {
    setState(() {
      _isPlaying = true;
    });
    _speakText("Session resumed.");
  }

  void _changePlaybackSpeed(double newSpeed) {
    final clampedSpeed = newSpeed.clamp(0.5, 2.0);
    setState(() {
      _playbackSpeed = clampedSpeed;
    });
    _speakText("Playback speed changed to ${clampedSpeed}x");
  }

  void _runCode() {
    _speakText(
        "Running code... Code executed successfully. Check the output below.");
  }

  void _resetCode() {
    _speakText("Code has been reset to the original state.");
  }

  void _completeSession() {
    _speakText("Excellent work! Session completed. Returning to dashboard.");
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  void _onMilestoneReached(String milestone) {
    _speakText("Milestone reached: $milestone. Great progress!");
  }

  void _onVoiceCommand(String message) {
    _speakText(message);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _recorderController?.dispose();
    _playerController?.dispose();
    _audioRecorder.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Progress indicator at top
              ProgressIndicatorWidget(
                progress: _sessionProgress,
                lessonTitle:
                    _currentLesson['title'] as String? ?? 'Learning Session',
                currentStep: _currentStep,
                totalSteps: _lessons.length,
                milestones: (_currentLesson['milestones'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    [],
                onMilestoneReached: _onMilestoneReached,
              ),

              // Main content area
              Expanded(
                child: Stack(
                  children: [
                    // Lesson content
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: LessonContentWidget(
                          lesson: _currentLesson,
                          onVoiceCommand: _onVoiceCommand,
                          isVoiceActive: _isVoiceActive,
                        ),
                      ),
                    ),

                    // Voice waveform overlay (appears when voice is active)
                    if (_isVoiceActive)
                      Positioned(
                        bottom: 20.h,
                        left: 4.w,
                        right: 4.w,
                        child: VoiceWaveformWidget(
                          isListening: _isListening,
                          isRecording: _isRecording,
                          recorderController: _recorderController,
                          playerController: _playerController,
                        ),
                      ),

                    // Floating controls
                    FloatingControlsWidget(
                      isPlaying: _isPlaying,
                      isVoiceActive: _isVoiceActive,
                      playbackSpeed: _playbackSpeed,
                      onPlayPause: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        _speakText(_isPlaying ? "Playing" : "Paused");
                      },
                      onVoiceToggle: _toggleVoiceActivation,
                      onSpeedChange: _changePlaybackSpeed,
                      onPrevious:
                          _currentLessonIndex > 0 ? _previousLesson : null,
                      onNext: _currentLessonIndex < _lessons.length - 1
                          ? _nextLesson
                          : null,
                      onSettings: () {
                        _speakText("Opening session settings");
                        _showSessionSettings();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 4,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session Settings',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'volume_up',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    title: Text('Audio Settings'),
                    subtitle: Text('Adjust voice and playback settings'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _speakText("Audio settings opened");
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'accessibility',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    title: Text('Accessibility'),
                    subtitle: Text('Voice commands and navigation'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _speakText("Accessibility settings opened");
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'exit_to_app',
                      color: AppTheme.getSemanticColor('error', isLight: true),
                      size: 24,
                    ),
                    title: Text('Exit Session'),
                    subtitle: Text('Return to dashboard'),
                    onTap: () {
                      Navigator.pop(context);
                      _speakText("Exiting learning session");
                      Navigator.pushReplacementNamed(
                          context, '/home-dashboard');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
