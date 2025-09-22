import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../core/env_service.dart';

class AIAssistantChat extends StatefulWidget {
  const AIAssistantChat({super.key});

  @override
  State<AIAssistantChat> createState() => _AIAssistantChatState();
}

class _AIAssistantChatState extends State<AIAssistantChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _error;
  StreamController<String>? _responseStream;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _responseStream?.close();
    super.dispose();
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

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

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
                  'You are a helpful AI learning assistant. Provide clear, concise, and educational responses to help users with their learning journey.'
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

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
      ),
      body: Column(
        children: [
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
              Icons.smart_toy,
              size: 12.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Hello! I\'m your AI Learning Assistant',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Ask me anything about your learning journey,\ncourse recommendations, or study tips!',
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
              child: Text(
                message.text,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: message.isUser
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
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
                  hintText: 'Ask me anything...',
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

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
