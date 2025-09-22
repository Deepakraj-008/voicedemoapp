import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:fluttertoast/fluttertoast.dart';
import '../env_service.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isListening = false;
  bool _isSpeaking = false;
  String _lastWords = '';
  Timer? _listeningTimer;

  // Callbacks for voice commands
  Function(String)? onVoiceCommand;
  Function(String)? onTranscription;
  VoidCallback? onListeningStart;
  VoidCallback? onListeningStop;

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get lastWords => _lastWords;

  Future<void> initialize() async {
    try {
      // Initialize Speech to Text
      await _speechToText.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      // Initialize Text to Speech
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) {
          print('TTS Error: $msg');
        }
      });

      if (kDebugMode) {
        print('Voice service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing voice service: $e');
      }
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final microphoneStatus = await Permission.microphone.request();
      final speechStatus = await Permission.speech.request();

      return microphoneStatus.isGranted && speechStatus.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
      return false;
    }
  }

  Future<void> startListening() async {
    if (_isListening) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      Fluttertoast.showToast(
        msg: 'Microphone permission required',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    if (!_speechToText.isAvailable) {
      Fluttertoast.showToast(
        msg: 'Speech recognition not available',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      _isListening = true;
      _lastWords = '';

      onListeningStart?.call();

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );

      // Auto-stop listening after 30 seconds
      _listeningTimer = Timer(const Duration(seconds: 30), () {
        stopListening();
      });

      if (kDebugMode) {
        print('Started listening...');
      }
    } catch (e) {
      _isListening = false;
      if (kDebugMode) {
        print('Error starting speech recognition: $e');
      }
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _listeningTimer?.cancel();
      _isListening = false;

      onListeningStop?.call();

      if (_lastWords.isNotEmpty) {
        _processVoiceCommand(_lastWords);
      }

      if (kDebugMode) {
        print('Stopped listening. Words: $_lastWords');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping speech recognition: $e');
      }
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print('Error speaking text: $e');
      }
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping speech: $e');
      }
    }
  }

  void _onSpeechStatus(String status) {
    if (kDebugMode) {
      print('Speech status: $status');
    }
  }

  void _onSpeechError(error) {
    _isListening = false;
    if (kDebugMode) {
      print('Speech error: $error');
    }
    Fluttertoast.showToast(
      msg: 'Speech recognition error occurred',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _onSpeechResult(result) {
    _lastWords = result.recognizedWords;
    onTranscription?.call(_lastWords);

    if (result.finalResult) {
      stopListening();
    }
  }

  void _processVoiceCommand(String command) {
    if (command.isEmpty) return;

    // Convert to lowercase for easier matching
    final processedCommand = command.toLowerCase().trim();

    if (kDebugMode) {
      print('Processing voice command: $processedCommand');
    }

    // Common voice commands
    if (processedCommand.contains('hello') || processedCommand.contains('hi')) {
      speak('Hello! How can I help you with your learning today?');
      return;
    }

    if (processedCommand.contains('help')) {
      speak(
          'I can help you with your learning journey. Try saying: show my courses, start learning, what should I study today, or open AI assistant.');
      return;
    }

    if (processedCommand.contains('ai') ||
        processedCommand.contains('assistant')) {
      onVoiceCommand?.call('open_ai_assistant');
      return;
    }

    if (processedCommand.contains('courses') ||
        processedCommand.contains('my courses')) {
      onVoiceCommand?.call('show_courses');
      return;
    }

    if (processedCommand.contains('schedule') ||
        processedCommand.contains('calendar')) {
      onVoiceCommand?.call('show_schedule');
      return;
    }

    if (processedCommand.contains('progress') ||
        processedCommand.contains('achievements')) {
      onVoiceCommand?.call('show_progress');
      return;
    }

    if (processedCommand.contains('study') ||
        processedCommand.contains('learn')) {
      onVoiceCommand?.call('start_learning');
      return;
    }

    if (processedCommand.contains('stop') ||
        processedCommand.contains('quiet')) {
      stopSpeaking();
      return;
    }

    // If no specific command matched, forward to AI for processing
    onVoiceCommand?.call('process_command:$processedCommand');
  }

  void dispose() {
    _listeningTimer?.cancel();
    _speechToText.stop();
    _flutterTts.stop();
  }
}
