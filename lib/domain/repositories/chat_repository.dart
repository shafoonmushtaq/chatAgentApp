import '../entities/agent.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Agent>> getAgents();
  Future<void> addAgent(Agent agent);
  Future<void> deleteAgent(String agentId);
  
  Future<List<Message>> getMessages(String agentId);
  Future<void> addMessage(Message message);
  Future<String> generateAIResponse(Agent agent, List<Message> chatHistory, String userMessage);
}
