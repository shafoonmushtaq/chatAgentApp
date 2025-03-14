import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/agent.dart';
import '../../domain/entities/message.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final Agent agent;

  const ChatPage({super.key, required this.agent});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMessages(widget.agent.id);
    });
  }

  void _sendMessage(String text) {
    context.read<ChatProvider>().sendMessage(widget.agent, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.agent.color,
              radius: 16,
              child: Text(
                widget.agent.name.isNotEmpty ? widget.agent.name[0] : "?",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.agent.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAgentDetails(context);
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (chatProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${chatProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      chatProvider.resetError();
                      chatProvider.loadMessages(widget.agent.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          List<Message> messages = List.from(chatProvider.messages);
          
          if (messages.isEmpty) {
            messages = [
              Message(
                id: 'welcome',
                text: "Hello! I'm ${widget.agent.name}. How can I help you today?",
                isUser: false,
                timestamp: DateTime.now(),
                agentId: widget.agent.id,
              )
            ];
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      agent: widget.agent,
                    );
                  },
                ),
              ),
              if (chatProvider.isTyping)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.agent.color,
                        radius: 12,
                        child: Text(
                          widget.agent.name.isNotEmpty ? widget.agent.name[0] : "?",
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Typing...'),
                    ],
                  ),
                ),
              ChatInput(onSend: _sendMessage),
            ],
          );
        },
      ),
    );
  }

  void _showAgentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.agent.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${widget.agent.description}'),
            const SizedBox(height: 8),
            Text('Personality: ${widget.agent.personality}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}