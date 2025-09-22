import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../core/services/voice_service.dart';
import '../voice_dashboard/widgets/ai_button_widget.dart';

class VoiceAIAssistantChat extends StatefulWidget {
  const VoiceAIAssistantChat({super.key});

  @override
  State<VoiceAIAssistantChat> createState() => _VoiceAIAssistantChatState();
}

class _VoiceAIAssistantChatState extends State<VoiceAIAssistantChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final VoiceService _voiceService = VoiceService();

  bool _isTyping = false;
  String? _error;
  bool _isVoiceMode = false;
  bool _isListening = false;

  StreamController<String>? _responseStream;

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _voiceService.dispose();
    _responseStream?.close();
    super.dispose();
  }

  void _initializeVoiceService() {
    _voiceService.onVoiceCommand = _handleVoiceCommand;
    _voiceService.onTranscription = _handleTranscription;
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

  void _handleVoiceCommand(String command) {
    switch (command) {
      case 'open_ai_assistant':
        // Already in AI assistant
        _voiceService
            .speak('AI assistant is already open. How can I help you?');
        break;
      case 'show_courses':
        Navigator.pop(context);
        Navigator.pushNamed(context, '/courses');
        _voiceService.speak('Opening your courses.');
        break;
      case 'show_schedule':
        Navigator.pop(context);
        Navigator.pushNamed(context, '/schedule');
        _voiceService.speak('Opening your schedule.');
        break;
      case 'show_progress':
        Navigator.pop(context);
        Navigator.pushNamed(context, '/progress');
        _voiceService.speak('Opening your progress.');
        break;
      case 'start_learning':
        Navigator.pop(context);
        Navigator.pushNamed(context, '/learning');
        _voiceService.speak('Starting your learning session.');
        break;
      default:
        if (command.startsWith('process_command:')) {
          final voiceText = command.replaceFirst('process_command:', '');
          _processVoiceMessage(voiceText);
        }
        break;
    }
  }

  void _handleTranscription(String text) {
    if (text.isNotEmpty && _isVoiceMode) {
      _messageController.text = text;
    }
  }

  void _processVoiceMessage(String voiceText) {
    if (voiceText.isEmpty) return;

    // Add user message to chat
    setState(() {
      _messages.add(ChatMessage(
        text: voiceText,
        isUser: true,
        timestamp: DateTime.now(),
        isVoice: true,
      ));
      _isTyping = true;
      _error = null;
    });

    _scrollToBottom();
    _sendAITextMessage(voiceText);
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

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
      _error = null;
      _messageController.clear();
    });

    _scrollToBottom();
    await _sendAITextMessage(message);
  }

  Future<void> _sendAITextMessage(String message) async {
    try {
      final dio = Dio();
      final apiKey = EnvService.getPerplexityApiKey();

      if (apiKey.isEmpty) {
        throw Exception('Perplexity API key not found');
      }

      final response = await dio.post(
        'https://api.perplexity.ai/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'llama-3.1-sonar-small-128k-online',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful AI learning assistant. Provide clear, concise, and educational responses to help users with their learning journey. Keep responses conversational and engaging, suitable for voice interaction.'
            },
            ..._messages
                .where((m) => !m.isUser)
                .map((m) => {'role': 'assistant', 'content': m.text}),
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final assistantMessage =
            response.data['choices'][0]['message']['content'];

        setState(() {
          _messages.add(ChatMessage(
            text: assistantMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });

        _scrollToBottom();

        // Speak the response if in voice mode
        if (_isVoiceMode) {
          await _voiceService.speak(assistantMessage);
        }
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
        _error = 'Error: ${e.toString()}';
      });
    }
  }

  void _toggleVoiceMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });

    if (_isVoiceMode) {
      _voiceService.speak('Voice mode activated. How can I help you?');
    } else {
      _voiceService.stopSpeaking();
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _voiceService.stopListening();
    } else {
      _voiceService.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'AI Learning Assistant',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isVoiceMode ? Icons.mic : Icons.mic_none,
              color: _isVoiceMode
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
            onPressed: _toggleVoiceMode,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isVoiceMode)
            Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Voice mode is active. Tap the mic button to speak or type your message.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              color: AppTheme.lightTheme.scaffoldBackgroundColor,
              child: _messages.isEmpty
                  ? _buildWelcomeMessage()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isTyping) {
                          return _buildTypingIndicator();
                        }
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
          ),
          if (_error != null)
            Container(
              padding: EdgeInsets.all(4.w),
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              child: Text(
                _error!,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isVoiceMode ? Icons.mic : Icons.smart_toy,
              size: 12.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _isVoiceMode
                ? 'Voice Assistant is Listening'
                : 'Hello! I\'m your AI Learning Assistant',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _isVoiceMode
                ? 'Tap the microphone button and ask me anything about your learning journey!'
                : 'Ask me anything about your learning journey,\ncourse recommendations, or study tips!',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'AI is thinking...',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              child: CircleAvatar(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: Icon(
                  Icons.smart_toy,
                  size: 4.w,
                  color: Colors.white,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: message.isUser
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (message.isVoice && message.isUser) SizedBox(height: 1.h),
                  if (message.isVoice && message.isUser)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic,
                          size: 3.w,
                          color: message.isUser
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Voice',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: message.isUser
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (message.isUser)
            Container(
              margin: EdgeInsets.only(left: 2.w),
              child: CircleAvatar(
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                child: Icon(
                  Icons.person,
                  size: 4.w,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_isVoiceMode)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              decoration: BoxDecoration(
                color: _isListening
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: _isListening
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
                onPressed: _toggleListening,
              ),
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: _isVoiceMode
                      ? 'Tap mic to speak or type...'
                      : 'Ask me anything...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 3.w),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isVoice;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isVoice = false,
  });
}
