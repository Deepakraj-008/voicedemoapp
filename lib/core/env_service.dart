import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class EnvService {
  static Map<String, dynamic> _env = {};

  static Future<void> loadEnv() async {
    try {
      final String response = await rootBundle.loadString('env.json');
      _env = json.decode(response);
    } catch (e) {
      // Fallback to loading from file for development
      try {
        final file = File('env.json');
        if (await file.exists()) {
          final String content = await file.readAsString();
          _env = json.decode(content);
        }
      } catch (fileError) {
        print('Error loading env.json: $fileError');
        _env = {};
      }
    }
  }

  static String? get(String key) {
    return _env[key]?.toString();
  }

  static String getPerplexityApiKey() {
    return get('PERPLEXITY_API_KEY') ?? '';
  }

  static String getSupabaseUrl() {
    return get('SUPABASE_URL') ?? '';
  }

  static String getSupabaseAnonKey() {
    return get('SUPABASE_ANON_KEY') ?? '';
  }

  static String getOpenaiApiKey() {
    return get('OPENAI_API_KEY') ?? '';
  }

  static String getGeminiApiKey() {
    return get('GEMINI_API_KEY') ?? '';
  }

  static String getAnthropicApiKey() {
    return get('ANTHROPIC_API_KEY') ?? '';
  }
}
