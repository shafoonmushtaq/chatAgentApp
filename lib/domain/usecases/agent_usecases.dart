import '../entities/agent.dart';
import '../repositories/chat_repository.dart';

class GetAgents {
  final ChatRepository repository;

  GetAgents(this.repository);

  Future<List<Agent>> call() async {
    return repository.getAgents();
  }
}

class AddAgent {
  final ChatRepository repository;

  AddAgent(this.repository);

  Future<void> call(Agent agent) async {
    return repository.addAgent(agent);
  }
}

class DeleteAgent {
  final ChatRepository repository;

  DeleteAgent(this.repository);

  Future<void> call(String agentId) async {
    return repository.deleteAgent(agentId);
  }
}