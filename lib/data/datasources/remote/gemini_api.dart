import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../domain/entities/agent.dart';
import '../../../domain/entities/message.dart';

class GeminiApi {
  final String apiKey;
  late GenerativeModel _model;

  GeminiApi({required this.apiKey}) {
    _setup();
  }

  void _setup() {
    if (apiKey.isEmpty) {
      debugPrint('API key missing');
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
  }

  Future<String> generateResponse({
    required Agent agent,
    required List<Message> chatHistory, 
    required String userMessage,
  }) async {
    try {

      final prompt = 'You are ${agent.name}.\n${agent.description}\n${agent.personality}\n\n';
      
      String history = '';
      for (var msg in chatHistory) {
        String role = msg.isUser ? 'User' : agent.name;
        history += '$role: ${msg.text}\n';
      }
      
      final fullPrompt = '$prompt$history\nUser: $userMessage\n${agent.name}:';

      print("shafoon: $fullPrompt");
      
      final response = await _model.generateContent([Content.text(fullPrompt)]);
      return response.text ?? _defaultResponse(agent);
    } catch (e) {
      debugPrint('API error: $e');
      return _defaultResponse(agent);
    }
  }

  String _defaultResponse(Agent agent) {
    return "Could you provide more details so I can assist you better?";
  }
}