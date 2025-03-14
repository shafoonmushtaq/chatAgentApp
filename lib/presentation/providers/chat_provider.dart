import 'package:flutter/foundation.dart';
import '../../domain/entities/agent.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/chat_usecases.dart';

class ChatProvider extends ChangeNotifier {
  final GetMessages getMessages;
  final AddMessage addMessage;
  final GenerateAIResponse generateAIResponse;
  
  List<Message> _messages = [];
  String _currentAgentId = '';
  bool _isLoading = false;
  bool _isTyping = false;
  String? _error;
  
  ChatProvider({
    required this.getMessages,
    required this.addMessage,
    required this.generateAIResponse,
  });
  
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isTyping => _isTyping;
  String? get error => _error;
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }
  
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }
  
  void _setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }
  
  Message _createMessage(String text, bool isUser, String agentId) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
      agentId: agentId,
    );
  }
  
  Future<void> _addMessageToState(Message message) async {
    await addMessage(message);
    _messages = [..._messages, message];
    notifyListeners();
  }
  
  Future<void> loadMessages(String agentId) async {
    if (_currentAgentId != agentId) {
      _messages = [];
      _currentAgentId = agentId;
    }
    
    _setLoading(true);
    
    try {
      _messages = await getMessages(agentId);
    } catch (e) {
      _setError('Failed to load messages: $e');
    } finally {
      if (_isLoading) _setLoading(false);
    }
  }
  
  Future<void> sendMessage(Agent agent, String messageText) async {
    try {
      final userMessage = _createMessage(messageText, true, agent.id);
      await _addMessageToState(userMessage);
      
      _setTyping(true);
      
      final response = await generateAIResponse(
        agent,
        _messages,
        messageText,
      );
      
      final aiMessage = _createMessage(response, false, agent.id);
      await _addMessageToState(aiMessage);
    } catch (e) {
      _setError('Failed to send message: $e');
    } finally {
      if (_isTyping) _setTyping(false);
    }
  }
  
  void resetError() {
    _error = null;
    notifyListeners();
  }
}