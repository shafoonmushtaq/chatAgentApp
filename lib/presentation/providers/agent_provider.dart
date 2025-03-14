import 'package:flutter/foundation.dart';
import '../../domain/entities/agent.dart';
import '../../domain/usecases/agent_usecases.dart';

class AgentProvider extends ChangeNotifier {
  final GetAgents getAgents;
  final AddAgent addAgent;
  final DeleteAgent deleteAgent;
  
  List<Agent> _agents = [];
  bool _isLoading = false;
  String? _error;
  
  AgentProvider({
    required this.getAgents,
    required this.addAgent,
    required this.deleteAgent,
  }) {
    loadAgents();
  }
  
  List<Agent> get agents => _agents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }
  
  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadAgents() async {
    _setLoading(true);
    
    try {
      _agents = await getAgents();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load agents: $e');
    } finally {
      if (_isLoading) _setLoading(false);
    }
  }
  
  Future<void> addNewAgent(Agent agent) async {
    _setLoading(true);
    
    try {
      await addAgent(agent);
      _agents = await getAgents();
    } catch (e) {
      _setError('Failed to add agent: $e');
    } finally {
      if (_isLoading) _setLoading(false);
    }
  }
  
  Future<void> removeAgent(String agentId) async {
    _setLoading(true);
    
    try {
      final index = _agents.indexWhere((agent) => agent.id == agentId);
      if (index >= 0) {
        _agents.removeAt(index);
        await deleteAgent(agentId);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to delete agent: $e');
    } finally {
      if (_isLoading) _setLoading(false);
    }
  }
}