import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/agent_provider.dart';
import '../widgets/agent_creation_dialog.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Chat Agent'),
        elevation: 1,
      ),
      body: Consumer<AgentProvider>(
        builder: (context, agentProvider, child) {
          if (agentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (agentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${agentProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => agentProvider.loadAgents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (agentProvider.agents.isEmpty) {
            return const Center(
              child: Text('No agents yet. Create one with the + button.'),
            );
          }

          return ListView.builder(
            itemCount: agentProvider.agents.length,
            itemBuilder: (context, index) {
              final agent = agentProvider.agents[index];
              return Dismissible(
                key: Key(agent.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: Text(
                            "Are you sure you want to delete ${agent.name}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("DELETE"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  context.read<AgentProvider>().removeAgent(agent.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${agent.name} deleted"),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: agent.color,
                    child: Text(
                      agent.name.isNotEmpty ? agent.name[0] : "?",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(agent.name),
                  subtitle: Text(agent.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(agent: agent),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AgentCreationDialog(
              onAgentCreated: (agent) {
                context.read<AgentProvider>().addNewAgent(agent);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
