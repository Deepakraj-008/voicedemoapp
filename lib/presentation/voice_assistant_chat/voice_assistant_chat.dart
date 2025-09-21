import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/quick_suggestions_widget.dart';
import './widgets/voice_input_widget.dart';

class VoiceAssistantChat extends StatefulWidget {
  const VoiceAssistantChat({Key? key}) : super(key: key);

  @override
  State<VoiceAssistantChat> createState() => _VoiceAssistantChatState();
}

class _VoiceAssistantChatState extends State<VoiceAssistantChat>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isListening = false;
  bool _isProcessing = false;
  bool _isTyping = false;
  bool _showSuggestions = true;
  String _currentTranscript = '';

  List<Map<String, dynamic>> _messages = [];

  // Mock conversation data
  final List<Map<String, dynamic>> _mockConversations = [
    {
      "id": 1,
      "message":
          "Hello! I'm Sweety, your AI learning assistant. How can I help you with your studies today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "isTyping": false,
    },
    {
      "id": 2,
      "message": "Can you help me understand quantum physics concepts?",
      "isUser": true,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 4)),
      "isTyping": false,
    },
    {
      "id": 3,
      "message":
          "Absolutely! Quantum physics deals with the behavior of matter and energy at the smallest scales. Let me break down the key concepts:\n\n1. **Wave-Particle Duality**: Particles can exhibit both wave and particle properties\n2. **Uncertainty Principle**: You cannot simultaneously know both position and momentum precisely\n3. **Superposition**: Particles can exist in multiple states simultaneously\n\nWould you like me to explain any of these concepts in more detail?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
      "isTyping": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _requestPermissions();
  }

  void _initializeChat() {
    setState(() {
      _messages = List.from(_mockConversations);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _startListening() async {
    if (await _audioRecorder.hasPermission()) {
      setState(() {
        _isListening = true;
        _showSuggestions = false;
      });

      try {
        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_input.m4a');

        // Simulate voice recognition after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (_isListening) {
            _stopListening();
          }
        });
      } catch (e) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
        _isProcessing = true;
      });

      try {
        await _audioRecorder.stop();

        // Simulate voice processing and transcription
        await Future.delayed(const Duration(seconds: 2));

        final transcribedText = _getRandomVoiceInput();
        _processVoiceInput(transcribedText);
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _getRandomVoiceInput() {
    final voiceInputs = [
      "Explain the concept of machine learning",
      "Help me create a study schedule for next week",
      "Generate some practice problems for calculus",
      "What are the key principles of data structures?",
      "Can you help me understand neural networks?",
    ];
    return voiceInputs[DateTime.now().millisecond % voiceInputs.length];
  }

  void _processVoiceInput(String input) {
    setState(() {
      _isProcessing = false;
      _currentTranscript = input;
    });

    _sendMessage(input);
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final userMessage = {
      "id": _messages.length + 1,
      "message": message.trim(),
      "isUser": true,
      "timestamp": DateTime.now(),
      "isTyping": false,
    };

    setState(() {
      _messages.add(userMessage);
      _textController.clear();
      _showSuggestions = false;
    });

    _scrollToBottom();
    _generateAIResponse(message);
  }

  void _generateAIResponse(String userMessage) {
    // Add typing indicator
    final typingMessage = {
      "id": _messages.length + 1,
      "message": "",
      "isUser": false,
      "timestamp": DateTime.now(),
      "isTyping": true,
    };

    setState(() {
      _messages.add(typingMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI processing time
    Future.delayed(const Duration(seconds: 2), () {
      final aiResponse = _getAIResponse(userMessage);

      setState(() {
        _messages.removeLast(); // Remove typing indicator
        _messages.add({
          "id": _messages.length + 1,
          "message": aiResponse,
          "isUser": false,
          "timestamp": DateTime.now(),
          "isTyping": false,
        });
        _isTyping = false;
        _showSuggestions = _messages.length <= 3;
      });

      _scrollToBottom();
    });
  }

  String _getAIResponse(String userMessage) {
    final responses = {
      "machine learning":
          "Machine Learning is a subset of artificial intelligence that enables computers to learn and improve from experience without being explicitly programmed. Here are the key types:\n\n**Supervised Learning**: Uses labeled data to train models\n**Unsupervised Learning**: Finds patterns in unlabeled data\n**Reinforcement Learning**: Learns through trial and error with rewards\n\nWould you like me to dive deeper into any specific type?",
      "study schedule":
          "I'd be happy to help you create an effective study schedule! Here's a framework:\n\n**1. Assess your subjects and priorities**\n**2. Use the Pomodoro Technique (25min study + 5min break)**\n**3. Schedule difficult subjects when you're most alert**\n**4. Include regular review sessions**\n**5. Plan breaks and rewards**\n\nWhat subjects are you currently studying? I can create a personalized schedule for you.",
      "calculus":
          "Here are some calculus practice problems to strengthen your skills:\n\n**Derivatives:**\n1. Find f'(x) if f(x) = 3x³ - 2x² + 5x - 1\n2. Find the derivative of sin(2x) + cos(x²)\n\n**Integrals:**\n1. ∫(2x + 3)dx\n2. ∫x²e^x dx (integration by parts)\n\n**Applications:**\n1. Find the maximum value of f(x) = -x² + 4x + 1\n\nWould you like me to work through any of these step by step?",
      "data structures":
          "Data structures are fundamental concepts in computer science. Here are the key principles:\n\n**1. Arrays**: Fixed-size sequential collection\n**2. Linked Lists**: Dynamic size with node connections\n**3. Stacks**: LIFO (Last In, First Out) principle\n**4. Queues**: FIFO (First In, First Out) principle\n**5. Trees**: Hierarchical structure with parent-child relationships\n**6. Hash Tables**: Key-value pairs for fast lookup\n\nEach has specific use cases and time complexities. Which one would you like to explore in detail?",
      "neural networks":
          "Neural networks are computing systems inspired by biological neural networks. Here's how they work:\n\n**Basic Components:**\n- **Neurons (Nodes)**: Process and transmit information\n- **Weights**: Determine connection strength\n- **Bias**: Helps adjust the output\n- **Activation Functions**: Determine neuron output\n\n**Learning Process:**\n1. Forward propagation: Data flows through network\n2. Loss calculation: Compare output to expected result\n3. Backpropagation: Adjust weights to minimize error\n\nWould you like me to explain any specific aspect in more detail?",
    };

    final lowerMessage = userMessage.toLowerCase();
    for (final key in responses.keys) {
      if (lowerMessage.contains(key)) {
        return responses[key]!;
      }
    }

    return "That's an interesting question! I'm here to help you learn and understand complex topics. Could you provide more context about what you'd like to explore? I can assist with:\n\n• Explaining concepts and theories\n• Creating study materials\n• Generating practice problems\n• Planning study schedules\n• Reviewing your progress\n\nWhat specific area would you like to focus on?";
  }

  void _onSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  void _speakMessage(String message) {
    // Simulate text-to-speech functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Speaking: ${message.substring(0, message.length > 50 ? 50 : message.length)}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message bookmarked successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message shared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildChatArea(),
          ),
          if (_showSuggestions)
            QuickSuggestionsWidget(
              onSuggestionTap: _onSuggestionTap,
              isVisible: _showSuggestions,
            ),
          VoiceInputWidget(
            textController: _textController,
            isListening: _isListening,
            isProcessing: _isProcessing,
            onStartListening: _startListening,
            onStopListening: _stopListening,
            onSendMessage: () => _sendMessage(_textController.text),
            onTextChanged: (text) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ),
      title: Row(
        children: [
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
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sweety AI Assistant',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isListening
                      ? 'Listening...'
                      : _isProcessing
                          ? 'Processing...'
                          : _isTyping
                              ? 'Typing...'
                              : 'Online',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _isListening || _isProcessing || _isTyping
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'home':
                _navigateToScreen('/home-dashboard');
                break;
              case 'schedule':
                _navigateToScreen('/study-schedule');
                break;
              case 'learning':
                _navigateToScreen('/learning-session');
                break;
              case 'profile':
                _navigateToScreen('/profile-settings');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'home',
              child: Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 8),
                  Text('Home Dashboard'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'schedule',
              child: Row(
                children: [
                  Icon(Icons.schedule),
                  SizedBox(width: 8),
                  Text('Study Schedule'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'learning',
              child: Row(
                children: [
                  Icon(Icons.school),
                  SizedBox(width: 8),
                  Text('Learning Session'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('Profile Settings'),
                ],
              ),
            ),
          ],
          child: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return MessageBubbleWidget(
            message: message['message'] as String,
            isUser: message['isUser'] as bool,
            timestamp: message['timestamp'] as DateTime,
            isTyping: message['isTyping'] as bool? ?? false,
            onSpeakMessage: message['isUser'] as bool
                ? null
                : () => _speakMessage(message['message'] as String),
            onBookmark: message['isUser'] as bool
                ? null
                : () => _bookmarkMessage(message['message'] as String),
            onShare: message['isUser'] as bool
                ? null
                : () => _shareMessage(message['message'] as String),
          );
        },
      ),
    );
  }
}