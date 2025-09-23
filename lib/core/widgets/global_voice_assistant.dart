import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../services/voice_service.dart';
import '../../presentation/ai_assistant_chat/voice_ai_assistant_chat.dart';

class GlobalVoiceAssistant extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  const GlobalVoiceAssistant({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  @override
  State<GlobalVoiceAssistant> createState() => _GlobalVoiceAssistantState();
}

class _GlobalVoiceAssistantState extends State<GlobalVoiceAssistant> {
  final VoiceService _voiceService = VoiceService();
  bool _isVoiceAssistantActive = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  void _initializeVoiceService() {
    _voiceService.onVoiceCommand = _handleGlobalVoiceCommand;
    _voiceService.onListeningStart = () {
      setState(() {
        _isListening = true;
      });
    };
    _voiceService.onListeningStop = () {
      setState(() {
        _isListening = false;
      });
    };
  }

  void _handleGlobalVoiceCommand(String command) {
    final context = widget.navigatorKey?.currentContext;
    if (context == null) return;

    switch (command) {
      case 'open_ai_assistant':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VoiceAIAssistantChat(),
          ),
        );
        break;
      case 'show_courses':
        Navigator.pushNamed(context, '/courses');
        _voiceService.speak('Opening your courses.');
        break;
      case 'show_schedule':
        Navigator.pushNamed(context, '/schedule');
        _voiceService.speak('Opening your schedule.');
        break;
      case 'show_progress':
        Navigator.pushNamed(context, '/progress');
        _voiceService.speak('Opening your progress.');
        break;
      case 'start_learning':
        Navigator.pushNamed(context, '/learning');
        _voiceService.speak('Starting your learning session.');
        break;
      case 'help':
        _voiceService.speak(
            'I can help you navigate the app. Try saying: open AI assistant, show my courses, show schedule, show progress, or start learning.');
        break;
      default:
        if (command.startsWith('process_command:')) {
          final voiceText = command.replaceFirst('process_command:', '');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VoiceAIAssistantChat(),
            ),
          );
        }
        break;
    }
  }

  void _toggleVoiceAssistant() {
    setState(() {
      _isVoiceAssistantActive = !_isVoiceAssistantActive;
    });

    if (_isVoiceAssistantActive) {
      _voiceService.speak(
          'Voice assistant activated. Say "help" for available commands.');
    } else {
      _voiceService.stopSpeaking();
      _voiceService.stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        widget.child,

        // Listening Indicator
        if (_isListening)
          Positioned(
            right: 6.w,
            bottom: 32.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  const Text(
                    'Listening...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Voice Command Overlay
        if (_isVoiceAssistantActive)
          Positioned(
            top: 10.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voice Assistant Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Say "help" for commands or tap the mic to speak',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_isListening) {
                            _voiceService.stopListening();
                          } else {
                            _voiceService.startListening();
                          }
                        },
                        icon: Icon(_isListening ? Icons.stop : Icons.mic),
                        label: Text(_isListening ? 'Stop' : 'Listen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isListening ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      ElevatedButton.icon(
                        onPressed: () {
                          _voiceService.stopSpeaking();
                          _voiceService.stopListening();
                        },
                        icon: const Icon(Icons.volume_off),
                        label: const Text('Mute'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Global navigator key for accessing context from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
