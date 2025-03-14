import '../entities/agent.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call(String agentId) async {
    return repository.getMessages(agentId);
  }
}

class AddMessage {
  final ChatRepository repository;

  AddMessage(this.repository);

  Future<void> call(Message message) async {
    return repository.addMessage(message);
  }
}

class GenerateAIResponse {
  final ChatRepository repository;

  GenerateAIResponse(this.repository);

  Future<String> call(Agent agent, List<Message> chatHistory, String userMessage) async {
    return repository.generateAIResponse(agent, chatHistory, userMessage);
  }
}