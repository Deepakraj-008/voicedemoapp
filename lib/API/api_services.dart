// lib/voice_api.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../core/env_service.dart';

class TranscriptResult {
  final String transcript;
  final String intent;
  final String responseText;
  final String? ttsUrl;
  TranscriptResult(
      {required this.transcript,
      required this.intent,
      required this.responseText,
      this.ttsUrl});

  factory TranscriptResult.fromJson(Map<String, dynamic> j) => TranscriptResult(
        transcript: j['transcript'] ?? '',
        intent: j['intent'] ?? '',
        responseText: j['response_text'] ?? '',
        ttsUrl: j['tts_url'] as String?,
      );
}

class VoiceApi {
  static String BACKEND_URL = "http://127.0.0.1:8003";
  static bool _envLoaded = false;

  static Future<void> _ensureEnvLoaded() async {
    if (!_envLoaded) {
      await EnvService.loadEnv();
      _envLoaded = true;
    }
  }

  static Future<TranscriptResult> sendAudio(File file) async {
    await _ensureEnvLoaded();
    final uri = Uri.parse('$BACKEND_URL/transcribe');
    final req = http.MultipartRequest('POST', uri);
    req.files.add(await http.MultipartFile.fromPath('file', file.path,
        filename: 'voice.m4a'));
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode != 200) {
      throw Exception('Server error ${resp.statusCode}: ${resp.body}');
    }
    return TranscriptResult.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> queryPerplexity(String query) async {
    await _ensureEnvLoaded();
    final apiKey = EnvService.getPerplexityApiKey();
    if (apiKey.isEmpty) {
      throw Exception('Perplexity API key not found in environment');
    }

    final uri = Uri.parse('$BACKEND_URL/perplexity');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Perplexity API error ${response.statusCode}: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getBackendDocs() async {
    final uri = Uri.parse('$BACKEND_URL/docs');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
          'Backend docs error ${response.statusCode}: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
