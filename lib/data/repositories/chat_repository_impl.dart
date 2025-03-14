import '../../domain/entities/agent.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/gemini_api.dart';
import '../models/agent_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final LocalStorage localStorage;
  final GeminiApi geminiApi;

  ChatRepositoryImpl({
    required this.localStorage,
    required this.geminiApi,
  });

  @override
  Future<List<Agent>> getAgents() async {
    final agentModels = await localStorage.getAgents();
    return agentModels;
  }

  @override
  Future<void> addAgent(Agent agent) async {
    final agentModel = AgentModel.fromEntity(agent);
    await localStorage.addAgent(agentModel);
  }

  @override
  Future<List<Message>> getMessages(String agentId) async {
    final messageModels = await localStorage.getMessages(agentId);
    return messageModels;
  }

  @override
  Future<void> addMessage(Message message) async {
    final messageModel = MessageModel.fromEntity(message);
    await localStorage.addMessage(messageModel);
  }

  @override
  Future<String> generateAIResponse(
    Agent agent, 
    List<Message> chatHistory, 
    String userMessage
  ) async {
    return geminiApi.generateResponse(
      agent: agent,
      chatHistory: chatHistory,
      userMessage: userMessage,
    );
  }
  
 @override
Future<void> deleteAgent(String agentId) async {
  final agents = await localStorage.getAgents();
  final updatedAgents = agents.where((agent) => agent.id != agentId).toList();
  await localStorage.saveAgents(updatedAgents);
  await localStorage.deleteMessages(agentId);
}
}