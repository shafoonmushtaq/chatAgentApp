import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/agent_model.dart';
import '../../models/message_model.dart';

class LocalStorage {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<AgentModel>> getAgents() async {
    final agentsJson = _prefs.getStringList('agents') ?? [];
    return agentsJson
        .map((json) => AgentModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveAgents(List<AgentModel> agents) async {
    final agentsJson =
        agents.map((agent) => jsonEncode(agent.toJson())).toList();
    await _prefs.setStringList('agents', agentsJson);
  }

  Future<void> addAgent(AgentModel agent) async {
    final agents = await getAgents();
    agents.add(agent);
    await saveAgents(agents);
  }

  Future<void> deleteAgent(String agentId) async {
    final agents = await getAgents();
    final updatedAgents = agents.where((agent) => agent.id != agentId).toList();
    await saveAgents(updatedAgents);
  }

  Future<List<MessageModel>> getMessages(String agentId) async {
    final messagesJson = _prefs.getStringList('messages_$agentId') ?? [];
    return messagesJson
        .map((json) => MessageModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveMessages(String agentId, List<MessageModel> messages) async {
    final messagesJson =
        messages.map((message) => jsonEncode(message.toJson())).toList();
    await _prefs.setStringList('messages_$agentId', messagesJson);
  }

  Future<void> addMessage(MessageModel message) async {
    final messages = await getMessages(message.agentId);
    messages.add(message);
    await saveMessages(message.agentId, messages);
  }

  Future<void> deleteMessages(String agentId) async {
    await _prefs.remove('messages_$agentId');
  }
}
